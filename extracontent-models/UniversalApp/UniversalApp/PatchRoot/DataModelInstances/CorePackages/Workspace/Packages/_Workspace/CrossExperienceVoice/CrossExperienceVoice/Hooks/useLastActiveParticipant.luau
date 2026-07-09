local EngineFeature = game:GetEngineFeature("AudioFocusManagement")
local CrossExperienceVoice = script:FindFirstAncestor("CrossExperienceVoice")
local dependencies = require(CrossExperienceVoice.dependencies)
local useSelector = dependencies.RoactUtils.Hooks.RoactRodux.useSelector
local useIsVoiceFocused = require(CrossExperienceVoice.Hooks.useIsVoiceFocused)
local GetFFlagEnableCrossExpVoice = dependencies.SharedFlags.GetFFlagEnableCrossExpVoice

return function() -- line: 13
	-- upvalues: GetFFlagEnableCrossExpVoice (copy), useIsVoiceFocused (copy), useSelector (copy), EngineFeature (copy)
	if not GetFFlagEnableCrossExpVoice() then
		return nil
	end

	local v7 = useIsVoiceFocused()
	local v8 = useSelector(function(p1) -- line: 19
		if p1 and (p1.Squad and p1.Squad.CrossExperienceVoice) then
			local activeUserIds = p1.Squad.CrossExperienceVoice.Participants.activeUserIds

			for i = #activeUserIds, 1, -1 do
				local v12 = activeUserIds[i]
				local v13 = p1.Squad.CrossExperienceVoice.Participants.participants[v12]

				if v13 and not v13.isMuted then
					return v13
				end
			end

			return nil
		end

		return nil
	end)

	if EngineFeature and not v7 then
		return nil
	end

	return v8
end
