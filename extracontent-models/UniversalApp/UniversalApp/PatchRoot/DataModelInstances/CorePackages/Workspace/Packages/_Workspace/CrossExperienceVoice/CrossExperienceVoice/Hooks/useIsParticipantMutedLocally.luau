local CrossExperienceVoice = script:FindFirstAncestor("CrossExperienceVoice")
local useSelector = require(CrossExperienceVoice.dependencies).RoactUtils.Hooks.RoactRodux.useSelector

return function(n1: number) -- line: 7
	-- upvalues: useSelector (copy)
	return useSelector(function(p1) -- line: 8
		-- upvalues: n1 (copy)
		if p1 and (p1.Squad and p1.Squad.CrossExperienceVoice) then
			local v5 = p1.Squad.CrossExperienceVoice.Participants.participants[n1]

			if v5 then
				return v5.isMutedLocally
			end

			return nil
		end

		return nil
	end)
end
