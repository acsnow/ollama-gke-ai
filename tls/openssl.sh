openssl req -x509 -nodes -days 365 -newkey rsa:2048 -out genai-ingress-tls.crt -keyout genai-ingress-tls.key -subj "/CN=genai.csnowconsulting.com/O=genai-ingress-tls"
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -out openai-ingress-tls.crt -keyout openai-ingress-tls.key -subj "/CN=openai.csnowconsulting.com/O=openai-ingress-tls"
