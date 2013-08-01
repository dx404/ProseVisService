#!/usr/bin/python
# Import smtplib for the actual sending function
import sys, smtplib
# Import the email modules we'll need
from email.mime.text import MIMEText

#sys.arg[1]
taskID = sys.argv[1]
recipient = sys.argv[2]
hostInfor = sys.argv[3]
# Create a text/plain message
msg = MIMEText("""
Note: This is an automatically generated email - do not reply!

Your document has been successfully processed. You can access your results at the following link:
    http://""" + hostInfor + """/rpv""" + taskID + """.zip

Thank you.
""")
# me == the sender's email address
# you == the recipient's email address
msg['Subject'] = 'ProseVis Testing: Job results for: ' + taskID
msg['From'] = "ProseVis@stampede.tacc.utexas.edu"
msg['To'] = recipient

# Send the message via our own SMTP server, but don't include the
# envelope header.
s = smtplib.SMTP('localhost')
s.sendmail(msg['From'] , [msg['To'] ], msg.as_string())
s.quit()