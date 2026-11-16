local CrossExperience = script:FindFirstAncestor("CrossExperience")

local Constants = require(CrossExperience.Constants)
local observeCurrentContextId = require(CrossExperience.Utils.observeCurrentContextId)

return function(callback)
	local v = nil
	observeCurrentContextId(function(p)
		local v2 = p == Constants.AUDIO_FOCUS_MANAGEMENT.CEV.CONTEXT_ID

		if v2 ~= v then
			v = v2
			callback(v)
		end
	end)
end
