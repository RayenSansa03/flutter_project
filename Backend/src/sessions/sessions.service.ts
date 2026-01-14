import { Injectable } from '@nestjs/common';
import { SessionsRepository } from './sessions.repository';
import { CreateSessionDto } from './dto/create-session.dto';
import { UpdateSessionDto } from './dto/update-session.dto';

@Injectable()
export class SessionsService {
  constructor(private readonly sessionsRepository: SessionsRepository) {}

  async create(createSessionDto: CreateSessionDto, userId: string) {
    // TODO: Implémenter la création
    throw new Error('Method not implemented.');
  }

  async findAll(userId: string) {
    // TODO: Implémenter la récupération
    throw new Error('Method not implemented.');
  }

  async findOne(id: string, userId: string) {
    // TODO: Implémenter la récupération
    throw new Error('Method not implemented.');
  }

  async update(id: string, updateSessionDto: UpdateSessionDto, userId: string) {
    // TODO: Implémenter la mise à jour
    throw new Error('Method not implemented.');
  }

  async remove(id: string, userId: string) {
    // TODO: Implémenter la suppression
    throw new Error('Method not implemented.');
  }
}
