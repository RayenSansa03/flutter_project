/**
 * Controller Circle
 * Endpoints pour la gestion du cercle privé
 */

import { Controller, UseGuards } from '@nestjs/common';
import { CircleService } from './circle.service';
import { JwtAuthGuard } from '../common/guards/auth.guard';

@Controller('circle')
@UseGuards(JwtAuthGuard)
export class CircleController {
  constructor(private readonly circleService: CircleService) {}

  // TODO: Implémenter les endpoints
}
