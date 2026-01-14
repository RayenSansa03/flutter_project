import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AuthModule } from './auth/auth.module';
import { SessionsModule } from './sessions/sessions.module';
import { ProjectsModule } from './projects/projects.module';
import { TasksModule } from './tasks/tasks.module';
import { HabitsModule } from './habits/habits.module';
import { CapsulesModule } from './capsules/capsules.module';
import { CircleModule } from './circle/circle.module';
import { databaseConfig } from './config/database.config';

@Module({
  imports: [
    // Configuration module
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: '.env',
    }),
    
    // Database module
    TypeOrmModule.forRootAsync({
      useFactory: () => databaseConfig(),
    }),
    
    // Feature modules
    AuthModule,
    SessionsModule,
    ProjectsModule,
    TasksModule,
    HabitsModule,
    CapsulesModule,
    CircleModule,
  ],
})
export class AppModule {}
