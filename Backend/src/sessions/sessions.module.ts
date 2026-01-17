import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { SessionsController } from './sessions.controller';
import { SessionsService } from './sessions.service';
import { SessionsRepository } from './sessions.repository';
import { Session } from './entities/session.entity';
import { SessionMember } from './entities/session-member.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Session, SessionMember])],
  controllers: [SessionsController],
  providers: [SessionsService, SessionsRepository],
  exports: [SessionsService],
})
export class SessionsModule { }
