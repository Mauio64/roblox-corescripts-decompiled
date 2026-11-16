local parent = script:FindFirstAncestor("FlyoutSidePanel").Parent

local React = require(parent.React)

local Drawer = require(parent.Drawer)
local useSetDrawerVisible = Drawer.Hooks.useSetDrawerVisible
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService

local RoactServiceTags = require(parent.RoactServiceTags)
local AppEventIngestService = RoactServiceTags.AppEventIngestService
local FlyoutAnalytics = require(script.Parent.Parent.Analytics.FlyoutAnalytics)
local FlyoutTooltipManager = require(script.Parent.Parent.FlyoutTooltipManager)

local function useOpenFlyoutSidePanel(p: string?)
	local v = useSetDrawerVisible()
	local v2 = useRoactService(AppEventIngestService)

	return React.useCallback(function()
		FlyoutAnalytics.sendPageLoadEvent(v2, p)
		v(true)
		FlyoutTooltipManager:flyoutSidePanelOpened()
	end, { v, v2, p })
end

return useOpenFlyoutSidePanel
