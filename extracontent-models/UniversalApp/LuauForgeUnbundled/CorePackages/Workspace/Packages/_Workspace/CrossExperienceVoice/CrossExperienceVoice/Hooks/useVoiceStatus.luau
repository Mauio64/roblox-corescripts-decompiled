local dependencies = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperienceVoice/CrossExperienceVoice/dependencies")

local useSelector = dependencies.RoactUtils.Hooks.RoactRodux.useSelector
local getFFlagEnableCrossExpVoice = dependencies.SharedFlags.GetFFlagEnableCrossExpVoice

return function()
	if getFFlagEnableCrossExpVoice() then
		return useSelector(function(p2)
			if p2 and p2.Squad and p2.Squad.CrossExperienceVoice then
				return p2.Squad.CrossExperienceVoice.Experience.voiceStatus
			end

			return nil
		end)
	end

	return nil
end
