/**
 * Service Projects
 * Logique métier pour la gestion des projets
 */

import { Injectable, NotFoundException } from '@nestjs/common';
import { ProjectsRepository } from './projects.repository';
// TODO: Implémenter les DTOs
// import { CreateProjectDto } from './dto/create-project.dto';
// import { UpdateProjectDto } from './dto/update-project.dto';

@Injectable()
export class ProjectsService {
  constructor(private readonly projectsRepository: ProjectsRepository) {}

  // TODO: Implémenter les méthodes
  // async findAll(userId: string) {
  //   return this.projectsRepository.findByUserId(userId);
  // }

  // async create(userId: string, createProjectDto: CreateProjectDto) {
  //   return this.projectsRepository.create(userId, createProjectDto);
  // }

  // async findOne(id: string, userId: string) {
  //   const project = await this.projectsRepository.findOneByIdAndUserId(id, userId);
  //   if (!project) {
  //     throw new NotFoundException('Project not found');
  //   }
  //   return project;
  // }

  // async update(id: string, userId: string, updateProjectDto: UpdateProjectDto) {
  //   await this.findOne(id, userId);
  //   return this.projectsRepository.update(id, updateProjectDto);
  // }

  // async remove(id: string, userId: string) {
  //   await this.findOne(id, userId);
  //   return this.projectsRepository.delete(id);
  // }
}
