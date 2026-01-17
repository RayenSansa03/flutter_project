import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { SessionsRepository } from './sessions.repository';
import { CreateSessionDto } from './dto/create-session.dto';
import { UpdateSessionDto } from './dto/update-session.dto';
import { Session, SessionStatus } from './entities/session.entity';
import { SessionMember } from './entities/session-member.entity';

@Injectable()
export class SessionsService {
  constructor(
    private readonly sessionsRepository: SessionsRepository,
    @InjectRepository(SessionMember)
    private sessionMemberRepository: Repository<SessionMember>,
  ) { }

  async create(createSessionDto: CreateSessionDto, userId: string) {
    const { invitedUserIds, ...sessionData } = createSessionDto;

    // Create the session
    const session = await this.sessionsRepository.create({
      ...sessionData,
      userId,
      status: createSessionDto.startTime ? SessionStatus.PLANNED : SessionStatus.ACTIVE,
    });

    // Add the creator as the first member
    await this.sessionMemberRepository.save({
      sessionId: session.id,
      userId,
    });

    // Handle invitations
    if (invitedUserIds && invitedUserIds.length > 0) {
      const members = invitedUserIds.map(inviteeId => ({
        sessionId: session.id,
        userId: inviteeId,
      }));
      await this.sessionMemberRepository.save(members);
    }

    return this.findOne(session.id, userId);
  }

  async findAll(userId: string) {
    // Return sessions where user is either host or member
    return this.sessionsRepository.findAllByUser(userId);
  }

  async findOne(id: string, userId: string) {
    return this.sessionsRepository.findOne(id);
  }

  async update(id: string, updateSessionDto: UpdateSessionDto, userId: string) {
    return this.sessionsRepository.update(id, updateSessionDto);
  }

  async joinSession(id: string, userId: string) {
    // Check if member already exists
    const existingMember = await this.sessionMemberRepository.findOne({
      where: { sessionId: id, userId }
    });

    if (!existingMember) {
      await this.sessionMemberRepository.save({
        sessionId: id,
        userId,
      });
    }

    return this.findOne(id, userId);
  }

  async leaveSession(id: string, userId: string) {
    await this.sessionMemberRepository.delete({ sessionId: id, userId });
    return { success: true };
  }

  async remove(id: string, userId: string) {
    return this.sessionsRepository.delete(id);
  }
}
