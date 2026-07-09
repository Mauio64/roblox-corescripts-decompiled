local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent
local mutedError = require(AvatarExperienceCatalogParent.Loggers).mutedError
local PurchaseItemsSuccess = require(AvatarExperienceCatalog.State.Actions.PurchaseItemsSuccess)
local AvatarExperienceAnalytics = require(AvatarExperienceCatalogParent.AvatarExperienceAnalytics)
local AvatarExperienceNavigation = require(AvatarExperienceCatalogParent.AvatarExperienceNavigation)
local UnifiedSelectionListStore = AvatarExperienceAnalytics.Store.UnifiedSelectionListStore
local sendUnifiedEventsForMultiItemShopping = AvatarExperienceAnalytics.sendUnifiedEventsForMultiItemShopping
local UnifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local getUnifiedEventsForMIS = AvatarExperienceAnalytics.Utils.getUnifiedEventsForMIS
local CartIdService = AvatarExperienceAnalytics.Lib.CartIdService
local AvatarScreenProperties = AvatarExperienceNavigation.AvatarRoute.AvatarScreenProperties
local AvatarExperienceFlags = require(AvatarExperienceCatalogParent.AvatarExperienceFlags)
local FFlagAXMISEnableMultiShoppingUnifiedEvents = AvatarExperienceFlags.FFlagAXMISEnableMultiShoppingUnifiedEvents
local FFlagAXMISSaveWearFix = AvatarExperienceFlags.FFlagAXMISSaveWearFix
local FFlagAXBackgroundsCustomizeHydration = AvatarExperienceFlags.FFlagAXBackgroundsCustomizeHydration
local AvatarExperienceCommon = require(AvatarExperienceCatalogParent.AvatarExperienceCommon)
local ApplyProfileConfiguration = require(AvatarExperienceCatalogParent.AvatarExperienceRodux).Actions.ApplyProfileConfiguration
local AvatarBackground = AvatarExperienceCommon.Constants.ASSET_TYPE_NAME_TO_ID_STRING.AvatarBackground

local function maybeApplyPurchasedBackground(p1, t1: {[any]: any}) -- line: 32
	-- upvalues: AvatarBackground (copy), ApplyProfileConfiguration (copy)
	local num = nil

	for _, v25 in t1 do
		if v25.assetTypeId == AvatarBackground then
			num = tonumber(v25.assetId)
		end
	end

	if num then
		p1:dispatch(ApplyProfileConfiguration({
			BackgroundAssetId = num
		}))
	end
end

if FFlagAXMISEnableMultiShoppingUnifiedEvents then
	return function(p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13: ((...any) -> ...any)?) -- line: 45
		-- upvalues: AvatarScreenProperties (copy), sendUnifiedEventsForMultiItemShopping (copy), getUnifiedEventsForMIS (copy), UnifiedEventLogEnums (copy), mutedError (copy), CartIdService (copy), UnifiedSelectionListStore (copy), FFlagAXMISSaveWearFix (copy), PurchaseItemsSuccess (copy), FFlagAXBackgroundsCustomizeHydration (copy), maybeApplyPurchasedBackground (copy)
		return function(p14, _) -- line: 59
			-- upvalues: AvatarScreenProperties (copy), p11 (copy), p12 (copy), sendUnifiedEventsForMultiItemShopping (copy), getUnifiedEventsForMIS (copy), p2 (copy), p8 (copy), UnifiedEventLogEnums (copy), mutedError (copy), CartIdService (copy), UnifiedSelectionListStore (copy), FFlagAXMISSaveWearFix (copy), p13 (copy), p6 (ref), p9 (copy), PurchaseItemsSuccess (copy), p3 (copy), p4 (copy), p10 (copy), p5 (copy), p7 (copy), FFlagAXBackgroundsCustomizeHydration (copy), maybeApplyPurchasedBackground (copy)
			local v51 = p14:getState()
			local v52 = AvatarScreenProperties[v51.Navigation and (v51.Navigation.currentRoute and v51.Navigation.currentRoute.routeName)]
			local v53 = if not v52 or not v52.analyticsData then nil else v52.analyticsData.unifiedLoggingSurface

			if not pcall(function() -- line: 70
				-- upvalues: p11 (copy), v51 (copy), p12 (copy), sendUnifiedEventsForMultiItemShopping (copy), getUnifiedEventsForMIS (copy), p2 (copy), p8 (copy), UnifiedEventLogEnums (copy), v53 (copy)
				if p11 then
					p11.isOrganicLook = v51.AvatarExperience.AvatarScene.OutfitTryOn.LookAnalyticsInfo == nil
				end

				if p12 then
					p12.isOrganicLook = v51.AvatarExperience.AvatarScene.OutfitTryOn.MakeupLookAnalyticsInfo == nil
				end

				sendUnifiedEventsForMultiItemShopping(getUnifiedEventsForMIS(p2, p8, p11, p12, UnifiedEventLogEnums.MarketplaceUnifiedAction.PURCHASE_SUCCESS), v53)
			end) then
				mutedError("Failed to send unified events for multi-item shopping purchase success")
			end

			CartIdService.refreshCartId()
			UnifiedSelectionListStore.clearSelectionList()

			local v54 = if not FFlagAXMISSaveWearFix or not p13 then nil else p13(v51, p8)
			local t2 = {}

			if FFlagAXMISSaveWearFix and v54 then
				for _, child in v54:GetChildren() do
					if child:IsA("MakeupDescription") then
						t2[tostring(child.assetId)] = child.order
					end
				end
			end

			if p6 == nil then
				local v58 = p9(v51, p8)

				p6 = if not v58 then nil else v58.scales
			end

			p14:dispatch(PurchaseItemsSuccess({
				items = p2,
				equippableAssets = p3,
				replaceAllEquippedAssets = p4,
				shouldClearEquippedMakeup = if not FFlagAXMISSaveWearFix then nil else p10,
				bodyColor3s = p5,
				bodyScales = p6,
				bodyPartColorRangeIds = p7,
				makeupAssetsOnHumanoid = if not FFlagAXMISSaveWearFix then nil else t2
			}))

			if FFlagAXBackgroundsCustomizeHydration then
				maybeApplyPurchasedBackground(p14, p3)
			end
		end
	end
end

return function(p16, p17, p18, p19, p20, p21, p22, p23, p24) -- line: 145
	-- upvalues: PurchaseItemsSuccess (copy), FFlagAXBackgroundsCustomizeHydration (copy), maybeApplyPurchasedBackground (copy)
	return function(p25, _) -- line: 156
		-- upvalues: p20 (ref), p23 (copy), p22 (copy), PurchaseItemsSuccess (copy), p16 (copy), p17 (copy), p18 (copy), p24 (copy), p19 (copy), p21 (copy), FFlagAXBackgroundsCustomizeHydration (copy), maybeApplyPurchasedBackground (copy)
		local v61 = p25:getState()

		if p20 == nil then
			local v62 = p23(v61, p22)

			p20 = if not v62 then nil else v62.scales
		end

		p25:dispatch(PurchaseItemsSuccess({
			items = p16,
			equippableAssets = p17,
			replaceAllEquippedAssets = p18,
			shouldClearEquippedMakeup = p24,
			bodyColor3s = p19,
			bodyScales = p20,
			bodyPartColorRangeIds = p21
		}))

		if FFlagAXBackgroundsCustomizeHydration then
			maybeApplyPurchasedBackground(p25, p17)
		end
	end
end
