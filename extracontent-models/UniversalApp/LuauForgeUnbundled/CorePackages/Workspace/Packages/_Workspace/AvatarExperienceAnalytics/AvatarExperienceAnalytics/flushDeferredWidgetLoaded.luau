local getUnifiedDeferredEventStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Store/getUnifiedDeferredEventStore")
local WIDGET_LOADED = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/UnifiedEventLogEnums").MarketplaceUnifiedAction.WIDGET_LOADED

local function flushDeferredWidgetLoaded()
	local v5 = getUnifiedDeferredEventStore(false)
	v5.markEntered()

	local v6 = v5.takePending(WIDGET_LOADED)

	for k, v7 in v6 do
		v7()
	end
end

return flushDeferredWidgetLoaded
