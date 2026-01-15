import {
  Injectable,
  ConflictException,
  UnauthorizedException,
  InternalServerErrorException,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';
import { User } from './entities/user.entity';
import { LoginDto } from './dto/login.dto';
import { RegisterDto } from './dto/register.dto';
import { VerifyEmailDto } from './dto/verify-email.dto';
import { UpdateProfileDto } from './dto/update-profile.dto';
import { EmailService } from './email.service';
import { CloudinaryService } from '../cloudinary/cloudinary.service';

@Injectable()
export class AuthService {
  constructor(
    @InjectRepository(User)
    private userRepository: Repository<User>,
    private jwtService: JwtService,
    private emailService: EmailService,
    private cloudinaryService: CloudinaryService,
  ) {}

  async register(registerDto: RegisterDto) {
    // Vérifier si l'utilisateur existe déjà
    const existingUser = await this.userRepository.findOne({
      where: { email: registerDto.email },
    });

    if (existingUser) {
      throw new ConflictException('Un utilisateur avec cet email existe déjà');
    }

    // Générer un code de vérification à 6 chiffres
    const verificationCode = Math.floor(100000 + Math.random() * 900000).toString();

    // Hasher le mot de passe
    const hashedPassword = await bcrypt.hash(registerDto.password, 10);

    // Créer un token temporaire avec les données de l'utilisateur et le code
    const tempPayload = {
      email: registerDto.email,
      password: hashedPassword,
      firstName: registerDto.firstName,
      lastName: registerDto.lastName,
      code: verificationCode,
    };

    // Token temporaire valide 10 minutes
    const tempToken = this.jwtService.sign(tempPayload, { expiresIn: '10m' });

    // Envoyer l'email de vérification
    try {
      await this.emailService.sendVerificationCode(
        registerDto.email,
        verificationCode,
        registerDto.firstName || undefined,
      );
    } catch (error) {
      console.error('Échec envoi email:', error);
      const errorMessage = error instanceof Error ? error.message : 'Échec envoi email de vérification';
      throw new InternalServerErrorException(errorMessage);
    }

    // Retourner le token temporaire (sans créer l'utilisateur)
    return {
      message: 'Code de vérification envoyé. Vérifiez votre email.',
      tempToken,
    };
  }

  async verifyEmail(verifyEmailDto: VerifyEmailDto) {
    let payload: any;

    // Vérifier le token temporaire
    try {
      payload = await this.jwtService.verifyAsync(verifyEmailDto.tempToken);
    } catch {
      throw new UnauthorizedException('Token invalide ou expiré');
    }

    // Vérifier le code
    if (payload.code !== verifyEmailDto.code) {
      throw new UnauthorizedException('Code de vérification incorrect');
    }

    // Vérifier si l'utilisateur existe déjà (au cas où)
    const existingUser = await this.userRepository.findOne({
      where: { email: payload.email },
    });

    if (existingUser) {
      throw new ConflictException('Un utilisateur avec cet email existe déjà');
    }

    // Créer l'utilisateur maintenant que l'email est vérifié
    const user = this.userRepository.create({
      email: payload.email,
      password: payload.password,
      firstName: payload.firstName,
      lastName: payload.lastName,
    });

    const savedUser = await this.userRepository.save(user);

    // Générer le token JWT final
    const jwtPayload = { sub: savedUser.id, email: savedUser.email };
    const access_token = this.jwtService.sign(jwtPayload);

    // Retourner le token et les informations utilisateur
    return {
      message: 'Compte créé avec succès',
      access_token,
      user: {
        id: savedUser.id,
        email: savedUser.email,
        firstName: savedUser.firstName,
        lastName: savedUser.lastName,
        image: savedUser.image,
      },
    };
  }

  async login(loginDto: LoginDto) {
    // Trouver l'utilisateur par email
    const user = await this.userRepository.findOne({
      where: { email: loginDto.email },
    });

    if (!user) {
      throw new UnauthorizedException('Email ou mot de passe incorrect');
    }

    // Vérifier le mot de passe
    const isPasswordValid = await bcrypt.compare(
      loginDto.password,
      user.password,
    );

    if (!isPasswordValid) {
      throw new UnauthorizedException('Email ou mot de passe incorrect');
    }

    // Générer le token JWT
    const payload = { sub: user.id, email: user.email };
    const access_token = this.jwtService.sign(payload);

    // Retourner le token et les informations utilisateur (sans le mot de passe)
    return {
      access_token,
      user: {
        id: user.id,
        email: user.email,
        firstName: user.firstName,
        lastName: user.lastName,
        image: user.image,
      },
    };
  }

  async validateUser(email: string, password: string): Promise<any> {
    const user = await this.userRepository.findOne({
      where: { email },
    });

    if (!user) {
      return null;
    }

    const isPasswordValid = await bcrypt.compare(password, user.password);

    if (!isPasswordValid) {
      return null;
    }

    // Retourner les informations utilisateur sans le mot de passe
    const { password: _, ...result } = user;
    return result;
  }

  async findById(id: string): Promise<User | null> {
    return this.userRepository.findOne({
      where: { id },
      select: ['id', 'email', 'firstName', 'lastName', 'image', 'createdAt', 'updatedAt'],
    });
  }

  async updateProfile(userId: string, updateProfileDto: UpdateProfileDto): Promise<User> {
    const user = await this.userRepository.findOne({ where: { id: userId } });
    
    if (!user) {
      throw new NotFoundException('Utilisateur non trouvé');
    }

    if (updateProfileDto.firstName !== undefined) {
      user.firstName = updateProfileDto.firstName;
    }
    if (updateProfileDto.lastName !== undefined) {
      user.lastName = updateProfileDto.lastName;
    }

    return this.userRepository.save(user);
  }

  async uploadProfileImage(userId: string, file: Express.Multer.File): Promise<User> {
    const user = await this.userRepository.findOne({ where: { id: userId } });
    
    if (!user) {
      throw new NotFoundException('Utilisateur non trouvé');
    }

    try {
      // Supprimer l'ancienne image si elle existe
      if (user.image) {
        try {
          // Extraire le public_id de l'URL Cloudinary
          const urlParts = user.image.split('/');
          const publicIdWithExt = urlParts[urlParts.length - 1];
          const publicId = publicIdWithExt.split('.')[0];
          const folder = 'productivity_profiles';
          await this.cloudinaryService.deleteImage(`${folder}/${publicId}`);
        } catch (error) {
          console.error('Erreur lors de la suppression de l\'ancienne image:', error);
          // Continuer même si la suppression échoue
        }
      }

      // Uploader la nouvelle image
      const result = await this.cloudinaryService.uploadImage(file);
      user.image = result.secure_url;

      return this.userRepository.save(user);
    } catch (error) {
      console.error('Erreur lors de l\'upload de l\'image:', error);
      throw new InternalServerErrorException('Erreur lors de l\'upload de l\'image');
    }
  }
}
