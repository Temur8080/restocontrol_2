import requests
from requests.auth import HTTPDigestAuth

IP = "192.168.1.10"
USERNAME = "admin"
PASSWORD = "A112233a"

IMAGE_PATH = "/LOCALS/pic/acsLinkCap/202601_00/07_051227_30075_0.jpeg"
URL = f"http://{IP}{IMAGE_PATH}"

response = requests.get(
    URL,
    auth=HTTPDigestAuth(USERNAME, PASSWORD),
    timeout=10
)

if response.status_code == 200:
    with open("face.jpg", "wb") as f:
        f.write(response.content)
    print("✅ Rasm yuklandi (Digest Auth): face.jpg")
else:
    print("❌ Xato:", response.status_code)
