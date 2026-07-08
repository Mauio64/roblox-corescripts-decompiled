local ParentParent = script.Parent.Parent
local ReactCurrentBatchConfig = require(ParentParent.Shared).ReactSharedInternals.ReactCurrentBatchConfig

return {
	NoTransition = 0,
	requestCurrentTransition = function() -- line: 20
		-- upvalues: ReactCurrentBatchConfig (copy)
		return ReactCurrentBatchConfig.transition
	end
}
