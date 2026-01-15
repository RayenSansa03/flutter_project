import { IsString, IsNotEmpty } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class VerifyEmailDto {
  @ApiProperty({
    description: 'Token temporaire reçu lors de l\'inscription',
    example: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
  })
  @IsString()
  @IsNotEmpty()
  tempToken: string;

  @ApiProperty({
    description: 'Code de vérification à 6 chiffres',
    example: '123456',
  })
  @IsString()
  @IsNotEmpty()
  code: string;
}
