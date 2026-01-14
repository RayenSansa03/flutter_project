/**
 * Repository Projects
 * Accès aux données pour les projets (TypeORM)
 */

import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Project } from './entities/project.entity';

@Injectable()
export class ProjectsRepository {
  constructor(
    @InjectRepository(Project)
    private readonly projectRepository: Repository<Project>,
  ) {}

  // TODO: Implémenter les méthodes de repository
  // async findByUserId(userId: string): Promise<Project[]> {
  //   return this.projectRepository.find({
  //     where: { user: { id: userId } },
  //     relations: ['tasks'],
  //     order: { createdAt: 'DESC' },
  //   });
  // }

  // async findOneByIdAndUserId(id: string, userId: string): Promise<Project | null> {
  //   return this.projectRepository.findOne({
  //     where: { id, user: { id: userId } },
  //     relations: ['tasks'],
  //   });
  // }

  // async create(userId: string, data: Partial<Project>): Promise<Project> {
  //   const project = this.projectRepository.create({
  //     ...data,
  //     user: { id: userId },
  //   });
  //   return this.projectRepository.save(project);
  // }

  // async update(id: string, data: Partial<Project>): Promise<Project> {
  //   await this.projectRepository.update(id, data);
  //   return this.findOneById(id);
  // }

  // async delete(id: string): Promise<void> {
  //   await this.projectRepository.delete(id);
  // }
}
