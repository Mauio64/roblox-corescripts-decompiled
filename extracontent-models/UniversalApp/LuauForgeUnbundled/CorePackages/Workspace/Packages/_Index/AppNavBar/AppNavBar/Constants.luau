local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/AppNavBar/RobloxAppEnums").AppPage

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppNavBar/SharedFlags")
local fFlagAppIaHomeSubTab = SharedFlags.FFlagAppIaHomeSubTab
local fFlagAppIaHomeCampaignSubTab = SharedFlags.FFlagAppIaHomeCampaignSubTab
local fFlagEnableIsChartsInSubTab = SharedFlags.FFlagEnableIsChartsInSubTab
local flyoutSidePanelIXP = require("@game/CorePackages/Workspace/Packages/_Workspace/AppNavBar/SharedExperimentDefinition").FlyoutSidePanelIXP

local v5 = {
	STUDIO_CTA_EVENT_CONTEXT = "StudioCTA",
	STUDIO_CTA_EVENT_NAME_OPEN = "OpenStudioCreatePage",
	STUDIO_CTA_EVENT_NAME_MOUNT = "MountStudioButton",
	HOME_CONTAINER_SUB_TAB_PAGES = fFlagAppIaHomeSubTab and { appPage.Home, appPage.Games } or nil
}

if fFlagEnableIsChartsInSubTab and fFlagAppIaHomeSubTab and not flyoutSidePanelIXP.isChartsInSubTab() then
	table.remove(v5.HOME_CONTAINER_SUB_TAB_PAGES, 2)
end

if fFlagAppIaHomeCampaignSubTab and fFlagAppIaHomeSubTab then
	table.insert(v5.HOME_CONTAINER_SUB_TAB_PAGES, appPage.Campaign)
end

return v5
