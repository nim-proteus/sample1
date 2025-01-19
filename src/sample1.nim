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
        newAcceleration(),
        newVelocity())

    var entityId = e.register(
        newEntity(),
        newHasLocation(vec3f(0f, 0f, 20f), vec3f(0f, 0f, 0f), quat(vec3f(0, 0.1f, 0), 0.001f)),
        newHasAcceleration(),
        newHasVelocity())

    var hasLocation = e.getComponent[:HasLocation](entityId)

    var hasVelocity = e.getComponent[:HasVelocity](entityId)
    hasVelocity.vel = vec3f(0f, 0f, 0.0f)
    hasVelocity.rot = quat(vec3f(0f, 0.1f, 0f), 0.1f)

    var hasAcceleration = e.getComponent[:HasAcceleration](entityId)
    hasAcceleration.vel = vec3f(0f, 0f, 0.0f)
    hasAcceleration.rot = quat(vec3f(0f, 0.1f, 0f), 0.001f)
    
    var i = 0
    while g.isRunning():
        # echo "========================>"
        # echo "FRAME: ", i
        var tasks = newSeq[RenderTask]()
        for mesh in mi.meshes:
            var translation = hasLocation.loc
            mesh.rotation = hasLocation.rot
            tasks.add(RenderTask(
                mode: RenderMode.Projection, 
                modelId: mi.id, 
                meshId: mesh.meshId, 
                matrix: translate(mat4f(), translation) * 
                    glm.mat4(mesh.rotation) * 
                    glm.scale(mat4f(), vec3f(0.1f, 0.1f, 0.1f))))            
            g.getRenderer().setCameraLookAt(translation)
        g.render(tasks)
        e.update()
        # echo "quat.angle(hasLocation.rot): ", quat.angle(hasLocation.rot)
        i += 1