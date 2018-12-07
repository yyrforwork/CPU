import cv2, time

t0 = time.time()
def progress(percent,msg='',show_time=0,width=50):
    '''
    Logging with progress bar
    '''
    percent = 1.0 if percent > 995e-3 else percent+5e-3
    time_str='|%6.1fm|'%((time.time()-t0)/60)
    show_str=('[%%-%ds]' %width) %(int(width * percent)*"#")
    show_str = msg+time_str+show_str if show_time else msg+show_str
    print('\r%s %d%%' %(show_str,percent*100),end='')

image = cv2.imread("img.jpg")
f = open("bin.txt", "w")

size = list(image.shape)
line = 0b00_1100_0000_0000_0000
data = ""

for i in range(size[0]):
    progress(float(i)/size[0])
    for j in range(size[1]):
        r,g,b = [int(d/32) for d in image[i,j]]
        ndata = "{:03b}{:03b}{:03b}".format(r,g,b)
        data += ndata
        if(len(data)>=16):
            f.writelines(("%06x=%04x\r\n"%(line, int(data[0:16],2))).upper())
            line += 1
            data = data[16:]