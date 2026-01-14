/**
 * Service Habits
 * Logique métier pour la gestion des habitudes
 */

import { Injectable } from '@nestjs/common';
import { HabitsRepository } from './habits.repository';

@Injectable()
export class HabitsService {
  constructor(private readonly habitsRepository: HabitsRepository) {}

  // TODO: Implémenter les méthodes
}
