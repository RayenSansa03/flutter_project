import {
    Entity,
    PrimaryGeneratedColumn,
    Column,
    CreateDateColumn,
    ManyToOne,
    JoinColumn,
} from 'typeorm';
import { User } from '../../auth/entities/user.entity';
import { Session } from './session.entity';

@Entity('session_members')
export class SessionMember {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    @Column()
    sessionId: string;

    @ManyToOne(() => Session, (session) => session.members)
    @JoinColumn({ name: 'sessionId' })
    session: Session;

    @Column()
    userId: string;

    @ManyToOne(() => User)
    @JoinColumn({ name: 'userId' })
    user: User;

    @CreateDateColumn()
    joinedAt: Date;
}
