local RoactMotionImplementation = script.Parent.RoactMotionImplementation
local MotionSpecifier = require(RoactMotionImplementation.MotionSpecifier)
local SimpleMotion = require(RoactMotionImplementation.SimpleMotion)

return {
	spring = MotionSpecifier.spring,
	SimpleMotion = SimpleMotion
}
