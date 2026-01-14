/**
 * Service Capsules
 * Logique métier pour la gestion des capsules
 */

import { Injectable } from '@nestjs/common';
import { CapsulesRepository } from './capsules.repository';

@Injectable()
export class CapsulesService {
  constructor(private readonly capsulesRepository: CapsulesRepository) {}

  // TODO: Implémenter les méthodes
}
