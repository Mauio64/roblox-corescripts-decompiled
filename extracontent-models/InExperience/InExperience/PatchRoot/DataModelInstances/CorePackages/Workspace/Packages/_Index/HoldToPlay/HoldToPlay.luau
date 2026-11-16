local HoldToPlayLauncher = require(script.HoldToPlayLauncher)
local useHoldToPlayStateAndCallbacks = require(script.useHoldToPlayStateAndCallbacks)
return {
	Constants = require(script.Constants),
	HoldToPlayLauncher = HoldToPlayLauncher,
	HoldDetector = require(script.HoldDetector),
	useHoldToPlayStateAndCallbacks = useHoldToPlayStateAndCallbacks,
	["jest.config"] = script["jest.config"]
}
