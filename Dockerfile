FROM python:3.10

ENV BOT_GATEWAY_TOKEN=

WORKDIR /workdir
COPY requirements.txt /workdir/requirements.txt
RUN pip install -r requirements.txt
COPY bot /workdir/bot

CMD [ "python", "bot/__init__.py" ]