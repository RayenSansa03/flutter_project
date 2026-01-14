/**
 * Controller Capsules
 * Endpoints pour la gestion des capsules
 */

import { Controller, UseGuards } from '@nestjs/common';
import { CapsulesService } from './capsules.service';
import { JwtAuthGuard } from '../common/guards/auth.guard';

@Controller('capsules')
@UseGuards(JwtAuthGuard)
export class CapsulesController {
  constructor(private readonly capsulesService: CapsulesService) {}

  // TODO: Implémenter les endpoints
}
