local CrossExperienceVoice = script:FindFirstAncestor("CrossExperienceVoice")
local dependencies = require(CrossExperienceVoice.dependencies)

local useSelector = dependencies.RoactUtils.Hooks.RoactRodux.useSelector

return function(p: number)
	return useSelector(function(p2)
		if not (p2 and p2.Squad and p2.Squad.CrossExperienceVoice) then
			return nil
		end

		local participant = p2.Squad.CrossExperienceVoice.Participants.participants[p]

		return if participant then participant.isMutedLocally else nil
	end)
end
