import os
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

def lambda_handler(event, context):
    sender_email = os.environ['SENDER_EMAIL']  
    sender_password = os.environ['SENDER_PASSWORD']  
    receiver_email = os.environ['RECEIVER_EMAIL'] 
    
    records = event.get('Records', [])
    if not records:
        return {
            'statusCode': 400,
            'body': "No se encontraron registros en el evento."
        }
    
    bucket_name = records[0]['s3']['bucket']['name']
    
    subject = "Deploy exitoso"
    body = f"El deploy de la aplicación de React en el bucket {bucket_name} fue exitoso."
    
    msg = MIMEMultipart()
    msg['From'] = sender_email
    msg['To'] = receiver_email
    msg['Subject'] = subject
    msg.attach(MIMEText(body, 'plain'))

    try:
        server = smtplib.SMTP('smtp.gmail.com', 587)
        server.starttls() 
        server.login(sender_email, sender_password)  
        text = msg.as_string()
        server.sendmail(sender_email, receiver_email, text)
        server.quit()
        
        return {
            'statusCode': 200,
            'body': "Correo enviado correctamente."
        }
        
    except Exception as e:
        return {
            'statusCode': 500,
            'body': f"Hubo un error al enviar el correo: {str(e)}"
        }