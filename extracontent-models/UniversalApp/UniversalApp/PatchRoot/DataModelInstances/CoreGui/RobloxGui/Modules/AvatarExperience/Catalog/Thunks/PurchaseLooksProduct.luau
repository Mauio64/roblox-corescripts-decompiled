local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local Cryo = require(CorePackages.Packages.Cryo)
local Promise = require(CorePackages.Packages.Promise)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local WebApi = require(Modules.AvatarExperience.Catalog.Http.WebApi)
local SetAssetOwned = require(Modules.AvatarExperience.Common.Actions.SetAssetOwned)
local SetBundleOwned = require(Modules.AvatarExperience.Common.Actions.SetBundleOwned)
local UpdateLookDetailsAfterSuccessfulPurchase = require(Modules.AvatarExperience.Common.Actions.UpdateLookDetailsAfterSuccessfulPurchase)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local WidgetConstants = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog).WidgetConstants
local AvatarExperienceAnalytics = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics)
local UnifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local sendUnifiedEventForDeferredAction = AvatarExperienceAnalytics.sendUnifiedEventForDeferredAction
local AvatarScreenProperties = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).AvatarRoute.AvatarScreenProperties
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local ItemTypeEnum = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Enums.ItemTypeEnum
local Selectors = require(CorePackages.Workspace.Packages.NavigationRodux).Selectors
local ApiFetchEconomyCurrency = require(Modules.LuaApp.Thunks.ApiFetchEconomyCurrency)
local v23 = game:DefineFastFlag("AXAnalyticsInfoCheck", false)
local v24 = game:DefineFastFlag("AXUnifiedSubsetOfLook", false)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local CartIdService = AvatarExperienceAnalytics.Lib.CartIdService
local UnifiedSelectionListStore = AvatarExperienceAnalytics.Store.UnifiedSelectionListStore
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXFixPurchaseSurfaceLogging = SharedFlags.FFlagAXFixPurchaseSurfaceLogging
local FFlagAXAvatarSortInDiscoveryUnifiedPurchase = SharedFlags.FFlagAXAvatarSortInDiscoveryUnifiedPurchase
local FFlagAXCatalogMakeupSupport = AvatarExperienceFlags.FFlagAXCatalogMakeupSupport
local FFlagAXMISEnableMultiShoppingUnifiedEvents = AvatarExperienceFlags.FFlagAXMISEnableMultiShoppingUnifiedEvents
local FFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local isEconomicRestrictionResponse = require(CorePackages.Workspace.Packages.IAPExperience).Utility.isEconomicRestrictionResponse
local t1 = {
	HttpError = Enum.HttpError.OK
}
local _ = {
	Unspecified = "Unspecified",
	Success = "Success",
	Failure = "Failure",
	PartialSuccess = "PartialSuccess"
}
local _ = {
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

local function updateRobux(p1, p2) -- line: 99
	-- upvalues: ArgCheck (copy), ApiFetchEconomyCurrency (copy)
	local LocalUserId = p2:getState().LocalUserId

	ArgCheck.isNonEmptyString(LocalUserId, "Thunk.PurchaseProduct.updateRobux.localUserId")

	if typeof(LocalUserId) == "string" and LocalUserId ~= "" then
		p2:dispatch(ApiFetchEconomyCurrency(p1, LocalUserId, true))
	end
end
local function v39(p3, p4, p5, n1: number, n2: number, t2: {[any]: any}) -- line: 107
	for v53, v54 in p4 do
		if v54 == "Success" or v54 == "AlreadyOwned" then
			n1 += 1
			p3:dispatch(p5(v53, true))

			if v54 == "Success" then
				table.insert(t2, (tonumber(v53)))
			end
		else
			n2 += 1
		end
	end

	return n1, n2, t2
end
local function isPlayerPremium(p6) -- line: 133
	local LocalUserId = p6.LocalUserId

	return ((if not p6.Users[LocalUserId] then Enum.MembershipType.None else p6.Users[LocalUserId].membership)) == Enum.MembershipType.Premium
end
local function getLookTypeForLookId(p7, s1: string) -- line: 144
	local v59 = p7:getState().AvatarExperience.AvatarScene.Looks[s1]

	if v59 then
		return v59.lookType
	end

	return nil
end
local function getPurchaseInfoForLookId(p8, s2: string) -- line: 156
	-- upvalues: Constants (copy), FFlagAXCatalogMakeupSupport (copy)
	local v62 = p8:getState()
	local t3 = {}
	local t4 = {}
	local t5 = {}
	local t6 = {}
	local n3 = 0
	local LocalUserId = v62.LocalUserId
	local v69 = ((if not v62.Users[LocalUserId] then Enum.MembershipType.None else v62.Users[LocalUserId].membership)) == Enum.MembershipType.Premium
	local TryOnItems = v62.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
	local v71 = v62.AvatarExperience.AvatarScene.Looks[s2]

	if TryOnItems == nil or v71 == nil then
		return n3, t3, t5
	end

	local g78 = nil
	local g80 = nil
	local v81 = nil
	local g83 = nil

	for _, v73 in TryOnItems do
		local v74 = v71.lookAssetInfos[tostring(v73.itemId)]
		local v75 = v71.lookBundleInfos[tostring(v73.itemId)]

		assert(v74 or v75, "itemInfo should not be nil")

		local v76 = v74 or v75

		if v73.itemId == tostring(Constants.BlockyBundleId) then
			continue
		end

		if v73.selectedInTryOnManager and v76.isPurchasable and not (v76.quantityOwned > 0) then
			local v77 = p8:getState().AvatarExperience.AvatarScene.Looks[s2]

			repeat
				if g78 or ((if not v77 then nil else v77.lookType)) ~= Constants.LookType.Avatar then
					if not g78 then
						if FFlagAXCatalogMakeupSupport then
							local v79 = p8:getState().AvatarExperience.AvatarScene.Looks[s2]

							if ((if not v79 then nil else v79.lookType)) == Constants.LookType.Makeup then
								g80 = true
							end
						end

						if not g80 then
							v81 = if not v69 then v74.priceInRobux else v74.premiumPriceInRobux
						end
					end

					if not g80 then
						g78 = false

						if v73.selectedTimedOptionIndex and v76.timedOptions then
							local v82 = v76.timedOptions[v73.selectedTimedOptionIndex]

							if v82 and v82.days then
								table.insert(t6, {
									itemType = v73.itemType,
									itemId = v73.itemId,
									days = v82.days
								})
								v81 = v82.price
							end
						end

						n3 += v81
						table.insert(t5, (tonumber(v73.itemId)))
						g83 = true

						break
					end
				end

				g80 = false
				v81 = v76.priceInRobux
				g78 = true
			until not g78

			if g83 then
				g83 = false

				continue
			end
		end

		if v73.itemType == Constants.ItemType.Bundle then
			table.insert(t4, v73.itemId)
		elseif v73.itemType == Constants.ItemType.Asset then
			table.insert(t3, v73.itemId)
		end
	end

	return n3, t3, t4, t5, t6
end
local function purchaseProductKeyMapper(s3: string) -- line: 230
	-- upvalues: CatalogConstants (copy)
	return CatalogConstants.PurchaseProductKey .. s3
end

return function(p9, s4: string, n4: number, p10) -- line: 238
	-- upvalues: PerformFetch (copy), CatalogConstants (copy), getPurchaseInfoForLookId (copy), HttpService (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), Constants (copy), Cryo (copy), WidgetConstants (copy), FFlagAXCatalogMakeupSupport (copy), WebApi (copy), isEconomicRestrictionResponse (copy), Promise (copy), v39 (copy), SetAssetOwned (copy), SetBundleOwned (copy), ArgCheck (copy), ApiFetchEconomyCurrency (copy), CatalogUtils (copy), FFlagUseNavigationSelectors (copy), Selectors (copy), AvatarScreenProperties (copy), v24 (copy), FFlagAXAvatarSortInDiscoveryUnifiedPurchase (copy), v23 (copy), sendUnifiedEventForDeferredAction (copy), UnifiedEventLogEnums (copy), CartIdService (copy), UnifiedSelectionListStore (copy), FFlagAXFixPurchaseSurfaceLogging (copy), ItemTypeEnum (copy), UpdateLookDetailsAfterSuccessfulPurchase (copy), t1 (copy)
	return PerformFetch.Single(CatalogConstants.PurchaseProductKey .. s4, function(p11) -- line: 239
		-- upvalues: getPurchaseInfoForLookId (copy), s4 (copy), HttpService (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), Constants (copy), Cryo (copy), n4 (copy), p10 (copy), WidgetConstants (copy), FFlagAXCatalogMakeupSupport (copy), WebApi (copy), p9 (copy), isEconomicRestrictionResponse (copy), Promise (copy), v39 (copy), SetAssetOwned (copy), SetBundleOwned (copy), ArgCheck (copy), ApiFetchEconomyCurrency (copy), CatalogUtils (copy), FFlagUseNavigationSelectors (copy), Selectors (copy), AvatarScreenProperties (copy), v24 (copy), FFlagAXAvatarSortInDiscoveryUnifiedPurchase (copy), v23 (copy), sendUnifiedEventForDeferredAction (copy), UnifiedEventLogEnums (copy), CartIdService (copy), UnifiedSelectionListStore (copy), FFlagAXFixPurchaseSurfaceLogging (copy), ItemTypeEnum (copy), UpdateLookDetailsAfterSuccessfulPurchase (copy), t1 (copy)
		local _, v91, v92, v93, v94 = getPurchaseInfoForLookId(p11, s4)
		local guid = HttpService:GenerateGUID(false)
		local HydratedWidgetData = p11:getState().AvatarExperience.Common.Widgets.HydratedWidgetData
		local LookAnalyticsInfo = p11:getState().AvatarExperience.AvatarScene.OutfitTryOn.LookAnalyticsInfo
		local g101 = nil
		local g104 = nil
		local v105 = nil

		if FFlagAXMISEnableMultiShoppingUnifiedEvents and p11:getState().AvatarExperience.AvatarScene.Looks[s4].lookType == Constants.LookType.Makeup then
			LookAnalyticsInfo = p11:getState().AvatarExperience.AvatarScene.OutfitTryOn.MakeupLookAnalyticsInfo
		end

		local u98 = if not LookAnalyticsInfo then nil else Cryo.Dictionary.join(LookAnalyticsInfo, {
			totalRobux = n4,
			assetIds = v93,
			lookType = if not HydratedWidgetData or (not HydratedWidgetData[Constants.ItemType.Look] or not HydratedWidgetData[Constants.ItemType.Look][s4]) then nil else HydratedWidgetData[Constants.ItemType.Look][s4].lookType
		})

		if u98 and #v93 > 0 then
			p10.widgetInteractionV2(u98, WidgetConstants.ActionType.PURCHASE_ATTEMPT)
		end

		local v99 = s4
		local v100 = p11:getState().AvatarExperience.AvatarScene.Looks[v99]

		repeat
			if g101 or ((if not v100 then nil else v100.lookType)) ~= Constants.LookType.Avatar then
				if not g101 then
					if FFlagAXCatalogMakeupSupport then
						local v102 = s4
						local v103 = p11:getState().AvatarExperience.AvatarScene.Looks[v102]

						if ((if not v103 then nil else v103.lookType)) == Constants.LookType.Makeup then
							g104 = true
						end
					end

					if not g104 then
						v105 = WebApi.PurchaseLook(p9, s4, guid, n4, 0, v91)
					end
				end

				if not g104 then
					g101 = false

					return v105:andThen(function(p12) -- line: 305
						-- upvalues: isEconomicRestrictionResponse (copy), Promise (copy), p11 (copy), s4 (copy), Constants (copy), FFlagAXCatalogMakeupSupport (copy), v39 (copy), SetAssetOwned (copy), SetBundleOwned (copy), p9 (copy), ArgCheck (copy), ApiFetchEconomyCurrency (copy), u98 (ref), CatalogUtils (copy), FFlagUseNavigationSelectors (copy), Selectors (copy), AvatarScreenProperties (copy), v24 (copy), FFlagAXAvatarSortInDiscoveryUnifiedPurchase (copy), v23 (copy), sendUnifiedEventForDeferredAction (copy), Cryo (copy), UnifiedEventLogEnums (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), CartIdService (copy), n4 (copy), UnifiedSelectionListStore (copy), p10 (copy), WidgetConstants (copy), FFlagAXFixPurchaseSurfaceLogging (copy), ItemTypeEnum (copy), WebApi (copy), UpdateLookDetailsAfterSuccessfulPurchase (copy), t1 (copy)
						local responseBody = p12.responseBody
						local v108 = responseBody.purchaseLookStatus == "Success" or responseBody.purchaseLookStatus == "PartialSuccess"

						if isEconomicRestrictionResponse(responseBody) then
							return Promise.reject(responseBody)
						end

						if not v108 or type(responseBody) ~= "table" then
							local v109 = t1

							return Promise.reject(v109)
						end

						local n5 = 0
						local n6 = 0
						local t7 = {}
						local t8 = {}
						local v114 = p11
						local v115 = s4
						local v116 = v114:getState().AvatarExperience.AvatarScene.Looks[v115]
						local g117 = nil
						local g121 = nil

						repeat
							if g117 or ((if not v116 then nil else v116.lookType)) ~= Constants.LookType.Avatar then
								if not g117 then
									if FFlagAXCatalogMakeupSupport then
										local v118 = p11
										local v119 = s4
										local v120 = v118:getState().AvatarExperience.AvatarScene.Looks[v119]

										if ((if not v120 then nil else v120.lookType)) == Constants.LookType.Makeup then
											g121 = true
										end
									end

									if not g121 then
										for v122, v123 in responseBody.itemPurchaseStatus do
											if v123 == "Success" or v123 == "AlreadyOwned" then
												n5 += 1
												p11:dispatch(SetAssetOwned(v122, true))

												if v123 == "Success" then
													table.insert(t7, (tonumber(v122)))
												end
											else
												n6 += 1
											end
										end
									end
								end

								if not g121 then
									g117 = false

									local v124 = p9
									local v125 = p11
									local LocalUserId = v125:getState().LocalUserId

									ArgCheck.isNonEmptyString(LocalUserId, "Thunk.PurchaseProduct.updateRobux.localUserId")

									if typeof(LocalUserId) == "string" and LocalUserId ~= "" then
										v125:dispatch(ApiFetchEconomyCurrency(v124, LocalUserId, true))
									end

									local v127 = nil
									local v128 = nil
									local v129 = nil
									local v130 = nil
									local v131 = p11:getState()
									local query

									if u98 then
										query = u98.query
									else
										local v133

										v133, v127, v128, v129, v130 = CatalogUtils.getAvatarsTabAnalyticsInfo(v131)
										query = v133
									end

									pcall(function() -- line: 373
										-- upvalues: FFlagUseNavigationSelectors (copy), Selectors (copy), p11 (copy), AvatarScreenProperties (copy), v24 (copy), u98 (ref), t7 (ref), t8 (ref), FFlagAXAvatarSortInDiscoveryUnifiedPurchase (copy), v23 (copy), sendUnifiedEventForDeferredAction (copy), Cryo (copy), UnifiedEventLogEnums (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), CartIdService (copy), s4 (copy), query (ref), n4 (copy)
										local name = nil

										if FFlagUseNavigationSelectors then
											local v143 = Selectors.selectCurrentRoactNavigationRoute(p11:getState())

											if v143.params and v143.params.fromAvatarRoute then
												name = v143.params.fromAvatarRoute.opaque.name
											elseif v143.params and v143.params.extraProps then
												name = v143.params.extraProps.routeName
											end
										else
											local v144 = p11:getState().Navigation and p11:getState().Navigation.currentRoute

											if v144 and v144.params and v144.params.fromAvatarRoute then
												name = v144.params.fromAvatarRoute.opaque.name
											elseif v144.params and v144.params.extraProps then
												name = v144.params.extraProps.routeName
											end
										end

										local v145 = AvatarScreenProperties[name]
										local v146 = if not v24 then nil else u98 == nil
										local v147 = nil
										local v148 = nil

										if v24 and #t7 > 0 then
											v147 = table.concat(t7, ",")
										end

										if v24 and #t8 > 0 then
											v148 = table.concat(t8, ",")
										end

										local v149 = if not FFlagAXAvatarSortInDiscoveryUnifiedPurchase then if not v145 or not v145.analyticsData then nil else v145.analyticsData.unifiedLoggingSurface else ((if not v23 then u98.surface else (if not u98 then nil else u98.surface))) or (not v145 or not v145.analyticsData or v145.analyticsData.unifiedLoggingSurface)

										sendUnifiedEventForDeferredAction(Cryo.Dictionary.join(p11:getState().AvatarExperience.AnalyticsMetadata, {
											action = UnifiedEventLogEnums.MarketplaceUnifiedAction.PURCHASE_SUCCESS,
											cartId = if not FFlagAXMISEnableMultiShoppingUnifiedEvents then nil else CartIdService.getCartId(),
											itemId = if not FFlagAXMISEnableMultiShoppingUnifiedEvents then nil else s4,
											itemType = UnifiedEventLogEnums.MarketplaceUnifiedItemType.LOOK,
											keyword = query,
											surface = v149,
											organicAssetIds = if not v24 or not v146 then nil else v147,
											organicBundleIds = if not v24 or not v146 then nil else v148,
											organicItemPrice = if not v24 or not v146 then nil else n4,
											assetIds = if not v24 or v146 then nil else v147,
											bundleIds = if not v24 or v146 then nil else v148,
											widgetItemPrice = if not v24 or v146 then nil else n4
										}))
									end)

									if FFlagAXMISEnableMultiShoppingUnifiedEvents then
										CartIdService.refreshCartId()
										UnifiedSelectionListStore.clearSelectionList()
									end

									local v134 = Cryo.Dictionary.join(responseBody, {
										successCount = n5,
										failureCount = n6
									})

									if u98 then
										u98 = Cryo.Dictionary.join(u98, {
											assetIds = t7
										})

										if #t7 > 0 or #t8 > 0 then
											p10.widgetInteractionV2(u98, WidgetConstants.ActionType.PURCHASE_SUCCESS)
										end
									elseif not u98 then
										local v135 = nil

										if FFlagAXFixPurchaseSurfaceLogging then
											if FFlagUseNavigationSelectors then
												local v136 = Selectors.selectCurrentRoactNavigationRoute(p11:getState())

												if v136 and v136.params then
													v135 = v136.params[Constants.NavigationParams.fromSurface]
												end
											elseif p11:getState().Navigation then
												v135 = p11:getState().Navigation.getParam(Constants.NavigationParams.fromSurface)
											end
										end

										p10.avatarShopBuyItem(s4, ItemTypeEnum.Look, n4, v130, v129, query, v127, v128, p11:getState().AvatarExperience.AnalyticsMetadata, v135)
									end

									if #t7 > 0 or #t8 > 0 then
										WebApi.GetLookDetailsV2(p9, s4):andThen(function(p13) -- line: 498
											-- upvalues: p11 (copy), UpdateLookDetailsAfterSuccessfulPurchase (copy), s4 (copy), t7 (ref), t8 (ref)
											local look = p13.responseBody.look

											if look then
												local v152 = true

												for _, v154 in look.items do
													if not v154.quantityOwned or v154.quantityOwned == 0 then
														v152 = false

														break
													end
												end

												p11:dispatch(UpdateLookDetailsAfterSuccessfulPurchase(s4, t7, t8, v152))
											end
										end)
									end

									return Promise.resolve(v134)
								end
							end

							g121 = false

							local v137, v138, v139 = v39(p11, responseBody.assetPurchaseStatus, SetAssetOwned, n5, n6, t7)

							t7 = v139

							local v140

							n5, n6, v140 = v39(p11, responseBody.bundlePurchaseStatus, SetBundleOwned, v137, v138, t8)
							t8 = v140
							g117 = true
						until not g117
					end, function(p14) -- line: 525
						-- upvalues: t1 (copy), Promise (copy)
						if type(p14) ~= "table" or p14.HttpError == nil then
							p14 = t1
						end

						return Promise.reject(p14)
					end)
				end
			end

			g104 = false
			v105 = WebApi.PurchaseLookV2(p9, s4, guid, n4, 0, v91, v92, if not (#v94 > 0) then nil else v94)
			g101 = true
		until not g101
	end)
end
