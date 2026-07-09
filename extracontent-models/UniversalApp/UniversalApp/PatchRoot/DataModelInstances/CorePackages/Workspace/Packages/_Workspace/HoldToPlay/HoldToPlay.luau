local HoldToPlayLauncher = require(script.HoldToPlayLauncher)
local useHoldToPlayStateAndCallbacks = require(script.useHoldToPlayStateAndCallbacks)
local Constants = require(script.Constants)
local HoldDetector = require(script.HoldDetector)

return {
	Constants = Constants,
	HoldToPlayLauncher = HoldToPlayLauncher,
	HoldDetector = HoldDetector,
	useHoldToPlayStateAndCallbacks = useHoldToPlayStateAndCallbacks,
	["jest.config"] = script["jest.config"]
}
