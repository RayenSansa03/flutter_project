import { IsString, IsNotEmpty, IsOptional, IsBoolean, IsDateString, IsNumber } from 'class-validator';

export class CreateTaskDto {
    @IsString()
    @IsNotEmpty()
    title: string;

    @IsString()
    @IsOptional()
    description?: string;

    @IsBoolean()
    @IsOptional()
    isCompleted?: boolean;

    @IsDateString()
    @IsOptional()
    time?: string;

    @IsNumber()
    @IsOptional()
    durationMinutes?: number;
}

export class UpdateTaskDto {
    @IsString()
    @IsOptional()
    title?: string;

    @IsString()
    @IsOptional()
    description?: string;

    @IsBoolean()
    @IsOptional()
    isCompleted?: boolean;

    @IsDateString()
    @IsOptional()
    time?: string;

    @IsNumber()
    @IsOptional()
    durationMinutes?: number;
}
