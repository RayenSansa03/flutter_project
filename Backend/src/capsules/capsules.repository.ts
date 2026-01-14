/**
 * Repository Capsules
 * Accès aux données pour les capsules (TypeORM)
 */

import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Capsule } from './entities/capsule.entity';

@Injectable()
export class CapsulesRepository {
  constructor(
    @InjectRepository(Capsule)
    private readonly capsuleRepository: Repository<Capsule>,
  ) {}

  // TODO: Implémenter les méthodes de repository
}
