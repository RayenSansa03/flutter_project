/**
 * Module Capsules
 * Gestion des capsules/mémoires utilisateur
 */

import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { CapsulesController } from './capsules.controller';
import { CapsulesService } from './capsules.service';
import { CapsulesRepository } from './capsules.repository';
import { Capsule } from './entities/capsule.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Capsule])],
  controllers: [CapsulesController],
  providers: [CapsulesService, CapsulesRepository],
  exports: [CapsulesService],
})
export class CapsulesModule {}
