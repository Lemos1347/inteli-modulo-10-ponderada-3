from database.engine import engine
from database.models import User
from flask import session
from sqlalchemy import select
from sqlalchemy.orm import sessionmaker


def get_user_by_id(id: str) -> User | None:
    Session = sessionmaker(bind=engine)
    session = Session()

    result = session.execute(select(User).filter_by(id=id))

    user = result.scalars().first()

    session.close()

    return user


def create_user(user_name: str, user_email: str, user_password):
    user = User(name=user_name, email=user_email, password=user_password)

    Session = sessionmaker(bind=engine)
    session = Session()

    session.add(user)
    session.commit()
    session.close()


def login_user(user_email: str, user_password) -> bool:
    Session = sessionmaker(bind=engine)
    session = Session()

    result = session.execute(select(User).filter_by(email=user_email))

    user = result.scalars().first()

    if user is None:
        return False

    return user.password == user_password
