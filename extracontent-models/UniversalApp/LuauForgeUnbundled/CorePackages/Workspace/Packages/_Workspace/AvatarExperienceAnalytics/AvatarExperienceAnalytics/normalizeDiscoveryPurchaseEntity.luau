local marketplaceUnifiedAction = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/UnifiedEventLogEnums").MarketplaceUnifiedAction
local unifiedLoggingSurface = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceNavigation").Enums.UnifiedLoggingSurface

local v5 = {
	"widgetId",
	"widgetType",
	"assetIds",
	"bundleIds",
	"widgetItemIds",
	"organicResultIds",
	"widgetItemPrice",
	"uiTreatmentType",
	"themeId",
	"widgetItemWearAfterPurchase",
	"widgetItemSaveToMyAvatars"
}

local v6 = {
	"assetType",
	"bundleType",
	"organicItemPrice",
	"organicItemWearAfterPurchase",
	"organicItemSaveToMyAvatars",
	"organicAssetIds",
	"organicBundleIds"
}

local function isDiscoverySurface(p2): boolean
	return p2 == unifiedLoggingSurface.DISCOVERY_HOMEPAGE
		or p2 == unifiedLoggingSurface.DISCOVERY_SEARCH_RESULTS
end

local function isNonEmpty(p2): boolean
	return p2 ~= nil and p2 ~= ""
end

local function normalizeDiscoveryPurchaseEntity(data)
	local action = data.action

	if
		action ~= marketplaceUnifiedAction.PURCHASE_SUCCESS
		and action ~= marketplaceUnifiedAction.PURCHASE_ATTEMPT
	then
		return data
	end

	local surface = data.surface

	if not (surface == unifiedLoggingSurface.DISCOVERY_HOMEPAGE or surface == unifiedLoggingSurface.DISCOVERY_SEARCH_RESULTS) then
		return data
	end

	local widgetId = data.widgetId
	local v7 = not (widgetId == nil) and widgetId ~= ""

	if v7 then
		local widgetType = data.widgetType
		v7 = not (widgetType == nil) and widgetType ~= ""

		if v7 then
			local widgetItemIds = data.widgetItemIds
			v7 = not (widgetItemIds == nil) and widgetItemIds ~= ""

			if v7 then
				local requestId = data.requestId
				v7 = not (requestId == nil) and requestId ~= ""
			end
		end
	end

	local clone = table.clone(data)

	if v7 then
		for k, v8 in v6 do
			clone[v8] = nil
		end
	else
		clone.organicItemPrice = clone.organicItemPrice or clone.widgetItemPrice
		clone.organicAssetIds = clone.organicAssetIds or clone.assetIds
		clone.organicBundleIds = clone.organicBundleIds or clone.bundleIds

		if clone.organicItemWearAfterPurchase == nil then
			clone.organicItemWearAfterPurchase = clone.widgetItemWearAfterPurchase
		end

		if clone.organicItemSaveToMyAvatars == nil then
			clone.organicItemSaveToMyAvatars = clone.widgetItemSaveToMyAvatars
		end

		for k, v8 in v5 do
			clone[v8] = nil
		end
	end

	return clone
end

return normalizeDiscoveryPurchaseEntity
