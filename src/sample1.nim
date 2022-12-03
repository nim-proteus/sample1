# This is just an example to get you started. A typical binary package
# uses this file as the main entry point of the application.

import graphics
import graphics/oglrenderer
import std/logging

when isMainModule:
    let fmtStr = "[$time] - $levelname: "
    addHandler(newConsoleLogger(fmtStr = fmtStr))
    # addHandler(newRollingFileLogger(filename = "log.txt", fmtStr = fmtStr))

    var g = newGraphics(newOglRenderer())
    g.openWindow(640, 480, "Sample")

    var path = "res/models/duck.dae"
    discard g.loadModel(path)
    var mi = g.getModelInstance(path)

    var tasks = newSeq[RenderTask]()
    for mesh in mi.meshes:
        echo "Mesh id: ", mesh.meshId
        tasks.add(RenderTask(mode: RenderMode.Projection, modelId: mi.id, meshId: mesh.meshId))

    while g.isRunning():
        g.render(tasks)
