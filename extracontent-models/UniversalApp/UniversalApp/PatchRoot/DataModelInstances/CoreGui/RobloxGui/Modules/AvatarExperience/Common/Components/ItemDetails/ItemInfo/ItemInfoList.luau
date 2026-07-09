local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagDynamicHeadsMigration = AvatarExperienceFlags.FFlagDynamicHeadsMigration
local React = require(CorePackages.Packages.React)
local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local NumberLocalization = require(CorePackages.Workspace.Packages.Localization).NumberLocalization
local ProfileTypes = require(CorePackages.Workspace.Packages.ProfilePlatform.Enums).ProfileTypes
local EnableCommunityProfilePageIXP = require(CorePackages.Workspace.Packages.ProfilePlatform.EnableCommunityProfilePageIXP)
local ItemData = require(Modules.AvatarExperience.Common.Selectors.ItemData)
local AttributionItemInfoRow = require(Modules.AvatarExperience.Common.Components.ItemDetails.ItemInfo.AttributionItemInfoRow)
local ItemInfoRow = require(Modules.AvatarExperience.Common.Components.ItemDetails.ItemInfo.ItemInfoRow)
local useItemDataDigest = require(Modules.AvatarExperience.Catalog.Hooks.useItemDataDigest)
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local FetchAssetResaleData = require(Modules.AvatarExperience.Catalog.Thunks.FetchAssetResaleData)
local FetchAssetVersionData = require(Modules.AvatarExperience.Catalog.Thunks.FetchAssetVersionData)

require(Modules.AvatarExperience.Common.Models.CollectibleInfo)

local UrlBuilder = require(Modules.LuaApp.Http.UrlBuilder)
local AppPage = require(Modules.LuaApp.AppPage)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v29 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local RoactLocalization = require(Modules.LuaApp.Services.RoactLocalization)
local useLocalization = require(Modules.LuaApp.Hooks.useLocalization)
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local useAppPolicy = require(Modules.LuaApp.Hooks.useAppPolicy)
local v35 = game:DefineFastFlag("UseItemDataHookRefactor", false)

require(Modules.AvatarExperience.Common.Types)

local getUseSelectorDeepEquals = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.getUseSelectorDeepEquals
local v37 = game:DefineFastFlag("FixNavigationToCreatorProfileWebviewFromProfile", false)
local FFlagAXAddHDRowInItemDetailsPage = AvatarExperienceFlags.FFlagAXAddHDRowInItemDetailsPage
local FFlagAXFixCollectibleOriginalPrice = require(Modules.AvatarExperience.Flags.FFlagAXFixCollectibleOriginalPrice)
local v40 = game:DefineFastFlag("AXFixMissingResalePrice", false)
local FFlagAXDurables2Option = AvatarExperienceFlags.FFlagAXDurables2Option
local getTaxonomyName = require(Modules.AvatarExperience.Common.Selectors.getTaxonomyName)
local getEquipSlotForAssetType = require(Modules.AvatarExperience.Common.Selectors.getEquipSlotForAssetType)

local function getNumberLocalization(p1, p2) -- line: 81
	-- upvalues: NumberLocalization (copy)
	if not p1 then
		return nil
	end

	return NumberLocalization.localize(p1, p2:GetLocale())
end
local function getProductIdAndCreator(p3, p4) -- line: 89
	local v53 = if not p3 then if not p4 or not p4.product then nil else p4.product.id else p3.collectibleProductId

	if p3 then
		return v53, p3.creator
	end

	if p4 then
		return v53, p4.creator
	end

	return v53, nil
end
local function getCreatingUniverseId(p5, p6) -- line: 102
	if p6 then
		return p6.creatingUniverseId
	end

	if p5 then
		return p5.creatingUniverseId
	end

	return nil
end
local function getGameJoinContext(p7, p8, p9, p10) -- line: 112
	-- upvalues: Constants (copy), Utils (copy)
	if p10 then
		return {
			outfitId = p10.outfitId,
			itemType = Enum.AvatarItemType.Bundle,
			joinSource = Enum.JoinSource.CreatedItemAttribution
		}
	end

	return {
		assetId = p8,
		itemType = if not p7 then nil else Enum.AvatarItemType[p7],
		assetType = if p7 ~= Constants.ItemType.Asset or not p9 then nil else Utils.AssetTypeIdStringToEnumValue(p9),
		joinSource = Enum.JoinSource.CreatedItemAttribution
	}
end
local function getLocalPlayerName() -- line: 136
	-- upvalues: Players (copy)
	local LocalPlayer = Players.LocalPlayer

	return LocalPlayer and LocalPlayer.Name or ""
end

return (React.forwardRef(function(t1: {[any]: any}, _) -- line: 141
	-- upvalues: useSelector (copy), ItemData (copy), getUseSelectorDeepEquals (copy), CatalogUtils (copy), v40 (copy), useAppPolicy (copy), React (copy), CatalogConstants (copy), v35 (copy), useDispatch (copy), useNavigation (copy), useRoactService (copy), RoactNetworking (copy), EnableCommunityProfilePageIXP (copy), AppPage (copy), ProfileTypes (copy), FFlagSignalsNavP3Dispatch (copy), v29 (copy), NavigateDown (copy), UrlBuilder (copy), v37 (copy), AvatarScreen (copy), Constants (copy), getTaxonomyName (copy), getEquipSlotForAssetType (copy), RoactLocalization (copy), NumberLocalization (copy), useLocalization (copy), FFlagAXDurables2Option (copy), FFlagAXFixCollectibleOriginalPrice (copy), useItemDataDigest (copy), FFlagAXAddHDRowInItemDetailsPage (copy), FetchAssetResaleData (copy), FetchAssetVersionData (copy), getGameJoinContext (copy), Players (copy), FFlagDynamicHeadsMigration (copy), AttributionItemInfoRow (copy), ItemInfoRow (copy), Focusable (copy)
	local collectibleItemId = nil
	local u64 = nil
	local u65 = nil
	local u66 = nil
	local u67 = nil
	local u68 = nil
	local u69 = nil
	local v70 = useSelector(function(p12) -- line: 155
		-- upvalues: ItemData (copy), t1 (copy)
		return ItemData(p12.AvatarExperience.Common, t1.itemId, t1.itemType)
	end, getUseSelectorDeepEquals());

	(function() -- line: 160
		-- upvalues: v70 (copy), collectibleItemId (ref), u64 (ref), u67 (ref), u68 (ref), u69 (ref), CatalogUtils (copy), t1 (copy), u65 (ref), v40 (copy), u66 (ref)
		if v70 then
			collectibleItemId = v70.collectibleItemId

			local resellerUserAssetIds = v70.resellerUserAssetIds

			u64 = resellerUserAssetIds and (#resellerUserAssetIds > 0 and resellerUserAssetIds[1])
			u67 = if not v70.creator then nil else v70.creator.id
			u68 = if not v70.creator then nil else v70.creator.type
			u69 = CatalogUtils.GetItemSubType(t1.itemType, v70)
			u65 = if not v40 then CatalogUtils.isLimitedCollectible(v70) else nil
			u66 = if not v40 then nil else CatalogUtils.IsResellable(v70)
		end
	end)()

	local v71 = useAppPolicy(function(p13) -- line: 176
		return p13.getWebViewSupport()
	end)
	local v72 = React.useCallback(function(p14) -- line: 180
		-- upvalues: collectibleItemId (ref)
		if collectibleItemId then
			return p14.AvatarExperience.Common.Collectibles.CollectiblesItemInfo[collectibleItemId]
		end

		return nil
	end, { collectibleItemId })
	local v73 = useSelector(v72)

	if useAppPolicy(function(p15) -- line: 187
		return p15.getDisableResellingCollectiblesForCompliance()
	end) and v73 then
		v73.resaleRestriction = CatalogConstants.ResaleRestriction.Disabled
	end

	local v74 = React.useCallback(function(p16) -- line: 195
		-- upvalues: v40 (copy), u66 (ref), u65 (ref), collectibleItemId (ref)
		if not if not v40 then u65 else u66 then
			return nil
		end

		if collectibleItemId then
			return p16.AvatarExperience.Common.Collectibles.CollectiblesResellableInstances[collectibleItemId]
		end

		return nil
	end, {
		collectibleItemId,
		if not v40 then u65 else u66
	})
	local v75 = if v35 then nil else useSelector(v74, getUseSelectorDeepEquals())
	local v76 = useSelector(function(p17) -- line: 210
		return p17.UserRobux[p17.LocalUserId]
	end, getUseSelectorDeepEquals())
	local v77 = useSelector(function(p18) -- line: 214
		-- upvalues: collectibleItemId (ref), v40 (copy), u66 (ref), u65 (ref), u64 (ref)
		if collectibleItemId then
			if not if not v40 then u65 else u66 then
				return nil
			end

			local v137 = p18.AvatarExperience.Common.Collectibles.CollectiblesResellersInstances[collectibleItemId]
			local v138 = v137 and (#v137.InstanceIdsList > 0 and v137.InstanceIdsList[1])
			local v139 = if not v138 then nil else v137.Instances[v138]

			if v139 then
				return v139.price
			end

			return nil
		end

		if u64 then
			local v140 = p18.AvatarExperience.Catalog.UserAssets[u64]

			if v140 then
				return v140.priceInRobux
			end

			return nil
		end

		return nil
	end, getUseSelectorDeepEquals())
	local v78 = useDispatch()
	local v79 = useNavigation()
	local v80 = useRoactService(RoactNetworking)
	local v81 = if not EnableCommunityProfilePageIXP.FFlagIsSetupEnabled then nil else EnableCommunityProfilePageIXP.useIsFeatureActive({
		isExposureEnabled = false
	})
	local v82 = React.useCallback(function() -- line: 246
		-- upvalues: u67 (ref), EnableCommunityProfilePageIXP (copy), u68 (ref), CatalogConstants (copy), v81 (copy), AppPage (copy), ProfileTypes (copy), FFlagSignalsNavP3Dispatch (copy), v29 (copy), v78 (copy), NavigateDown (copy), UrlBuilder (copy), v37 (copy), v79 (copy)
		if u67 then
			if EnableCommunityProfilePageIXP.FFlagIsSetupEnabled and u68 == CatalogConstants.CreatorType.Group then
				EnableCommunityProfilePageIXP.logExposure()
			end

			if EnableCommunityProfilePageIXP.FFlagIsSetupEnabled and v81 then
				if u68 == CatalogConstants.CreatorType.Group then
					local t2 = {
						name = AppPage.ProfilePlatform,
						detail = u67,
						extraProps = {
							source = "ItemDetailsPage",
							profileType = ProfileTypes.Community
						}
					}

					if FFlagSignalsNavP3Dispatch then
						v29.down(v29.fromLegacyPage(t2))

						return
					end

					v78(NavigateDown(t2))

					return
				end

				if u68 == CatalogConstants.CreatorType.User then
					local t3 = {
						name = AppPage.ProfilePlatform,
						detail = u67,
						extraProps = {
							source = "ItemDetailsPage",
							profileType = ProfileTypes.User
						}
					}

					if FFlagSignalsNavP3Dispatch then
						v29.down(v29.fromLegacyPage(t3))

						return
					end

					v78(NavigateDown(t3))

					return
				end

				local t4 = {
					name = AppPage.GenericWebPage,
					detail = UrlBuilder.user.profile({
						userId = u67
					}),
					extraProps = {
						titleKey = "CommonUI.Features.Label.Profile"
					}
				}

				if FFlagSignalsNavP3Dispatch then
					v29.down(v29.fromLegacyPage(t4))

					return
				end

				v78(NavigateDown(t4))

				return
			end

			local v144 = if u68 ~= CatalogConstants.CreatorType.Group then UrlBuilder.user.profile({
				userId = u67
			}) else UrlBuilder.user.group({
				groupId = u67
			})

			if v37 then
				local t5 = {
					name = AppPage.GenericWebPage,
					detail = v144,
					extraProps = {
						titleKey = "CommonUI.Features.Label.Profile"
					}
				}

				if FFlagSignalsNavP3Dispatch then
					v29.down(v29.fromLegacyPage(t5))

					return
				end

				v78(NavigateDown(t5))

				return
			end

			v79.navigate(AppPage.GenericWebPage, {
				detail = v144,
				extraProps = {
					titleKey = "CommonUI.Features.Label.Profile"
				}
			})
		end
	end, {
		u67,
		u68,
		if not EnableCommunityProfilePageIXP.FFlagIsSetupEnabled then nil else v81
	})
	local v83 = React.useCallback(function() -- line: 333
		-- upvalues: v79 (copy), AvatarScreen (copy), t1 (copy), collectibleItemId (ref)
		v79.navigate(AvatarScreen.ResellersPage, {
			itemId = t1.itemId,
			collectibleItemId = collectibleItemId,
			itemType = t1.itemType,
			fromContentFeed = v79.getParam("fromContentFeed"),
			fromProfile = v79.getParam("fromProfile")
		})
	end, {
		v79,
		t1.itemId,
		v70,
		t1.itemType,
		v79.getParam("fromContentFeed"),
		v79.getParam("fromProfile")
	})
	local v84 = nil
	local v85 = nil

	if t1.itemType == Constants.ItemType.Asset then
		local v86 = Constants.AssetTypeIdToCategory[u69]

		v84 = Constants.AssetCategoriesLocalized[v86]
		v85 = Constants.AssetTypeLocalized[u69]
	end

	local v87 = if not v70 then nil else getTaxonomyName(v70.taxonomy)
	local v88 = if not u69 then nil else getEquipSlotForAssetType(t1.itemType, u69)
	local v89 = useRoactService(RoactLocalization)
	local v90 = not v77 and "" or NumberLocalization.localize(v77, v89:GetLocale())
	local v91 = useLocalization({
		bundle = "Feature.Catalog.Label.Bundle",
		yesText = "Feature.Catalog.Label.Yes",
		noText = "Feature.Catalog.Label.No",
		isPBR = "Feature.Catalog.Label.PBR.true",
		notPBR = "Feature.Catalog.Label.PBR.false",
		noneText = "Feature.Catalog.Label.None",
		category = v84,
		subType = v85,
		threeDays = if not FFlagAXDurables2Option then nil else {
			"Feature.Durables.ItemDetails.WearTimeOptions.Button.XDays",
			num = 3
		},
		fromResalePrice = {
			"Feature.Catalog.Label.FromPrice",
			itemPrice = CatalogConstants.RobloxEmoji.Robux .. v90
		},
		priceUnavailableText = if not FFlagAXFixCollectibleOriginalPrice then nil else "Feature.Catalog.Label.NA",
		placementCategory = if not v88 then nil else v88.categoryKey,
		placementSlot = if not v88 then nil else v88.slotKey
	})
	local u92 = nil

	if v88 then
		if v91.placementCategory and v91.placementSlot then
			u92 = `{ v91.placementCategory } | { v91.placementSlot }`
		elseif v91.placementCategory then
			u92 = v91.placementCategory
		end
	end

	local u93 = if not v87 then if t1.itemType ~= Constants.ItemType.Asset or (not v91.category or not v91.subType) then t1.itemType ~= Constants.ItemType.Bundle and "" or v91.bundle else `{ v91.category } | { v91.subType }` else v87
	local isTradable = nil
	local hasAttribution = nil
	local shouldShowQuantityLimit = nil
	local reachedQuantityLimit = nil
	local hasResellers = nil
	local isStockAvailable = nil
	local soldCount = nil
	local itemStock = nil
	local originalPrice = nil
	local averagePrice = nil
	local quantityLimit = nil
	local collectiblesResaleRestriction = nil
	local u106 = false
	local u107 = nil
	local isPBR = nil;

	(function() -- line: 422
		-- upvalues: v35 (copy), useItemDataDigest (copy), t1 (copy), u66 (ref), isTradable (ref), hasAttribution (ref), shouldShowQuantityLimit (ref), reachedQuantityLimit (ref), hasResellers (ref), soldCount (ref), itemStock (ref), originalPrice (ref), averagePrice (ref), quantityLimit (ref), isStockAvailable (ref), collectiblesResaleRestriction (ref), u107 (ref), FFlagAXAddHDRowInItemDetailsPage (copy), isPBR (ref), v40 (copy), CatalogUtils (copy), v70 (copy), v73 (copy), CatalogConstants (copy), FFlagAXFixCollectibleOriginalPrice (copy), v75 (copy), collectibleItemId (ref), u106 (ref)
		if v35 then
			local v146 = useItemDataDigest(t1.itemId, t1.itemType)

			u66 = v146.isResellable
			isTradable = v146.isTradable
			hasAttribution = v146.hasAttribution
			shouldShowQuantityLimit = v146.shouldShowQuantityLimit
			reachedQuantityLimit = v146.reachedQuantityLimit
			hasResellers = v146.hasResellers
			soldCount = v146.soldCount
			itemStock = v146.itemStock
			originalPrice = v146.originalPrice
			averagePrice = v146.averagePrice
			quantityLimit = v146.quantityLimit
			isStockAvailable = v146.isStockAvailable
			collectiblesResaleRestriction = v146.collectiblesResaleRestriction
			u107 = if not FFlagAXAddHDRowInItemDetailsPage then nil else v146.isHighDefinition
			isPBR = v146.isPBR
		else
			if not v40 then
				u66 = CatalogUtils.IsResellable(v70)
			end

			isTradable = CatalogUtils.getIsTradable(v70)
			hasAttribution = CatalogUtils.HasAttribution(v70)
			quantityLimit = 0
			shouldShowQuantityLimit = false
			reachedQuantityLimit = false
			hasResellers = not not v70 and (not not v70.resellerUserAssetIds and #v70.resellerUserAssetIds > 0)
			soldCount = (not v70 or not v70.soldCount) and 0 or v70.soldCount
			itemStock = (not v70 or not v70.totalQuantity) and 0 or v70.totalQuantity
			originalPrice = (not v70 or not v70.originalPrice) and 0 or v70.originalPrice
			averagePrice = (not v70 or not v70.averagePrice) and 0 or v70.averagePrice
			u107 = if not FFlagAXAddHDRowInItemDetailsPage or not v70 then nil else v70.isHighDefinition
			isPBR = if not v70 then nil else v70.isPBR

			if v73 then
				collectiblesResaleRestriction = if not v73.resaleRestriction then CatalogConstants.ResaleRestriction.None else v73.resaleRestriction
				hasResellers = not not v73.hasResellers and v73.hasResellers

				local v147 = v73.assetStock or 0
				local v148 = v73.unitsAvailableForConsumption or 0

				soldCount = (not v147 or not v148) and 0 or v147 - v148
				originalPrice = if not FFlagAXFixCollectibleOriginalPrice then v73.price or 0 else v73.price
				averagePrice = v73.recentAveragePrice or 0
				itemStock = v73.assetStock or 0
				quantityLimit = v73.quantityLimitPerUser or 0
				reachedQuantityLimit = CatalogUtils.reachQuantityLimit(v73, v75)
				shouldShowQuantityLimit = CatalogUtils.shouldShowQuantityLimit(quantityLimit)
			end

			isStockAvailable = soldCount < itemStock
			isStockAvailable = isStockAvailable and CatalogUtils.isOriginalStockSellableInShop(v73)
		end

		if u66 and v70 and not collectibleItemId then
			u106 = true
		end
	end)()

	if t1.outfitInfo then
		hasAttribution = t1.outfitInfo.creatingUniverseId ~= nil
	end

	local v109 = soldCount
	local v110 = if v109 then NumberLocalization.localize(v109, v89:GetLocale()) else nil
	local v111 = itemStock
	local v112 = if v111 then NumberLocalization.localize(v111, v89:GetLocale()) else nil
	local v113 = originalPrice
	local v114 = if v113 then NumberLocalization.localize(v113, v89:GetLocale()) else nil
	local v115 = if not v73 then if not v70 or not v70.product then nil else v70.product.id else v73.collectibleProductId
	local v116 = if not v73 then if not v70 then nil else v70.creator else v73.creator
	local v117 = React.useCallback(function() -- line: 496
		-- upvalues: v116 (copy), v79 (copy), originalPrice (ref), v76 (copy), AvatarScreen (copy), t1 (copy), v115 (copy)
		local v149 = if not v116 then nil else v116.id
		local v150 = if not v116 then nil else v116.name
		local v151 = v79.getParam("fromContentFeed")
		local v152 = v79.getParam("fromProfile")

		if originalPrice and (v76 and v76 >= originalPrice) then
			v79.navigate(AvatarScreen.PurchaseCatalogItem, {
				userAssetId = nil,
				collectibleInstanceId = nil,
				itemId = t1.itemId,
				itemType = t1.itemType,
				productId = v115,
				priceInRobux = originalPrice,
				sellerId = v149,
				sellerName = v150,
				fromProfile = v152,
				fromContentFeed = v151
			})

			return
		end

		v79.navigate(AvatarScreen.InsufficientRobuxPrompt, {})
	end, {
		v115,
		v116,
		v73,
		v79,
		t1.itemId,
		t1.itemType,
		originalPrice
	})

	React.useEffect(function() -- line: 520
		-- upvalues: u106 (ref), v78 (copy), FetchAssetResaleData (copy), v80 (copy), t1 (copy), Constants (copy), FetchAssetVersionData (copy)
		if u106 then
			v78(FetchAssetResaleData(v80, t1.itemId))
		end

		if t1.itemType == Constants.ItemType.Asset then
			v78(FetchAssetVersionData(v80, t1.itemId))
		end
	end, {
		u106,
		v80,
		t1.itemId
	})

	local outfitInfo = t1.outfitInfo
	local v119 = if not outfitInfo then if not v70 then nil else v70.creatingUniverseId else outfitInfo.creatingUniverseId
	local v120 = getGameJoinContext(t1.itemType, t1.itemId, u69, t1.outfitInfo)
	local name

	if v116 then
		name = v116.name
	elseif v119 then
		local LocalPlayer = Players.LocalPlayer

		name = LocalPlayer and LocalPlayer.Name or ""
	else
		name = ""
	end

	local v123 = name
	local v124 = if not v71 or not u67 then nil else v82
	local v125 = (function() -- line: 543
		-- upvalues: v123 (copy), v124 (copy), v116 (copy), FFlagAXDurables2Option (copy), v70 (copy), v91 (copy), hasAttribution (ref), v119 (copy), v120 (copy), t1 (copy), u66 (ref), u93 (ref), v87 (copy), u92 (ref), FFlagAXAddHDRowInItemDetailsPage (copy), u107 (ref), isPBR (ref), isTradable (ref), shouldShowQuantityLimit (ref), quantityLimit (ref), collectiblesResaleRestriction (ref), CatalogConstants (copy), hasResellers (ref), v77 (copy), v83 (copy), averagePrice (ref), itemStock (ref), v110 (copy), v112 (copy), v114 (copy), FFlagAXFixCollectibleOriginalPrice (copy), isStockAvailable (ref), reachedQuantityLimit (ref), v117 (copy), FFlagDynamicHeadsMigration (copy)
		local t6 = {}

		table.insert(t6, {
			key = "Creator",
			infoName = "Feature.Catalog.Label.Filter.Creator",
			LayoutOrder = 2,
			infoData = v123,
			onActivate = v124,
			hasVerifiedBadge = not not v116 and v116.hasVerifiedBadge
		})

		if FFlagAXDurables2Option and (v70 and v70.timedOptions) then
			table.insert(t6, {
				key = "RentOption",
				infoName = "Feature.Catalog.Label.RentOption",
				infoNameDetails = "Feature.Catalog.Label.RentOptionInfo",
				LayoutOrder = 2,
				infoData = v91.threeDays
			})
		end

		if hasAttribution then
			table.insert(t6, {
				key = "Attribution",
				isAttribution = true,
				infoName = "Feature.Catalog.Label.Attribution",
				LayoutOrder = 3,
				creatingUniverseId = v119,
				gameJoinContext = v120,
				attributionRef = t1.attributionRef,
				NextSelectionUp = if not u66 then t1.NextSelectionUp else t1.resellerRef,
				NextSelectionDown = t1.NextSelectionDown
			})
		end

		if u93 and u93 ~= "" then
			table.insert(t6, {
				key = "CategoryType",
				infoName = "Feature.Catalog.Label.CategoryType",
				LayoutOrder = 4,
				infoData = u93,
				infoNameDetails = if not v87 then nil else "Feature.Catalog.Message.PriceCouldBeDifferent"
			})
		end

		if u92 then
			table.insert(t6, {
				key = "Placement",
				infoName = "Feature.Catalog.Label.Placement",
				LayoutOrder = 5,
				infoData = u92
			})
		end

		if FFlagAXAddHDRowInItemDetailsPage and u107 then
			table.insert(t6, {
				key = "HighDefinition",
				infoName = "Feature.Catalog.Label.HD",
				infoNameDetails = "Feature.Catalog.Label.HighDefinitionInfo",
				LayoutOrder = 6,
				infoData = v91.yesText
			})
		end

		if isPBR ~= nil then
			table.insert(t6, {
				key = "PBR",
				infoName = "Feature.Catalog.Label.PBR",
				infoNameDetails = "Feature.Catalog.Label.PBRInfo",
				infoData = if not isPBR then v91.notPBR else v91.isPBR,
				LayoutOrder = (not FFlagAXAddHDRowInItemDetailsPage and 0 or 1) + 6
			})
		end

		if isTradable ~= nil then
			table.insert(t6, {
				key = "Tradeability",
				infoName = "Feature.Catalog.Label.Tradable",
				infoData = if not isTradable then v91.noText else v91.yesText,
				LayoutOrder = (not FFlagAXAddHDRowInItemDetailsPage and 0 or 1) + 7
			})
		end

		if shouldShowQuantityLimit then
			table.insert(t6, {
				key = "QuantityLimit",
				infoName = "Feature.Catalog.Label.MaxPerUser",
				infoData = quantityLimit,
				LayoutOrder = (not FFlagAXAddHDRowInItemDetailsPage and 0 or 1) + 9
			})
		end

		if u66 then
			if collectiblesResaleRestriction == CatalogConstants.ResaleRestriction.Disabled then
				table.insert(t6, {
					key = "Resellability",
					infoName = "Feature.Catalog.Label.Resellable",
					infoData = v91.noText,
					LayoutOrder = (not FFlagAXAddHDRowInItemDetailsPage and 0 or 1) + 8
				})
			else
				table.insert(t6, {
					key = "Sellers",
					infoName = "Feature.Catalog.Heading.Resellers",
					TextScaled = true,
					LayoutOrder = 1,
					infoData = if hasResellers then not v77 and "" or v91.fromResalePrice else v91.noneText,
					onActivate = if not hasResellers then nil else v83,
					ref = t1.resellerRef,
					NextSelectionUp = t1.NextSelectionUp,
					NextSelectionDown = if not hasAttribution then t1.NextSelectionDown else t1.attributionRef
				})
				table.insert(t6, {
					key = "AveragePrice",
					infoName = "Feature.Catalog.Label.AveragePrice",
					infoData = tostring(averagePrice),
					LayoutOrder = (not FFlagAXAddHDRowInItemDetailsPage and 0 or 1) + 12
				})
			end

			table.insert(t6, {
				key = "SoldCount",
				infoName = "Feature.Catalog.Label.QuantitySold",
				TextScaled = true,
				infoData = if itemStock ~= 0 then `{ v110 }/{ v112 }` else v110,
				LayoutOrder = (not FFlagAXAddHDRowInItemDetailsPage and 0 or 1) + 10
			})

			local v154 = not v114 and "" or CatalogConstants.RobloxEmoji.Robux .. v114

			if FFlagAXFixCollectibleOriginalPrice then
				v154 = if not v114 then v91.priceUnavailableText else CatalogConstants.RobloxEmoji.Robux .. v114
			end

			table.insert(t6, {
				key = "Price",
				infoName = collectiblesResaleRestriction ~= CatalogConstants.ResaleRestriction.Disabled and "Feature.Catalog.Label.OriginalPrice" or "Feature.Catalog.Label.Price",
				infoData = v154,
				onActivate = if not isStockAvailable or reachedQuantityLimit then nil else v117,
				LayoutOrder = if not isStockAvailable and collectiblesResaleRestriction ~= CatalogConstants.ResaleRestriction.Disabled then (not FFlagAXAddHDRowInItemDetailsPage and 0 or 1) + 11 else 0
			})
		end

		table.sort(t6, function(p19, p20) -- line: 704
			return p19.LayoutOrder < p20.LayoutOrder
		end)

		if FFlagDynamicHeadsMigration and #t6 > 0 then
			t6[#t6].hideDivider = true
		end

		return t6
	end)()
	local t7 = {
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder
		})
	}

	for _, v128 in v125 do
		t7[v128.key] = React.createElement(if not v128.isAttribution then ItemInfoRow else AttributionItemInfoRow, v128)
	end

	return React.createElement(Focusable.Frame, {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = t1.LayoutOrder
	}, t7)
end))
