local CrossExperienceVoice = script:FindFirstAncestor("CrossExperienceVoice")
local dependencies = require(CrossExperienceVoice.dependencies)
local GetFFlagEnableCrossExpVoice = dependencies.SharedFlags.GetFFlagEnableCrossExpVoice
local useSelector = dependencies.RoactUtils.Hooks.RoactRodux.useSelector

return function() -- line: 9
	-- upvalues: GetFFlagEnableCrossExpVoice (copy), useSelector (copy)
	if not GetFFlagEnableCrossExpVoice() then
		return nil
	end

	return useSelector(function(p1) -- line: 13
		if p1 and (p1.Squad and p1.Squad.CrossExperienceVoice) then
			return p1.Squad.CrossExperienceVoice.Experience
		end

		return nil
	end)
end
