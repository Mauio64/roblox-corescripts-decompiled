local EngineFeature = game:GetEngineFeature("AudioFocusManagement")
local CrossExperienceVoice = script:FindFirstAncestor("CrossExperienceVoice")
local dependencies = require(CrossExperienceVoice.dependencies)
local useSelector = dependencies.RoactUtils.Hooks.RoactRodux.useSelector
local GetFFlagEnableCrossExpVoice = dependencies.SharedFlags.GetFFlagEnableCrossExpVoice
local useIsVoiceFocused = require(CrossExperienceVoice.Hooks.useIsVoiceFocused)

return function(n1: number) -- line: 11
	-- upvalues: GetFFlagEnableCrossExpVoice (copy), useIsVoiceFocused (copy), useSelector (copy), EngineFeature (copy)
	if not GetFFlagEnableCrossExpVoice() then
		return false
	end

	local v8 = useIsVoiceFocused()
	local v9 = useSelector(function(p1) -- line: 16
		-- upvalues: n1 (copy)
		if p1 and (p1.Squad and p1.Squad.CrossExperienceVoice) then
			if table.find(p1.Squad.CrossExperienceVoice.Participants.activeUserIds, n1) ~= nil then
				local v11 = p1.Squad.CrossExperienceVoice.Participants.participants[n1]

				return v11 and not v11.isMuted
			end

			return false
		end

		return false
	end)

	if EngineFeature and not v8 then
		return false
	end

	return v9
end
