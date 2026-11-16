local BehaviorKind = require(script.BehaviorKind)
local Behaviors = require(script.Behaviors)
require(script.Types)
return {
	BehaviorKind = BehaviorKind,
	Behaviors = Behaviors,
	Window = require(script.Window),
	["jest.config"] = script["jest.config"]
}
