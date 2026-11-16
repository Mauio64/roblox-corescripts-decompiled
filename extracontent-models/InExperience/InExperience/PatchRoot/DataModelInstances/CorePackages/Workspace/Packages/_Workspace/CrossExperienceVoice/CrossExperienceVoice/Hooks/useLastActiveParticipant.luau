local engineFeature = game:GetEngineFeature("AudioFocusManagement")
local CrossExperienceVoice = script:FindFirstAncestor("CrossExperienceVoice")
local dependencies = require(CrossExperienceVoice.dependencies)

local useSelector = dependencies.RoactUtils.Hooks.RoactRodux.useSelector

local useIsVoiceFocused = require(CrossExperienceVoice.Hooks.useIsVoiceFocused)
local getFFlagEnableCrossExpVoice = dependencies.SharedFlags.GetFFlagEnableCrossExpVoice

return function()
	if not getFFlagEnableCrossExpVoice() then
		return nil
	end

	local v = useIsVoiceFocused()

	local v2 = useSelector(function(p)
		if not (p and p.Squad and p.Squad.CrossExperienceVoice) then
			return nil
		end

		local activeUserIds = p.Squad.CrossExperienceVoice.Participants.activeUserIds

		for i = #activeUserIds, 1, -1 do
			local activeUserId = activeUserIds[i]

			local participant = p.Squad.CrossExperienceVoice.Participants.participants[activeUserId]

			if participant and not participant.isMuted then
				return participant
			end
		end

		return nil
	end)
	return if not (engineFeature and not v) then v2 else nil
end
