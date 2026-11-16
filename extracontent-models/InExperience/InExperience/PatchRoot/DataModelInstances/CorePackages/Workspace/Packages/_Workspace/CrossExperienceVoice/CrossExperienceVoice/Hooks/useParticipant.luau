local CrossExperienceVoice = script:FindFirstAncestor("CrossExperienceVoice")
local dependencies = require(CrossExperienceVoice.dependencies)

local useSelector = dependencies.RoactUtils.Hooks.RoactRodux.useSelector
local getFFlagEnableCrossExpVoice = dependencies.SharedFlags.GetFFlagEnableCrossExpVoice

return function(p: number)
	if getFFlagEnableCrossExpVoice() then
		return useSelector(function(p2)
			if p2 and p2.Squad and p2.Squad.CrossExperienceVoice then
				return p2.Squad.CrossExperienceVoice.Participants.participants[p]
			end

			return nil
		end)
	end

	return nil
end
