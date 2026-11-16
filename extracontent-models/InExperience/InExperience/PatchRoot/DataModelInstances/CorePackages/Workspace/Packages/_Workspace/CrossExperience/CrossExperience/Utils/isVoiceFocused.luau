local CrossExperience = script:FindFirstAncestor("CrossExperience")

local Constants = require(CrossExperience.Constants)

local v = nil
local v2 = false

return function(): boolean
	if not v2 then
		local success, result = pcall(function()
			return game:GetService("AudioFocusService")
		end)
		v = success and result or v
		v2 = true
	end

	local v3 = v

	if v3 then
		return v3:GetFocusedContextId() == Constants.AUDIO_FOCUS_MANAGEMENT.CEV.CONTEXT_ID
	end

	return false
end
