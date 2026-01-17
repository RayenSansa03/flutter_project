import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Task } from './entities/task.entity';

@Injectable()
export class TasksRepository {
  constructor(
    @InjectRepository(Task)
    private readonly taskRepository: Repository<Task>,
  ) { }

  async findAll(userId: string): Promise<Task[]> {
    return this.taskRepository.find({
      where: { userId },
      order: { time: 'ASC' },
    });
  }

  async findOne(id: string, userId: string): Promise<Task> {
    return this.taskRepository.findOne({
      where: { id, userId },
    });
  }

  async create(userId: string, taskData: Partial<Task>): Promise<Task> {
    const task = this.taskRepository.create({
      ...taskData,
      userId,
    });
    return this.taskRepository.save(task);
  }

  async update(id: string, userId: string, taskData: Partial<Task>): Promise<Task> {
    await this.taskRepository.update({ id, userId }, taskData);
    return this.findOne(id, userId);
  }

  async remove(id: string, userId: string): Promise<void> {
    await this.taskRepository.delete({ id, userId });
  }
}
