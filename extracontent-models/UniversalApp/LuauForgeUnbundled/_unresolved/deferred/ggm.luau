local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")

local Cryo = require(CorePackages.Packages.Cryo)
local Promise = require(CorePackages.Packages.Promise)
local module = require("@luauforge/bundled/dwM")
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch

local module2 = require("@luauforge/bundled/dME")
local GetExperienceSourceLanguage = require("@game/CoreGui/RobloxGui/Modules/Feedback/Network/GetExperienceSourceLanguage")
local module4 = require("@luauforge/bundled/dMV")
local module5 = require("@luauforge/bundled/dNj")

local module6 = require("@luauforge/bundled/dMg")

local module7 = require("@luauforge/bundled/dMx")
local widgetConstants = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog").WidgetConstants
local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")
local unifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local sendUnifiedEventForDeferredAction = AvatarExperienceAnalytics.sendUnifiedEventForDeferredAction
local avatarScreenProperties = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").AvatarRoute.AvatarScreenProperties
local module9 = require("@luauforge/bundled/dRQ")
local itemTypeEnum = require("@luauforge/bundled/dMd").Enums.ItemTypeEnum
local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Selectors

local module10 = require("@luauforge/bundled/fuX")

local defineFastFlag = game:DefineFastFlag("AXUnifiedSubsetOfLook", false)

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local cartIdService = AvatarExperienceAnalytics.Lib.CartIdService
local mapAnalyticsMetadataFields = AvatarExperienceAnalytics.Utils.mapAnalyticsMetadataFields
local getWidgetAttributionFields = AvatarExperienceAnalytics.Utils.getWidgetAttributionFields

local unifiedSelectionListStore = AvatarExperienceAnalytics.Store.UnifiedSelectionListStore
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXFixPurchaseSurfaceLogging = SharedFlags.FFlagAXFixPurchaseSurfaceLogging
local fFlagAXCatalogMakeupSupport = AvatarExperienceFlags.FFlagAXCatalogMakeupSupport
local fFlagAXMISEnableMultiShoppingUnifiedEvents = AvatarExperienceFlags.FFlagAXMISEnableMultiShoppingUnifiedEvents
local fFlagAXUnifiedEventStrictPayloads = AvatarExperienceFlags.FFlagAXUnifiedEventStrictPayloads
local fFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local fFlagSignalsNavP3gAvatarExperience = SharedFlags.FFlagSignalsNavP3gAvatarExperience
local getLegacyNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore

local isEconomicRestrictionResponse = require("@luauforge/deferred/gfP").Utility.isEconomicRestrictionResponse

local v5 = { HttpError = Enum.HttpError.OK }

local v6 = {
	Unspecified = "Unspecified",
	Success = "Success",
	Failure = "Failure",
	PartialSuccess = "PartialSuccess"
}

local v7 = {
	Unspecified = "Unspecified",
	Success = "Success",
	Throttled = "Throttled",
	ExceptionOccured = "ExceptionOccured",
	ExpectedPriceIncreased = "ExpectedPriceIncreased",
	TwoStepVerificationRequired = "TwoStepVerificationRequired",
	AlreadyOwned = "AlreadyOwned",
	InsufficientFunds = "InsufficientFunds",
	InsufficientMembership = "InsufficientMembership",
	NotForSale = "NotForSale",
	PriceChanged = "PriceChanged",
	NotAttempted = "NotAttempted",
	SaleExpired = "SaleExpired",
	SupplyExausted = "SupplyExausted",
	ContentRatingRestricted = "ContentRatingRestricted",
	UnknownBirthday = "UnknownBirthday",
	AffiliateSalesDisabled = "AffiliateSalesDisabled",
	BadAffiliateSaleProduct = "BadAffiliateSaleProduct",
	IOSOnlyItem = "IOSOnlyItem",
	InvalidArguments = "InvalidArguments",
	Unauthorized = "Unauthorized",
	AccountRestrictionsRestricted = "AccountRestrictionsRestricted",
	PendingTransactionAlreadyExists = "PendingTransactionAlreadyExists",
	SaleUnavailableAtSaleLocation = "SaleUnavailableAtSaleLocation",
	UnexpectedSeller = "UnexpectedSeller",
	EconomyDisabled = "EconomyDisabled"
}

local function updateRobux(p2, object)
	local localUserId = object:getState().LocalUserId
	module.isNonEmptyString(localUserId, "Thunk.PurchaseProduct.updateRobux.localUserId")

	if typeof(localUserId) == "string" and localUserId ~= "" then
		object:dispatch(module10(p2, localUserId, true))
	end
end

local function fn(object, items, callback, count, count2, list)
	for k, item in items do
		if item == "Success" or item == "AlreadyOwned" then
			count += 1
			object:dispatch(callback(k, true))

			if item == "Success" then
				table.insert(list, (tonumber(k)))
			end
		else
			count2 += 1
		end
	end

	return count, count2, list
end

local function isPlayerPremium(p2): boolean
	local localUserId = p2.LocalUserId
	return (if p2.Users[localUserId] then p2.Users[localUserId].membership else Enum.MembershipType.None) == Enum.MembershipType.Premium
end

local function getLookTypeForLookId(object, p2)
	local look = object:getState().AvatarExperience.AvatarScene.Looks[p2]

	if look then
		return look.lookType
	end

	return nil
end

local function getPurchaseInfoForLookId(object, p2)
	local state = object:getState()
	local itemIds = {}
	local itemIds2 = {}

	local itemIds3 = {}
	local result = {}
	local total = 0
	local localUserId = state.LocalUserId
	local v9 = (if state.Users[localUserId] then state.Users[localUserId].membership else Enum.MembershipType.None) == Enum.MembershipType.Premium

	local tryOnItems = state.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
	local look = state.AvatarExperience.AvatarScene.Looks[p2]

	if tryOnItems == nil or look == nil then
		return total, itemIds, itemIds3
	end

	for k, tryOnItem in tryOnItems do
		local lookAssetInfo = look.lookAssetInfos[tostring(tryOnItem.itemId)]
		local lookBundleInfo = look.lookBundleInfos[tostring(tryOnItem.itemId)]
		assert(lookAssetInfo or lookBundleInfo, "itemInfo should not be nil")

		local v10 = lookAssetInfo or lookBundleInfo

		if tryOnItem.itemId == tostring(module7.BlockyBundleId) then
			continue
		end

		if tryOnItem.selectedInTryOnManager and v10.isPurchasable and not (v10.quantityOwned > 0) then
			local look2 = object:getState().AvatarExperience.AvatarScene.Looks[p2]
			local lookType = if look2 then look2.lookType else nil
			local v11

			if lookType == module7.LookType.Avatar then
				v11 = v10.priceInRobux
			elseif fFlagAXCatalogMakeupSupport then
				local look3 = object:getState().AvatarExperience.AvatarScene.Looks[p2]
				local v12 = if look3 then look3.lookType else nil

				if v12 == module7.LookType.Makeup then
					v11 = v10.priceInRobux
				else
					v11 = if v9 then lookAssetInfo.premiumPriceInRobux else lookAssetInfo.priceInRobux
				end
			else
				v11 = if v9 then lookAssetInfo.premiumPriceInRobux else lookAssetInfo.priceInRobux
			end

			if tryOnItem.selectedTimedOptionIndex and v10.timedOptions then
				local timedOption = v10.timedOptions[tryOnItem.selectedTimedOptionIndex]

				if timedOption and timedOption.days then
					table.insert(result, {
						itemType = tryOnItem.itemType,
						itemId = tryOnItem.itemId,
						days = timedOption.days
					})

					v11 = timedOption.price
				end
			end

			total += v11
			table.insert(itemIds3, (tonumber(tryOnItem.itemId)))
		elseif tryOnItem.itemType == module7.ItemType.Bundle then
			table.insert(itemIds2, tryOnItem.itemId)
		elseif tryOnItem.itemType == module7.ItemType.Asset then
			table.insert(itemIds, tryOnItem.itemId)
		end
	end

	return total, itemIds, itemIds2, itemIds3, result
end

local function purchaseProductKeyMapper(p2)
	return module2.PurchaseProductKey .. p2
end

return function(p2, p3, p4, p5)
	return performFetch.Single(module2.PurchaseProductKey .. p3, function(object)
		local purchaseInfoForLookId, v8, v9, v10, v11 = getPurchaseInfoForLookId(object, p3)

		local guid = HttpService:GenerateGUID(false)

		local hydratedWidgetData = object:getState().AvatarExperience.Common.Widgets.HydratedWidgetData
		local v12 = object:getState().AvatarExperience.AvatarScene.OutfitTryOn.LookAnalyticsInfo

		if
			fFlagAXMISEnableMultiShoppingUnifiedEvents
			and object:getState().AvatarExperience.AvatarScene.Looks[p3].lookType == module7.LookType.Makeup
		then
			v12 = object:getState().AvatarExperience.AvatarScene.OutfitTryOn.MakeupLookAnalyticsInfo
		end

		local joined

		if v12 then
			local join = Cryo.Dictionary.join
			local v13 = { totalRobux = p4, assetIds = v10, lookType = 0 }

			local v14 = if hydratedWidgetData and hydratedWidgetData[module7.ItemType.Look] and hydratedWidgetData[module7.ItemType.Look][p3] then hydratedWidgetData[module7.ItemType.Look][p3].lookType else nil
			v13.lookType = v14
			joined = join(v12, v13)
		else
			joined = nil
		end

		if joined and #v10 > 0 then
			p5.widgetInteractionV2(joined, widgetConstants.ActionType.PURCHASE_ATTEMPT)
		end

		local look = object:getState().AvatarExperience.AvatarScene.Looks[p3]
		local lookType = if look then look.lookType else nil
		local purchaseLookV2, v14, v15, v16, v17, v18

		if lookType == module7.LookType.Avatar then
			purchaseLookV2 = GetExperienceSourceLanguage.PurchaseLookV2
			v14 = p2
			v15 = p3

			v16 = p4
			v17 = 0

			if not (#v11 > 0) then
				v11 = nil
			end

			v18 = purchaseLookV2(v14, v15, guid, v16, v17, v8, v9, v11)
		elseif fFlagAXCatalogMakeupSupport then
			local look2 = object:getState().AvatarExperience.AvatarScene.Looks[p3]
			local v20 = if look2 then look2.lookType else nil

			if v20 == module7.LookType.Makeup then
				purchaseLookV2 = GetExperienceSourceLanguage.PurchaseLookV2
				v14 = p2
				v15 = p3

				v16 = p4
				v17 = 0

				if not (#v11 > 0) then
					v11 = nil
				end

				v18 = purchaseLookV2(v14, v15, guid, v16, v17, v8, v9, v11)
			else
				v18 = GetExperienceSourceLanguage.PurchaseLook(p2, p3, guid, p4, 0, v8)
			end
		else
			v18 = GetExperienceSourceLanguage.PurchaseLook(p2, p3, guid, p4, 0, v8)
		end

		return v18:andThen(function(p6)
			local responseBody = p6.responseBody
			local v19 = responseBody.purchaseLookStatus == "Success"
				or responseBody.purchaseLookStatus == "PartialSuccess"

			if isEconomicRestrictionResponse(responseBody) then
				return Promise.reject(responseBody)
			end

			if not v19 or type(responseBody) ~= "table" then
				return Promise.reject(v5)
			end

			local v20 = 0
			local v21 = 0
			local v22 = {}
			local v23 = {}
			local look2 = object:getState().AvatarExperience.AvatarScene.Looks[p3]
			local lookType2 = if look2 then look2.lookType else nil
			local v25, v26

			if lookType2 == module7.LookType.Avatar then
				v25, v26, v22 = fn(object, responseBody.assetPurchaseStatus, module4, v20, v21, v22)

				v20, v21, v23 = fn(object, responseBody.bundlePurchaseStatus, module5, v25, v26, v23)
			elseif fFlagAXCatalogMakeupSupport then
				local look3 = object:getState().AvatarExperience.AvatarScene.Looks[p3]
				local v28 = if look3 then look3.lookType else nil

				if v28 == module7.LookType.Makeup then
					v25, v26, v22 = fn(object, responseBody.assetPurchaseStatus, module4, v20, v21, v22)

					v20, v21, v23 = fn(object, responseBody.bundlePurchaseStatus, module5, v25, v26, v23)
				else
					for k, v29 in responseBody.itemPurchaseStatus do
						if v29 == "Success" or v29 == "AlreadyOwned" then
							v20 += 1
							object:dispatch(module4(k, true))

							if v29 == "Success" then
								table.insert(v22, (tonumber(k)))
							end
						else
							v21 += 1
						end
					end
				end
			else
				for k, v29 in responseBody.itemPurchaseStatus do
					if v29 == "Success" or v29 == "AlreadyOwned" then
						v20 += 1
						object:dispatch(module4(k, true))

						if v29 == "Success" then
							table.insert(v22, (tonumber(k)))
						end
					else
						v21 += 1
					end
				end
			end

			local v27 = p2
			local v28 = object
			local localUserId = v28:getState().LocalUserId
			module.isNonEmptyString(localUserId, "Thunk.PurchaseProduct.updateRobux.localUserId")

			if typeof(localUserId) == "string" and localUserId ~= "" then
				v28:dispatch(module10(v27, localUserId, true))
			end

			local v29 = nil
			local v30 = nil
			local v31 = nil
			local v32 = nil
			local state = object:getState()
			local v33

			if joined then
				v33 = joined.query
			else
				v33, v29, v30, v31, v32 = module9.getAvatarsTabAnalyticsInfo(state)
			end

			pcall(function()
				local v34 = nil

				if fFlagSignalsNavP3gAvatarExperience then
					local currentRoute = getLegacyNavigationStore(false).getCurrentRoute(false)

					if currentRoute and currentRoute.params and currentRoute.params.fromAvatarRoute then
						v34 = currentRoute.params.fromAvatarRoute.opaque.name
					elseif currentRoute and currentRoute.params and currentRoute.params.extraProps then
						v34 = currentRoute.params.extraProps.routeName
					end
				elseif fFlagUseNavigationSelectors then
					local currentRoactNavigationRoute = selectors.selectCurrentRoactNavigationRoute(object:getState())

					if
						currentRoactNavigationRoute.params
						and currentRoactNavigationRoute.params.fromAvatarRoute
					then
						v34 = currentRoactNavigationRoute.params.fromAvatarRoute.opaque.name
					elseif
						currentRoactNavigationRoute.params
						and currentRoactNavigationRoute.params.extraProps
					then
						v34 = currentRoactNavigationRoute.params.extraProps.routeName
					end
				else
					local currentRoute = object:getState().Navigation
						and object:getState().Navigation.currentRoute

					if currentRoute and currentRoute.params and currentRoute.params.fromAvatarRoute then
						v34 = currentRoute.params.fromAvatarRoute.opaque.name
					elseif currentRoute.params and currentRoute.params.extraProps then
						v34 = currentRoute.params.extraProps.routeName
					end
				end

				local avatarScreenProperty = avatarScreenProperties[v34]
				local v35 = if defineFastFlag then joined == nil else nil
				local joined2 = nil
				local joined3 = if defineFastFlag and #v22 > 0 then table.concat(v22, ",") else nil

				if defineFastFlag and #v23 > 0 then
					joined2 = table.concat(v23, ",")
				end

				local v36 = if joined then joined.surface else nil

				if not v36 and avatarScreenProperty and avatarScreenProperty.analyticsData then
					v36 = avatarScreenProperty.analyticsData.unifiedLoggingSurface
				end

				local join = Cryo.Dictionary.join
				local analyticsMetadata = object:getState().AvatarExperience.AnalyticsMetadata
				local v37 = {
					action = unifiedEventLogEnums.MarketplaceUnifiedAction.PURCHASE_SUCCESS,
					cartId = 0,
					itemId = 0,
					itemType = 0,
					keyword = 0,
					surface = 0,
					organicAssetIds = 0,
					organicBundleIds = 0,
					organicItemPrice = 0,
					assetIds = 0,
					bundleIds = 0,
					widgetItemPrice = 0
				}

				local v38 = if fFlagAXMISEnableMultiShoppingUnifiedEvents then cartIdService.getCartId() else nil
				v37.cartId = v38

				v37.itemId = if fFlagAXMISEnableMultiShoppingUnifiedEvents then p3 else nil
				v37.itemType = unifiedEventLogEnums.MarketplaceUnifiedItemType.LOOK
				v37.keyword = v33
				v37.surface = v36
				local v40 = if defineFastFlag and v35 then joined3 else nil
				v37.organicAssetIds = v40
				local v41 = if defineFastFlag and v35 then joined2 else nil
				v37.organicBundleIds = v41
				local v42 = if defineFastFlag and v35 then p4 else nil
				v37.organicItemPrice = v42

				if not defineFastFlag or v35 then
					joined3 = nil
				end

				v37.assetIds = joined3

				if not defineFastFlag or v35 then
					joined2 = nil
				end

				v37.bundleIds = joined2
				local v43 = if defineFastFlag and not v35 then p4 else nil
				v37.widgetItemPrice = v43
				local v44 = join(analyticsMetadata, v37)

				if fFlagAXUnifiedEventStrictPayloads then
					v44 = mapAnalyticsMetadataFields(v44)
				end

				local v46 = if fFlagAXUnifiedEventStrictPayloads then getWidgetAttributionFields(joined) else nil
				sendUnifiedEventForDeferredAction(v44, v46)
			end)

			if fFlagAXMISEnableMultiShoppingUnifiedEvents then
				cartIdService.refreshCartId()
				unifiedSelectionListStore.clearSelectionList()
			end

			local joined2 = Cryo.Dictionary.join(responseBody, {
				successCount = v20,
				failureCount = v21
			})

			if joined then
				joined = Cryo.Dictionary.join(joined, { assetIds = v22 })

				if #v22 > 0 or #v23 > 0 then
					p5.widgetInteractionV2(joined, widgetConstants.ActionType.PURCHASE_SUCCESS)
				end
			elseif not joined then
				local v34 = nil

				if fFlagAXFixPurchaseSurfaceLogging then
					if fFlagSignalsNavP3gAvatarExperience then
						local currentRoute = getLegacyNavigationStore(false).getCurrentRoute(false)

						if currentRoute and currentRoute.params then
							v34 = currentRoute.params[module7.NavigationParams.fromSurface]
						end
					elseif fFlagUseNavigationSelectors then
						local currentRoactNavigationRoute = selectors.selectCurrentRoactNavigationRoute(object:getState())

						if currentRoactNavigationRoute and currentRoactNavigationRoute.params then
							v34 = currentRoactNavigationRoute.params[module7.NavigationParams.fromSurface]
						end
					elseif object:getState().Navigation then
						v34 = object:getState().Navigation.getParam(module7.NavigationParams.fromSurface)
					end
				end

				p5.avatarShopBuyItem(
					p3,
					itemTypeEnum.Look,
					p4,
					v32,
					v31,
					v33,
					v29,
					v30,
					object:getState().AvatarExperience.AnalyticsMetadata,
					v34
				)
			end

			if #v22 > 0 or #v23 > 0 then
				GetExperienceSourceLanguage.GetLookDetailsV2(p2, p3):andThen(function(p7)
					local look3 = p7.responseBody.look

					if look3 then
						local v34 = true

						for k, item in look3.items do
							if not item.quantityOwned or item.quantityOwned == 0 then
								v34 = false
								break
							end
						end

						object:dispatch(module6(p3, v22, v23, v34))
					end
				end)
			end

			return Promise.resolve(joined2)
		end, function(p6)
			if type(p6) ~= "table" or p6.HttpError == nil then
				p6 = v5
			end

			return Promise.reject(p6)
		end)
	end)
end
