# This is just an example to get you started. A typical binary package
# uses this file as the main entry point of the application.

import graphics
import graphics/oglrenderer
import std/logging
import glm
import ecs
import systems/acceleration
import systems/location
import systems/velocity

when isMainModule:
    let fmtStr = "[$time] - $levelname: "
    addHandler(newConsoleLogger(fmtStr = fmtStr))
    # addHandler(newRollingFileLogger(filename = "log.txt", fmtStr = fmtStr))

    var g = newGraphics(newOglRenderer())
    g.openWindow(640, 480, "Sample")
    g.getRenderer().setCameraEye(vec3f(-50f, -50f, 70))
    var id = g.getRenderer().loadShaderProgram(
        io.readFile("res/shaders/vertex.glsl"), 
        io.readFile("res/shaders/fragment.glsl"))
    g.getRenderer().useShaderProgram(id)
    
    var path = "res/models/duck.dae"
    var modelId = g.loadModel(path)
    var mi = g.getModelInstance(modelId)

    var e = newEcs()

    e.register(
        newEntity(),
        newHasLocation(),
        newHasAcceleration(),
        newHasVelocity())

    e.register(
        newAcceleration(),
        newVelocity())

    var inc = vec3(0f, 0f, 0f)
    while g.isRunning():
        var tasks = newSeq[RenderTask]()
        for mesh in mi.meshes:
            # Where do we store the translate and rotation and scale?
            var translation = vec3f(0f, 0f, 20f)
            mesh.rotation = quat(glm.rotate(mat4f(), 0.0001f, vec3f(0f, 0f, -1f))) * mesh.rotation
            tasks.add(RenderTask(mode: RenderMode.Projection, modelId: mi.id, meshId: mesh.meshId, matrix: translate(mat4f(), translation) * glm.mat4(mesh.rotation) * glm.scale(mat4f(), vec3f(0.1f, 0.1f, 0.1f))))            
            # inc += vec3f(0f, 0f, 0.01f)
            g.getRenderer().setCameraLookAt(translation)
        g.render(tasks)
        e.update()