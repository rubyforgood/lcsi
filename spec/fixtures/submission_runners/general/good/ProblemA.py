import sys
for line in sys.stdin.readlines():    
  print(line[1:].rstrip('\n') + line[0:1] + "ay")

