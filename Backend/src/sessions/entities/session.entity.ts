import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  OneToMany,
  JoinColumn,
} from 'typeorm';
import { User } from '../../auth/entities/user.entity';
import { SessionMember } from './session-member.entity';

export enum SessionStatus {
  PLANNED = 'planned',
  ACTIVE = 'active',
  COMPLETED = 'completed',
  CANCELLED = 'cancelled',
}

@Entity('sessions')
export class Session {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  userId: string;

  @ManyToOne(() => User)
  @JoinColumn({ name: 'userId' })
  user: User;

  @Column({ default: 'Study Session' })
  title: string;

  @Column({ nullable: true })
  description: string;

  @Column({
    type: 'enum',
    enum: SessionStatus,
    default: SessionStatus.PLANNED,
  })
  status: SessionStatus;

  @Column({ default: false })
  isGroup: boolean;

  @Column({ type: 'timestamp', nullable: true })
  startTime: Date;

  @Column({ type: 'timestamp', nullable: true })
  endTime: Date;

  @Column({ default: 25 })
  durationMinutes: number;

  @OneToMany(() => SessionMember, (member) => member.session)
  members: SessionMember[];

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
