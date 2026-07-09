local EngagementScreen = script:FindFirstAncestor("EngagementScreen")
local EngagementScreenParent = EngagementScreen.Parent
local React = require(EngagementScreenParent.React)
local EngagementScreen2 = require(EngagementScreen.Components.EngagementScreen)
local useEngagementScreenProps = require(EngagementScreen.Components.useEngagementScreenProps)
local getAppFeaturePolicies = require(EngagementScreenParent.UniversalAppPolicy).getAppFeaturePolicies

return function() -- line: 9
	-- upvalues: React (copy), EngagementScreen2 (copy), useEngagementScreenProps (copy), getAppFeaturePolicies (copy)
	return React.createElement(EngagementScreen2, useEngagementScreenProps({
		useSingleSignOn = getAppFeaturePolicies().getUseSingleSignOn(),
		allowPlatformAccountSwitching = getAppFeaturePolicies().getAllowPlatformAccountSwitching()
	}))
end
