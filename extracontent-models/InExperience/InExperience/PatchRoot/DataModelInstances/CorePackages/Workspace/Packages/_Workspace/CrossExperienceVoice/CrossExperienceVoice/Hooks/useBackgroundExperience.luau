local CrossExperienceVoice = script:FindFirstAncestor("CrossExperienceVoice")
local dependencies = require(CrossExperienceVoice.dependencies)

local getFFlagEnableCrossExpVoice = dependencies.SharedFlags.GetFFlagEnableCrossExpVoice

local useSelector = dependencies.RoactUtils.Hooks.RoactRodux.useSelector

return function()
	if getFFlagEnableCrossExpVoice() then
		return useSelector(function(p)
			if p and p.Squad and p.Squad.CrossExperienceVoice then
				return p.Squad.CrossExperienceVoice.Experience
			end

			return nil
		end)
	end

	return nil
end
