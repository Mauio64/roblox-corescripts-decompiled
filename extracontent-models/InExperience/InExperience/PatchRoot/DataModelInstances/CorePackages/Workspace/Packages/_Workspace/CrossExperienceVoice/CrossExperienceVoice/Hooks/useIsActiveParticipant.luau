local engineFeature = game:GetEngineFeature("AudioFocusManagement")
local CrossExperienceVoice = script:FindFirstAncestor("CrossExperienceVoice")
local dependencies = require(CrossExperienceVoice.dependencies)

local useSelector = dependencies.RoactUtils.Hooks.RoactRodux.useSelector
local getFFlagEnableCrossExpVoice = dependencies.SharedFlags.GetFFlagEnableCrossExpVoice

local useIsVoiceFocused = require(CrossExperienceVoice.Hooks.useIsVoiceFocused)

return function(p: number)
	if not getFFlagEnableCrossExpVoice() then
		return false
	end

	local v = useIsVoiceFocused()
	local v2 = useSelector(function(p2)
		if not (p2 and p2.Squad and p2.Squad.CrossExperienceVoice and table.find(
			p2.Squad.CrossExperienceVoice.Participants.activeUserIds,
			p
		) ~= nil) then
			return false
		end

		local participant = p2.Squad.CrossExperienceVoice.Participants.participants[p]
		return participant and not participant.isMuted
	end)
	return not (engineFeature and not v) and v2
end
