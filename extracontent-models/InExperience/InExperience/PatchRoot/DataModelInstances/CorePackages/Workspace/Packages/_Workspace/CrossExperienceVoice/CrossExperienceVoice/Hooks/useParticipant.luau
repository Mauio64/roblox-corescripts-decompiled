local CrossExperienceVoice = script:FindFirstAncestor("CrossExperienceVoice")
local dependencies = require(CrossExperienceVoice.dependencies)
local useSelector = dependencies.RoactUtils.Hooks.RoactRodux.useSelector
local GetFFlagEnableCrossExpVoice = dependencies.SharedFlags.GetFFlagEnableCrossExpVoice

return function(n1: number) -- line: 8
	-- upvalues: GetFFlagEnableCrossExpVoice (copy), useSelector (copy)
	if not GetFFlagEnableCrossExpVoice() then
		return nil
	end

	return useSelector(function(p1) -- line: 12
		-- upvalues: n1 (copy)
		if p1 and (p1.Squad and p1.Squad.CrossExperienceVoice) then
			return p1.Squad.CrossExperienceVoice.Participants.participants[n1]
		end

		return nil
	end)
end
