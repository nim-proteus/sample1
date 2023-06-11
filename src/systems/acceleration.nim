import ecs
import glm
import std/tables
import ./velocity

type
    HasAcceleration* = ref object of Component
        accel: Vec3f

    Acceleration* = ref object of System
        components: TableRef[ComponentId, HasAcceleration]

method register*(this: Acceleration, c: Component) =
    if c of HasAcceleration:
        this.components[c.getId()] = (HasAcceleration)c

method update*(this: Acceleration) =
    let elapsed = 0f
    for c in this.components.values:
        var v = this.getEcs().getComponent[:HasVelocity](c.entityId)
        v.vel = v.vel + (c.accel * elapsed)

proc newHasAcceleration*(): HasAcceleration =
    result = HasAcceleration()
    result.accel = vec3(0f, 0f, 0f)

proc newAcceleration*(): Acceleration =
    result = Acceleration()
    result.components = newTable[ComponentId, HasAcceleration]()