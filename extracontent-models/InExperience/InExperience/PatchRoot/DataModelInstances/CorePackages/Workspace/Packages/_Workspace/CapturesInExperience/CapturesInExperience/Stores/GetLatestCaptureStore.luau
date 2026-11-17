local parent = script.Parent.Parent.Parent

local Signals = require(parent.Signals)

local createLatestCaptureStore = require(script.createLatestCaptureStore)

return Signals.createComputed(function(_)
	return createLatestCaptureStore()
end)
