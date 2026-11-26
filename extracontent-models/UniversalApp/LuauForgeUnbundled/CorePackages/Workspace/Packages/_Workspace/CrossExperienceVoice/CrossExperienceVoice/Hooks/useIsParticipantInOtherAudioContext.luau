local dependencies = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperienceVoice/CrossExperienceVoice/dependencies")

local useSelector = dependencies.RoactUtils.Hooks.RoactRodux.useSelector
local getFFlagEnableCrossExpVoice = dependencies.SharedFlags.GetFFlagEnableCrossExpVoice

return function(p2, p3)
	if getFFlagEnableCrossExpVoice() then
		return useSelector(function(p4): nil | boolean
			if p4 and p4.Squad and p4.Squad.CrossExperienceVoice then
				return (p4.Squad.CrossExperienceVoice.Participants.publicVoiceFocusedUserIds[p2] == true) ~= (p4.Squad.CrossExperienceVoice.Participants.publicVoiceFocusedUserIds[p3] == true)
			end

			return nil
		end)
	end

	return nil
end
