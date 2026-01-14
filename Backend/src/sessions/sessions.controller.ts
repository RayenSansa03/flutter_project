import { Controller, Get, Post, Put, Delete, Body, Param, UseGuards } from '@nestjs/common';
import { SessionsService } from './sessions.service';
import { CreateSessionDto } from './dto/create-session.dto';
import { UpdateSessionDto } from './dto/update-session.dto';
import { JwtAuthGuard } from '../common/guards/auth.guard';
import { CurrentUser } from '../common/decorators/current-user.decorator';

@Controller('sessions')
@UseGuards(JwtAuthGuard)
export class SessionsController {
  constructor(private readonly sessionsService: SessionsService) {}

  @Post()
  create(@Body() createSessionDto: CreateSessionDto, @CurrentUser() user: any) {
    // TODO: Implémenter la création
    return { message: 'Create session - to be implemented' };
  }

  @Get()
  findAll(@CurrentUser() user: any) {
    // TODO: Implémenter la récupération de toutes les sessions
    return { message: 'Get all sessions - to be implemented' };
  }

  @Get(':id')
  findOne(@Param('id') id: string, @CurrentUser() user: any) {
    // TODO: Implémenter la récupération d'une session
    return { message: 'Get session - to be implemented' };
  }

  @Put(':id')
  update(@Param('id') id: string, @Body() updateSessionDto: UpdateSessionDto, @CurrentUser() user: any) {
    // TODO: Implémenter la mise à jour
    return { message: 'Update session - to be implemented' };
  }

  @Delete(':id')
  remove(@Param('id') id: string, @CurrentUser() user: any) {
    // TODO: Implémenter la suppression
    return { message: 'Delete session - to be implemented' };
  }
}
