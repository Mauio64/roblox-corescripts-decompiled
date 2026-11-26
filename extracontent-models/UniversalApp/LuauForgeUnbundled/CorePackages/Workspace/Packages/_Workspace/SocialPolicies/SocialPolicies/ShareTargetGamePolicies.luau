local function ShareTargetGamePolicies(p2)
	return {
		shouldShowCreatorName = function()
			local showShareTargetGameCreator = p2.ShowShareTargetGameCreator

			if showShareTargetGameCreator == nil then
				return false
			end

			return showShareTargetGameCreator
		end
	}
end

return ShareTargetGamePolicies
