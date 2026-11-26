local engineFeature = game:GetEngineFeature("AudioFocusManagement")

local dependencies = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperienceVoice/CrossExperienceVoice/dependencies")

local useSelector = dependencies.RoactUtils.Hooks.RoactRodux.useSelector
local getFFlagEnableCrossExpVoice = dependencies.SharedFlags.GetFFlagEnableCrossExpVoice

local useIsVoiceFocused = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperienceVoice/CrossExperienceVoice/Hooks/useIsVoiceFocused")

return function(p2)
	if not getFFlagEnableCrossExpVoice() then
		return false
	end

	local v5 = useIsVoiceFocused()
	local v6 = useSelector(function(p3)
		if not (p3 and p3.Squad and p3.Squad.CrossExperienceVoice and table.find(
			p3.Squad.CrossExperienceVoice.Participants.activeUserIds,
			p2
		) ~= nil) then
			return false
		end

		local participant = p3.Squad.CrossExperienceVoice.Participants.participants[p2]
		return participant and not participant.isMuted
	end)

	if engineFeature and not v5 then
		return false
	end

	return v6
end
