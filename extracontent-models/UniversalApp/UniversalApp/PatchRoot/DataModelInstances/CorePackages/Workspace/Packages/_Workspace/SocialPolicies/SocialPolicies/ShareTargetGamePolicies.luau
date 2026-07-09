local function ShareTargetGamePolicies(p1) -- line: 2
	return {
		shouldShowCreatorName = function() -- line: 4
			-- upvalues: p1 (copy)
			local ShowShareTargetGameCreator = p1.ShowShareTargetGameCreator

			if ShowShareTargetGameCreator ~= nil then
				return ShowShareTargetGameCreator
			end

			return false
		end
	}
end

return ShareTargetGamePolicies
