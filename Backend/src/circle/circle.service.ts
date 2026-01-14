/**
 * Service Circle
 * Logique métier pour la gestion du cercle privé
 */

import { Injectable } from '@nestjs/common';
import { CircleRepository } from './circle.repository';

@Injectable()
export class CircleService {
  constructor(private readonly circleRepository: CircleRepository) {}

  // TODO: Implémenter les méthodes
}
