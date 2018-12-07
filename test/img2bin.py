#!/usr/bin/python3
import cv2, time

# image to instrctions and ram data
# eg:
# input:
#    i0.png         // 40x30 image
# output:
#    i0.png         // 40x30 image, 1 bit per channel
#    i0.png.txt     // instrctions to load this png to VGA
#    i0.png.data    // data for ram1 to save this image

name = "i2.png"

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

image = cv2.imread(name)
fbin = open(name+".data", "w")
fdat = open(name+".txt", "w")

size = list(image.shape)
line = 0b00_1100_0000_0000_0000
data = ""

fdat.writelines(("LI R2 C0\r\n").upper())
fdat.writelines(("SLL R2 R2 0\r\n").upper())
for i in range(size[0]):
    progress(float(i)/size[0])
    for j in range(size[1]):
        r,g,b = [int(d/128) for d in image[i,j]]
        ndata = "{:01b}{:01b}{:01b}".format(r,g,b)
        image[i,j] = [r*128,g*128,b*128]
        data += ndata
        if(len(data)>=16):
            fbin.writelines(("%06x=%04x\r\n"%(line, int(data[0:16],2))).upper())
            fdat.writelines(("LI R1 %02x\r\n"%int(data[0:8],2)).upper())
            if(int(data[8])==1):
                fdat.writelines(("SLL R1 R1 4\r\n").upper())
                fdat.writelines(("ADDIU R1 %02x\r\n"%int(data[8:12],2)).upper())
                fdat.writelines(("SLL R1 R1 4\r\n").upper())
                fdat.writelines(("ADDIU R1 %02x\r\n"%int(data[12:16],2)).upper())
            else:
                fdat.writelines(("SLL R1 R1 0\r\n").upper())
                fdat.writelines(("ADDIU R1 %02x\r\n"%int(data[8:16],2)).upper())
            fdat.writelines(("SW R2 R1 0\r\n").upper())
            fdat.writelines(("ADDIU R2 1\r\n").upper())
            line += 1
            data = data[16:]
progress(1.0)
fdat.writelines(("JR R7\r\nNOP\r\n").upper())

fbin.close()
fdat.close()

cv2.imwrite(name,image)
cv2.imshow(name,image)

cv2.waitKey(0)