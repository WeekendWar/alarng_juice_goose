import socket
import time

# Replace with the IP address of your iP 50 device
IP_ADDRESS = '192.168.1.77'
PORT = 19740

# Commands to control the iP 50
LINE_END = '\r\n'
POD1ON = 'POD1ON' + LINE_END
POD1OFF = 'POD1OFF' + LINE_END
POD2ON = 'POD2ON' + LINE_END
POD2OFF = 'POD2OFF' + LINE_END

def send_command(command):
    with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as s:

        # cmd_ba = bytearray(2) + bytearray(command, 'utf-8')
        # print(cmd_ba)

        s.sendto(command.encode(), (IP_ADDRESS, PORT))
        # s.sendto(cmd_ba, (IP_ADDRESS, PORT))
        print('Sent:', command)

# Example usage
send_command(LINE_END)
time.sleep(1)

for i in range(4):
    time.sleep(1)
    send_command(POD1ON)
    time.sleep(1)
    send_command(POD1OFF)
