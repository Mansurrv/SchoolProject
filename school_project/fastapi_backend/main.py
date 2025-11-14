from fastapi import FastAPI, HTTPException, Depends, UploadFile, File
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel, EmailStr
from sqlalchemy import create_engine, Column, Integer, String, Date
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, Session
from datetime import date, timedelta
import bcrypt
import random
import smtplib
from email.mime.text import MIMEText
import os
import shutil

# --- Database setup ---
DATABASE_URL = "postgresql://postgres:0609@localhost/postgres"
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

# --- Models ---
class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    login = Column(String, unique=True, index=True, nullable=False)
    password = Column(String, nullable=False)
    name = Column(String, nullable=False)
    surname = Column(String, nullable=False)
    birth_date = Column(Date, nullable=False)
    email = Column(String, unique=True, nullable=False)
    image_url = Column(String, nullable=True)

class ResetCode(Base):
    __tablename__ = "reset_codes"
    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, nullable=False)
    code = Column(String, nullable=False)
    expires_at = Column(Date, nullable=False)

class LogopedNews(Base):
    __tablename__ = "logoped_news"
    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, nullable=False)
    description = Column(String, nullable=False)
    image_url = Column(String, nullable=True)
    created_at = Column(Date, default=date.today)

class Banner(Base):
    __tablename__ = "banners"
    id = Column(Integer, primary_key=True, index=True)
    image_url = Column(String, nullable=False)
    created_at = Column(Date, default=date.today)

class Book(Base):
    __tablename__ = "books"
    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, nullable=False)
    author = Column(String, nullable=False)
    file_url = Column(String, nullable=False)  # ссылка на PDF
    created_at = Column(Date, default=date.today)


Base.metadata.create_all(bind=engine)

# --- Email configuration ---
SENDER_EMAIL = "buyserikov06@gmail.com"
SENDER_PASSWORD = "hcdeycwzrvytyrwh"

# --- FastAPI app ---
app = FastAPI(title="User Management API")

# --- CORS middleware ---
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # restrict to your frontend if needed
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# --- Static files for uploaded images ---
UPLOAD_DIR = "uploads"
os.makedirs(UPLOAD_DIR, exist_ok=True)
app.mount("/uploads", StaticFiles(directory=UPLOAD_DIR), name="uploads")

# --- DB dependency ---
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# --- Pydantic Schemas ---
class UserCreate(BaseModel):
    login: str
    password: str
    name: str
    surname: str
    birth_date: date
    email: EmailStr

class UserLogin(BaseModel):
    login: str
    password: str

class UserResponse(BaseModel):
    id: int
    login: str
    name: str
    surname: str
    email: str
    image_url: str | None = None

    class Config:
        from_attributes = True  # FastAPI v2 compatible

class UserUpdate(BaseModel):
    name: str
    surname: str

class ForgotPasswordRequest(BaseModel):
    email: EmailStr

class CodeVerifyRequest(BaseModel):
    email: EmailStr
    code: str

class BookCreate(BaseModel):
    title: str
    author: str
    file_url: str

class BookResponse(BaseModel):
    id: int
    title: str
    author: str
    file_url: str
    created_at: date

    class Config:
        from_attributes = True

# --- Endpoints ---
@app.get("/")
def root():
    return {"message": "Backend is running!"}

@app.post("/register", response_model=UserResponse)
def register_user(user: UserCreate, db: Session = Depends(get_db)):
    if db.query(User).filter(User.login == user.login).first():
        raise HTTPException(status_code=400, detail="Login already exists")
    hashed_password = bcrypt.hashpw(user.password.encode(), bcrypt.gensalt()).decode()
    new_user = User(
        login=user.login,
        password=hashed_password,
        name=user.name,
        surname=user.surname,
        birth_date=user.birth_date,
        email=user.email,
    )
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    return new_user

@app.post("/login", response_model=UserResponse)
def login_user(user: UserLogin, db: Session = Depends(get_db)):
    db_user = db.query(User).filter(User.login == user.login).first()
    if not db_user or not bcrypt.checkpw(user.password.encode(), db_user.password.encode()):
        raise HTTPException(status_code=400, detail="Invalid login or password")
    return db_user

@app.get("/user/{login}", response_model=UserResponse)
def get_user(login: str, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.login == login).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user

@app.put("/user/update/{login}", response_model=UserResponse)
def update_user(login: str, update: UserUpdate, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.login == login).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    user.name = update.name
    user.surname = update.surname
    db.commit()
    db.refresh(user)
    return user

# --- Add this endpoint to your FastAPI app ---

@app.get("/items")
def get_all_users(db: Session = Depends(get_db)):
    """
    Returns a list of all users in the format:
    [
        {"id": 1, "name": "John Doe"},
        {"id": 2, "name": "Jane Smith"}
    ]
    """
    users = db.query(User).all()
    result = [{"id": user.id, "name": f"{user.name} {user.surname}"} for user in users]
    return result
    

# --- Profile image upload ---
@app.post("/user/upload-image/{login}")
def upload_image(login: str, file: UploadFile = File(...), db: Session = Depends(get_db)):
    user = db.query(User).filter(User.login == login).first()
    if not user:
        raise HTTPException(404, "User not found")

    ext = os.path.splitext(file.filename)[1]
    file_path = os.path.join(UPLOAD_DIR, f"{login}{ext}")
    
    # Save file
    with open(file_path, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)

    # Save relative path in DB
    user.image_url = f"/uploads/{login}{ext}"
    db.commit()
    db.refresh(user)

    # Return full URL
    full_url = f"http://127.0.0.1:8000{user.image_url}"
    return {"message": "Upload successful", "image_url": full_url}


# --- Forgot password ---
@app.post("/forgot-password")
def send_reset_code(request: ForgotPasswordRequest, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.email == request.email).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    code = str(random.randint(100000, 999999))
    expires_at = date.today() + timedelta(minutes=10)
    reset = ResetCode(email=request.email, code=code, expires_at=expires_at)
    db.add(reset)
    db.commit()
    
    try:
        msg = MIMEText(f"Your verification code is: {code}")
        msg["Subject"] = "Password Reset Code"
        msg["From"] = SENDER_EMAIL
        msg["To"] = request.email
        with smtplib.SMTP_SSL("smtp.gmail.com", 465) as server:
            server.login(SENDER_EMAIL, SENDER_PASSWORD)
            server.sendmail(SENDER_EMAIL, [request.email], msg.as_string())
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Email sending failed: {str(e)}")
    
    return {"message": "Verification code sent to email"}

@app.post("/verify-code")
def verify_code(request: CodeVerifyRequest, db: Session = Depends(get_db)):
    record = db.query(ResetCode).filter(
        ResetCode.email == request.email,
        ResetCode.code == request.code
    ).first()
    
    if not record:
        raise HTTPException(status_code=400, detail="Invalid code")
    if record.expires_at < date.today():
        raise HTTPException(status_code=400, detail="Code expired")
    
    return {"message": "Code verified successfully"}



# --- Video Courses Model ---
class VideoCourse(Base):
    __tablename__ = "video_courses"
    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, nullable=False)
    url = Column(String, nullable=False)
    description = Column(String, nullable=True)
    category = Column(String, nullable=False)

Base.metadata.create_all(bind=engine)


# --- Pydantic Schema ---
class VideoCourseCreate(BaseModel):
    title: str
    url: str
    description: str | None = None
    category: str


class VideoCourseResponse(BaseModel):
    id: int
    title: str
    url: str
    description: str | None
    category: str

    class Config:
        from_attributes = True


# --- Endpoints for Video Courses ---

@app.post("/videos", response_model=VideoCourseResponse)
def create_video(video: VideoCourseCreate, db: Session = Depends(get_db)):
    """Добавление нового видеокурса"""
    new_video = VideoCourse(
        title=video.title,
        url=video.url,
        description=video.description,
        category=video.category
    )
    db.add(new_video)
    db.commit()
    db.refresh(new_video)
    return new_video


@app.get("/videos", response_model=list[VideoCourseResponse])
def get_all_videos(db: Session = Depends(get_db)):
    """Получение всех видеокурсов"""
    videos = db.query(VideoCourse).all()
    return videos


@app.get("/videos/category/{category}", response_model=list[VideoCourseResponse])
def get_videos_by_category(category: str, db: Session = Depends(get_db)):
    """Получение видео по категории (например, Урок 1)"""
    videos = db.query(VideoCourse).filter(VideoCourse.category == category).all()
    if not videos:
        raise HTTPException(status_code=404, detail="No videos found for this category")
    return videos



# --- News Model ---
class News(Base):
    __tablename__ = "news"
    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, nullable=False)
    description = Column(String, nullable=False)
    image_url = Column(String, nullable=True)
    created_at = Column(Date, default=date.today)

Base.metadata.create_all(bind=engine)

# --- Schemas ---
class NewsCreate(BaseModel):
    title: str
    description: str
    image_url: str | None = None

class NewsResponse(BaseModel):
    id: int
    title: str
    description: str
    image_url: str | None
    created_at: date

    class Config:
        from_attributes = True

# --- Endpoints ---
@app.post("/news", response_model=NewsResponse)
def create_news(news: NewsCreate, db: Session = Depends(get_db)):
    new_item = News(
        title=news.title,
        description=news.description,
        image_url=news.image_url
    )
    db.add(new_item)
    db.commit()
    db.refresh(new_item)
    return new_item


@app.get("/news", response_model=list[NewsResponse])
def get_all_news(db: Session = Depends(get_db)):
    return db.query(News).order_by(News.id.desc()).all()


class LogopedNewsCreate(BaseModel):
    title: str
    description: str
    image_url: str | None = None

class LogopedNewsResponse(BaseModel):
    id: int
    title: str
    description: str
    image_url: str | None
    created_at: date

    class Config:
        from_attributes = True


@app.post("/logoped-news", response_model=LogopedNewsResponse)
def create_logoped_news(news: LogopedNewsCreate, db: Session = Depends(get_db)):
    new_item = LogopedNews(
        title=news.title,
        description=news.description,
        image_url=news.image_url
    )
    db.add(new_item)
    db.commit()
    db.refresh(new_item)
    return new_item

@app.get("/logoped-news", response_model=list[LogopedNewsResponse])
def get_all_logoped_news(db: Session = Depends(get_db)):
    return db.query(LogopedNews).order_by(LogopedNews.id.desc()).all()


# Add a new banner
@app.post("/banners")
def create_banner(file: UploadFile = File(...), db: Session = Depends(get_db)):
    ext = os.path.splitext(file.filename)[1]
    file_path = os.path.join(UPLOAD_DIR, f"banner_{random.randint(1000,9999)}{ext}")
    with open(file_path, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)

    banner = Banner(image_url=f"/uploads/{os.path.basename(file_path)}")
    db.add(banner)
    db.commit()
    db.refresh(banner)
    return {"id": banner.id, "image_url": f"http://127.0.0.1:8000{banner.image_url}"}

# Get all banners
@app.get("/banners")
def get_banners(db: Session = Depends(get_db)):
    banners = db.query(Banner).all()
    result = []
    for b in banners:
        # If image_url starts with http, leave it, else add local prefix
        if b.image_url.startswith("http"):
            url = b.image_url
        else:
            url = f"http://127.0.0.1:8000{b.image_url}"
        result.append({"id": b.id, "image_url": url})
    return result

# Delete a banner
@app.delete("/banners/{banner_id}")
def delete_banner(banner_id: int, db: Session = Depends(get_db)):
    banner = db.query(Banner).filter(Banner.id == banner_id).first()
    if not banner:
        raise HTTPException(status_code=404, detail="Banner not found")
    
    # Remove file only if it's a local file
    if not banner.image_url.startswith("http"):
        file_path = banner.image_url
        if os.path.exists(file_path):
            os.remove(file_path)

    db.delete(banner)
    db.commit()
    return {"message": "Banner deleted"}

# --- Add a new book ---
@app.post("/books", response_model=BookResponse)
def create_book(book: BookCreate, db: Session = Depends(get_db)):
    new_book = Book(
        title=book.title,
        author=book.author,
        file_url=book.file_url
    )
    db.add(new_book)
    db.commit()
    db.refresh(new_book)
    return new_book

# --- Get all books ---
@app.get("/books", response_model=list[BookResponse])
def get_all_books(db: Session = Depends(get_db)):
    return db.query(Book).order_by(Book.id.desc()).all()

# --- Get a book by id ---
@app.get("/books/{book_id}", response_model=BookResponse)
def get_book(book_id: int, db: Session = Depends(get_db)):
    book = db.query(Book).filter(Book.id == book_id).first()
    if not book:
        raise HTTPException(status_code=404, detail="Book not found")
    return book
