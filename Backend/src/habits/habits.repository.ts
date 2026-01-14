/**
 * Repository Habits
 * Accès aux données pour les habitudes (TypeORM)
 */

import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Habit } from './entities/habit.entity';

@Injectable()
export class HabitsRepository {
  constructor(
    @InjectRepository(Habit)
    private readonly habitRepository: Repository<Habit>,
  ) {}

  // TODO: Implémenter les méthodes de repository
}
