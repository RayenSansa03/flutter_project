import { IsString, IsOptional, IsEnum, IsDateString } from 'class-validator';
import { SessionStatus } from '../entities/session.entity';

export class UpdateSessionDto {
  @IsString()
  @IsOptional()
  title?: string;

  @IsString()
  @IsOptional()
  description?: string;

  @IsEnum(SessionStatus)
  @IsOptional()
  status?: SessionStatus;

  @IsDateString()
  @IsOptional()
  endTime?: string;
}
