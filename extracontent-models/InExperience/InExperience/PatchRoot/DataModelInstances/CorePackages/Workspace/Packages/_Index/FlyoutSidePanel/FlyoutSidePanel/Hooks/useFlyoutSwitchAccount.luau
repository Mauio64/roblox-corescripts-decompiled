local FlyoutSidePanel = script:FindFirstAncestor("FlyoutSidePanel")
local parent = FlyoutSidePanel.Parent

local React = require(parent.React)
local SharedExperimentDefinition = require(parent.SharedExperimentDefinition)
local FlyoutAccountSwitcherIXP = SharedExperimentDefinition.FlyoutAccountSwitcherIXP
local FlyoutAnalytics = require(FlyoutSidePanel.Analytics.FlyoutAnalytics)

local function useFlyoutSwitchAccount(callback, callback2)
	local ref = React.useRef(nil)

	local onActivated = React.useCallback(function()
		local current = ref.current

		if current then
			current()
		end

		callback2()
		FlyoutAnalytics.onFlyoutSwitchAccountClicked({
			source = FlyoutAccountSwitcherIXP.getClickSource()
		})

		if callback then
			callback()
		end
	end, { callback2, callback })

	local ref2 = React.useRef(nil)

	if not callback then
		onActivated = nil
	end

	return { onActivated = onActivated, anchorRef = ref2, dismissRef = ref }
end

return useFlyoutSwitchAccount
