# SocialEase: Enhancing Communication for Social Anxiety

## Overview

SocialEase is a comprehensive application designed to support individuals with social anxiety in navigating social situations more confidently. The app offers tools and resources to help users practise communication skills, interpret social cues, and manage anxiety in various social contexts.

## Features

- Guided Communication Exercises: Interactive scenarios to practise conversations and improve verbal skills.

- Real-Time Emotion Analysis: Provides feedback on emotional expressions to help users understand and manage their own emotions during interactions.

- Social Cue Interpretation: Assists users in reading and responding to social cues effectively.

- Progress Tracking: Monitors user progress and provides personalised recommendations.

## Prerequisites

Before setting up the application, ensure you have the following installed:

- Docker

- Dart SDK

- Flutter SDK

## Setup Instructions

1. Backend Setup

a. Navigate to the Backend Directory:

```bash
cd flutter_backend_server
```

b. Build and Start Backend Services:

Use Docker Compose to build and start the necessary services in detached mode:

```bash
docker compose up --build --detach
```

Note: The --detach flag runs the containers in the background.

c. Apply Database Migrations:

Execute the following command to apply any pending database migrations:

```bash
dart bin/main.dart --apply-migrations
```

This step ensures that your database schema is up-to-date.

2. Frontend Setup

a. Navigate to the Flutter Application Directory:

```bash
cd ichack_flutter_backend_flutter
```

b. Run the Flutter Application:

Start the Flutter application using the following command:

```bash
flutter run
```

This will launch the application on your connected device or emulator.

### Emotion Detection Service

An external emotion detection service is hosted on AWS and can be accessed at:

```bash
http://35.177.93.9/analyze
```

Usage:

Endpoint: /analyze

Method: POST

Request Body: JSON object containing an image parameter with the image data encoded in Base64.

Example Request:
```bash
{
  "image": "base64ImagetoString..."
}
```
Response:

The service will return a JSON response indicating the likely emotion detected in the image.

Ensure that your application correctly encodes image data to Base64 before sending the request.

## Additional Information

Serverpod Framework: The backend is built using Serverpod, an open-source, scalable app server written in Dart for the Flutter community.

Docker Compose: The docker compose up --build --detach command builds, (re)creates, starts, and attaches to containers for a service. The --detach flag runs containers in the background and leaves them running.
