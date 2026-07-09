require(script.createPageTracker)

local usePageTracker = require(script.Hooks.usePageTracker)
local ComponentTracker = require(script.Components.ComponentTracker)

return {
	["jest.config"] = script["jest.config"],
	usePageTracker = usePageTracker,
	ComponentTracker = ComponentTracker
}
