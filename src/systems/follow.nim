import ecs
import std/tables
import ./location
import ./lookat

type
    Follow* = ref object of System
        components*: TableRef[ComponentId, HasFollow]
        
    HasFollow* = ref object of Component
        targetEntityId*: EntityId

method register*(this: Follow, c: Component) =
    if c of HasFollow:
        this.components[c.getId()] = (HasFollow)c

# CONSIDER: track when any component is updated so that any conflicts are easily debugged?
method update*(this: Follow) =
    let elapsed = 0f
    for c in this.components.values:
        var l = this.getEcs().getComponent[:HasLocation](c.entityId)
        var f = this.getEcs().getComponent[:HasLocation](c.targetEntityId)
        l.loc = f.loc
