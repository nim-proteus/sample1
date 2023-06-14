import ecs
import glm
import std/tables
import ./location

type
    HasVelocity* = ref object of Component
        vel*: Vec3f
        rot*: Quatf

    Velocity* = ref object of System
        components: TableRef[ComponentId, HasVelocity]


method register*(this: Velocity, c: Component) =
    if c of HasVelocity:
        this.components[c.getId()] = (HasVelocity)c

method update*(this: Velocity) =
    let elapsed = 0.01f
    for c in this.components.values:
        var l = this.getEcs().getComponent[:HasLocation](c.entityId)
        l.loc = l.loc + (c.vel * elapsed)
        # quat(glm.rotate(mat4f(), 0.0001f, hasAcceleration.rot)) * mesh.rotation
        # v.rot = v.rot + quat(quat.axis(c.rot), quat.angle(c.rot) * (1f + elapsed))
        # echo "BEFORE"
        # echo "axis: ", quat.axis(l.rot)
        # echo "angle: ", quat.angle(l.rot)
        # echo "ACCEL"
        # echo "axis: ", quat.axis(c.rot)
        # echo "angle: ", quat.angle(c.rot)
        l.rot = quat(glm.rotate(mat4f(), quat.angle(c.rot) * elapsed, quat.axis(c.rot))) * l.rot
        # echo "AFTER"
        # echo "axis: ", quat.axis(l.rot)
        # echo "angle: ", quat.angle(l.rot)
        # quit 0

proc newHasVelocity*(): HasVelocity =
    result = HasVelocity()
    result.vel = vec3(0f, 0f, 0f)
    result.rot = quatf(vec3f(0f, 1f, 0f), 0f)

proc newVelocity*(): Velocity =
    result = Velocity()
    result.components = newTable[ComponentId, HasVelocity]()