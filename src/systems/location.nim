import ecs
import glm

type
    HasLocation* = ref object of Component
        loc*: Vec3f
        offset*: Vec3f
        rot*: Vec3f
