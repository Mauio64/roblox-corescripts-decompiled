local CrossExperience = script:FindFirstAncestor("CrossExperience")
local Constants = require(CrossExperience.Constants)
local observeCurrentContextId = require(CrossExperience.Utils.observeCurrentContextId)

return function(p1: ((...any) -> ...any)) -- line: 6
	-- upvalues: observeCurrentContextId (copy), Constants (copy)
	local u5 = nil

	observeCurrentContextId(function(p2) -- line: 8
		-- upvalues: Constants (copy), u5 (ref), p1 (copy)
		local v7 = p2 == Constants.AUDIO_FOCUS_MANAGEMENT.CEV.CONTEXT_ID

		if v7 ~= u5 then
			u5 = v7
			p1(u5)
		end
	end)
end
