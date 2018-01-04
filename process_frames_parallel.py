import subprocess
import math

frame_list_file = "./frame_list.txt"

matlab_script = 'demo_for_std2p_parallel';

launch_generate_frame_list = "matlab -nodesktop -nosplash -r 'generateFrameList=1;%s;exit;'" % (matlab_script)

launch_save_frame_batch_wait = "matlab -nodesktop -nosplash -r 'batchId=%d;operation=%d;%s;exit;'"
launch_save_frame_batch = '%s &' % (launch_save_frame_batch_wait)

operation = 1; # Can be 0-ALL (to generate superpixels) or 1-HHA
testing = False; # If true just messages will be displayed

#print(launch_generate_frame_list)
#print(launch_save_frame_batch)

subprocess.call(launch_generate_frame_list, shell=True)

# Read the frame list to determine how many workers needed
with open(frame_list_file) as frames:
   line = frames.readline()
   cnt = 1
   # Loop through target frames
   while line:
       #print("Line {}: {}".format(cnt, line.strip()))
       frame = line.strip()

       line = frames.readline()
       cnt += 1

#workers = cnt - 1;
# For testing
#workers = 4;
workers = 32;

specificWorker = False;
specificBatchId = 51;

# Keep launching workers in batches until frame list is consumed
for ii in range(0, int(math.ceil(float(cnt)/workers))):
  # Spawn the workers
  for x in range(0, workers):
    if (x+1+(ii * workers) > cnt - 1):
      exit()
    batchId = (x+1+(ii * workers))
    print('BatchId: %d' % (batchId))
    if(not specificWorker or (specificWorker and batchId==specificBatchId)): # adjust if you want only a specific file
      if (x == (workers-1)):
        spawn_command = launch_save_frame_batch_wait % (x+1+(ii * workers), operation, matlab_script)
      else:
        spawn_command = launch_save_frame_batch % (x+1+(ii * workers), operation, matlab_script)
      if (testing):
        print(spawn_command)
      else:
        subprocess.call(spawn_command, shell=True)

