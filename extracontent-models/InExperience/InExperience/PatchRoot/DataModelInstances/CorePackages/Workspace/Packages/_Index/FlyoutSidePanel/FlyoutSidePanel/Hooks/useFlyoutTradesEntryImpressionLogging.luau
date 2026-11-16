local FlyoutSidePanel = script:FindFirstAncestor("FlyoutSidePanel")
local parent = FlyoutSidePanel.Parent

local React = require(parent.React)
local Drawer = require(parent.Drawer)
local useDrawerVisible = Drawer.Hooks.useDrawerVisible
local FlyoutAnalytics = require(FlyoutSidePanel.Analytics.FlyoutAnalytics)
local FlyoutContentSettings = require(FlyoutSidePanel.Config.FlyoutContentSettings)

local function useFlyoutTradesEntryImpressionLogging(items)
	local v = useDrawerVisible()
	local ref = React.useRef(false)
	local v2 = false

	for _, item in items do
		if item.itemType == FlyoutContentSettings.ItemType.Trades then
			v2 = true
			break
		end
	end

	React.useEffect(function()
		if not v then
			ref.current = false
		elseif v2 and not ref.current then
			ref.current = true
			FlyoutAnalytics.onFlyoutContentItemImpressed({
				integrationId = FlyoutContentSettings.ItemType.Trades,
				source = "impression"
			})
		end
	end, { v, v2 })
end

return useFlyoutTradesEntryImpressionLogging
