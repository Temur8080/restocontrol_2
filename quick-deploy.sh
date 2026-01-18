#!/bin/bash

# Quick Deployment Script
# Bu script tez deployment uchun

echo "🚀 Quick Deployment..."

# 1. Git pull
git pull

# 2. Install dependencies
npm install --production

# 3. Restart PM2
pm2 restart hodim-nazorati || pm2 start ecosystem.config.js

# 4. Show status
pm2 status

echo "✅ Done!"
