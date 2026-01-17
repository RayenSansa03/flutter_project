import { IsString, IsOptional, IsBoolean, IsNumber, IsArray } from 'class-validator';

export class CreateSessionDto {
  @IsString()
  title: string;

  @IsOptional()
  description?: string;

  @IsBoolean()
  @IsOptional()
  isGroup?: boolean;

  @IsNumber()
  durationMinutes: number;

  @IsOptional()
  startTime?: any;

  @IsArray()
  @IsString({ each: true })
  @IsOptional()
  invitedUserIds?: string[];
}
