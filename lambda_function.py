import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

def lambda_handler(event, context):
  
    sender_email = "lineage2reforged@gmail.com" # es el mail secundario que tenia
    receiver_email = "guirever@gmail.com"
    subject = "Deploy exitoso"
    body = "El deploy de la aplicación de React en el Bucket de S3 fue exitoso"

    msg = MIMEMultipart()
    msg['From'] = sender_email
    msg['To'] = receiver_email
    msg['Subject'] = subject
    msg.attach(MIMEText(body, 'plain'))

    try:
        server = smtplib.SMTP('smtp.gmail.com', 587)
        server.starttls() 
        server.login(sender_email, "zsdombmzngcxytmm") 
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
