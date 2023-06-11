import ecs
import glm

type
    HasLocation* = ref object of Component
        loc*: Vec3f
        offset*: Vec3f
        rot*: Vec3f

proc newHasLocation*(): HasLocation =
    result = new(HasLocation)
    result.loc = vec3f(0, 0, 0)
    result.offset = vec3f(0, 0, 0)
    result.rot = vec3f(0, 0, 0)