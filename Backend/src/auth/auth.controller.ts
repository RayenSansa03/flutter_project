import {
  Controller,
  Post,
  Body,
  UseGuards,
  Get,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
  ApiBody,
} from '@nestjs/swagger';
import { AuthService } from './auth.service';
import { LoginDto } from './dto/login.dto';
import { RegisterDto } from './dto/register.dto';
import { VerifyEmailDto } from './dto/verify-email.dto';
import { AuthResponseDto } from './dto/auth-response.dto';
import { RegisterResponseDto } from './dto/register-response.dto';
import { UserResponseDto } from './dto/user-response.dto';
import { JwtAuthGuard } from '../common/guards/auth.guard';
import { CurrentUser } from '../common/decorators/current-user.decorator';

@ApiTags('auth')
@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('register')
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({
    summary: 'Inscription d\'un nouvel utilisateur',
    description: 'Envoie un code de vérification par email. Utilisez /verify-email pour finaliser l\'inscription.',
  })
  @ApiBody({ type: RegisterDto })
  @ApiResponse({
    status: 201,
    description: 'Code de vérification envoyé',
    type: RegisterResponseDto,
  })
  @ApiResponse({
    status: 409,
    description: 'Un utilisateur avec cet email existe déjà',
  })
  @ApiResponse({
    status: 400,
    description: 'Données de validation invalides',
  })
  async register(@Body() registerDto: RegisterDto): Promise<RegisterResponseDto> {
    return this.authService.register(registerDto);
  }

  @Post('verify-email')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Vérifier l\'email avec le code reçu',
    description: 'Vérifie le code de vérification et crée le compte utilisateur',
  })
  @ApiBody({ type: VerifyEmailDto })
  @ApiResponse({
    status: 200,
    description: 'Email vérifié et compte créé avec succès',
    type: AuthResponseDto,
  })
  @ApiResponse({
    status: 401,
    description: 'Code incorrect ou token expiré',
  })
  @ApiResponse({
    status: 400,
    description: 'Données de validation invalides',
  })
  async verifyEmail(@Body() verifyEmailDto: VerifyEmailDto): Promise<AuthResponseDto> {
    return this.authService.verifyEmail(verifyEmailDto);
  }

  @Post('login')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Connexion d\'un utilisateur',
    description: 'Authentifie un utilisateur et retourne un token JWT',
  })
  @ApiBody({ type: LoginDto })
  @ApiResponse({
    status: 200,
    description: 'Connexion réussie',
    type: AuthResponseDto,
  })
  @ApiResponse({
    status: 401,
    description: 'Email ou mot de passe incorrect',
  })
  @ApiResponse({
    status: 400,
    description: 'Données de validation invalides',
  })
  async login(@Body() loginDto: LoginDto): Promise<AuthResponseDto> {
    return this.authService.login(loginDto);
  }

  @UseGuards(JwtAuthGuard)
  @Get('profile')
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({
    summary: 'Récupérer le profil de l\'utilisateur connecté',
    description: 'Retourne les informations du profil de l\'utilisateur authentifié',
  })
  @ApiResponse({
    status: 200,
    description: 'Profil utilisateur récupéré avec succès',
    type: UserResponseDto,
  })
  @ApiResponse({
    status: 401,
    description: 'Non autorisé - Token invalide ou manquant',
  })
  async getProfile(@CurrentUser() user: any): Promise<UserResponseDto> {
    const userProfile = await this.authService.findById(user.userId);
    if (!userProfile) {
      throw new Error('Utilisateur non trouvé');
    }
    return userProfile;
  }
}
