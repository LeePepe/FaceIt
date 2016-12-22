# FaceIt

CS193P Demo: FaceIt

# Feature

There are few feature I learned from CS193p:

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
