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
local profileTypes = require("@luauforge/bundled/ehC").ProfileTypes

local module2 = require("@luauforge/bundled/fIU")

local module3 = require("@luauforge/deferred/gPc")
local ItemInfoRow = require("@game/CorePackages/Workspace/Packages/_Workspace/ItemDetails/ItemDetails/ItemInfoRow")
local module5 = require("@luauforge/deferred/gPg")
local module6 = require("@luauforge/bundled/dPU")
local module7 = require("@luauforge/bundled/dPN")
local module8 = require("@luauforge/bundled/dVl")

local module9 = require("@luauforge/deferred/gPh")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local module10 = require("@luauforge/deferred/gPk")
local module11 = require("@luauforge/deferred/gPl")
require("@luauforge/bundled/dQF")

local module12 = require("@luauforge/bundled/fzK")
local module13 = require("@luauforge/bundled/dFu")
local module14 = require("@luauforge/bundled/ehB")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dFz").NavigationCommands
else
	navigationCommands = nil
end

local module15 = require("@luauforge/bundled/egx")
local module16 = require("@luauforge/bundled/egY")
local module17 = require("@luauforge/bundled/gxM")
local module18 = require("@luauforge/bundled/eie")
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useAppPolicy")
local defineFastFlag = game:DefineFastFlag("UseItemDataHookRefactor", false)
require("@luauforge/bundled/dPs")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals
local itemData = AvatarExperienceCommon.State.Selectors.ItemData

local fFlagFixNavigationToCreatorProfileWebviewFromProfile = AvatarExperienceFlags.FFlagFixNavigationToCreatorProfileWebviewFromProfile

local fFlagAXAddHDRowInItemDetailsPage = AvatarExperienceFlags.FFlagAXAddHDRowInItemDetailsPage
local module21 = require("@luauforge/deferred/gPm")
local defineFastFlag2 = game:DefineFastFlag("AXFixMissingResalePrice", false)
local fFlagAXDurables2Option = AvatarExperienceFlags.FFlagAXDurables2Option
local fFlagAXMarketplaceLicensingItemDetails = AvatarExperienceFlags.FFlagAXMarketplaceLicensingItemDetails
local module22 = require("@luauforge/deferred/gPn")
local module23 = require("@luauforge/deferred/gPo")

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

	local v14 = useSelector((React.useCallback(function(p3)
		if collectibleItemId then
			return p3.AvatarExperience.Common.Collectibles.CollectiblesItemInfo[collectibleItemId]
		end

		return nil
	end, { collectibleItemId })))

	if useAppPolicy(function(p3)
		return p3.getDisableResellingCollectiblesForCompliance()
	end) and v14 then
		v14.resaleRestriction = module6.ResaleRestriction.Disabled
	end

	local useCallback = React.useCallback
	local function fn(p3)
		local v15 = if defineFastFlag2 then v7 else v6

		if not v15 then
			return nil
		end

		if collectibleItemId then
			return p3.AvatarExperience.Common.Collectibles.CollectiblesResellableInstances[collectibleItemId]
		end

		return nil
	end

	local v17 = if defineFastFlag2 then v7 else v6
	local v18 = useCallback(fn, { collectibleItemId, v17 })

	local v19 = if not defineFastFlag then useSelector(v18, getUseSelectorDeepEquals()) else nil

	local v20 = useSelector(function(p3)
		return p3.UserRobux[p3.LocalUserId]
	end, getUseSelectorDeepEquals())

	local v21 = useSelector(function(p3)
		if collectibleItemId then
			local v22 = if defineFastFlag2 then v7 else v6

			if not v22 then
				return nil
			end

			local collectiblesResellersInstance = p3.AvatarExperience.Common.Collectibles.CollectiblesResellersInstances[collectibleItemId]
			local v23

			if collectiblesResellersInstance then
				if #collectiblesResellersInstance.InstanceIdsList > 0 then
					v23 = collectiblesResellersInstance.InstanceIdsList[1]
				else
					v23 = false
				end
			else
				v23 = collectiblesResellersInstance
			end

			local v24 = if v23 then collectiblesResellersInstance.Instances[v23] else nil

			if v24 then
				return v24.price
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

	local v22 = useDispatch()
	local v23 = useNavigation()
	local v24 = module18(module15)
	local v25

	if module2.FFlagIsSetupEnabled then
		v25 = module2.useIsFeatureActive({ isExposureEnabled = false })
	else
		v25 = nil
	end

	local useCallback2 = React.useCallback
	local function fn2()
		if v8 then
			if module2.FFlagIsSetupEnabled and v9 == module6.CreatorType.Group then
				module2.logExposure()
			end

			if module2.FFlagIsSetupEnabled and v25 then
				if v9 == module6.CreatorType.Group then
					local v26 = {
						name = module13.ProfilePlatform,
						detail = v8,
						extraProps = {
							profileType = profileTypes.Community,
							source = "ItemDetailsPage"
						}
					}

					if fFlagSignalsNavP3Dispatch then
						navigationCommands.down(navigationCommands.fromLegacyPage(v26))
					else
						v22(module14(v26))
					end
				elseif v9 == module6.CreatorType.User then
					local v26 = {
						name = module13.ProfilePlatform,
						detail = v8,
						extraProps = {
							profileType = profileTypes.User,
							source = "ItemDetailsPage"
						}
					}

					if fFlagSignalsNavP3Dispatch then
						navigationCommands.down(navigationCommands.fromLegacyPage(v26))
					else
						v22(module14(v26))
					end
				else
					local v26 = {
						name = module13.GenericWebPage,
						detail = module12.user.profile({ userId = v8 }),
						extraProps = { titleKey = "CommonUI.Features.Label.Profile" }
					}

					if fFlagSignalsNavP3Dispatch then
						navigationCommands.down(navigationCommands.fromLegacyPage(v26))
					else
						v22(module14(v26))
					end
				end
			else
				local v26

				if v9 == module6.CreatorType.Group then
					v26 = module12.user.group({ groupId = v8 })
				else
					v26 = module12.user.profile({ userId = v8 })
				end

				if fFlagFixNavigationToCreatorProfileWebviewFromProfile then
					local v27 = {
						name = module13.GenericWebPage,
						detail = v26,
						extraProps = { titleKey = "CommonUI.Features.Label.Profile" }
					}

					if fFlagSignalsNavP3Dispatch then
						navigationCommands.down(navigationCommands.fromLegacyPage(v27))
					else
						v22(module14(v27))
					end
				else
					v23.navigate(module13.GenericWebPage, {
						detail = v26,
						extraProps = { titleKey = "CommonUI.Features.Label.Profile" }
					})
				end
			end
		end
	end
	local v27 = v8
	local v28 = v9
	local v29 = if module2.FFlagIsSetupEnabled then v25 else nil
	local v30 = useCallback2(fn2, { v27, v28, v29 })

	local v31 = React.useCallback(function()
		v23.navigate(avatarScreen.ResellersPage, {
			itemId = props.itemId,
			collectibleItemId = collectibleItemId,
			itemType = props.itemType,
			fromContentFeed = v23.getParam("fromContentFeed"),
			fromProfile = v23.getParam("fromProfile")
		})
	end, {
		v23,
		props.itemId,
		v11,
		props.itemType,
		v23.getParam("fromContentFeed"),
		v23.getParam("fromProfile")
	})
	local v32, v33

	if props.itemType == module7.ItemType.Asset then
		local category = module7.AssetTypeIdToCategory[v10]
		v32 = module7.AssetCategoriesLocalized[category]
		v33 = module7.AssetTypeLocalized[v10]
	end

	local v34 = if v11 then module22(v11.taxonomy) else nil

	local v35 = if v10 then module23(props.itemType, v10) else nil

	local v36 = module18(module16)

	local v37 = not v21 and "" or numberLocalization.localize(v21, v36:GetLocale())

	local v39 = {
		bundle = "Feature.Catalog.Label.Bundle",
		category = v32,
		subType = v33,
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
			itemPrice = module6.RobloxEmoji.Robux .. v37
		},
		priceUnavailableText = module21 and "Feature.Catalog.Label.NA" or nil,
		placementCategory = 0,
		placementSlot = 0
	}

	local v40 = if v35 then v35.categoryKey else nil
	v39.placementCategory = v40
	local v41 = if v35 then v35.slotKey else nil
	v39.placementSlot = v41
	local v42 = module17(v39)

	local v43 = nil

	if v35 then
		if v42.placementCategory and v42.placementSlot then
			v43 = `{v42.placementCategory} | {v42.placementSlot}`
		elseif v42.placementCategory then
			v43 = v42.placementCategory
		end
	end

	local v44

	if v34 then
		v44 = v34
	elseif props.itemType == module7.ItemType.Asset and v42.category and v42.subType then
		v44 = `{v42.category} | {v42.subType}`
	else
		v44 = props.itemType ~= module7.ItemType.Bundle and "" or v42.bundle
	end

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
	local v56 = nil
	local flag = false
	local v57 = nil
	local v58 = nil

	(function()
		if defineFastFlag then
			local v59 = module5(props.itemId, props.itemType)
			v7 = v59.isResellable
			v45 = v59.isTradable
			v46 = v59.hasAttribution
			v47 = v59.shouldShowQuantityLimit
			v48 = v59.reachedQuantityLimit
			v49 = v59.hasResellers
			v51 = v59.soldCount
			v52 = v59.itemStock
			v53 = v59.originalPrice
			v54 = v59.averagePrice
			v55 = v59.quantityLimit
			v50 = v59.isStockAvailable
			v56 = v59.collectiblesResaleRestriction
			v57 = if fFlagAXAddHDRowInItemDetailsPage then v59.isHighDefinition else nil
			v58 = v59.renderProperties
		else
			if not defineFastFlag2 then
				v7 = module8.IsResellable(v11)
			end

			v45 = module8.getIsTradable(v11)
			v46 = module8.HasAttribution(v11)
			v55 = 0
			v47 = false
			v48 = false
			v49 = if v11 and v11.resellerUserAssetIds then #v11.resellerUserAssetIds > 0 else false

			v51 = not (v11 and v11.soldCount) and 0 or v11.soldCount
			v52 = not (v11 and v11.totalQuantity) and 0 or v11.totalQuantity
			v53 = not (v11 and v11.originalPrice) and 0 or v11.originalPrice
			v54 = not (v11 and v11.averagePrice) and 0 or v11.averagePrice
			v57 = if fFlagAXAddHDRowInItemDetailsPage and v11 then v11.isHighDefinition else nil
			v58 = if v11 then v11.renderProperties else nil

			if v14 then
				v56 = if v14.resaleRestriction then v14.resaleRestriction else module6.ResaleRestriction.None
				v49 = if v14.hasResellers then v14.hasResellers else false
				local assetStock = v14.assetStock or 0
				local unitsAvailableForConsumption = v14.unitsAvailableForConsumption or 0
				v51 = not (assetStock and unitsAvailableForConsumption) and 0
					or assetStock - unitsAvailableForConsumption

				v53 = if module21 then v14.price else v14.price or 0
				v54 = v14.recentAveragePrice or 0
				v52 = v14.assetStock or 0
				v55 = v14.quantityLimitPerUser or 0
				v48 = module8.reachQuantityLimit(v14, v19)
				v47 = module8.shouldShowQuantityLimit(v55)
			end

			v50 = v51 < v52
			v50 = v50 and module8.isOriginalStockSellableInShop(v14)
		end

		if v7 and v11 and not collectibleItemId then
			flag = true
		end
	end)()

	if props.outfitInfo then
		v46 = not (props.outfitInfo.creatingUniverseId == nil)
	end

	local v59 = v51
	local v60 = if v59 then numberLocalization.localize(v59, v36:GetLocale()) else nil

	local v61 = v52
	local v62 = if v61 then numberLocalization.localize(v61, v36:GetLocale()) else nil

	local v63 = v53
	local v64 = if v63 then numberLocalization.localize(v63, v36:GetLocale()) else nil
	local v65

	if v14 then
		v65 = v14.collectibleProductId
	else
		v65 = if v11 and v11.product then v11.product.id else nil
	end

	local creator = if v14 then v14.creator elseif v11 then v11.creator else nil

	local v66 = React.useCallback(function()
		local id = if creator then creator.id else nil
		local name = if creator then creator.name else nil
		local param = v23.getParam("fromContentFeed")
		local param2 = v23.getParam("fromProfile")

		if v53 and v20 and v53 <= v20 then
			v23.navigate(avatarScreen.PurchaseCatalogItem, {
				itemId = props.itemId,
				itemType = props.itemType,
				productId = v65,
				priceInRobux = v53,
				sellerId = id,
				sellerName = name,
				userAssetId = nil,
				collectibleInstanceId = nil,
				fromProfile = param2,
				fromContentFeed = param
			})
		else
			v23.navigate(avatarScreen.InsufficientRobuxPrompt, {})
		end
	end, { v65, creator, v14, v23, props.itemId, props.itemType, v53 })

	React.useEffect(function()
		if flag then
			v22(module10(v24, props.itemId))
		end

		if props.itemType == module7.ItemType.Asset then
			v22(module11(v24, props.itemId))
		end
	end, { flag, v24, props.itemId })

	local outfitInfo = props.outfitInfo
	local creatingUniverseId

	if outfitInfo then
		creatingUniverseId = outfitInfo.creatingUniverseId
	else
		creatingUniverseId = if v11 then v11.creatingUniverseId else nil
	end

	local itemType = props.itemType
	local itemId = props.itemId
	local v68 = v10
	local v69 = module9(itemType, itemId, v68, props.outfitInfo)
	local v70

	if creator then
		v70 = creator.name
	elseif creatingUniverseId then
		local localPlayer = Players.LocalPlayer
		v70 = localPlayer and localPlayer.Name or ""
	else
		v70 = ""
	end

	if not (v12 and v8) then
		v30 = nil
	end

	local v71 = (function()
		local v72 = {}

		if fFlagAXMarketplaceLicensingItemDetails then
			local itemLicensingInfo = if v11 then v11.itemLicensingInfo else nil

			if itemLicensingInfo and itemLicensingInfo.licenseDisplayName then
				table.insert(v72, {
					key = "LicensedBy",
					infoName = "Feature.Catalog.Label.LicensedBy",
					infoData = itemLicensingInfo.licenseDisplayName,
					LayoutOrder = -1
				})
			end
		end

		local v73 = {
			key = "Creator",
			infoName = "Feature.Catalog.Label.Filter.Creator",
			infoData = v70,
			onActivate = v30,
			hasVerifiedBadge = 0,
			LayoutOrder = 2
		}

		local v74 = if creator then creator.hasVerifiedBadge else false
		v73.hasVerifiedBadge = v74
		table.insert(v72, v73)

		if fFlagAXDurables2Option and v11 and v11.timedOptions then
			table.insert(v72, {
				key = "RentOption",
				infoName = "Feature.Catalog.Label.RentOption",
				infoData = v42.threeDays,
				infoNameDetails = "Feature.Catalog.Label.RentOptionInfo",
				LayoutOrder = 2
			})
		end

		if v46 then
			local v75 = {
				key = "Attribution",
				isAttribution = true,
				infoName = "Feature.Catalog.Label.Attribution",
				creatingUniverseId = creatingUniverseId,
				gameJoinContext = v69,
				LayoutOrder = 3,
				attributionRef = props.attributionRef,
				NextSelectionUp = 0,
				NextSelectionDown = 0
			}
			local v76 = if v7 then props.resellerRef else props.NextSelectionUp
			v75.NextSelectionUp = v76
			v75.NextSelectionDown = props.NextSelectionDown
			table.insert(v72, v75)
		end

		if v44 and v44 ~= "" then
			table.insert(v72, {
				key = "CategoryType",
				infoName = "Feature.Catalog.Label.CategoryType",
				infoData = v44,
				infoNameDetails = v34 and "Feature.Catalog.Message.PriceCouldBeDifferent" or nil,
				LayoutOrder = 4
			})
		end

		if v43 then
			table.insert(v72, {
				key = "Placement",
				infoName = "Feature.Catalog.Label.Placement",
				infoData = v43,
				LayoutOrder = 5
			})
		end

		if fFlagAXAddHDRowInItemDetailsPage and v57 then
			table.insert(v72, {
				key = "HighDefinition",
				infoName = "Feature.Catalog.Label.HD",
				infoData = v42.yesText,
				infoNameDetails = "Feature.Catalog.Label.HighDefinitionInfo",
				LayoutOrder = 6
			})
		end

		local flag2 = false
		local flag3 = false

		if v58 then
			for k, v75 in v58 do
				local v76 = string.lower((tostring(v75)))

				if v76 == "pbr" or v76 == "advancedmaterials" then
					flag2 = true
				elseif v76 == "emissive" then
					flag3 = true
				end
			end
		end

		local v75 = {}
		local v76 = {}

		if flag2 then
			table.insert(v75, v42.labelAdvancedMaterials)
			table.insert(v76, {
				heading = "Feature.Catalog.Label.AdvancedMaterials",
				body = "Feature.Catalog.Label.PBRInfo"
			})
		end

		if flag3 then
			table.insert(v75, v42.labelEmissive)
			table.insert(v76, {
				heading = "Feature.Catalog.Label.Emissive",
				body = "Feature.Catalog.Label.EmissiveInfo"
			})
		end

		local v77 = if #v75 > 0 then table.concat(v75, v42.attributesListSeparator) else v42.notPBR

		if v58 ~= nil then
			local v78 = {
				key = "Attributes",
				infoName = "Feature.Catalog.Label.Attributes",
				infoData = v77,
				LayoutOrder = (fFlagAXAddHDRowInItemDetailsPage and 1 or 0) + 6,
				infoNameDetailsTitle = #v76 > 0 and "Feature.Catalog.Label.Attributes" or nil,
				infoNameDetailsSections = 0,
				wrapInfoData = true
			}

			if not (#v76 > 0) then
				v76 = nil
			end

			v78.infoNameDetailsSections = v76
			table.insert(v72, v78)
		end

		if v45 ~= nil then
			local v79 = if v45 then v42.yesText else v42.noText
			local v78 = {
				key = "Tradeability",
				infoName = "Feature.Catalog.Label.Tradable",
				infoData = v79,
				LayoutOrder = (fFlagAXAddHDRowInItemDetailsPage and 1 or 0) + 7
			}
			table.insert(v72, v78)
		end

		if v47 then
			table.insert(v72, {
				key = "QuantityLimit",
				infoName = "Feature.Catalog.Label.MaxPerUser",
				infoData = v55,
				LayoutOrder = (fFlagAXAddHDRowInItemDetailsPage and 1 or 0) + 9
			})
		end

		if v7 then
			if v56 == module6.ResaleRestriction.Disabled then
				table.insert(v72, {
					key = "Resellability",
					infoName = "Feature.Catalog.Label.Resellable",
					infoData = v42.noText,
					LayoutOrder = (fFlagAXAddHDRowInItemDetailsPage and 1 or 0) + 8
				})
			else
				local v79 = if v49 then not v21 and "" or v42.fromResalePrice else v42.noneText
				local v78 = {
					key = "Sellers",
					infoName = "Feature.Catalog.Heading.Resellers",
					infoData = v79,
					onActivate = if v49 then v31 else nil,
					TextScaled = true,
					LayoutOrder = 1,
					ref = props.resellerRef,
					NextSelectionUp = props.NextSelectionUp,
					NextSelectionDown = 0
				}
				local v81 = if v46 then props.attributionRef else props.NextSelectionDown
				v78.NextSelectionDown = v81
				table.insert(v72, v78)

				table.insert(v72, {
					key = "AveragePrice",
					infoName = "Feature.Catalog.Label.AveragePrice",
					infoData = tostring(v54),
					LayoutOrder = (fFlagAXAddHDRowInItemDetailsPage and 1 or 0) + 12
				})
			end

			local v79 = if v52 == 0 then v60 else `{v60}/{v62}`
			local v78 = {
				key = "SoldCount",
				infoName = "Feature.Catalog.Label.QuantitySold",
				infoData = v79,
				TextScaled = true,
				LayoutOrder = (fFlagAXAddHDRowInItemDetailsPage and 1 or 0) + 10
			}
			table.insert(v72, v78)

			local v80 = not v64 and "" or module6.RobloxEmoji.Robux .. v64

			if module21 then
				v80 = if v64 then module6.RobloxEmoji.Robux .. v64 else v42.priceUnavailableText
			end

			local v81 = {
				key = "Price",
				infoName = v56 == module6.ResaleRestriction.Disabled and "Feature.Catalog.Label.Price" or "Feature.Catalog.Label.OriginalPrice",
				infoData = v80,
				onActivate = 0,
				LayoutOrder = 0
			}
			local v82 = if v50 and not v48 then v66 else nil
			v81.onActivate = v82
			v81.LayoutOrder = (v50 or v56 == module6.ResaleRestriction.Disabled) and 0
				or (fFlagAXAddHDRowInItemDetailsPage and 1 or 0) + 11
			table.insert(v72, v81)
		end

		table.sort(v72, function(a, b): boolean
			return a.LayoutOrder < b.LayoutOrder
		end)

		if #v72 > 0 then
			v72[#v72].hideDivider = true
		end

		return v72
	end)()

	local children = {
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder
		})
	}

	for k, v72 in v71 do
		local key = v72.key
		local createElement = React.createElement
		local v73 = if v72.isAttribution then module3 else ItemInfoRow
		children[key] = createElement(v73, v72)
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
