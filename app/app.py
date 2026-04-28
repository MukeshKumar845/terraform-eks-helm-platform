from flask import Flask

app = Flask(__name__)


@app.get("/")
def health():
    return {"status": "ok", "service": "terraform-eks-helm-platform"}


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
