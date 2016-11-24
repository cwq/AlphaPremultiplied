# AlphaPremultiplied
for OpenGL anti-aliasing and anti-blackEdges
## Anti-aliasing
if draw a image in a rotate angle, will cause aliasing

- add 2(or larger) pixels around the image (image.width+=4, image.height+=4)
- use blend `glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);`

but it will cause black edges, because GL_LINEAR
RGBA all changed by GL_LINEAR in edges, for example (1,0,0,1) may be (0.5,0,0,0.5), r=0.5*0.5=0.25

## anti-blackEdges
if draw a image trigger GL_LINEAR, may cause black edges

- transform image to alpha premultiplied
- use blend `glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA)`

so we ignore the alpha that changed by GL_LINEAR


