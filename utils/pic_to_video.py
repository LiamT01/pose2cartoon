import sys
import cv2
import os
from tqdm import tqdm

def pic_to_video(pic_list, video_name, fps, pic_size):
    """
    图片合成视频
    :param pic_list: 图片路径列表
    :param video_name: 生成视频的名字
    :param fps: 1s显示多少张图片
    :param pic_size: 图片尺寸
    :return:
    """
    # 'mp4v' 生成mp4格式的视频
    # 'DIVX' 生成avi格式的视频
    if "mp4" in video_name:
        video = cv2.VideoWriter(video_name, cv2.VideoWriter_fourcc(*'mp4v'), fps, pic_size)
    elif ".avi" in video_name:
        video = cv2.VideoWriter(video_name, cv2.VideoWriter_fourcc(*'DIVX'), fps, pic_size)
    else:
        print("格式错误")
        return

    for filename in tqdm(pic_list, total=len(pic_list)):
        if os.path.exists(filename):
            video.write(cv2.resize(cv2.imread(filename), pic_size))
    video.release()

if __name__ == "__main__":
    dir = 'visualization/' + sys.argv[1].split('/')[-1]
    img_list = []
    for i in range(1, 448):
        img_list.append(dir + '/' + str(i) + ".png")
    pic_to_video(img_list, dir + "/vis.mp4", 24, (840, 480))