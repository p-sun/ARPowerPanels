# Welcome to ARPowerPanels!

Reimagining the power of Xcode's View Debugger for live debugging of AR or SceneKit apps. 2018 WWDC Scolarship application in Swift 4. Pan vertically or type into the textfields to change the numbers, your node will update instantly. Drop more models and basic shapes into your scene. View and edit your node heirachy.

**Today is a good day for experimentation.**

*"Control is for Beginners. Iteration is truly the mother of invention."*


Hello, fellow traveller.

Where ever you are in your journey of learning or developing, I want to be of use to you. For people still developing their 3D intuition, this can be a playground within a playground. Once you start developing, you can use this framework to help you view and debug your scenes live, without having to pause your app.

*"How far is 30 units?"*

*"What does a quaternion look like?"*

*"I dropped an model into my AR app -- but where did it go?"* <--- I feel you. This happens a lot to me.

ARPowerPanels will help you answer that.

## Let's get started! 🚀
- Tap any panel on the left to display it. Then tap again to hide it.
- Select a node by tapping the node, or selecting it from the `Scene Graph` panel.

#### The Scene Graph Panel
- All the iOS basic shapes and a few extra models are available for you to play with.
- Most importantly, the  `Scene Graph`  displays the hierachy of your nodes. It gets updated whenever you add or remove nodes, and when you hide and show the right panel.
- You can also add, delete, and select nodes here.
![image1]
![image5]

#### The Info Panel
- You can change the name or opacity of your selected node here.
- The `Bounding Box` is a smallest box that can contain the selected and all its child nodes.
- The `Local Vector` is a vector from the parent, to the currently selected node. It's very useful for helping you find nodes in your scene.
- The `Axis` is the x, y, z local axis of the selected node.
![image3]

#### The Transform Panel
- The `Transform` panel lets you translate, rotate, and scale any node.
- Pan your fingers up and down, starting on from one of the textFields to edit the values.
- Tap inside a textField to edit. The keyboard has "-" to make your number negative, and "0" to go to zero, or the smallest allowed value.
![image2]
![image4]

## More things to Try

Here are a few things to try.

- Open the `Info` panel on the lefthand side. You can scrub your finger up and down to change the numbers, or you can tap into a text field to manually type any number. (The keyboard has a button to make the number negative, and another button to make it zero.)

- Open the `Scene Graph`. This will show you the current hierachy of nodes in the scene. The emojis tell you whether there are any light, geometry, or camera attached to that node. You can tap the triangle to the left of a parent node to hide or show its children.

- Tap on any row in the `Scene Graph` to select it. Open the   `Transform` panel. You can now view, rotate, scale, translate any node. Try to find the camera node that represents your iPad!

- On the top left, tap "Scene". That's what your scene looks like from another point of view! Move your iPad around to see how feature points near where you are pointing your camera. That camera object represents your device! Tap the camera in the scene graph to move your POV around numerically. Drag your fingers across to rotate, pinch, or pan the camera.

- See the spinning fox named Paige? See if you can guess how the rotational numbers will change in  `Info`, and then tap the `Dizzy` fox on the Scene Graph, and tap `Info` to view the animation live.

- There can be up to two panels on the right side. Tap an menu item will show or dismiss it. Do you want the `Scene Graph` on top, and `Info` on the bottom? Dismiss all your panels, and then show them by tapping `Scene Graph` first, then `Info`

- The `Info` tab lets you change the name of any node, and it also gives you the size of the smallest box that can contain that node and all its children. You can hide any node by changing the opacity to 0.

- On the `Scene Graph` there are 3D models that you can place into your scene! The life sized wolf is my favourite -- I can stare at it all day. Selecting a model will place that model as a child of your selected node with no position or rotational values. If nothing happened, check that you have a node selected.

- On the `Scene Graph` panel, you can also drop in some Geometric shapes. Try to create a rocket with the panels, and write down the numbers, and then recreate it in code~

- The fox nodes has a lot of child nodes! If you want to how many pieces make up a tiny fox, simply replace
`addNode(foxNode, to: scene.rootNode)`
with
`scene.rootNode.addChild(foxNode)`

- Want to play with this on a phone, or use the whole thing, or bits and pieces on your app?
Come grab the Universal iOS app, and [available on my Github](https://github.com/p-sun/ARPowerPanels). 

- After you're done experimenting around, feel free to take the project and drop it into any ARKit app to help you debug and understand it in real time. The `ARPowerPanel` class is just a view that takes an ARSCNView as a parameter -- it's easy to use.

- Of course, try to create your own world here!

### Credits

Build by Paige Sun

GitHub [@p-sun](https://github.com/p-sun)

Email [paige.sun.dev@gmail.com](paige.sun.dev@gmail.com)

LinkedIn [https://www.linkedin.com/in/paigesun/](https://www.linkedin.com/in/paigesun/)

Toronto, ON, Canada

[image1]: https://github.com/p-sun/ARPowerPanels/blob/master/Screenshots/ARPowerPanels_1_.PNG
[image2]: https://github.com/p-sun/ARPowerPanels/blob/master/Screenshots/ARPowerPanels_2_.PNG
[image3]: https://github.com/p-sun/ARPowerPanels/blob/master/Screenshots/ARPowerPanels_3_.PNG
[image4]: https://github.com/p-sun/ARPowerPanels/blob/master/Screenshots/ARPowerPanels_4_.PNG
[image5]: https://github.com/p-sun/ARPowerPanels/blob/master/Screenshots/ARPowerPanels_5_.PNG
[image6]: https://github.com/p-sun/ARPowerPanels/blob/master/Screenshots/ARPowerPanels_6_.PNG
