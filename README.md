# FaceIt

The demo of CS193P lecture 13.

Showing how to use NSTimer(now is Timer), and Animation

## Feature

1. set attributes of FaceView in inspector.(mark property with @IBInspectable)
2. show FaceView in Storyboard.(mark FaceView @IBDesignable)
3. multiple MVCs and segues
   when you perpar for segue:
   1. ctrl+drag from action button to target MVC, and set identifier of segue in storyboard inspector.
   2. perpar segue in Controller, make sure the identifier and target MVC is correct.
   3. set the porperties what you need. But the @IBOutlet is not set yet.
4. add gesture recognizer to FaceView
   1. add gesture recognizer in @IBOutlet didSet.
   2. add func to recognizer.
5. add BlinkFaceViewControler to controll blink eyes.
   1. using Timer to close and open eyes automatically.
   2. change eye to EyeView so can transition in Timer.
6. make head shake.
   1. change tap gesture action to another func.
   2. add animation to faceView(transform.rotated func to shake)
