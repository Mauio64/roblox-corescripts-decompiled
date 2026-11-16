local parent = script:FindFirstAncestor("AvatarExperienceAnalytics").Parent

local UnifiedEventLogEnums = require(script.Parent.UnifiedEventLogEnums)
local MarketplaceUnifiedAction = UnifiedEventLogEnums.MarketplaceUnifiedAction
local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local UnifiedLoggingSurface = AvatarExperienceNavigation.Enums.UnifiedLoggingSurface

local v = {
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

local v2 = {
	"assetType",
	"bundleType",
	"organicItemPrice",
	"organicItemWearAfterPurchase",
	"organicItemSaveToMyAvatars",
	"organicAssetIds",
	"organicBundleIds"
}

local function isDiscoverySurface(surface: number?): boolean -- 1 equivalent call inferred from this helper
	return surface == UnifiedLoggingSurface.DISCOVERY_HOMEPAGE
		or surface == UnifiedLoggingSurface.DISCOVERY_SEARCH_RESULTS
end

local function isNonEmpty(p): boolean -- 4 equivalent calls inferred from this helper
	return p ~= nil and p ~= ""
end

local function normalizeDiscoveryPurchaseEntity(data)
	local action = data.action

	if action ~= MarketplaceUnifiedAction.PURCHASE_SUCCESS and action ~= MarketplaceUnifiedAction.PURCHASE_ATTEMPT then
		return data
	end

	if not isDiscoverySurface(data.surface) then -- inferred equivalent call
		return data
	end

	local v3 = isNonEmpty(data.widgetId) -- inferred equivalent call

	if v3 then
		v3 = isNonEmpty(data.widgetType) -- inferred equivalent call

		if v3 then
			v3 = isNonEmpty(data.widgetItemIds) and isNonEmpty(data.requestId) -- inferred equivalent call
		end
	end

	local clone = table.clone(data)

	if v3 then
		for _, v4 in v2 do
			clone[v4] = nil
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

		for _, v4 in v do
			clone[v4] = nil
		end
	end

	return clone
end

return normalizeDiscoveryPurchaseEntity
