local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local parent = AvatarExperienceCatalog.Parent
local Loggers = require(parent.Loggers)
local mutedError = Loggers.mutedError

local PurchaseItemsSuccess = require(AvatarExperienceCatalog.State.Actions.PurchaseItemsSuccess)

local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)
local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local UnifiedSelectionListStore = AvatarExperienceAnalytics.Store.UnifiedSelectionListStore
local sendUnifiedEventsForMultiItemShopping = AvatarExperienceAnalytics.sendUnifiedEventsForMultiItemShopping
local UnifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local getUnifiedEventsForMIS = AvatarExperienceAnalytics.Utils.getUnifiedEventsForMIS
local CartIdService = AvatarExperienceAnalytics.Lib.CartIdService
local AvatarScreenProperties = AvatarExperienceNavigation.AvatarRoute.AvatarScreenProperties

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXMISEnableMultiShoppingUnifiedEvents = AvatarExperienceFlags.FFlagAXMISEnableMultiShoppingUnifiedEvents
local FFlagAXUnifiedEventStrictPayloads = AvatarExperienceFlags.FFlagAXUnifiedEventStrictPayloads
local FFlagAXMISSaveWearFix = AvatarExperienceFlags.FFlagAXMISSaveWearFix
local FFlagAXBackgroundsCustomizeHydration = AvatarExperienceFlags.FFlagAXBackgroundsCustomizeHydration

local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local AvatarExperienceRodux = require(parent.AvatarExperienceRodux)
local ApplyProfileConfiguration = AvatarExperienceRodux.Actions.ApplyProfileConfiguration

local AvatarBackground = AvatarExperienceCommon.Constants.ASSET_TYPE_NAME_TO_ID_STRING.AvatarBackground

local function maybeApplyPurchasedBackground(object, items)
	local assetId = nil

	for _, item in items do
		if item.assetTypeId == AvatarBackground then
			assetId = tonumber(item.assetId)
		end
	end

	if assetId then
		object:dispatch(ApplyProfileConfiguration({ BackgroundAssetId = assetId }))
	end
end

local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3gAvatarExperience = SharedFlags.FFlagSignalsNavP3gAvatarExperience
local NavigationRodux = require(parent.NavigationRodux)
local GetLegacyNavigationStore = NavigationRodux.GetLegacyNavigationStore

if FFlagAXMISEnableMultiShoppingUnifiedEvents then
	return function(items, equippableAssets, replaceAllEquippedAssets, bodyColor3s, bodyScales, bodyPartColorRangeIds, p, callback, p2, p3, p4, callback2)
		return function(object, _)
			local state = object:getState()
			local routeName

			if FFlagSignalsNavP3gAvatarExperience then
				local currentRoute = GetLegacyNavigationStore(false).getCurrentRoute(false)
				routeName = currentRoute and currentRoute.routeName
			else
				routeName = state.Navigation
					and state.Navigation.currentRoute
					and state.Navigation.currentRoute.routeName
			end

			local avatarScreenProperty = AvatarScreenProperties[routeName]
			local unifiedLoggingSurface

			if avatarScreenProperty and avatarScreenProperty.analyticsData then
				unifiedLoggingSurface = avatarScreenProperty.analyticsData.unifiedLoggingSurface
			else
				unifiedLoggingSurface = nil
			end

			if not pcall(function()
				if p3 then
					p3.isOrganicLook = state.AvatarExperience.AvatarScene.OutfitTryOn.LookAnalyticsInfo == nil
				end

				if p4 then
					p4.isOrganicLook = state.AvatarExperience.AvatarScene.OutfitTryOn.MakeupLookAnalyticsInfo == nil
				end

				local PURCHASE_SUCCESS = UnifiedEventLogEnums.MarketplaceUnifiedAction.PURCHASE_SUCCESS
				local v

				if FFlagAXUnifiedEventStrictPayloads then
					v = unifiedLoggingSurface
				end

				local lookAnalyticsInfo

				if FFlagAXUnifiedEventStrictPayloads then
					lookAnalyticsInfo = state.AvatarExperience.AvatarScene.OutfitTryOn.LookAnalyticsInfo
				end

				local v2

				if FFlagAXUnifiedEventStrictPayloads then
					v2 = state.AvatarExperience.AvatarScene.OutfitTryOn.MakeupLookAnalyticsInfo
				end

				local unifiedEventsForMIS, v3 = getUnifiedEventsForMIS(
					items,
					p,
					p3,
					p4,
					PURCHASE_SUCCESS,
					v,
					lookAnalyticsInfo,
					v2
				)

				if not FFlagAXUnifiedEventStrictPayloads then
					v3 = nil
				end

				sendUnifiedEventsForMultiItemShopping(unifiedEventsForMIS, unifiedLoggingSurface, v3)
			end) then
				mutedError("Failed to send unified events for multi-item shopping purchase success")
			end

			CartIdService.refreshCartId()
			UnifiedSelectionListStore.clearSelectionList()
			local v

			if FFlagAXMISSaveWearFix and callback2 then
				v = callback2(state, p)
			end

			local ordersByAssetId = {}

			if FFlagAXMISSaveWearFix and v then
				for _, makeupDescription in v:GetChildren() do
					if makeupDescription:IsA("MakeupDescription") then
						ordersByAssetId[tostring(makeupDescription.assetId)] = makeupDescription.order
					end
				end
			end

			if bodyScales == nil then
				local v2 = callback(state, p)
				local v3

				if v2 then
					v3 = v2.scales
				end

				bodyScales = v3
			end

			local v2 = {
				items = items,
				equippableAssets = equippableAssets,
				replaceAllEquippedAssets = replaceAllEquippedAssets,
				shouldClearEquippedMakeup = nil,
				bodyColor3s = nil,
				bodyScales = nil,
				bodyPartColorRangeIds = nil,
				makeupAssetsOnHumanoid = nil
			}
			local shouldClearEquippedMakeup

			if FFlagAXMISSaveWearFix then
				shouldClearEquippedMakeup = p2
			end

			v2.shouldClearEquippedMakeup = shouldClearEquippedMakeup
			v2.bodyColor3s = bodyColor3s
			v2.bodyScales = bodyScales
			v2.bodyPartColorRangeIds = bodyPartColorRangeIds

			if not FFlagAXMISSaveWearFix then
				ordersByAssetId = nil
			end

			v2.makeupAssetsOnHumanoid = ordersByAssetId
			object:dispatch(PurchaseItemsSuccess(v2))

			if FFlagAXBackgroundsCustomizeHydration then
				maybeApplyPurchasedBackground(object, equippableAssets)
			end
		end
	end
end

return function(items, equippableAssets, replaceAllEquippedAssets, bodyColor3s, bodyScales, bodyPartColorRangeIds, p, callback, shouldClearEquippedMakeup)
	return function(object, _)
		local state = object:getState()

		if bodyScales == nil then
			local v = callback(state, p)
			local v2

			if v then
				v2 = v.scales
			end

			bodyScales = v2
		end

		object:dispatch(PurchaseItemsSuccess({
			items = items,
			equippableAssets = equippableAssets,
			replaceAllEquippedAssets = replaceAllEquippedAssets,
			shouldClearEquippedMakeup = shouldClearEquippedMakeup,
			bodyColor3s = bodyColor3s,
			bodyScales = bodyScales,
			bodyPartColorRangeIds = bodyPartColorRangeIds
		}))

		if FFlagAXBackgroundsCustomizeHydration then
			maybeApplyPurchasedBackground(object, equippableAssets)
		end
	end
end
