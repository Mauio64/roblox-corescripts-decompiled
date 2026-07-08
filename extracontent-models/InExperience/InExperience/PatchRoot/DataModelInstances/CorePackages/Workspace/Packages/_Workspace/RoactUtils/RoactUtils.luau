local ExternalEventConnection = require(script.ExternalEventConnection)
local validatePropsWithForwardRef = require(script.validatePropsWithForwardRef)
local isGamepadInput = require(script.isGamepadInput)
local wasLastInputGamepad = require(script.wasLastInputGamepad)
local withIsGamepadInput = require(script.withIsGamepadInput)
local Components = require(script.Components)
local Hooks = require(script.Hooks)
local Profiling = require(script.Profiling)

require(script.types)

local TestIdUtils = require(script.TestIdUtils)
local TagUtils = require(script.TagUtils)

return {
	Components = Components,
	Hooks = Hooks,
	Profiling = Profiling,
	ExternalEventConnection = ExternalEventConnection,
	validatePropsWithForwardRef = validatePropsWithForwardRef,
	isGamepadInput = isGamepadInput,
	wasLastInputGamepad = wasLastInputGamepad,
	withIsGamepadInput = withIsGamepadInput,
	getTestId = TestIdUtils.getTestId,
	combineReactTags = TagUtils.combineReactTags,
	["jest.config"] = script["jest.config"]
}
