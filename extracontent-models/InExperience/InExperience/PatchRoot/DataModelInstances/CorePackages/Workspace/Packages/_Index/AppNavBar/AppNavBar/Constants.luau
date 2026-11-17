local parent = script.Parent.Parent

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage

local SharedFlags = require(parent.SharedFlags)
local FFlagAppIaHomeSubTab = SharedFlags.FFlagAppIaHomeSubTab
local FFlagAppIaHomeCampaignSubTab = SharedFlags.FFlagAppIaHomeCampaignSubTab
local FFlagEnableIsChartsInSubTab = SharedFlags.FFlagEnableIsChartsInSubTab
local SharedExperimentDefinition = require(parent.SharedExperimentDefinition)
local FlyoutSidePanelIXP = SharedExperimentDefinition.FlyoutSidePanelIXP

local Constants = {
	STUDIO_CTA_EVENT_CONTEXT = "StudioCTA",
	STUDIO_CTA_EVENT_NAME_OPEN = "OpenStudioCreatePage",
	STUDIO_CTA_EVENT_NAME_MOUNT = "MountStudioButton",
	HOME_CONTAINER_SUB_TAB_PAGES = FFlagAppIaHomeSubTab and { AppPage.Home, AppPage.Games } or nil
}

if FFlagEnableIsChartsInSubTab and FFlagAppIaHomeSubTab and not FlyoutSidePanelIXP.isChartsInSubTab() then
	table.remove(Constants.HOME_CONTAINER_SUB_TAB_PAGES, 2)
end

if FFlagAppIaHomeCampaignSubTab and FFlagAppIaHomeSubTab then
	table.insert(Constants.HOME_CONTAINER_SUB_TAB_PAGES, AppPage.Campaign)
end

return Constants
