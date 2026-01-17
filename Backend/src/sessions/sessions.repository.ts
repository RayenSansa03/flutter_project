import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Session } from './entities/session.entity';

@Injectable()
export class SessionsRepository {
  constructor(
    @InjectRepository(Session)
    private sessionRepository: Repository<Session>,
  ) { }

  async create(data: Partial<Session>): Promise<Session> {
    const session = this.sessionRepository.create(data);
    return this.sessionRepository.save(session);
  }

  async findAllByUser(userId: string): Promise<Session[]> {
    return this.sessionRepository.find({
      where: { userId },
      relations: ['members', 'members.user'],
      order: { createdAt: 'DESC' },
    });
  }

  async findOne(id: string): Promise<Session | null> {
    return this.sessionRepository.findOne({
      where: { id },
      relations: ['members', 'members.user', 'user'],
    });
  }

  async update(id: string, data: Partial<Session>): Promise<Session> {
    await this.sessionRepository.update(id, data);
    return this.findOne(id);
  }

  async delete(id: string): Promise<void> {
    await this.sessionRepository.delete(id);
  }
}
