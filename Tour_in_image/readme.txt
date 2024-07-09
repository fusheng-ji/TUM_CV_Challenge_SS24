Group 31 TUM CV challenge SS 24

Member:  Wenbo Ji, Xiang Ji, Hongru Li, Yuming Li, Shilin Zhang 

Successfully test on MacOS, Windows, Ubuntu with Matlab R2023b

---Dependency analysis---

In this Project we use Image Processing Toolbox provided by Matlab Official. (Obtained by Matlab Dependency Analyzer App)

---Start up---

- Doubble click 'Start_GUI.mlapp' or run 'main.m' under root path, then you will see the Wellcome Page.

---Wellcome Page----
In this page we explain the usage of our live demo and references of our method. 

To reach our github repo and project page, you can scan the QR codes on the right side.

Once you click the "Let's go!" button, the demo will start to run.

---Step 1: Data Selection---
- select the dataset root path and image you like.
- click 'Next Step'

---Step 2: Foreground Selection---
- clik "Label Foreground" to draw Polygon To Select Foreground Object
- wait for decomposited foreground objects and inpaint back ground
- click 'Next Step'

---Step 3: Spidery Mesh
- click 'select vanishing point' then draw it in the image
- click 'select wall' then draw rectangle to mention inner wall
- wait the perspective line show off then check is everything ok, otherwise just reproduce the operations again
- click 'Next Step'

---Step 4: Time to Tour
- adjust 'x' to change location of camera
- adjust 'z' to change focal length of camera
- adjust 'theta', 'phi', 'y' to change angle of camera
- click 'save current view' to save image  