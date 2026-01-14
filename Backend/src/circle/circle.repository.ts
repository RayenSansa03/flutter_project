/**
 * Repository Circle
 * Accès aux données pour le cercle privé (TypeORM)
 */

import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Circle } from './entities/circle.entity';
import { CircleMember } from './entities/circle-member.entity';

@Injectable()
export class CircleRepository {
  constructor(
    @InjectRepository(Circle)
    private readonly circleRepository: Repository<Circle>,
    @InjectRepository(CircleMember)
    private readonly circleMemberRepository: Repository<CircleMember>,
  ) {}

  // TODO: Implémenter les méthodes de repository
}
