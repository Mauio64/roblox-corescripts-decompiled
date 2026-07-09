local AccountSwitching = script:FindFirstAncestor("AccountSwitching")
local dependencies = require(AccountSwitching.dependencies)
local CentralOverlayType = dependencies.RobloxAppEnums.CentralOverlayType
local SetCentralOverlay = dependencies.CentralOverlay.Actions.SetCentralOverlay

return function(s1: string, s2: string, s3: string?, s4: string?, p1, p2, s5: string, s6: string?, b1: boolean?) -- line: 7
	-- upvalues: SetCentralOverlay (copy), CentralOverlayType (copy)
	return function(p3) -- line: 18
		-- upvalues: SetCentralOverlay (copy), CentralOverlayType (copy), s1 (copy), s2 (copy), s3 (copy), s4 (copy), p1 (copy), p2 (copy), s5 (copy), s6 (copy), b1 (copy)
		p3:dispatch(SetCentralOverlay(CentralOverlayType.AccountSwitchingErrorOverlay, {
			titleTextKey = s1,
			bodyTextKey = s2,
			primaryButtonTextKey = s3,
			secondaryButtonTextKey = s4,
			primaryButtonCallback = p1,
			secondaryButtonCallback = p2,
			errorType = s5,
			bodyUsername = s6,
			forceDarkTheme = b1
		}))
	end
end
