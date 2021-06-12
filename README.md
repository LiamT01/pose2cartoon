# Pose2Cartoon 

EE228 课程大作业，利用3D骨架控制3D卡通人物。

# Maya 环境配置
  ## 系统 macOS Catalina 10.15.7
    
    1. 在官网上下载Maya 2020的安装程序后，按照提示进行即可。这一步没有难点。
    
    2. 在Terminal中添加环境变量
      2.1. sudo nano /etc/paths
      2.2. 输入密码
      2.3. 添加/Applications/Autodesk/maya2020/Maya.app/Contents/bin
      2.4. 保存并退出

经过上述步骤，就可以调用mayapy进行python脚本了。



# 匹配流程

  ## 给定数据匹配
  
  ### 对于给定模型的匹配，运行脚本transfer.py和vis.py,最终得到：
    
    1. 1个静态动作的obj文件；
    
    2. 文件夹obj_seq_5_3dmodel，内有447个obj (即447帧动作)；
    
    3. 447张open3D的窗口截图；
    
    4. 以及对比标准人体动作的MP4文件。

  ### 具体步骤如下：
   
    1. 运行transfer.py，得到原模型的关节点与编号的对应关系。
    
    2. 运行Blender并导入对应的fbx文件，根据关节位置和名称与标准人体(即smpl)的关节进行匹配，手动填写匹配字典。
    
    3. 将匹配字典作为参数运行transfer.py，得到一个静态obj文件和包含447个obj文件(即447帧动作)的文件夹3dmodel。
    
    4. 剩下的匹配步骤与3.1相同。因为下载的模型与smpl重合度较高，可以采用lazy模式自动匹配。


  ## 单mesh自选数据匹配与蒙皮

  ### 对于单mesh自选模型，先运行脚本fbx_parser.py。除与给定数据相同的文件外，额外产生了：
    
    1. 包含多个蒙皮png文件的文件夹fbm；
    
    2. 包含材质信息的mtl文件。

  ### 蒙皮的步骤（macOS）：

    1.运行fbx_parser.py生成的mtl中的路径本身即是相对路径，不存在引导失败的问题。这可能是系统的原因。

    2.transfer.py中默认生成的是symbol link，实际上无法蒙皮。于是修改transfer.py中生成symbol link的代码，
    替换为shutil包中的copy函数，直接将png和mtl文件拷贝到obj_seq_5_3dmodel文件夹中。这样可以成功蒙皮。

    3.剩下的步骤与前面相同，不再赘述。

# 新增脚本说明

  为了让整个过程更加自动化，编写了4个shell脚本，只需在terminal中运行脚本，即可完成一系列工作。
  
  对文件存放的结构作如下改变：
  
    1.原始数据（包括原始模型和人体obj_seq_5）放在raw文件夹下；

    2.提供的python脚本放在utils文件夹下。Shell脚本运行需要的一些路径配置文件放在conf文件夹下；

    3.每个模型生成的obj文件放在3dmodel文件夹中的一个文件夹中，以模型的名字命名后者；

    4.可视化的结果放在visualization文件夹下的一个文件夹中，同样用模型的名字命名。

  下面按4个脚本的顺序，简要介绍shell脚本的功能，以及对相应python脚本的改动。

  ## parse_fbx.sh 解析网上下载的fbx文件

  改动了fbx_parser.py，可以读取fbx的路径。
  
  本shell脚本读入网上下载的fbx文件的路径，用法如下：
  
  ./parse_fbx.sh raw/task2/1/ Ch25_nonPBR.fbx
  
  ## get_joint_indices.sh 得到模型的关节及编号，便于后续匹配

  改动了transfer.py，提取出transfer_given_pose函数中得到模型的关节及其编号的一部分。若传入transfer.py的第一个参数是1，则打印出模型的关节及其编号；若该参数为2，则进行关节匹配（这一功能由match_and_transfer.sh实现）。
  
  本shell脚本依次读入是task1还是task2、模型的路径。
  
  对给定数据(task1)的用法：
  
  ./get_joint_indices.sh 1 2794
  
  对自选数据(task2)的用法：
  
  ./get_joint_indices.sh 2 1/Ch25_nonPBR

  ## match_and_transfer.sh 进行关节的匹配
  
  改动了transfer.py，在传入transfer.py的第一个参数是2时，后面读入待匹配的模型的obj路径，用于匹配的字典，人体模型(smpl)的动作序列，和当前模型是否为网上下载的模型。
  
  本shell脚本依次读入是task1还是task2、模型路径、匹配字典、（可选）是否为自选模型。
  
  对给定数据(task1)的用法：
  
  ./match_and_transfer.sh 1 2794 "{0:0, 1:1, 2:3, 3:2, 5:4, 6:6, 7:5, 9:7, 10:9, 11:8, 12:10, 13:12, 14:13, 15:14, 16:11, 17:15, 18:16, 19:17, 20:18, 23:19, 26:20, 27:21}"
  
  对自选数据(task2)的用法：
  
  ./match_and_transfer.sh 2 5/dreyar_m_aure "{}" true
  
  因为自选模型与smpl的重合度很高，传入空字典，以采用lazy匹配模式。参数true告诉python脚本当前的模型是从网上下载的。

  ## visualize.sh 可视化结果

  修改了vis.py，可以读入需要可视化的obj序列，是否是从网上下载的模型，以及人体obj_seq_5的序列。
  
  为了解决在macOS上vis.py无法调用open3d生成MP4文件的问题，自己写了pic_to_video.py，使用open3d，利用vis.py生成的png文件来生成MP4。
  
  本shell脚本读入obj序列的路径、（可选）是否为自选模型。
  
  对给定数据(task1)的用法：
  
  ./visualize.sh 3dmodel/2794
  
  对自选数据(task2)的用法：
  
  ./visualize.sh 3dmodel/dreyar_m_aure true
  
  参数true说明该模型是从网上下载的。

# 项目结果

  下面是匹配结果的截图。

  ![image](../img/pose2carton.png)


# 协议 
  
  本项目在 Apache-2.0 协议下开源。

  所涉及代码及数据的最终解释权归倪冰冰老师课题组所有。

  涂宏伟 序号8
  组员 李思远 序号7
