import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class UserResponseDto {
  @ApiProperty({
    description: 'ID unique de l\'utilisateur',
    example: '123e4567-e89b-12d3-a456-426614174000',
  })
  id: string;

  @ApiProperty({
    description: 'Email de l\'utilisateur',
    example: 'user@example.com',
  })
  email: string;

  @ApiPropertyOptional({
    description: 'Prénom de l\'utilisateur',
    example: 'John',
  })
  firstName?: string;

  @ApiPropertyOptional({
    description: 'Nom de l\'utilisateur',
    example: 'Doe',
  })
  lastName?: string;

  @ApiPropertyOptional({
    description: 'URL de l\'image de profil (Cloudinary)',
    example: 'https://res.cloudinary.com/dd72uedgl/image/upload/v1234567890/productivity_profiles/abc123.jpg',
  })
  image?: string;

  @ApiProperty({
    description: 'Date de création du compte',
    example: '2024-01-01T00:00:00.000Z',
  })
  createdAt: Date;

  @ApiProperty({
    description: 'Date de dernière mise à jour',
    example: '2024-01-01T00:00:00.000Z',
  })
  updatedAt: Date;
}
