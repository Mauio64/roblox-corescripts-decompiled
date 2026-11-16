local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/React")
local useDrawerVisible = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/Drawer").Hooks.useDrawerVisible
local FlyoutAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Analytics/FlyoutAnalytics")
local FlyoutContentSettings = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Config/FlyoutContentSettings")

local function useFlyoutTradesEntryImpressionLogging(items)
	local v5 = useDrawerVisible()
	local ref = React.useRef(false)
	local v6 = false

	for k, item in items do
		if item.itemType == FlyoutContentSettings.ItemType.Trades then
			v6 = true
			break
		end
	end

	React.useEffect(function()
		if not v5 then
			ref.current = false
		elseif v6 and not ref.current then
			ref.current = true
			FlyoutAnalytics.onFlyoutContentItemImpressed({
				integrationId = FlyoutContentSettings.ItemType.Trades,
				source = "impression"
			})
		end
	end, { v5, v6 })
end

return useFlyoutTradesEntryImpressionLogging
