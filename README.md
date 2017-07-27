# Traffic-Vehicle-Recognition-System
A summer project using neural network toolbox in MATLAB for differentiating toll paying vehicles and toll-exempted travellers.  


Documentation unfinished yet!>>
code restructuring pending>>
hardware limitations regarding Gpu (better then Nvidia Computing capabilty >=3.5 required)>>
Naive segmentation approach using background subtraction, will not work on complex images with higher number of occlusions and overlapping objects>>
>>the code will not work as such because of the limitations to upload trained network and data set>> dataset have to be collected and cann be trained using ImageCNN.m>>videotrafficgmm is the main module for classification, rest are supporting components>>
appropriate path variables for test videos ,test data , trained network and various other inputs and outputs will have to be recalibrated according to your system.
>>This repository does not account for the fulfillness of purpose specified because of the limitations of data upload limits(large datasets and trained network could not be uploaded) Although it may be useful for interested users to get an idea of approach used in my project which can be used in certain common Computer vision problems  

SUMMARY :->
The project titled was developed to study various characteristics of the different components of CNN. The objective of the project is to detect moving vehicles from the traffic video feed and recognize the category of the vehicle.For the sake of simplicity, the vehicles were divided into two classes: Toll-paying and Toll-exempted. Toll-paying included all the motor vehicles having four or more wheels, which need to pay toll at toll plaza, like cars, buses, lorry, trucks etc. On the other hand, Toll-exempted include walking people and two wheelers e.g. motor-bike, cycles, scooters; which are exempted from paying toll.The project has two components : 
1. Object detection/segmentation 
2. Object classification.

The image segmentation methods are used for segmenting the image to localize the objects and then the isolated image segment is resized and given to trained CNN for classification.

The results obtained so far are certainly encouraging as far as the classification component of the project is concerned.The CNN architecture designed, was able to handle the complex dataset pretty accurately and was successful in its objective. The segmentation component gave satisfactory results in the cases with less traffic (without overlapping or occlusions) but more robust methods are required to be studied and implemented for turning the project deliverables into a more polished end product
