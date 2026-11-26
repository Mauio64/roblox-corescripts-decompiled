local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Constants")
local observeCurrentContextId = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/Utils/observeCurrentContextId")

return function(callback)
	local v5 = nil
	observeCurrentContextId(function(p2)
		local v6 = p2 == Constants.AUDIO_FOCUS_MANAGEMENT.CEV.CONTEXT_ID

		if v6 ~= v5 then
			v5 = v6
			callback(v5)
		end
	end)
end
