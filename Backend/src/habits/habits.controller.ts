/**
 * Controller Habits
 * Endpoints pour la gestion des habitudes
 */

import { Controller, UseGuards } from '@nestjs/common';
import { HabitsService } from './habits.service';
import { JwtAuthGuard } from '../common/guards/auth.guard';

@Controller('habits')
@UseGuards(JwtAuthGuard)
export class HabitsController {
  constructor(private readonly habitsService: HabitsService) {}

  // TODO: Implémenter les endpoints
}
