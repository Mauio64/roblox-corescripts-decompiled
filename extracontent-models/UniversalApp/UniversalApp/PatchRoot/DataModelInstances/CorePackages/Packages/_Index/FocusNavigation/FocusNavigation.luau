require(script.Parent.EventPropagation)

local FocusNavigationService = require(script.FocusNavigationService)
local isValidFocusTarget = require(script.isValidFocusTarget)
local EngineInterface = require(script.EngineInterface)

require(script.types)

return {
	isValidFocusTarget = isValidFocusTarget,
	FocusNavigationService = FocusNavigationService,
	EngineInterface = {
		CoreGui = EngineInterface.CoreGui,
		PlayerGui = EngineInterface.PlayerGui
	}
}
