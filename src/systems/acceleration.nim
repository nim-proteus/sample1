import ecs
import glm
import std/tables
import ./velocity

type
    HasAcceleration* = ref object of Component
        vel*: Vec3f
        rot*: Vec3f

    Acceleration* = ref object of System
        components: TableRef[ComponentId, HasAcceleration]

method register*(this: Acceleration, c: Component) =
    if c of HasAcceleration:
        this.components[c.getId()] = (HasAcceleration)c

method update*(this: Acceleration) =
    echo "Updating Acceleration"
    let elapsed = 0.01f
    for c in this.components.values:
        var v = this.getEcs().getComponent[:HasVelocity](c.entityId)
        v.vel = v.vel + (c.vel * elapsed)
        v.rot = v.rot + (c.rot * elapsed)

proc newHasAcceleration*(): HasAcceleration =
    result = HasAcceleration()
    result.vel = vec3(0f, 0f, 0f)
    result.rot = vec3(0f, 0f, 0f)

proc newAcceleration*(): Acceleration =
    result = Acceleration()
    result.components = newTable[ComponentId, HasAcceleration]()