local CrossExperienceVoice = script:FindFirstAncestor("CrossExperienceVoice")
local dependencies = require(CrossExperienceVoice.dependencies)

local useSelector = dependencies.RoactUtils.Hooks.RoactRodux.useSelector
local getFFlagEnableCrossExpVoice = dependencies.SharedFlags.GetFFlagEnableCrossExpVoice

return function()
	if getFFlagEnableCrossExpVoice() then
		return useSelector(function(p)
			if p and p.Squad and p.Squad.CrossExperienceVoice then
				return p.Squad.CrossExperienceVoice.Experience.voiceStatus
			end

			return nil
		end)
	end

	return nil
end
