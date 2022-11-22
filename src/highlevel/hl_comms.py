from ws4py.client.threadedclient import WebSocketClient
import json  
import time

class BasicClient(WebSocketClient):
    def opened(self):
        self.operation_mode = None
        self.responded = True
        # self.arm_pose = None

        privilege_request = ['request-privilege', 
                                {'privilege' : 'change-action-command',
                                 'priority' : 0}]
        self.send(json.dumps(privilege_request))


    def closed(self, code, reason):
        print(("Closed", code, reason))


    def received_message(self, m):
        dataloaded = json.loads(m.data)
        message_type = str(dataloaded[0])
        message_dict = dataloaded[1]

        if message_type == 'privileges':
            self.done = message_dict['privileges'][0]['has']
            if self.done:
                print("Privilege request executed successfully.")

        elif message_type == 'robot-status':
            self.responded = True
            self.operation_mode = str(message_dict['operation-mode'])

        elif message_type == 'error':
            self.error_info = str(message_dict['info'])
            print('Error: ', self.error_info)

        elif message_type == 'action-status-changed':
            if message_dict['status'] == 'running':
                # print('Command received and is running')
                self.completed = False

            elif message_dict['status'] == 'success':
                print('Command finished successfully executing: ', str(message_dict['info']))
                self.completed = True
            elif message_dict['status'] == 'error':
                print('Error: ', str(message_dict['info']))
                self.completed = True 


class HLComms:
    def __init__(self, real=True):
        if real:
            ip = "ws://10.10.2.1:8080"
        else:
            ip = "ws://127.0.0.1:8080"
        self.ws = BasicClient(ip, protocols=["json-v1-agility"])
        self.ws.daemon = False
        while True:
            try:
                self.ws.connect()
                print("WS connection established")
                time.sleep(1)
                break
            except:
                print('WS connection NOT established')
                time.sleep(1)
    
    def set_lowlevel_mode(self):
        msg = [ 
                "action-set-operation-mode",
                {
                    "mode": "low-level-api"
                }
            ]
        self.ws.send(json.dumps(msg))
        time.sleep(5.0)
        print("booo")
        # self.ws.close()
    
    def set_locomotion_mode(self):
        msg = [ 
                "action-set-operation-mode",
                {
                    "mode": "locomotion"
                }
            ]
        self.ws.send(json.dumps(msg))
        time.sleep(5.0)
        # self.ws.close()
