local engineFeature = game:GetEngineFeature("AudioFocusManagement")

local dependencies = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperienceVoice/CrossExperienceVoice/dependencies")

local useSelector = dependencies.RoactUtils.Hooks.RoactRodux.useSelector

local useIsVoiceFocused = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperienceVoice/CrossExperienceVoice/Hooks/useIsVoiceFocused")
local getFFlagEnableCrossExpVoice = dependencies.SharedFlags.GetFFlagEnableCrossExpVoice

return function()
	if not getFFlagEnableCrossExpVoice() then
		return nil
	end

	local v5 = useIsVoiceFocused()

	local v6 = useSelector(function(p2)
		if not (p2 and p2.Squad and p2.Squad.CrossExperienceVoice) then
			return nil
		end

		local activeUserIds = p2.Squad.CrossExperienceVoice.Participants.activeUserIds

		for i = #activeUserIds, 1, -1 do
			local activeUserId = activeUserIds[i]

			local participant = p2.Squad.CrossExperienceVoice.Participants.participants[activeUserId]

			if participant and not participant.isMuted then
				return participant
			end
		end

		return nil
	end)

	if engineFeature and not v5 then
		return nil
	end

	return v6
end
