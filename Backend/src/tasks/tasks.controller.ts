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
import { TasksService } from './tasks.service';
import { JwtAuthGuard } from '../common/guards/auth.guard';
import { CurrentUser } from '../common/decorators/current-user.decorator';
import { CreateTaskDto, UpdateTaskDto } from './dto/task.dto';
import { Task } from './entities/task.entity';

@Controller('tasks')
@UseGuards(JwtAuthGuard)
export class TasksController {
  constructor(private readonly tasksService: TasksService) { }

  @Get()
  async findAll(@CurrentUser('userId') userId: string): Promise<Task[]> {
    return this.tasksService.findAll(userId);
  }

  @Get(':id')
  async findOne(
    @Param('id') id: string,
    @CurrentUser('userId') userId: string,
  ): Promise<Task> {
    return this.tasksService.findOne(id, userId);
  }

  @Post()
  async create(
    @CurrentUser('userId') userId: string,
    @Body() createTaskDto: CreateTaskDto,
  ): Promise<Task> {
    return this.tasksService.create(userId, createTaskDto);
  }

  @Put(':id')
  async update(
    @Param('id') id: string,
    @CurrentUser('userId') userId: string,
    @Body() updateTaskDto: UpdateTaskDto,
  ): Promise<Task> {
    return this.tasksService.update(id, userId, updateTaskDto);
  }

  @Delete(':id')
  async remove(
    @Param('id') id: string,
    @CurrentUser('userId') userId: string,
  ): Promise<void> {
    return this.tasksService.remove(id, userId);
  }
}
