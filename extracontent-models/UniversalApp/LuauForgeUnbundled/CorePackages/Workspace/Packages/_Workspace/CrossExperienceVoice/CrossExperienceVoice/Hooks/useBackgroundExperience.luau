local dependencies = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperienceVoice/CrossExperienceVoice/dependencies")

local getFFlagEnableCrossExpVoice = dependencies.SharedFlags.GetFFlagEnableCrossExpVoice

local useSelector = dependencies.RoactUtils.Hooks.RoactRodux.useSelector

return function()
	if getFFlagEnableCrossExpVoice() then
		return useSelector(function(p2)
			if p2 and p2.Squad and p2.Squad.CrossExperienceVoice then
				return p2.Squad.CrossExperienceVoice.Experience
			end

			return nil
		end)
	end

	return nil
end
