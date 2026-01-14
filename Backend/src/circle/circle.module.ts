/**
 * Module Circle
 * Gestion du cercle privé (réseau social)
 */

import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { CircleController } from './circle.controller';
import { CircleService } from './circle.service';
import { CircleRepository } from './circle.repository';
import { Circle } from './entities/circle.entity';
import { CircleMember } from './entities/circle-member.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Circle, CircleMember])],
  controllers: [CircleController],
  providers: [CircleService, CircleRepository],
  exports: [CircleService],
})
export class CircleModule {}
