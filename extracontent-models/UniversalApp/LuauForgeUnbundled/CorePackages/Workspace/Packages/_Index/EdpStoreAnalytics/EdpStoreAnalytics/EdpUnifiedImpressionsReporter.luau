local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/EdpStoreAnalytics/Cryo")

local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/EdpStoreAnalytics/AvatarExperienceAnalytics")
local unifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local unifiedLoggingSurface = require("@game/CorePackages/Workspace/Packages/_Workspace/EdpStoreAnalytics/AvatarExperienceNavigation").Enums.UnifiedLoggingSurface
local sendUnifiedEventLogForInstance = AvatarExperienceAnalytics.sendUnifiedEventLogForInstance

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/EdpStoreAnalytics/EdpStoreAnalytics/Constants")

local function EdpUnifiedImpressionsReporter(p2)
	return function(p3)
		local visibleInstance = p3.visibleInstance
		local attributes = visibleInstance:GetAttributes() or {}

		local join = Cryo.Dictionary.join
		local v6 = {
			action = unifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_IMPRESSION,
			surface = 0
		}
		local v7 = if p2 == Constants.StoreEnums.LocationType.Edp then unifiedLoggingSurface.EDP_PREVIEW else unifiedLoggingSurface.EDP_STORE
		v6.surface = v7
		sendUnifiedEventLogForInstance(visibleInstance, join(attributes, v6), {
			includeScreenSize = true,
			includeElementSizeAndPosition = true
		})
	end
end

return EdpUnifiedImpressionsReporter
