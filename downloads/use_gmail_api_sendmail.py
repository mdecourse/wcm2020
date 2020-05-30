import pickle
from googleapiclient.discovery import build
from email.mime.text import MIMEText
from base64 import urlsafe_b64encode
from apiclient import errors

def create_message(sender, to, subject, message_text):
    """Create a message for an email.
        
    Args:
        sender: Email address of the sender.
        to: Email address of the receiver.
        subject: The subject of the email message.
        message_text: The text of the email message.
        
    Returns:
        An object containing a base64url encoded email object.
    """
    message = MIMEText(message_text)
    message['to'] = to
    message['from'] = sender
    message['subject'] = subject
    encoded_message = urlsafe_b64encode(message.as_bytes())
    return {'raw': encoded_message.decode()}
  
def send_message(service, user_id, message):
    """Send an email message.
    
    Args:
        service: Authorized Gmail API service instance.
        user_id: User's email address. The special value "me"
        can be used to indicate the authenticated user.
        message: Message to be sent.
        
    Returns:
        Sent Message.
    """
    try:
        message = (service.users().messages().send(userId=user_id, body=message).execute())
        #print('Message Id: %s' % message['id'])
        return message
    except errors.HttpError as error:
        #print('An error occurred: %s' % error)
        g.es("error")


#SCOPES = ['https://www.googleapis.com/auth/gmail.send', ]

with open('./../../scrum_gmail_token.dat', 'rb') as credentials_dat:
    credentials = pickle.load(credentials_dat)
service = build('gmail', 'v1', credentials=credentials)
#g.es(service)

sender = "scrum1@domain"
to = "scrum2@domain"
subject = "測試"
message_text = "這是測試內文 http://www.google.com"
message = create_message(sender, to, subject, message_text)
user_id = "me"
send_message(service, user_id, message)
g.es(" 已經寄出")

