import { Controller, Get, Post, Put, Delete, Body, Param, UseGuards } from '@nestjs/common';
import { SessionsService } from './sessions.service';
import { CreateSessionDto } from './dto/create-session.dto';
import { UpdateSessionDto } from './dto/update-session.dto';
import { JwtAuthGuard } from '../common/guards/auth.guard';
import { CurrentUser } from '../common/decorators/current-user.decorator';

@Controller('sessions')
@UseGuards(JwtAuthGuard)
export class SessionsController {
  constructor(private readonly sessionsService: SessionsService) { }

  @Post()
  create(@Body() createSessionDto: CreateSessionDto, @CurrentUser('userId') userId: string) {
    return this.sessionsService.create(createSessionDto, userId);
  }

  @Get()
  findAll(@CurrentUser('userId') userId: string) {
    return this.sessionsService.findAll(userId);
  }

  @Get(':id')
  findOne(@Param('id') id: string, @CurrentUser('userId') userId: string) {
    return this.sessionsService.findOne(id, userId);
  }

  @Put(':id')
  update(
    @Param('id') id: string,
    @Body() updateSessionDto: UpdateSessionDto,
    @CurrentUser('userId') userId: string,
  ) {
    return this.sessionsService.update(id, updateSessionDto, userId);
  }

  @Post(':id/join')
  join(@Param('id') id: string, @CurrentUser('userId') userId: string) {
    return this.sessionsService.joinSession(id, userId);
  }

  @Delete(':id/leave')
  leave(@Param('id') id: string, @CurrentUser('userId') userId: string) {
    return this.sessionsService.leaveSession(id, userId);
  }

  @Delete(':id')
  remove(@Param('id') id: string, @CurrentUser('userId') userId: string) {
    return this.sessionsService.remove(id, userId);
  }
}
