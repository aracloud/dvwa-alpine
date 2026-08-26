# dvwa-alpine
lightweight dvwa container for demo purposes only

Docker image for DVWA ([Damn Vulnerable Web Application](https://github.com/digininja/DVWA))

### Note
This container runs directly with an initialized MySQL database.
So, it's ready for testing without any further manual setup step's needed.
Just plug-n-play makes it very easy to use!

### Login credentials
- username: `admin`
- password: `password`

### Using

- Pull image: `docker pull ghcr.io/aracloud/dvwa-alpine:latest`
- Start (with random mysql password): `docker run -dit -p 80:80 ghcr.io/aracloud/dvwa-alpine:latest`