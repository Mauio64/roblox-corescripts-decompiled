local CrossExperienceVoice = script:FindFirstAncestor("CrossExperienceVoice")
local dependencies = require(CrossExperienceVoice.dependencies)

local useSelector = dependencies.RoactUtils.Hooks.RoactRodux.useSelector
local getFFlagEnableCrossExpVoice = dependencies.SharedFlags.GetFFlagEnableCrossExpVoice

return function(p: number, p2: number)
	if getFFlagEnableCrossExpVoice() then
		return useSelector(function(p3): nil | boolean
			if p3 and p3.Squad and p3.Squad.CrossExperienceVoice then
				return (p3.Squad.CrossExperienceVoice.Participants.publicVoiceFocusedUserIds[p] == true) ~= (p3.Squad.CrossExperienceVoice.Participants.publicVoiceFocusedUserIds[p2] == true)
			end

			return nil
		end)
	end

	return nil
end
