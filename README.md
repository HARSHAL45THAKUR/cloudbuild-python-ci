# ☁️ CloudBuild Python CI – Flask App Deployment to Google Cloud Run

A minimal Flask application showcasing **CI/CD automation** with **GitLab CI**, **Docker**, **Google Cloud Build**, and **Cloud Run**.

---

## 📁 Project Structure

```bash
.
├── app.py                 # Flask application
├── Dockerfile             # Container build instructions
├── .gitlab-ci.yml         # GitLab CI/CD pipeline configuration
├── encoded-key.txt        # Base64-encoded GCP service account (not tracked)
└── README.md
```

---

## 🚀 Technologies Used

- 🐍 **Flask** – Python micro web framework  
- 🐳 **Docker** – Containerization  
- ☁️ **Google Cloud Build** – Builds Docker image  
- 🌐 **Google Cloud Run** – Deploys app  
- 🔁 **GitLab CI/CD** – Automation for build & deploy  

---

## 🧪 Running Locally

To run the Flask app on your machine:

```bash
# (Optional) Create a virtual environment
python -m venv venv
source venv/bin/activate        # Windows: venv\Scripts\activate

# Install Flask
pip install flask

# Run the app
python app.py
```

Visit: [http://localhost:8080](http://localhost:8080)

---

## 🐳 Build Docker Image Locally (Optional)

```bash
docker build -t flask-app .
docker run -p 8080:8080 flask-app
```

---

## ⚙️ GitLab CI/CD Pipeline

The pipeline is defined in `.gitlab-ci.yml` with two key stages:

### 🔨 Build Stage

- Authenticates using the base64-encoded GCP service account (`$GCLOUD_SERVICE_KEY`)
- Submits the code to **Google Cloud Build**
- Builds and pushes the Docker image to **Google Container Registry (GCR)**

### 🚀 Deploy Stage

- Deploys the container to **Google Cloud Run**
- Exposes the app to the public with HTTPS

---

## 🧾 .gitlab-ci.yml Overview

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

## 🔐 How to Store the GCP Service Account Key in GitLab CI/CD

To allow GitLab to authenticate with Google Cloud during CI/CD, store the base64-encoded service account key securely as a variable:

### ✅ Steps:

1. **Encode your JSON key file:**

    ```bash
    base64 your-key-file.json > encoded-key.txt
    ```

2. **Copy the contents** of `encoded-key.txt`

3. Go to your GitLab Project:  
   → **Settings** → **CI/CD** → **Variables**

4. Click **"Add variable"** and configure:

   - **Key**: `GCLOUD_SERVICE_KEY`  
   - **Value**: *(Paste the base64 string you copied)*  
   - **Type**: Variable  
   - **Mask**: ✅ *(optional: hides value in logs)*  
   - **Protect**: ❌ *(leave unchecked unless using protected branches)*

That's it! Now your pipeline can securely authenticate and deploy without exposing credentials in the repo.

---

## 🛡️ Security Notes

- `encoded-key.txt` contains sensitive credentials and **is excluded** via `.gitignore`
- Always **rotate service keys** periodically and limit scope
- Never commit raw credentials — use encrypted or environment-based secrets

---

## 🌍 Deployment Output

Once deployed, Google Cloud Run provides a **public HTTPS URL** where your Flask app is live and accessible by anyone.

---

Made with ❤️ for DevOps and Cloud automation.
