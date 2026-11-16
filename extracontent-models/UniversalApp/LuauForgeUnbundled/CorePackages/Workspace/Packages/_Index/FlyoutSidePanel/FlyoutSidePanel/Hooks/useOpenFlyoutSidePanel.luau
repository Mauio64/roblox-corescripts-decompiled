local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/React")

local useSetDrawerVisible = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/Drawer").Hooks.useSetDrawerVisible
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/RobloxAppHooks").useRoactService

local appEventIngestService = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/RoactServiceTags").AppEventIngestService
local FlyoutAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Analytics/FlyoutAnalytics")
local FlyoutTooltipManager = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/FlyoutTooltipManager")

local function useOpenFlyoutSidePanel(p2)
	local v5 = useSetDrawerVisible()
	local v6 = useRoactService(appEventIngestService)

	return React.useCallback(function()
		FlyoutAnalytics.sendPageLoadEvent(v6, p2)
		v5(true)
		FlyoutTooltipManager:flyoutSidePanelOpened()
	end, { v5, v6, p2 })
end

return useOpenFlyoutSidePanel
