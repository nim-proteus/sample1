import ecs
import glm

type
    HasLocation* = ref object of Component
        loc*: Vec3f
        offset*: Vec3f
        rot*: Quatf

proc newHasLocation*(loc: Vec3f, offset: Vec3f, rot: Quatf): HasLocation =
    result = new(HasLocation)
    result.loc = loc
    result.offset = offset
    result.rot = rot