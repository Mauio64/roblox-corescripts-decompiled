local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Loggers").mutedError

local PurchaseItemsSuccess = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/State/Actions/PurchaseItemsSuccess")

local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceAnalytics")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceNavigation")
local unifiedSelectionListStore = AvatarExperienceAnalytics.Store.UnifiedSelectionListStore
local sendUnifiedEventsForMultiItemShopping = AvatarExperienceAnalytics.sendUnifiedEventsForMultiItemShopping
local unifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local getUnifiedEventsForMIS = AvatarExperienceAnalytics.Utils.getUnifiedEventsForMIS
local cartIdService = AvatarExperienceAnalytics.Lib.CartIdService
local avatarScreenProperties = AvatarExperienceNavigation.AvatarRoute.AvatarScreenProperties

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags")
local fFlagAXMISEnableMultiShoppingUnifiedEvents = AvatarExperienceFlags.FFlagAXMISEnableMultiShoppingUnifiedEvents
local fFlagAXUnifiedEventStrictPayloads = AvatarExperienceFlags.FFlagAXUnifiedEventStrictPayloads
local fFlagAXMISSaveWearFix = AvatarExperienceFlags.FFlagAXMISSaveWearFix
local fFlagAXBackgroundsCustomizeHydration = AvatarExperienceFlags.FFlagAXBackgroundsCustomizeHydration

local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceCommon")
local applyProfileConfiguration = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceRodux").Actions.ApplyProfileConfiguration

local avatarBackground = AvatarExperienceCommon.Constants.ASSET_TYPE_NAME_TO_ID_STRING.AvatarBackground

local function maybeApplyPurchasedBackground(object, items)
	local assetId = nil

	for k, item in items do
		if item.assetTypeId == avatarBackground then
			assetId = tonumber(item.assetId)
		end
	end

	if assetId then
		object:dispatch(applyProfileConfiguration({ BackgroundAssetId = assetId }))
	end
end

local fFlagSignalsNavP3gAvatarExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/SharedFlags").FFlagSignalsNavP3gAvatarExperience
local getLegacyNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/NavigationRodux").GetLegacyNavigationStore

if fFlagAXMISEnableMultiShoppingUnifiedEvents then
	return function(p2, p3, p4, bodyColor3s, bodyScales, bodyPartColorRangeIds, p5, callback, p6, p7, p8, callback2)
		return function(object, p9)
			local state = object:getState()
			local routeName

			if fFlagSignalsNavP3gAvatarExperience then
				local currentRoute = getLegacyNavigationStore(false).getCurrentRoute(false)
				routeName = currentRoute and currentRoute.routeName
			else
				routeName = state.Navigation
					and state.Navigation.currentRoute
					and state.Navigation.currentRoute.routeName
			end

			local avatarScreenProperty = avatarScreenProperties[routeName]
			local unifiedLoggingSurface

			if avatarScreenProperty and avatarScreenProperty.analyticsData then
				unifiedLoggingSurface = avatarScreenProperty.analyticsData.unifiedLoggingSurface
			else
				unifiedLoggingSurface = nil
			end

			if not pcall(function()
				if p7 then
					p7.isOrganicLook = state.AvatarExperience.AvatarScene.OutfitTryOn.LookAnalyticsInfo == nil
				end

				if p8 then
					p8.isOrganicLook = state.AvatarExperience.AvatarScene.OutfitTryOn.MakeupLookAnalyticsInfo == nil
				end

				local PURCHASE_SUCCESS = unifiedEventLogEnums.MarketplaceUnifiedAction.PURCHASE_SUCCESS
				local v10 = if fFlagAXUnifiedEventStrictPayloads then unifiedLoggingSurface else nil
				local lookAnalyticsInfo

				if fFlagAXUnifiedEventStrictPayloads then
					lookAnalyticsInfo = state.AvatarExperience.AvatarScene.OutfitTryOn.LookAnalyticsInfo
				end

				local v11

				if fFlagAXUnifiedEventStrictPayloads then
					v11 = state.AvatarExperience.AvatarScene.OutfitTryOn.MakeupLookAnalyticsInfo
				end

				local v12, v13 = getUnifiedEventsForMIS(
					p2,
					p5,
					p7,
					p8,
					PURCHASE_SUCCESS,
					v10,
					lookAnalyticsInfo,
					v11
				)

				if not fFlagAXUnifiedEventStrictPayloads then
					v13 = nil
				end

				sendUnifiedEventsForMultiItemShopping(v12, unifiedLoggingSurface, v13)
			end) then
				mutedError("Failed to send unified events for multi-item shopping purchase success")
			end

			cartIdService.refreshCartId()
			unifiedSelectionListStore.clearSelectionList()

			local v5 = if fFlagAXMISSaveWearFix and callback2 then callback2(state, p5) else nil

			local ordersByAssetId = {}

			if fFlagAXMISSaveWearFix and v5 then
				for i, makeupDescription in v5:GetChildren() do
					if makeupDescription:IsA("MakeupDescription") then
						ordersByAssetId[tostring(makeupDescription.assetId)] = makeupDescription.order
					end
				end
			end

			if bodyScales == nil then
				local v6 = callback(state, p5)
				bodyScales = if v6 then v6.scales else nil
			end

			local v7 = {
				items = p2,
				equippableAssets = p3,
				replaceAllEquippedAssets = p4,
				shouldClearEquippedMakeup = if fFlagAXMISSaveWearFix then p6 else nil,
				bodyColor3s = bodyColor3s,
				bodyScales = bodyScales,
				bodyPartColorRangeIds = bodyPartColorRangeIds,
				makeupAssetsOnHumanoid = nil
			}

			if not fFlagAXMISSaveWearFix then
				ordersByAssetId = nil
			end

			v7.makeupAssetsOnHumanoid = ordersByAssetId
			object:dispatch(PurchaseItemsSuccess(v7))

			if fFlagAXBackgroundsCustomizeHydration then
				maybeApplyPurchasedBackground(object, p3)
			end
		end
	end
end

return function(p2, p3, p4, p5, p6, p7, p8, callback, p9)
	return function(object, p10)
		local state = object:getState()

		if p6 == nil then
			local v5 = callback(state, p8)
			p6 = if v5 then v5.scales else nil
		end

		object:dispatch(PurchaseItemsSuccess({
			items = p2,
			equippableAssets = p3,
			replaceAllEquippedAssets = p4,
			shouldClearEquippedMakeup = p9,
			bodyColor3s = p5,
			bodyScales = p6,
			bodyPartColorRangeIds = p7
		}))

		if fFlagAXBackgroundsCustomizeHydration then
			maybeApplyPurchasedBackground(object, p3)
		end
	end
end
