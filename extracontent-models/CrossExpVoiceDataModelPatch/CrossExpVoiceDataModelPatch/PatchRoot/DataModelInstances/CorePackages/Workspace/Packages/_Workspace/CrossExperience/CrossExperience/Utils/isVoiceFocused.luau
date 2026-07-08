local CrossExperience = script:FindFirstAncestor("CrossExperience")
local Constants = require(CrossExperience.Constants)
local u3 = nil
local u4 = false

return function() -- line: 20
	-- upvalues: u4 (ref), u3 (ref), Constants (copy)
	if not u4 then
		local ok, result = pcall(function() -- line: 9
			return game:GetService("AudioFocusService")
		end)

		if ok and result then
			u3 = result
		end

		u4 = true
	end

	local v9 = u3

	if not v9 then
		return false
	end

	return v9:GetFocusedContextId() == Constants.AUDIO_FOCUS_MANAGEMENT.CEV.CONTEXT_ID
end
