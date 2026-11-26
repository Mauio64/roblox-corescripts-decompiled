local dependencies = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperienceVoice/CrossExperienceVoice/dependencies")

local useSelector = dependencies.RoactUtils.Hooks.RoactRodux.useSelector
local getFFlagEnableCrossExpVoice = dependencies.SharedFlags.GetFFlagEnableCrossExpVoice

return function(p2)
	if getFFlagEnableCrossExpVoice() then
		return useSelector(function(p3)
			if not (p3 and p3.Squad and p3.Squad.CrossExperienceVoice) then
				return nil
			end

			local participant = p3.Squad.CrossExperienceVoice.Participants.participants[p2]

			if participant then
				return participant.isMuted
			end

			return nil
		end)
	end

	return nil
end
