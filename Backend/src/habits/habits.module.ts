/**
 * Module Habits
 * Gestion des habitudes utilisateur
 */

import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { HabitsController } from './habits.controller';
import { HabitsService } from './habits.service';
import { HabitsRepository } from './habits.repository';
import { Habit } from './entities/habit.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Habit])],
  controllers: [HabitsController],
  providers: [HabitsService, HabitsRepository],
  exports: [HabitsService],
})
export class HabitsModule {}
