---

```markdown
# 🚀 DevOps Flask App Deployment using GitHub Actions & EC2

This project demonstrates a complete CI/CD pipeline where a **Flask application** is automatically deployed to an **AWS EC2 instance** using **GitHub Actions** whenever changes are pushed to the `main` branch.

---

## 📁 Project Structure

```
DevOps-Project/
│
├── flask-monitoring-app/        # Flask application
│   ├── app.py                   # Main Flask app
│   └── requirements.txt         # Python dependencies
│
├── .github/workflows/
│   └── deploy.yml               # GitHub Actions CI/CD pipeline
│
├── deploy.sh                    # EC2 deployment script
└── README.md                    # This file
```

---

## ⚙️ Tech Stack

- **Flask** – Python-based web application
- **GitHub Actions** – CI/CD pipeline
- **AWS EC2 (Ubuntu)** – Cloud server
- **SSH** – Secure remote access
- **Systemd Service** – Persistent app hosting

---

## 🚀 Deployment Workflow (CI/CD)

### ✅ Trigger

Whenever code is pushed to the `main` branch, GitHub Actions triggers the deployment workflow.

### ✅ GitHub Actions Workflow (`.github/workflows/deploy.yml`)

```yaml
name: Deploy Flask App to EC2

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout Code
      uses: actions/checkout@v3

    - name: Setup SSH Key
      run: |
        mkdir -p ~/.ssh
        echo "${{ secrets.EC2_KEY }}" > ~/.ssh/devops_key.pem
        chmod 600 ~/.ssh/devops_key.pem
        ssh-keyscan -H ${{ secrets.EC2_HOST }} >> ~/.ssh/known_hosts

    - name: Deploy to EC2
      run: |
        ssh -i ~/.ssh/devops_key.pem ${{ secrets.EC2_USER }}@${{ secrets.EC2_HOST }} "bash ~/deploy.sh"
````

---

## 📜 EC2 Deployment Script (`deploy.sh`)

```bash
#!/bin/bash

cd ~/flask-monitoring-app

# Pull latest changes
git pull origin main

# Activate virtual environment
source ~/env/bin/activate

# Install dependencies
pip install -r requirements.txt

# Restart the Flask systemd service
sudo systemctl restart flask.service
```

---

## 🧠 Systemd Service (`flask.service`)

Located at `/etc/systemd/system/flask.service` on EC2:

```ini
[Unit]
Description=Gunicorn instance to serve Flask App
After=network.target

[Service]
User=ec2-user
Group=www-data
WorkingDirectory=/home/ec2-user/flask-monitoring-app
Environment="PATH=/home/ec2-user/env/bin"
ExecStart=/home/ec2-user/env/bin/gunicorn --workers 3 --bind 0.0.0.0:5001 app:app

[Install]
WantedBy=multi-user.target
```

Enable and start it:

```bash
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable flask
sudo systemctl start flask
```

---

## 🔒 GitHub Secrets Required

Go to your repo → Settings → Secrets → Actions and add:

| Secret Name | Description                       |
| ----------- | --------------------------------- |
| `EC2_KEY`   | Your EC2 private key (PEM file)   |
| `EC2_USER`  | EC2 username (usually `ec2-user`) |
| `EC2_HOST`  | EC2 public IP or DNS name         |

---

## 🌐 Access the App

Once deployed, access it via:

```
http://<EC2-PUBLIC-IP>:5001
```

Make sure port `5001` is open in your EC2 Security Group (inbound rule).

---

## 💡 Future Enhancements

* [ ] NGINX Reverse Proxy + Port 80
* [ ] Custom domain with HTTPS (SSL)
* [ ] Telegram / Slack deployment alerts
* [ ] Dockerize the app and deploy via ECS or Kubernetes

---

## 🤝 Author

**Syed Sohail Mehmood**
💼 Aspiring DevOps Engineer | Cloud | Automation
🔗 [LinkedIn](https://linkedin.com/in/sohail52)
📫 [ssohailm07@gmail.com](mailto:ssohailm07@gmail.com)

---

## 🏁 Final Result

✅ CI/CD working via GitHub Actions
✅ Flask app auto-deploys to EC2
✅ Visible live on: `http://<your-ec2-ip>:5001`
```

---

