local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperienceVoice/CrossExperienceVoice/dependencies").RoactUtils.Hooks.RoactRodux.useSelector

return function(p2)
	return useSelector(function(p3)
		if not (p3 and p3.Squad and p3.Squad.CrossExperienceVoice) then
			return nil
		end

		local participant = p3.Squad.CrossExperienceVoice.Participants.participants[p2]

		if participant then
			return participant.isMutedLocally
		end

		return nil
	end)
end
