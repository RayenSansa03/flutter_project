/**
 * Controller Projects
 * Endpoints pour la gestion des projets
 */

import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Body,
  Param,
  UseGuards,
} from '@nestjs/common';
import { ProjectsService } from './projects.service';
import { JwtAuthGuard } from '../common/guards/auth.guard';
import { CurrentUser } from '../common/decorators/current-user.decorator';
// TODO: Implémenter les DTOs
// import { CreateProjectDto } from './dto/create-project.dto';
// import { UpdateProjectDto } from './dto/update-project.dto';

@Controller('projects')
@UseGuards(JwtAuthGuard)
export class ProjectsController {
  constructor(private readonly projectsService: ProjectsService) {}

  // TODO: Implémenter les endpoints
  // @Get()
  // findAll(@CurrentUser() user: any) {
  //   return this.projectsService.findAll(user.id);
  // }

  // @Post()
  // create(@CurrentUser() user: any, @Body() createProjectDto: CreateProjectDto) {
  //   return this.projectsService.create(user.id, createProjectDto);
  // }

  // @Get(':id')
  // findOne(@Param('id') id: string, @CurrentUser() user: any) {
  //   return this.projectsService.findOne(id, user.id);
  // }

  // @Put(':id')
  // update(
  //   @Param('id') id: string,
  //   @CurrentUser() user: any,
  //   @Body() updateProjectDto: UpdateProjectDto,
  // ) {
  //   return this.projectsService.update(id, user.id, updateProjectDto);
  // }

  // @Delete(':id')
  // remove(@Param('id') id: string, @CurrentUser() user: any) {
  //   return this.projectsService.remove(id, user.id);
  // }
}
