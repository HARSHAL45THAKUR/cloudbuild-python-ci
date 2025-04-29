#  CloudBuild Python CI - Flask App Deployment to Google Cloud Run

This project is a minimal Flask application that demonstrates automated CI/CD using **GitLab CI**, **Docker**, **Google Cloud Build**, and **Cloud Run**.

---

##  Project Structure

```bash
.
├── app.py                 # Flask application
├── Dockerfile             # Container build instructions
├── .gitlab-ci.yml         # GitLab CI/CD pipeline configuration
├── encoded-key.txt        # Base64-encoded GCP service account (not tracked)
└── README.md
```

---

##  Technologies Used

- **Flask** – Python web framework
- **Docker** – Containerization
- **Google Cloud Build** – Build Docker image
- **Google Cloud Run** – Host the app
- **GitLab CI/CD** – Automate build & deployment

---

##  Run Locally

To test the Flask app locally:

```bash
# (Optional) Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows use: venv\Scripts\activate

# Install Flask
pip install flask

# Run the app
python app.py
```

Then go to `http://localhost:8080`

---

##  Build Docker Image Locally (Optional)

```bash
docker build -t flask-app .
docker run -p 8080:8080 flask-app
```

---

##  GitLab CI/CD Pipeline

The `.gitlab-ci.yml` handles two stages:

###  Build Stage

- Authenticates using a GCP service account (`$GCLOUD_SERVICE_KEY`)
- Submits the app to **Google Cloud Build**
- Builds a Docker image and pushes it to **Google Container Registry (GCR)**

###  Deploy Stage

- Deploys the built image to **Google Cloud Run**
- Makes the app publicly accessible

###  .gitlab-ci.yml Overview

```yaml
image: google/cloud-sdk:latest

stages:
  - build
  - deploy

variables:
  PROJECT_ID: <your-project-id>
  IMAGE_NAME: python-gitlab-cloudbuild

before_script:
  - echo "$GCLOUD_SERVICE_KEY" > gcloud-key.json
  - gcloud auth activate-service-account --key-file=gcloud-key.json
  - gcloud config set project $PROJECT_ID

build:
  stage: build
  script:
    - gcloud builds submit --tag gcr.io/$PROJECT_ID/$IMAGE_NAME:$CI_COMMIT_SHORT_SHA .

deploy:
  stage: deploy
  script:
    - gcloud run deploy python-app-gitlab \
        --image gcr.io/$PROJECT_ID/$IMAGE_NAME:$CI_COMMIT_SHORT_SHA \
        --platform managed \
        --region us-central1 \
        --allow-unauthenticated
```

---

##  Security Notes

- `encoded-key.txt` contains your **base64-encoded service account** credentials.
- It's excluded from version control using `.gitignore`.
- Rotate credentials regularly for security.

---

##  Deployment Output

Once deployed, Cloud Run gives you a **public HTTPS URL** where the Flask app is live and accessible without authentication.

---
