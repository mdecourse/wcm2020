# https://developers.google.com/blogger/docs/3.0/using
# under Mac command + b to execute
import pickle
import os
from googleapiclient.discovery import build
from google_auth_oauthlib.flow import InstalledAppFlow


SCOPES = ['https://www.googleapis.com/auth/gmail.send', ]

# we check if the file tBo store the credentials exists
if not os.path.exists('./../../scrum_gmail_token.dat'):

    flow = InstalledAppFlow.from_client_secrets_file('./../../scrum_client_secrets.json', SCOPES)
    credentials = flow.run_local_server(port=0)

    with open('./../../scrum_gmail_token.dat', 'wb') as credentials_dat:
        pickle.dump(credentials, credentials_dat)
else:
    with open('./../../scrum_gmail_token.dat', 'rb') as credentials_dat:
        credentials = pickle.load(credentials_dat)
service = build('gmail', 'v1', credentials=credentials)
print(service)