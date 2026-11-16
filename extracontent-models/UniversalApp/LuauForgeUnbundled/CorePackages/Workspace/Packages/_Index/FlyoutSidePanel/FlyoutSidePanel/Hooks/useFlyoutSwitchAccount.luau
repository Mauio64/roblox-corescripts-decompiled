local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/React")
local flyoutAccountSwitcherIXP = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/SharedExperimentDefinition").FlyoutAccountSwitcherIXP
local FlyoutAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Analytics/FlyoutAnalytics")

local function useFlyoutSwitchAccount(callback, callback2)
	local ref = React.useRef(nil)

	local v5 = React.useCallback(function()
		local current = ref.current

		if current then
			current()
		end

		callback2()
		FlyoutAnalytics.onFlyoutSwitchAccountClicked({
			source = flyoutAccountSwitcherIXP.getClickSource()
		})

		if callback then
			callback()
		end
	end, { callback2, callback })

	local ref2 = React.useRef(nil)

	if not callback then
		v5 = nil
	end

	return { onActivated = v5, anchorRef = ref2, dismissRef = ref }
end

return useFlyoutSwitchAccount
