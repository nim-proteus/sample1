import ecs
import glm
import options
import std/tables
import ./location

type
    HasLookAt* = ref object of Component
        targetEntityId: Option[EntityId]
        lookAt: Vec3f

    LookAt* = ref object of System
        components*: TableRef[ComponentId, HasLookAt]

method register*(this: LookAt, c: Component) =
    if c of HasLookAt:
        this.components[c.getId()] = (HasLookAt)c

method update*(this: LookAt) =
    let elapsed = 0f
    for c in this.components.values:
        if c.targetEntityId.isSome:
            var t = this.getEcs().getComponent[:HasLocation](c.targetEntityId.get())
            c.lookAt = t.loc
