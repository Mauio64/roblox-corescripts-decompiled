local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local numberLocalization = require("@game/CorePackages/Workspace/Packages/Localization").NumberLocalization
local profileTypes = require("@luauforge/bundled/eef").ProfileTypes

local module2 = require("@luauforge/bundled/fWW")

local module3 = require("@luauforge/deferred/gkw")
local ItemInfoRow = require("@game/CorePackages/Workspace/Packages/_Workspace/ItemDetails/ItemDetails/ItemInfoRow")
local module5 = require("@luauforge/deferred/gkA")
local module6 = require("@luauforge/bundled/dME")
local module7 = require("@luauforge/bundled/dMx")
local module8 = require("@luauforge/bundled/dRQ")

local module9 = require("@luauforge/deferred/gkB")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local module10 = require("@luauforge/deferred/gkE")
local module11 = require("@luauforge/deferred/gkF")
require("@luauforge/bundled/dNp")

local module12 = require("@luauforge/bundled/fsq")
local module13 = require("@luauforge/bundled/dCp")
local module14 = require("@luauforge/bundled/eee")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dCu").NavigationCommands
else
	navigationCommands = nil
end

local module15 = require("@luauforge/bundled/eda")
local module16 = require("@luauforge/bundled/edB")
local module17 = require("@luauforge/bundled/fTi")
local module18 = require("@luauforge/bundled/eeH")
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useAppPolicy")
local defineFastFlag = game:DefineFastFlag("UseItemDataHookRefactor", false)
require("@luauforge/bundled/dMc")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals
local itemData = AvatarExperienceCommon.State.Selectors.ItemData

local fFlagFixNavigationToCreatorProfileWebviewFromProfile = AvatarExperienceFlags.FFlagFixNavigationToCreatorProfileWebviewFromProfile

local fFlagAXAddHDRowInItemDetailsPage = AvatarExperienceFlags.FFlagAXAddHDRowInItemDetailsPage
local module21 = require("@luauforge/deferred/gkG")
local defineFastFlag2 = game:DefineFastFlag("AXFixMissingResalePrice", false)
local fFlagAXDurables2Option = AvatarExperienceFlags.FFlagAXDurables2Option
local fFlagAXMarketplaceLicensingItemDetails = AvatarExperienceFlags.FFlagAXMarketplaceLicensingItemDetails
local module22 = require("@luauforge/deferred/gkH")
local module23 = require("@luauforge/deferred/gkI")

local function getNumberLocalization(p2, object)
	if p2 then
		return numberLocalization.localize(p2, object:GetLocale())
	end

	return nil
end

local function getProductIdAndCreator(p2, p3)
	local v5 = if p2 then p2.collectibleProductId elseif p3 and p3.product then p3.product.id else nil

	if p2 then
		return v5, p2.creator
	end

	if p3 then
		return v5, p3.creator
	end

	return v5, nil
end

local function getCreatingUniverseId(p2, p3)
	if p3 then
		return p3.creatingUniverseId
	end

	if p2 then
		return p2.creatingUniverseId
	end

	return nil
end

local function getLocalPlayerName()
	local localPlayer = Players.LocalPlayer
	return localPlayer and localPlayer.Name or ""
end

return (React.forwardRef(function(props, p2)
	local collectibleItemId = nil
	local v5 = nil
	local v6 = nil
	local v7 = nil

	local v8 = nil
	local v9 = nil
	local v10 = nil

	local v11 = useSelector(function(p3)
		return itemData(p3.AvatarExperience.Common, props.itemId, props.itemType)
	end, getUseSelectorDeepEquals());

	(function()
		if v11 then
			collectibleItemId = v11.collectibleItemId
			local v12 = v11.resellerUserAssetIds

			if v12 then
				v12 = #v12 > 0 and v12[1]
			end

			v5 = v12
			v8 = if v11.creator then v11.creator.id else nil
			v9 = if v11.creator then v11.creator.type else nil
			v10 = module8.GetItemSubType(props.itemType, v11)
			v6 = if not defineFastFlag2 then module8.isLimitedCollectible(v11) else nil
			v7 = if defineFastFlag2 then module8.IsResellable(v11) else nil
		end
	end)()

	local v12 = useAppPolicy(function(p3)
		return p3.getWebViewSupport()
	end)

	local v13 = useSelector((React.useCallback(function(p3)
		if collectibleItemId then
			return p3.AvatarExperience.Common.Collectibles.CollectiblesItemInfo[collectibleItemId]
		end

		return nil
	end, { collectibleItemId })))

	if useAppPolicy(function(p3)
		return p3.getDisableResellingCollectiblesForCompliance()
	end) and v13 then
		v13.resaleRestriction = module6.ResaleRestriction.Disabled
	end

	local useCallback = React.useCallback
	local function fn(p3)
		local v14 = if defineFastFlag2 then v7 else v6

		if not v14 then
			return nil
		end

		if collectibleItemId then
			return p3.AvatarExperience.Common.Collectibles.CollectiblesResellableInstances[collectibleItemId]
		end

		return nil
	end

	local v16 = if defineFastFlag2 then v7 else v6
	local v17 = useCallback(fn, { collectibleItemId, v16 })

	local v18 = if not defineFastFlag then useSelector(v17, getUseSelectorDeepEquals()) else nil

	local v19 = useSelector(function(p3)
		return p3.UserRobux[p3.LocalUserId]
	end, getUseSelectorDeepEquals())

	local v20 = useSelector(function(p3)
		if collectibleItemId then
			local v21 = if defineFastFlag2 then v7 else v6

			if not v21 then
				return nil
			end

			local collectiblesResellersInstance = p3.AvatarExperience.Common.Collectibles.CollectiblesResellersInstances[collectibleItemId]
			local v22

			if collectiblesResellersInstance then
				if #collectiblesResellersInstance.InstanceIdsList > 0 then
					v22 = collectiblesResellersInstance.InstanceIdsList[1]
				else
					v22 = false
				end
			else
				v22 = collectiblesResellersInstance
			end

			local v23 = if v22 then collectiblesResellersInstance.Instances[v22] else nil

			if v23 then
				return v23.price
			end

			return nil
		else
			if not v5 then
				return nil
			end

			local userAsset = p3.AvatarExperience.Catalog.UserAssets[v5]

			if userAsset then
				return userAsset.priceInRobux
			end

			return nil
		end
	end, getUseSelectorDeepEquals())

	local v21 = useDispatch()
	local v22 = useNavigation()
	local v23 = module18(module15)
	local v24

	if module2.FFlagIsSetupEnabled then
		v24 = module2.useIsFeatureActive({ isExposureEnabled = false })
	else
		v24 = nil
	end

	local useCallback2 = React.useCallback
	local function fn2()
		if v8 then
			if module2.FFlagIsSetupEnabled and v9 == module6.CreatorType.Group then
				module2.logExposure()
			end

			if module2.FFlagIsSetupEnabled and v24 then
				if v9 == module6.CreatorType.Group then
					local v25 = {
						name = module13.ProfilePlatform,
						detail = v8,
						extraProps = {
							profileType = profileTypes.Community,
							source = "ItemDetailsPage"
						}
					}

					if fFlagSignalsNavP3Dispatch then
						navigationCommands.down(navigationCommands.fromLegacyPage(v25))
					else
						v21(module14(v25))
					end
				elseif v9 == module6.CreatorType.User then
					local v25 = {
						name = module13.ProfilePlatform,
						detail = v8,
						extraProps = {
							profileType = profileTypes.User,
							source = "ItemDetailsPage"
						}
					}

					if fFlagSignalsNavP3Dispatch then
						navigationCommands.down(navigationCommands.fromLegacyPage(v25))
					else
						v21(module14(v25))
					end
				else
					local v25 = {
						name = module13.GenericWebPage,
						detail = module12.user.profile({ userId = v8 }),
						extraProps = { titleKey = "CommonUI.Features.Label.Profile" }
					}

					if fFlagSignalsNavP3Dispatch then
						navigationCommands.down(navigationCommands.fromLegacyPage(v25))
					else
						v21(module14(v25))
					end
				end
			else
				local v25

				if v9 == module6.CreatorType.Group then
					v25 = module12.user.group({ groupId = v8 })
				else
					v25 = module12.user.profile({ userId = v8 })
				end

				if fFlagFixNavigationToCreatorProfileWebviewFromProfile then
					local v26 = {
						name = module13.GenericWebPage,
						detail = v25,
						extraProps = { titleKey = "CommonUI.Features.Label.Profile" }
					}

					if fFlagSignalsNavP3Dispatch then
						navigationCommands.down(navigationCommands.fromLegacyPage(v26))
					else
						v21(module14(v26))
					end
				else
					v22.navigate(module13.GenericWebPage, {
						detail = v25,
						extraProps = { titleKey = "CommonUI.Features.Label.Profile" }
					})
				end
			end
		end
	end
	local v26 = v8
	local v27 = v9
	local v28 = if module2.FFlagIsSetupEnabled then v24 else nil
	local v29 = useCallback2(fn2, { v26, v27, v28 })

	local v30 = React.useCallback(function()
		v22.navigate(avatarScreen.ResellersPage, {
			itemId = props.itemId,
			collectibleItemId = collectibleItemId,
			itemType = props.itemType,
			fromContentFeed = v22.getParam("fromContentFeed"),
			fromProfile = v22.getParam("fromProfile")
		})
	end, {
		v22,
		props.itemId,
		v11,
		props.itemType,
		v22.getParam("fromContentFeed"),
		v22.getParam("fromProfile")
	})
	local v31, v32

	if props.itemType == module7.ItemType.Asset then
		local category = module7.AssetTypeIdToCategory[v10]
		v31 = module7.AssetCategoriesLocalized[category]
		v32 = module7.AssetTypeLocalized[v10]
	end

	local v33 = if v11 then module22(v11.taxonomy) else nil

	local v34 = if v10 then module23(props.itemType, v10) else nil

	local v35 = module18(module16)

	local v36 = not v20 and "" or numberLocalization.localize(v20, v35:GetLocale())

	local v38 = {
		bundle = "Feature.Catalog.Label.Bundle",
		category = v31,
		subType = v32,
		yesText = "Feature.Catalog.Label.Yes",
		noText = "Feature.Catalog.Label.No",
		notPBR = "Feature.Catalog.Label.PBR.false",
		labelAdvancedMaterials = "Feature.Catalog.Label.AdvancedMaterials",
		labelEmissive = "Feature.Catalog.Label.Emissive",
		attributesListSeparator = "Feature.GameDetails.Label.FriendsSeparator",
		threeDays = fFlagAXDurables2Option and {
			"Feature.Durables.ItemDetails.WearTimeOptions.Button.XDays",
			num = 3
		} or nil,
		noneText = "Feature.Catalog.Label.None",
		fromResalePrice = {
			"Feature.Catalog.Label.FromPrice",
			itemPrice = module6.RobloxEmoji.Robux .. v36
		},
		priceUnavailableText = module21 and "Feature.Catalog.Label.NA" or nil,
		placementCategory = 0,
		placementSlot = 0
	}

	local v39 = if v34 then v34.categoryKey else nil
	v38.placementCategory = v39
	local v40 = if v34 then v34.slotKey else nil
	v38.placementSlot = v40
	local v41 = module17(v38)

	local v42 = nil

	if v34 then
		if v41.placementCategory and v41.placementSlot then
			v42 = `{v41.placementCategory} | {v41.placementSlot}`
		elseif v41.placementCategory then
			v42 = v41.placementCategory
		end
	end

	local v43

	if v33 then
		v43 = v33
	elseif props.itemType == module7.ItemType.Asset and v41.category and v41.subType then
		v43 = `{v41.category} | {v41.subType}`
	else
		v43 = props.itemType ~= module7.ItemType.Bundle and "" or v41.bundle
	end

	local v44 = nil
	local v45 = nil
	local v46 = nil
	local v47 = nil
	local v48 = nil
	local v49 = nil
	local v50 = nil
	local v51 = nil
	local v52 = nil
	local v53 = nil
	local v54 = nil
	local v55 = nil
	local flag = false
	local v56 = nil
	local v57 = nil

	(function()
		if defineFastFlag then
			local v58 = module5(props.itemId, props.itemType)
			v7 = v58.isResellable
			v44 = v58.isTradable
			v45 = v58.hasAttribution
			v46 = v58.shouldShowQuantityLimit
			v47 = v58.reachedQuantityLimit
			v48 = v58.hasResellers
			v50 = v58.soldCount
			v51 = v58.itemStock
			v52 = v58.originalPrice
			v53 = v58.averagePrice
			v54 = v58.quantityLimit
			v49 = v58.isStockAvailable
			v55 = v58.collectiblesResaleRestriction
			v56 = if fFlagAXAddHDRowInItemDetailsPage then v58.isHighDefinition else nil
			v57 = v58.renderProperties
		else
			if not defineFastFlag2 then
				v7 = module8.IsResellable(v11)
			end

			v44 = module8.getIsTradable(v11)
			v45 = module8.HasAttribution(v11)
			v54 = 0
			v46 = false
			v47 = false
			v48 = if v11 and v11.resellerUserAssetIds then #v11.resellerUserAssetIds > 0 else false

			v50 = not (v11 and v11.soldCount) and 0 or v11.soldCount
			v51 = not (v11 and v11.totalQuantity) and 0 or v11.totalQuantity
			v52 = not (v11 and v11.originalPrice) and 0 or v11.originalPrice
			v53 = not (v11 and v11.averagePrice) and 0 or v11.averagePrice
			v56 = if fFlagAXAddHDRowInItemDetailsPage and v11 then v11.isHighDefinition else nil
			v57 = if v11 then v11.renderProperties else nil

			if v13 then
				v55 = if v13.resaleRestriction then v13.resaleRestriction else module6.ResaleRestriction.None
				v48 = if v13.hasResellers then v13.hasResellers else false
				local assetStock = v13.assetStock or 0
				local unitsAvailableForConsumption = v13.unitsAvailableForConsumption or 0
				v50 = not (assetStock and unitsAvailableForConsumption) and 0
					or assetStock - unitsAvailableForConsumption

				v52 = if module21 then v13.price else v13.price or 0
				v53 = v13.recentAveragePrice or 0
				v51 = v13.assetStock or 0
				v54 = v13.quantityLimitPerUser or 0
				v47 = module8.reachQuantityLimit(v13, v18)
				v46 = module8.shouldShowQuantityLimit(v54)
			end

			v49 = v50 < v51
			v49 = v49 and module8.isOriginalStockSellableInShop(v13)
		end

		if v7 and v11 and not collectibleItemId then
			flag = true
		end
	end)()

	if props.outfitInfo then
		v45 = not (props.outfitInfo.creatingUniverseId == nil)
	end

	local v58 = v50
	local v59 = if v58 then numberLocalization.localize(v58, v35:GetLocale()) else nil

	local v60 = v51
	local v61 = if v60 then numberLocalization.localize(v60, v35:GetLocale()) else nil

	local v62 = v52
	local v63 = if v62 then numberLocalization.localize(v62, v35:GetLocale()) else nil
	local v64

	if v13 then
		v64 = v13.collectibleProductId
	else
		v64 = if v11 and v11.product then v11.product.id else nil
	end

	local creator = if v13 then v13.creator elseif v11 then v11.creator else nil

	local v65 = React.useCallback(function()
		local id = if creator then creator.id else nil
		local name = if creator then creator.name else nil
		local param = v22.getParam("fromContentFeed")
		local param2 = v22.getParam("fromProfile")

		if v52 and v19 and v52 <= v19 then
			v22.navigate(avatarScreen.PurchaseCatalogItem, {
				itemId = props.itemId,
				itemType = props.itemType,
				productId = v64,
				priceInRobux = v52,
				sellerId = id,
				sellerName = name,
				userAssetId = nil,
				collectibleInstanceId = nil,
				fromProfile = param2,
				fromContentFeed = param
			})
		else
			v22.navigate(avatarScreen.InsufficientRobuxPrompt, {})
		end
	end, { v64, creator, v13, v22, props.itemId, props.itemType, v52 })

	React.useEffect(function()
		if flag then
			v21(module10(v23, props.itemId))
		end

		if props.itemType == module7.ItemType.Asset then
			v21(module11(v23, props.itemId))
		end
	end, { flag, v23, props.itemId })

	local outfitInfo = props.outfitInfo
	local creatingUniverseId

	if outfitInfo then
		creatingUniverseId = outfitInfo.creatingUniverseId
	else
		creatingUniverseId = if v11 then v11.creatingUniverseId else nil
	end

	local itemType = props.itemType
	local itemId = props.itemId
	local v67 = v10
	local v68 = module9(itemType, itemId, v67, props.outfitInfo)
	local v69

	if creator then
		v69 = creator.name
	elseif creatingUniverseId then
		local localPlayer = Players.LocalPlayer
		v69 = localPlayer and localPlayer.Name or ""
	else
		v69 = ""
	end

	if not (v12 and v8) then
		v29 = nil
	end

	local v70 = (function()
		local v71 = {}

		if fFlagAXMarketplaceLicensingItemDetails then
			local itemLicensingInfo = if v11 then v11.itemLicensingInfo else nil

			if itemLicensingInfo and itemLicensingInfo.licenseDisplayName then
				table.insert(v71, {
					key = "LicensedBy",
					infoName = "Feature.Catalog.Label.LicensedBy",
					infoData = itemLicensingInfo.licenseDisplayName,
					LayoutOrder = -1
				})
			end
		end

		local v72 = {
			key = "Creator",
			infoName = "Feature.Catalog.Label.Filter.Creator",
			infoData = v69,
			onActivate = v29,
			hasVerifiedBadge = 0,
			LayoutOrder = 2
		}

		local v73 = if creator then creator.hasVerifiedBadge else false
		v72.hasVerifiedBadge = v73
		table.insert(v71, v72)

		if fFlagAXDurables2Option and v11 and v11.timedOptions then
			table.insert(v71, {
				key = "RentOption",
				infoName = "Feature.Catalog.Label.RentOption",
				infoData = v41.threeDays,
				infoNameDetails = "Feature.Catalog.Label.RentOptionInfo",
				LayoutOrder = 2
			})
		end

		if v45 then
			local v74 = {
				key = "Attribution",
				isAttribution = true,
				infoName = "Feature.Catalog.Label.Attribution",
				creatingUniverseId = creatingUniverseId,
				gameJoinContext = v68,
				LayoutOrder = 3,
				attributionRef = props.attributionRef,
				NextSelectionUp = 0,
				NextSelectionDown = 0
			}
			local v75 = if v7 then props.resellerRef else props.NextSelectionUp
			v74.NextSelectionUp = v75
			v74.NextSelectionDown = props.NextSelectionDown
			table.insert(v71, v74)
		end

		if v43 and v43 ~= "" then
			table.insert(v71, {
				key = "CategoryType",
				infoName = "Feature.Catalog.Label.CategoryType",
				infoData = v43,
				infoNameDetails = v33 and "Feature.Catalog.Message.PriceCouldBeDifferent" or nil,
				LayoutOrder = 4
			})
		end

		if v42 then
			table.insert(v71, {
				key = "Placement",
				infoName = "Feature.Catalog.Label.Placement",
				infoData = v42,
				LayoutOrder = 5
			})
		end

		if fFlagAXAddHDRowInItemDetailsPage and v56 then
			table.insert(v71, {
				key = "HighDefinition",
				infoName = "Feature.Catalog.Label.HD",
				infoData = v41.yesText,
				infoNameDetails = "Feature.Catalog.Label.HighDefinitionInfo",
				LayoutOrder = 6
			})
		end

		local flag2 = false
		local flag3 = false

		if v57 then
			for k, v74 in v57 do
				local v75 = string.lower((tostring(v74)))

				if v75 == "pbr" or v75 == "advancedmaterials" then
					flag2 = true
				elseif v75 == "emissive" then
					flag3 = true
				end
			end
		end

		local v74 = {}
		local v75 = {}

		if flag2 then
			table.insert(v74, v41.labelAdvancedMaterials)
			table.insert(v75, {
				heading = "Feature.Catalog.Label.AdvancedMaterials",
				body = "Feature.Catalog.Label.PBRInfo"
			})
		end

		if flag3 then
			table.insert(v74, v41.labelEmissive)
			table.insert(v75, {
				heading = "Feature.Catalog.Label.Emissive",
				body = "Feature.Catalog.Label.EmissiveInfo"
			})
		end

		local v76 = if #v74 > 0 then table.concat(v74, v41.attributesListSeparator) else v41.notPBR

		if v57 ~= nil then
			local v77 = {
				key = "Attributes",
				infoName = "Feature.Catalog.Label.Attributes",
				infoData = v76,
				LayoutOrder = (fFlagAXAddHDRowInItemDetailsPage and 1 or 0) + 6,
				infoNameDetailsTitle = #v75 > 0 and "Feature.Catalog.Label.Attributes" or nil,
				infoNameDetailsSections = 0,
				wrapInfoData = true
			}

			if not (#v75 > 0) then
				v75 = nil
			end

			v77.infoNameDetailsSections = v75
			table.insert(v71, v77)
		end

		if v44 ~= nil then
			local v78 = if v44 then v41.yesText else v41.noText
			local v77 = {
				key = "Tradeability",
				infoName = "Feature.Catalog.Label.Tradable",
				infoData = v78,
				LayoutOrder = (fFlagAXAddHDRowInItemDetailsPage and 1 or 0) + 7
			}
			table.insert(v71, v77)
		end

		if v46 then
			table.insert(v71, {
				key = "QuantityLimit",
				infoName = "Feature.Catalog.Label.MaxPerUser",
				infoData = v54,
				LayoutOrder = (fFlagAXAddHDRowInItemDetailsPage and 1 or 0) + 9
			})
		end

		if v7 then
			if v55 == module6.ResaleRestriction.Disabled then
				table.insert(v71, {
					key = "Resellability",
					infoName = "Feature.Catalog.Label.Resellable",
					infoData = v41.noText,
					LayoutOrder = (fFlagAXAddHDRowInItemDetailsPage and 1 or 0) + 8
				})
			else
				local v78 = if v48 then not v20 and "" or v41.fromResalePrice else v41.noneText
				local v77 = {
					key = "Sellers",
					infoName = "Feature.Catalog.Heading.Resellers",
					infoData = v78,
					onActivate = if v48 then v30 else nil,
					TextScaled = true,
					LayoutOrder = 1,
					ref = props.resellerRef,
					NextSelectionUp = props.NextSelectionUp,
					NextSelectionDown = 0
				}
				local v80 = if v45 then props.attributionRef else props.NextSelectionDown
				v77.NextSelectionDown = v80
				table.insert(v71, v77)

				table.insert(v71, {
					key = "AveragePrice",
					infoName = "Feature.Catalog.Label.AveragePrice",
					infoData = tostring(v53),
					LayoutOrder = (fFlagAXAddHDRowInItemDetailsPage and 1 or 0) + 12
				})
			end

			local v78 = if v51 == 0 then v59 else `{v59}/{v61}`
			local v77 = {
				key = "SoldCount",
				infoName = "Feature.Catalog.Label.QuantitySold",
				infoData = v78,
				TextScaled = true,
				LayoutOrder = (fFlagAXAddHDRowInItemDetailsPage and 1 or 0) + 10
			}
			table.insert(v71, v77)

			local v79 = not v63 and "" or module6.RobloxEmoji.Robux .. v63

			if module21 then
				v79 = if v63 then module6.RobloxEmoji.Robux .. v63 else v41.priceUnavailableText
			end

			local v80 = {
				key = "Price",
				infoName = v55 == module6.ResaleRestriction.Disabled and "Feature.Catalog.Label.Price" or "Feature.Catalog.Label.OriginalPrice",
				infoData = v79,
				onActivate = 0,
				LayoutOrder = 0
			}
			local v81 = if v49 and not v47 then v65 else nil
			v80.onActivate = v81
			v80.LayoutOrder = (v49 or v55 == module6.ResaleRestriction.Disabled) and 0
				or (fFlagAXAddHDRowInItemDetailsPage and 1 or 0) + 11
			table.insert(v71, v80)
		end

		table.sort(v71, function(a, b): boolean
			return a.LayoutOrder < b.LayoutOrder
		end)

		if #v71 > 0 then
			v71[#v71].hideDivider = true
		end

		return v71
	end)()

	local children = {
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder
		})
	}

	for k, v71 in v70 do
		local key = v71.key
		local createElement = React.createElement
		local v72 = if v71.isAttribution then module3 else ItemInfoRow
		children[key] = createElement(v72, v71)
	end

	return React.createElement(
		focusable.Frame,
		{
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			LayoutOrder = props.LayoutOrder
		},
		children
	)
end))
