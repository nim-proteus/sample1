# This is just an example to get you started. A typical binary package
# uses this file as the main entry point of the application.

import graphics
import graphics/oglrenderer
import std/logging
import glm

when isMainModule:
    let fmtStr = "[$time] - $levelname: "
    addHandler(newConsoleLogger(fmtStr = fmtStr))
    # addHandler(newRollingFileLogger(filename = "log.txt", fmtStr = fmtStr))

    var g = newGraphics(newOglRenderer())
    g.openWindow(640, 480, "Sample")
    g.getRenderer().setCameraEye(vec3f(0, 0, 100))

    var path = "res/models/duck.dae"
    var modelId = g.loadModel(path)
    var mi = g.getModelInstance(modelId)

    var tasks = newSeq[RenderTask]()
    for mesh in mi.meshes:
        # Where do we store the translate and rotation and scale?
        tasks.add(RenderTask(mode: RenderMode.Projection, modelId: mi.id, meshId: mesh.meshId, matrix: translate(mat4f(), mesh.translation) * glm.mat4(mesh.rotation) * glm.scale(mat4f(), vec3f(0.2f, 0.2f, 0.2f))))

    while g.isRunning():
        g.render(tasks)