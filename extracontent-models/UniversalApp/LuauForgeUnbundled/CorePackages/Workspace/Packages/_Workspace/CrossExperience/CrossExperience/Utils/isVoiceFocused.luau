local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Constants")

local v5 = nil
local v6 = false

return function(): boolean
	if not v6 then
		local success, result = pcall(function()
			return game:GetService("AudioFocusService")
		end)
		v5 = success and result or v5
		v6 = true
	end

	local v7 = v5

	if v7 then
		return v7:GetFocusedContextId() == Constants.AUDIO_FOCUS_MANAGEMENT.CEV.CONTEXT_ID
	end

	return false
end
