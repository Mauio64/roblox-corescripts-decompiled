local function ShareTargetGamePolicies(p)
	return {
		shouldShowCreatorName = function()
			local showShareTargetGameCreator = p.ShowShareTargetGameCreator
			return showShareTargetGameCreator ~= nil and showShareTargetGameCreator
		end
	}
end

return ShareTargetGamePolicies
