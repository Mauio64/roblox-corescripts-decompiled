local createGroupMotor = require(script.createGroupMotor)
local createSingleMotor = require(script.createSingleMotor)
local ease = require(script.ease)
local spring = require(script.spring)
local instant = require(script.instant)

require(script.types)

local AnimationStepSignal = require(script.AnimationStepSignal)

return {
	createGroupMotor = createGroupMotor,
	createSingleMotor = createSingleMotor,
	ease = ease,
	spring = spring,
	instant = instant,
	__devAnimationStepSignal = AnimationStepSignal
}
