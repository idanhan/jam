"""Add urls and urldes columns to users

Revision ID: 60dd959bdc05
Revises: 
Create Date: 2024-06-22 20:11:28.697451

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import mysql

# revision identifiers, used by Alembic.
revision: str = '60dd959bdc05'
down_revision: Union[str, None] = None
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # Drop foreign key constraints before dropping the tables
    op.drop_constraint('jams_users_ibfk_2', 'jams_users', type_='foreignkey')
    op.drop_constraint('jams_users_ibfk_1', 'jams_users', type_='foreignkey')
    op.drop_constraint('friends_ibfk_1', 'friends', type_='foreignkey')
    op.drop_constraint('friends_ibfk_2', 'friends', type_='foreignkey')

    # Drop tables
    op.drop_table('jam_Mod')
    op.drop_table('friends')
    op.drop_index('email', table_name='users')
    op.drop_index('username', table_name='users')
    op.drop_table('users')
    op.drop_table('jams_users')

    # Add new columns to the users table
    op.add_column('users', sa.Column('urls', sa.JSON, nullable=True))
    op.add_column('users', sa.Column('urldes', sa.JSON, nullable=True))


def downgrade() -> None:
    # Create the tables again if downgrading
    op.create_table('jam_Mod',
    sa.Column('id', mysql.INTEGER(), autoincrement=True, nullable=False),
    sa.Column('jamTitle', mysql.VARCHAR(length=300), nullable=True),
    sa.Column('jamDescription', mysql.VARCHAR(length=1000), nullable=True),
    sa.Column('jamStartTime', mysql.VARCHAR(length=300), nullable=False),
    sa.Column('jamEndTime', mysql.VARCHAR(length=300), nullable=False),
    sa.Column('created_at', mysql.VARCHAR(length=100), nullable=True),
    sa.PrimaryKeyConstraint('id'),
    mysql_collate='utf8mb4_0900_ai_ci',
    mysql_default_charset='utf8mb4',
    mysql_engine='InnoDB'
    )

    op.create_table('users',
    sa.Column('id', mysql.INTEGER(), autoincrement=True, nullable=False),
    sa.Column('username', mysql.VARCHAR(length=50), nullable=False),
    sa.Column('email', mysql.VARCHAR(length=100), nullable=False),
    sa.Column('password', mysql.VARCHAR(length=100), nullable=False),
    sa.Column('created_at', mysql.VARCHAR(length=100), nullable=True),
    sa.Column('country', mysql.VARCHAR(length=50), nullable=False),
    sa.Column('city', mysql.VARCHAR(length=50), nullable=False),
    sa.Column('instrument', mysql.JSON(), nullable=False),
    sa.Column('level', mysql.VARCHAR(length=30), nullable=False),
    sa.Column('genre', mysql.JSON(), nullable=False),
    sa.PrimaryKeyConstraint('id'),
    mysql_collate='utf8mb4_0900_ai_ci',
    mysql_default_charset='utf8mb4',
    mysql_engine='InnoDB'
    )

    op.create_index('username', 'users', ['username'], unique=True)
    op.create_index('email', 'users', ['email'], unique=True)

    op.create_table('friends',
    sa.Column('friend_a_id', mysql.INTEGER(), autoincrement=False, nullable=False),
    sa.Column('friend_b_id', mysql.INTEGER(), autoincrement=False, nullable=False),
    sa.Column('Status_enum', mysql.ENUM('PENDING', 'ACCEPTED', 'DECLINED'), nullable=False),
    sa.Column('created_at', mysql.DATETIME(), nullable=True),
    sa.ForeignKeyConstraint(['friend_a_id'], ['users.id'], name='friends_ibfk_1'),
    sa.ForeignKeyConstraint(['friend_b_id'], ['users.id'], name='friends_ibfk_2'),
    sa.PrimaryKeyConstraint('friend_a_id', 'friend_b_id'),
    mysql_collate='utf8mb4_0900_ai_ci',
    mysql_default_charset='utf8mb4',
    mysql_engine='InnoDB'
    )

    op.create_table('jams_users',
    sa.Column('id', mysql.INTEGER(), autoincrement=True, nullable=False),
    sa.Column('user_id', mysql.INTEGER(), autoincrement=False, nullable=True),
    sa.Column('jam_id', mysql.INTEGER(), autoincrement=False, nullable=True),
    sa.ForeignKeyConstraint(['jam_id'], ['jam_Mod.id'], name='jams_users_ibfk_2'),
    sa.ForeignKeyConstraint(['user_id'], ['users.id'], name='jams_users_ibfk_1'),
    sa.PrimaryKeyConstraint('id'),
    mysql_collate='utf8mb4_0900_ai_ci',
    mysql_default_charset='utf8mb4',
    mysql_engine='InnoDB'
    )

    # Remove the new columns from the users table
    op.drop_column('users', 'urls')
    op.drop_column('users', 'urldes')
