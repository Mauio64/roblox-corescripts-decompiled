local parent = script.Parent.Parent

local Shared = require(parent.Shared)
local ReactCurrentBatchConfig = Shared.ReactSharedInternals.ReactCurrentBatchConfig

return {
	NoTransition = 0,
	requestCurrentTransition = function()
		return ReactCurrentBatchConfig.transition
	end
}
