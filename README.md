# Welcome to ARPowerPanels!

Reimagining the power of Xcode's View Debugger for live debugging of AR or SceneKit apps. 2018 WWDC Scolarship application in Swift 4. 

**Today is a good day for experimentation.**

*"Control is for Beginners. Iteration is truly the mother of invention."*


Hello, fellow traveller.

Whereever you are in your journey of learning or developing, I want to be of use to you. For people still developing their 3D intuition, this can be a playground within a playground. Once you start developing, you can use this framework to help you view and debug your scenes live, without having to pause your app.

*"How far is 30 units?"*

*"What does a quaternion look like?"*

*"I dropped an model into my AR app -- but where did it go?"* <--- I feel you. This happens a lot to me.

ARPowerPanels will help you answer that. Here are a few things to try.

- Open the `Easy Moves` menu on the lefthand menu. You can scrub your finger up and down to change the numbers, or you can tap into a text field to manually type any number. (The keyboard has a button to make the number negative, and another button to make it zero.)

- Open the `Scene Graph`. This will show you the current hierachy of nodes in the scene. The emojis tell you whether there are any light, geometry, or camera attached to that node. You can tap the triangle to the left of a parent node to hide or show its children.

- Tap on any row in the `Scene Graph` to select it. You can now edit it with any of the transform actions. Try to find the camera node that represents your iPad!

- On the top left, tap "Game". That's what your scene looks like from another point of view! Move your iPad around to see how feature points near where you are pointing your camera. That camera object represents your device! Tap the camera in the scene graph to move your POV around numerically. Drag your fingers across to rotate, pinch, or pan the camera.

- See the spinning fox named Paige? See if you can guess how the rotational numbers will change in  `Easy Moves`, and then tap `Paige` on the Scene Graph, and tap `Easy Moves` to view the animation live.

- There can be up to two menu panels on the right side. Tap an menu item will show or dismiss it. Do you want the `Scene Graph` on top, and `Easy Moves` on the bottom? Dismiss all your panels, and then show them by tapping `Scene Graph` first, then `Easy Moves`

- The `info` tab lets you change the name of any node, and it also gives you the size of the smallest box that can contain that node and all its children. You can hide any node by changing the opacity to 0.

- On the `Scene Graph` there are 3D models that you can place into your scene! The life sized wolf is my favourite -- I can stare at it all day. Selecting a model will place that model as a child of your selected node with no position or rotational values. If nothing happened, check that you have a node selected.

- On the `Scene Graph` panel, you can also drop in some Geometric shapes. Try to create a rocket with the panels, and write down the numbers, and then recreate it in code~

- The fox nodes has a lot of child nodes! If you want to how many pieces make up a tiny fox, simply replace
`addNode(foxNode, to: scene.rootNode)`
with
`scene.rootNode.addChild(foxNode)`

- Want to play with this on a phone, or use the whole thing, or bits and pieces on your app?
Come grab the Universal iOS app, and [available on my Github](https://github.com/p-sun/ARPowerPanels). There's some code I've commentd out highlights the currently selected node in yellow with a Metal shader. It doesn't play well in a playground.

- After you're done experimenting around, feel free to take the project and drop it into any ARKit app to help you debug and understand it in real time. The `ARPowerPanel` class is just a view that takes an ARSCNView as a parameter -- it's easy to use.

- Of course, try to create your own world here!

Thank you so much for visiting! We could definitely use more features and some code clean up. I'd be super happy if you would like to be involved. Make a PR or contact me anytime!

Yours Truely,

-- Paige Sun

GitHub [@p-sun](https://github.com/p-sun)

Email [paige.sun.dev@gmail.com](paige.sun.dev@gmail.com)

LinkedIn [https://www.linkedin.com/in/paigesun/](https://www.linkedin.com/in/paigesun/)

Toronto, ON, Canada

## Let's get started! 🚀

![image1]
![image2]
![image3]
![image4]
![image5]

[image1]: https://github.com/p-sun/ARPowerPanels/blob/master/Screenshots/ARPowerPanels_1.PNG
[image2]: https://github.com/p-sun/ARPowerPanels/blob/master/Screenshots/ARPowerPanels_2.PNG
[image3]: https://github.com/p-sun/ARPowerPanels/blob/master/Screenshots/ARPowerPanels_3.PNG
[image4]: https://github.com/p-sun/ARPowerPanels/blob/master/Screenshots/ARPowerPanels_4.PNG
[image5]: https://github.com/p-sun/ARPowerPanels/blob/master/Screenshots/ARPowerPanels_5.PNG
