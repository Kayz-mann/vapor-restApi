# E-Learning REST API

A comprehensive REST API built with Vapor 4.119.0 (Server-Side Swift) for managing an e-learning platform with courses, guides, articles, and sessions.

## Table of Contents

- [Tech Stack](#tech-stack)
- [Features](#features)
- [Getting Started](#getting-started)
- [Authentication](#authentication)
- [API Documentation](#api-documentation)
  - [Public Routes](#public-routes)
  - [Authentication Routes](#authentication-routes)
  - [User Routes](#user-routes)
  - [Content Routes (Public)](#content-routes-public)
  - [Admin Routes](#admin-routes)
  - [Student Routes](#student-routes)
- [Data Models](#data-models)
- [Error Handling](#error-handling)

## Tech Stack

- **Framework**: Vapor 4.119.0
- **Language**: Swift 6.2.1
- **Database**: PostgreSQL
- **ORM**: Fluent 4.13.0
- **Authentication**: Bearer Token Authentication

## Features

- User authentication and authorization with role-based access control (Admin/Student)
- CRUD operations for courses, guides, articles, and video sessions
- Content filtering by status (draft, published, planned, trashed)
- Search functionality across all content types
- Secure password hashing with Bcrypt
- Token-based session management
- RESTful API design

## Getting Started

### Prerequisites

- Swift 6.0+ installed
- PostgreSQL 16+ installed and running
- Vapor Toolbox (optional but recommended)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd restApi
```

2. Configure database connection in `Sources/App/configure.swift` or set environment variables:
```bash
export DATABASE_HOST=localhost
export DATABASE_PORT=5432
export DATABASE_USERNAME=elearningdb
export DATABASE_PASSWORD=your_password
export DATABASE_NAME=elearningdb
```

3. Build and run:
```bash
swift build
swift run App serve
```

The API will be available at `http://localhost:8080`

## Authentication

This API uses bearer token authentication. Most endpoints require authentication.

### Obtaining a Token

1. Register a user account
2. Login with credentials to receive a bearer token
3. Include the token in the `Authorization` header for subsequent requests:

```
Authorization: Bearer <your-token-here>
```

### User Roles

- **Admin**: Full access to create, update, and delete all content
- **Student**: Read access to published content and protected resources

---

## API Documentation

### Public Routes

#### Root Endpoint
```http
GET /
```
**Description**: Welcome message

**Response**:
```
Welcome to the API!
```

---

#### Health Check
```http
GET /health
```
**Description**: Check if the API is running

**Response**:
```
OK
```

---

#### Debug Users
```http
GET /debug-users
```
**Description**: Get all users with basic information (for debugging)

**Response**:
```json
[
  {
    "email": "user@example.com",
    "hasPassword": "true",
    "verified": "true"
  }
]
```

---

### Authentication Routes

#### Login
```http
POST /login
```
**Description**: Authenticate user and receive bearer token

**Request Body**:
```json
{
  "userName": "johndoe",
  "password": "securepassword123"
}
```

**Response**:
```json
{
  "id": "uuid-here",
  "value": "token-value-here",
  "userId": "user-uuid",
  "expiresAt": "2025-11-17T00:00:00Z",
  "createdAt": "2025-11-10T00:00:00Z"
}
```

**Status Codes**:
- `200 OK`: Login successful
- `401 Unauthorized`: Invalid credentials

---

### User Routes

#### Register User
```http
POST /users/register
```
**Description**: Create a new user account

**Request Body**:
```json
{
  "userName": "johndoe",
  "email": "john@example.com",
  "password": "securepassword123",
  "name": "John"
}
```

**Response**:
```json
{
  "id": "uuid-here",
  "userName": "johndoe",
  "email": "john@example.com",
  "name": "John",
  "createdAt": "2025-11-10T00:00:00Z"
}
```

**Status Codes**:
- `201 Created`: User created successfully
- `400 Bad Request`: Invalid input data
- `409 Conflict`: User already exists

---

#### Get Current User
```http
GET /user
```
**Authentication**: Required (Bearer Token)

**Description**: Get the authenticated user's profile

**Response**:
```json
{
  "id": "uuid-here",
  "userName": "johndoe",
  "email": "john@example.com",
  "name": "John",
  "lastName": "Doe",
  "city": "New York",
  "address": "123 Main St",
  "country": "USA",
  "postalcode": "10001",
  "bio": "Software developer",
  "role": "student"
}
```

---

#### Update User Profile
```http
PUT /user
```
**Authentication**: Required (Bearer Token)

**Description**: Update the authenticated user's profile

**Request Body**:
```json
{
  "name": "John",
  "lastName": "Doe",
  "userName": "johndoe",
  "email": "john@example.com",
  "city": "New York",
  "address": "123 Main St",
  "country": "USA",
  "postalcode": "10001",
  "bio": "Full-stack developer"
}
```

**Response**:
```json
{
  "message": "User updated successfully",
  "data": {
    "id": "uuid-here",
    "userName": "johndoe",
    "email": "john@example.com",
    ...
  }
}
```

---

#### Delete User Account
```http
DELETE /user
```
**Authentication**: Required (Bearer Token)

**Description**: Delete the authenticated user's account

**Response**:
```json
{
  "message": "User deleted successfully"
}
```

---

#### Verify User (Token Auth)
```http
GET /users/verify/:id
```
**Authentication**: Required (Bearer Token)

**Description**: Verify a user account by ID

**Parameters**:
- `id` (UUID): User ID to verify

---

### Content Routes (Public)

#### Get All Courses
```http
GET /users/courses
```
**Description**: Retrieve all published courses

**Response**:
```json
[
  {
    "id": "uuid-here",
    "title": "Swift Programming Masterclass",
    "slug": "swift-programming-masterclass",
    "tags": ["swift", "ios", "programming"],
    "description": "Learn Swift from scratch",
    "status": "published",
    "price": "free",
    "headerImage": "https://example.com/image.jpg",
    "topHexColor": "#FF6B6B",
    "bottomHexColor": "#4ECDC4",
    "syllabus": "https://example.com/syllabus.pdf",
    "assets": "https://example.com/assets.zip",
    "article": "Course overview text...",
    "author": "John Doe",
    "publishDate": "2025-11-10T00:00:00Z",
    "createdAt": "2025-11-10T00:00:00Z",
    "updatedAt": "2025-11-10T00:00:00Z"
  }
]
```

---

#### Get Course by Slug
```http
GET /users/courses/:slug
```
**Description**: Retrieve a specific course by its slug

**Parameters**:
- `slug` (string): Course slug (e.g., "swift-programming-masterclass")

**Response**: Single course object

---

#### Get All Guides
```http
GET /users/guides
```
**Description**: Retrieve all published guides

**Response**:
```json
[
  {
    "id": "uuid-here",
    "title": "Swift Best Practices Guide",
    "slug": "swift-best-practices",
    "description": "Industry-standard Swift coding practices",
    "headerImage": "https://example.com/guide.jpg",
    "price": "free",
    "status": "published",
    "author": "John Doe",
    "tags": ["swift", "best-practices"],
    "publishDate": "2025-11-10T00:00:00Z",
    "createdAt": "2025-11-10T00:00:00Z",
    "updatedAt": "2025-11-10T00:00:00Z"
  }
]
```

---

#### Get Guide by Slug
```http
GET /users/guides/:slug
```
**Description**: Retrieve a specific guide by its slug

**Parameters**:
- `slug` (string): Guide slug

**Response**: Single guide object

---

### Student Routes

These routes require authentication and student role.

#### Get Session by Slug
```http
GET /users/courses/:slug/session/:articleSlug
```
**Authentication**: Required (Bearer Token - Student Role)

**Description**: Retrieve a specific video session within a course

**Parameters**:
- `slug` (string): Course slug
- `articleSlug` (string): Session slug

**Response**:
```json
{
  "id": "uuid-here",
  "title": "Introduction to Swift",
  "slug": "introduction-to-swift",
  "mp4URL": "https://example.com/video.mp4",
  "hlsURL": "https://example.com/video.m3u8",
  "publishDate": "2025-11-10T00:00:00Z",
  "price": "free",
  "article": "Session description...",
  "course": "course-uuid",
  "createdAt": "2025-11-10T00:00:00Z",
  "updatedAt": "2025-11-10T00:00:00Z"
}
```

---

#### Get Article by Slug
```http
GET /users/guides/:slug/article/:articleSlug
```
**Authentication**: Required (Bearer Token - Student Role)

**Description**: Retrieve a specific article within a guide

**Parameters**:
- `slug` (string): Guide slug
- `articleSlug` (string): Article slug

**Response**:
```json
{
  "id": "uuid-here",
  "title": "Understanding Swift Optionals",
  "slug": "understanding-swift-optionals",
  "excerp": "Brief overview...",
  "content": "Full article content...",
  "guide": "guide-uuid",
  "headerImage": "https://example.com/article.jpg",
  "author": "John Doe",
  "status": "published",
  "price": "free",
  "role": "article",
  "tags": ["swift", "optionals"],
  "publishDate": "2025-11-10T00:00:00Z",
  "createdAt": "2025-11-10T00:00:00Z",
  "updatedAt": "2025-11-10T00:00:00Z"
}
```

---

### Admin Routes

All admin routes require authentication with admin role.

---

## Courses (Admin)

#### Create Course
```http
POST /courses
```
**Authentication**: Required (Bearer Token - Admin Role)

**Request Body**:
```json
{
  "title": "Advanced Swift Development",
  "tags": ["swift", "advanced", "ios"],
  "description": "Master advanced Swift concepts",
  "status": "draft",
  "price": "pro",
  "headerImage": "https://example.com/header.jpg",
  "topHexColor": "#FF6B6B",
  "bottomHexColor": "#4ECDC4",
  "syllabus": "https://example.com/syllabus.pdf",
  "assets": "https://example.com/assets.zip",
  "article": "Course overview...",
  "publishDate": "2025-12-01T00:00:00Z"
}
```

**Response**: Created course object with `201 Created` status

---

#### Get Course by Slug (Admin)
```http
GET /courses/:slug
```
**Authentication**: Required (Bearer Token - Admin Role)

**Description**: Get any course (including drafts) by slug

---

#### Get All Courses (Admin)
```http
GET /courses
```
**Authentication**: Required (Bearer Token - Admin Role)

**Description**: Get all courses regardless of status

---

#### Update Course
```http
PATCH /courses/:slug
```
**Authentication**: Required (Bearer Token - Admin Role)

**Request Body**: Same as create course (all fields optional)

**Response**: Updated course object

---

#### Delete Course
```http
DELETE /courses/:slug
```
**Authentication**: Required (Bearer Token - Admin Role)

**Response**:
```json
{
  "message": "Course deleted successfully"
}
```

---

#### Get Courses by Status
```http
GET /courses/status?status=published
```
**Authentication**: Required (Bearer Token - Admin Role)

**Query Parameters**:
- `status` (string): One of `draft`, `published`, `planned`, `trashed`

**Response**: Array of courses with matching status

---

#### Search Courses
```http
GET /courses/:term
```
**Authentication**: Required (Bearer Token - Admin Role)

**Parameters**:
- `term` (string): Search term to match against course titles and descriptions

**Response**: Array of matching courses

---

## Guides (Admin)

#### Create Guide
```http
POST /guides
```
**Authentication**: Required (Bearer Token - Admin Role)

**Request Body**:
```json
{
  "title": "API Design Guide",
  "description": "Best practices for API design",
  "headerImage": "https://example.com/guide.jpg",
  "price": "free",
  "status": "published",
  "tags": ["api", "design", "best-practices"],
  "publishDate": "2025-11-10T00:00:00Z"
}
```

**Response**: Created guide object

---

#### Get Guide by Slug (Admin)
```http
GET /guides/:slug
```
**Authentication**: Required (Bearer Token - Admin Role)

---

#### Get All Guides (Admin)
```http
GET /guides
```
**Authentication**: Required (Bearer Token - Admin Role)

---

#### Update Guide
```http
PATCH /guides/:slug
```
**Authentication**: Required (Bearer Token - Admin Role)

**Request Body**: Same as create guide (all fields optional)

---

#### Delete Guide
```http
DELETE /guides/:slug
```
**Authentication**: Required (Bearer Token - Admin Role)

---

#### Search Guides
```http
GET /guides/:term
```
**Authentication**: Required (Bearer Token - Admin Role)

**Parameters**:
- `term` (string): Search term

---

## Articles (Admin)

#### Create Article
```http
POST /articles
```
**Authentication**: Required (Bearer Token - Admin Role)

**Request Body**:
```json
{
  "title": "Understanding Closures in Swift",
  "slug": "understanding-closures-swift",
  "excerp": "Learn about closures...",
  "content": "Full article content here...",
  "guide": "guide-uuid",
  "headerImage": "https://example.com/article.jpg",
  "status": "published",
  "price": "free",
  "role": "article",
  "tags": ["swift", "closures", "functions"],
  "publishDate": "2025-11-10T00:00:00Z"
}
```

**Response**: Created article object

---

#### Get Article by Slug (Admin)
```http
GET /articles/:slug
```
**Authentication**: Required (Bearer Token - Admin Role)

---

#### Get All Articles (Admin)
```http
GET /articles
```
**Authentication**: Required (Bearer Token - Admin Role)

---

#### Update Article
```http
PATCH /articles/:slug
```
**Authentication**: Required (Bearer Token - Admin Role)

---

#### Delete Article
```http
DELETE /articles/:slug
```
**Authentication**: Required (Bearer Token - Admin Role)

---

#### Get Articles by Status
```http
GET /articles/status?status=published
```
**Authentication**: Required (Bearer Token - Admin Role)

**Query Parameters**:
- `status` (string): One of `draft`, `published`, `planned`, `trashed`

---

#### Search Articles
```http
GET /articles/:term
```
**Authentication**: Required (Bearer Token - Admin Role)

---

## Sessions (Admin)

Video sessions are lessons within courses.

#### Create Session
```http
POST /sessions
```
**Authentication**: Required (Bearer Token - Admin Role)

**Request Body**:
```json
{
  "title": "Introduction to Variables",
  "slug": "introduction-to-variables",
  "mp4URL": "https://example.com/video.mp4",
  "hlsURL": "https://example.com/video.m3u8",
  "publishDate": "2025-11-10T00:00:00Z",
  "price": "free",
  "article": "In this session we cover...",
  "course": "course-uuid"
}
```

**Response**: Created session object

---

#### Get Session by Slug (Admin)
```http
GET /sessions/:slug
```
**Authentication**: Required (Bearer Token - Admin Role)

---

#### Get All Sessions (Admin)
```http
GET /sessions
```
**Authentication**: Required (Bearer Token - Admin Role)

---

#### Update Session
```http
PATCH /sessions/:slug
```
**Authentication**: Required (Bearer Token - Admin Role)

---

#### Delete Session
```http
DELETE /sessions/:slug
```
**Authentication**: Required (Bearer Token - Admin Role)

---

#### Get Sessions by Status
```http
GET /sessions/status?status=published
```
**Authentication**: Required (Bearer Token - Admin Role)

---

#### Search Sessions
```http
GET /sessions/search?q=swift
```
**Authentication**: Required (Bearer Token - Admin Role)

**Query Parameters**:
- `q` (string): Search term

---

## Data Models

### User
```swift
{
  id: UUID
  userName: String
  email: String
  password: String (hashed)
  name: String
  lastName: String?
  city: String?
  address: String?
  country: String?
  postalcode: String?
  bio: String?
  role: String ("admin" | "student")
  verify: Bool?
  createdAt: Date
  updatedAt: Date
}
```

### Course
```swift
{
  id: UUID
  title: String
  slug: String (unique)
  tags: [String]
  description: String
  status: String ("draft" | "published" | "planned" | "trashed")
  price: String ("free" | "pro")
  headerImage: URL?
  topHexColor: String
  bottomHexColor: String
  syllabus: URL?
  assets: URL?
  article: String
  author: String
  publishDate: Date
  createdAt: Date
  updatedAt: Date
}
```

### Guide
```swift
{
  id: UUID
  title: String
  slug: String (unique)
  description: String
  headerImage: URL?
  price: String ("free" | "pro")
  status: String
  author: String
  tags: [String]
  publishDate: Date
  createdAt: Date
  updatedAt: Date
}
```

### Article
```swift
{
  id: UUID
  title: String
  slug: String (unique)
  excerp: String
  content: String
  guide: UUID (foreign key)
  headerImage: URL?
  author: String
  status: String
  price: String
  role: String ("article" | "podcast" | "blogpost" | "tutorial" | "livestream")
  tags: [String]
  publishDate: Date
  createdAt: Date
  updatedAt: Date
}
```

### Session
```swift
{
  id: UUID
  title: String
  slug: String (unique)
  mp4URL: URL?
  hlsURL: URL?
  publishDate: Date
  price: String
  article: String
  course: UUID (foreign key)
  createdAt: Date
  updatedAt: Date
}
```

### Token
```swift
{
  id: UUID
  value: String (unique)
  userId: UUID (foreign key)
  expiresAt: Date
  createdAt: Date
}
```

---

## Error Handling

The API uses standard HTTP status codes:

### Success Codes
- `200 OK`: Request successful
- `201 Created`: Resource created successfully
- `204 No Content`: Request successful, no content to return

### Client Error Codes
- `400 Bad Request`: Invalid request data
- `401 Unauthorized`: Authentication required or failed
- `403 Forbidden`: Insufficient permissions
- `404 Not Found`: Resource not found
- `409 Conflict`: Resource already exists

### Server Error Codes
- `500 Internal Server Error`: Server error occurred

### Error Response Format
```json
{
  "error": true,
  "reason": "Detailed error message here"
}
```

---

## Development

### Running Migrations

Migrations run automatically on server start. To run them manually:

```bash
swift run App migrate
```

To revert migrations:

```bash
swift run App migrate --revert
```

### Database Seeding

Sample content can be seeded using the `SeedContentMigration`. Uncomment in `configure.swift`:

```swift
app.migrations.add(SeedContentMigration())
```

### Testing Endpoints

You can use curl, Postman, or any HTTP client to test endpoints.

Example using curl:

```bash
# Register a user
curl -X POST http://localhost:8080/users/register \
  -H "Content-Type: application/json" \
  -d '{"userName":"testuser","email":"test@example.com","password":"password123","name":"Test"}'

# Login
curl -X POST http://localhost:8080/login \
  -H "Content-Type: application/json" \
  -d '{"userName":"testuser","password":"password123"}'

# Get courses (with token)
curl -X GET http://localhost:8080/users/courses \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

---

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

---

## License

This project is licensed under the MIT License.

---

## Support

For issues and questions, please open an issue on the GitHub repository.
