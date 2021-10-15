import time

def counter_loop():
    count = 0
    while True:
        print("count=%d" % count)
        time.sleep(1)
        count += 1

counter_loop()
