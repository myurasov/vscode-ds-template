import os
from datetime import datetime

print('Now is', datetime.today(), '\n')

# list gpus
print('GPUs:\n')
os.system('nvidia-smi -L')
