local ParentParent = script.Parent.Parent
local AppPage = require(ParentParent.RobloxAppEnums).AppPage
local FFlagAppIaHomeSubTab = require(ParentParent.SharedFlags).FFlagAppIaHomeSubTab

return {
	STUDIO_CTA_EVENT_CONTEXT = "StudioCTA",
	STUDIO_CTA_EVENT_NAME_OPEN = "OpenStudioCreatePage",
	STUDIO_CTA_EVENT_NAME_MOUNT = "MountStudioButton",
	HOME_CONTAINER_SUB_TAB_PAGES = if not FFlagAppIaHomeSubTab then nil else {
		AppPage.Home,
		AppPage.Games
	}
}
