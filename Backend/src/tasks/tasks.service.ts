import { Injectable, NotFoundException } from '@nestjs/common';
import { TasksRepository } from './tasks.repository';
import { CreateTaskDto, UpdateTaskDto } from './dto/task.dto';
import { Task } from './entities/task.entity';

@Injectable()
export class TasksService {
  constructor(private readonly tasksRepository: TasksRepository) { }

  async findAll(userId: string): Promise<Task[]> {
    return this.tasksRepository.findAll(userId);
  }

  async findOne(id: string, userId: string): Promise<Task> {
    const task = await this.tasksRepository.findOne(id, userId);
    if (!task) {
      throw new NotFoundException(`Task with ID ${id} not found`);
    }
    return task;
  }

  async create(userId: string, createTaskDto: CreateTaskDto): Promise<Task> {
    return this.tasksRepository.create(userId, {
      ...createTaskDto,
      time: createTaskDto.time ? new Date(createTaskDto.time) : null,
    });
  }

  async update(id: string, userId: string, updateTaskDto: UpdateTaskDto): Promise<Task> {
    const task = await this.findOne(id, userId);
    return this.tasksRepository.update(id, userId, {
      ...updateTaskDto,
      time: updateTaskDto.time ? new Date(updateTaskDto.time) : undefined,
    });
  }

  async remove(id: string, userId: string): Promise<void> {
    await this.findOne(id, userId);
    return this.tasksRepository.remove(id, userId);
  }
}
