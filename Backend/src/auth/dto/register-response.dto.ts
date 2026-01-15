import { ApiProperty } from '@nestjs/swagger';

export class RegisterResponseDto {
  @ApiProperty({
    description: 'Message de confirmation',
    example: 'Code de vérification envoyé. Vérifiez votre email.',
  })
  message: string;

  @ApiProperty({
    description: 'Token temporaire pour la vérification email',
    example: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
  })
  tempToken: string;
}
