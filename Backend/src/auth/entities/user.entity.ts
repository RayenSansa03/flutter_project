import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  OneToMany,
} from 'typeorm';
// Imports commentés temporairement - à décommenter quand les entités seront créées
// import { Session } from '../../sessions/entities/session.entity';
// import { Project } from '../../projects/entities/project.entity';
import { Task } from '../../tasks/entities/task.entity';
// import { Habit } from '../../habits/entities/habit.entity';
// import { Capsule } from '../../capsules/entities/capsule.entity';
// import { CircleMember } from '../../circle/entities/circle-member.entity';

@Entity('users')
export class User {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ unique: true })
  email: string;

  @Column()
  password: string;

  @Column({ nullable: true })
  firstName: string;

  @Column({ nullable: true })
  lastName: string;

  @Column({ nullable: true })
  image: string; // URL Cloudinary de l'image de profil

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;

  // Relations - À décommenter quand les autres entités seront créées
  // @OneToMany(() => Session, (session) => session.user)
  // sessions: Session[];

  // @OneToMany(() => Project, (project) => project.user)
  // projects: Project[];

  @OneToMany(() => Task, (task) => task.user)
  tasks: Task[];

  // @OneToMany(() => Habit, (habit) => habit.user)
  // habits: Habit[];

  // @OneToMany(() => Capsule, (capsule) => capsule.user)
  // capsules: Capsule[];

  // @OneToMany(() => CircleMember, (circleMember) => circleMember.user)
  // circleMembers: CircleMember[];
}
