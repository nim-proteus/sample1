import ecs
import glm
import std/tables

type
    HasVelocity* = ref object of Component
        vel*: Vec3f

    Velocity* = ref object of System
        components: TableRef[EntityId, HasVelocity]


method register*(this: Velocity, c: Component) =
    if c of HasVelocity:
        this.components[c.getId()] = (HasVelocity)c

method update*(this: Velocity) =
    let elapsed = 0f
    for c in this.components.values:
        var v = this.getEcs().getComponent[:HasVelocity](c.entityId)
        v.vel = v.vel + (c.vel * elapsed)
