local CorePackages = game:GetService("CorePackages")

local UIBlox = require(CorePackages.Packages.UIBlox)
local images = UIBlox.App.ImageSet.Images
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local numberLocalization = require("@game/CorePackages/Workspace/Packages/Localization").NumberLocalization
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").useAppPolicy
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local tutils = require(CorePackages.Packages.tutils)

local module3 = require("@luauforge/bundled/dAB")
local module4 = require("@luauforge/bundled/dVl")
local module5 = require("@luauforge/deferred/fCu")
local module6 = require("@luauforge/bundled/fDf")
local module7 = require("@luauforge/bundled/dzE")
local module8 = require("@luauforge/bundled/eie")
local module9 = require("@luauforge/bundled/egY")
local module10 = require("@luauforge/bundled/dPU")
local module11 = require("@luauforge/bundled/egx")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals
local getTryOnItemReducerKey = AvatarExperienceCommon.Utils.getTryOnItemReducerKey
local itemData = AvatarExperienceCommon.State.Selectors.ItemData
local useShouldFetchCartPricingForPurchasePrompt = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog").Hooks.useShouldFetchCartPricingForPurchasePrompt

local module13 = require("@luauforge/deferred/fDu")
local module14 = require("@luauforge/deferred/fDv")
local module15 = require("@luauforge/deferred/fDw")
local module16 = require("@luauforge/deferred/fDx")

local fFlagAXShowFaeUpsell = AvatarExperienceFlags.FFlagAXShowFaeUpsell
local fFlagAXDurables2Option = AvatarExperienceFlags.FFlagAXDurables2Option
local fFlagPurchasePromptSubtitleForTimedOptions = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagPurchasePromptSubtitleForTimedOptions
local iconsmenuavatar_on = images["icons/menu/avatar_on"]
local iconscommonrobux = images["icons/common/robux"]
local iconsactionsblock = images["icons/actions/block"]

local function selectUserRobux(p2)
	local localUserId = p2.LocalUserId
	return p2.UserRobux[localUserId]
end

local function useLocalizedPrice(p2)
	local v5 = p2 and string.format("%.0f", p2)
	local v6 = module8(module9)

	if p2 then
		return (numberLocalization.localize(v5, v6:GetLocale()))
	end

	return nil
end

local function selectCollectibleItemInfo(p2, p3)
	local collectiblesItemInfo = p2.AvatarExperience.Common.Collectibles.CollectiblesItemInfo

	if p3 then
		return collectiblesItemInfo[p3]
	end

	return nil
end

local function selectIsLoadingState(data, p2, p3)
	if not p2 then
		return true
	end

	local v5 = itemData(data.AvatarExperience.Common, p2, p3)
	local collectibleItemId = if v5 then v5.collectibleItemId else nil
	local collectiblesItemInfo = data.AvatarExperience.Common.Collectibles.CollectiblesItemInfo
	local v6 = if collectibleItemId then collectiblesItemInfo[collectibleItemId] else nil

	local v7 = not (collectibleItemId == nil) and collectibleItemId ~= ""
	local status = performFetch.GetStatus(data, module4.GetItemDetailsKey(p2, p3))

	local receivedCatalogData = v5 and v5.receivedCatalogData

	local v8 = (status == module3.Fetching or status == module3.NotStarted) and not receivedCatalogData
	local localUserId = data.LocalUserId
	local v10 = data.UserRobux[localUserId]
	local v11

	if collectibleItemId then
		v11 = performFetch.GetStatus(
			data,
			module10.FetchCollectibleResellableInstancesKey .. tostring(collectibleItemId)
		)
	end

	local v12 = if v11 then v11 == module3.Fetching or v11 == module3.NotStarted else nil

	return v8 or v7 and not v6 or v12 or v10 == nil
end

local function selectBuyActionBarStateWithItemIdAndType(p2, p3, p4, p5, p6)
	local v5 = itemData(p2.AvatarExperience.Common, p3, p4)
	local collectibleItemId = if v5 then v5.collectibleItemId else nil
	local collectiblesItemInfo = p2.AvatarExperience.Common.Collectibles.CollectiblesItemInfo
	local v6 = if collectibleItemId then collectiblesItemInfo[collectibleItemId] else nil

	local collectiblesResellableInstance = p2.AvatarExperience.Common.Collectibles.CollectiblesResellableInstances[collectibleItemId]
	local v7 = not collectiblesResellableInstance and 0 or tutils.fieldCount(collectiblesResellableInstance)

	local v8 = selectIsLoadingState(p2, p3, p4)

	if not fFlagAXShowFaeUpsell then
		p6 = nil
	end

	local v11 = module14(v5, v6, v7, v8, not (p5 and collectibleItemId), p6)

	local assetType = if fFlagAXShowFaeUpsell and v5 then v5.assetType or v5.bundleType else nil

	local v12 = if fFlagAXShowFaeUpsell and p3 then p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems[getTryOnItemReducerKey(p3, p4)] ~= nil else nil

	return {
		itemData = v5,
		buttonType = v11,
		collectibleItemInfo = v6,
		localUserId = p2.LocalUserId,
		itemSubType = assetType,
		isItemToggledOn = v12
	}
end

local function useBuyActionBarButtonProps(p2, p3, p4, p5, p6, p7, p8)
	local v5 = useDispatch()
	local v6 = module8(module11)

	local v7, v8 = useAppPolicy(function(p9)
		return p9.getDisableIAPEntryPoint(), p9.getDisableResellingCollectiblesForCompliance()
	end)

	local function fn(p9)
		local v13 = if fFlagAXShowFaeUpsell then p8 else nil
		return selectBuyActionBarStateWithItemIdAndType(p9, p3, p4, v8, v13)
	end

	local v12 = useSelector(React.useCallback(fn, {
		p3,
		p4,
		v8,
		if fFlagAXShowFaeUpsell then p8 else nil
	}), getUseSelectorDeepEquals())
	local buttonType = v12.buttonType
	local itemData2 = v12.itemData
	local v13

	if itemData2 then
		if buttonType == module13.PurchaseFromResale then
			v13 = itemData2.lowestResalePrice
		else
			v13 = itemData2.priceInRobux
		end
	else
		v13 = 0
	end

	local v14 = v13 and string.format("%.0f", v13)
	local v15 = module8(module9)
	local v16 = if v13 then numberLocalization.localize(v14, v15:GetLocale()) else nil

	local v17 = useAvatarRoute()
	local v18 = useNavigation()
	local v19 = module8(module6)
	local v20 = useLocalization({
		freeText = "Feature.Catalog.LabelFree",
		unlockButtonText = fFlagAXShowFaeUpsell and "Feature.MarketplaceFAEUpsell.ActionBar.PrimaryButton.Text" or nil,
		soldOut = "Feature.Catalog.Label.SoldOut",
		fromResale = "Feature.Catalog.Label.PriceFromResale",
		inMultipleExperiences = "Feature.Catalog.Label.InMultipleExperiences",
		inSingleExperience = "Feature.Catalog.Label.InSingleExperience",
		purchaseNotAvailableOnHeadSet = "IAPExperience.RobuxUpsell.Text.PurchaseNotAvailableOnHeadSet",
		buyButtonTextForRentalItem = "Feature.Durables.BottomBar.BuyButton",
		buyButtonWithTimedOptionDays = {
			"Feature.Durables.ItemDetails.BottomBar.BuyButton.Days",
			num = p5
		},
		buyButtonWithTimedOptionPermanent = "Feature.Durables.ItemDetails.BottomBar.BuyButton.Permanent"
	})

	local v21 = useTokens()

	local v22 = fFlagPurchasePromptSubtitleForTimedOptions and (not fFlagAXDurables2Option or p5) and {
		componentName = "TIMED_OPTIONS_SUBTITLE",
		props = { timedOptionDays = p5 }
	} or nil

	local v23 = useShouldFetchCartPricingForPurchasePrompt(itemData2)

	local function fn2()
		return v5(module5(
			v6,
			v19,
			p2,
			v18,
			v17,
			p3,
			p4,
			v7,
			{
				toastMessage = v20.purchaseNotAvailableOnHeadSet,
				isLocalized = true,
				toastType = module7.InformationMessage
			},
			p5,
			if fFlagPurchasePromptSubtitleForTimedOptions then v22 else nil,
			v23
		))
	end

	local v26 = React.useCallback(fn2, {
		v20,
		v6,
		v19,
		p2,
		v18,
		v17,
		p3,
		p4,
		v7,
		p5,
		if fFlagPurchasePromptSubtitleForTimedOptions then v22 else nil,
		v23,
		v5
	})

	local collectibleItemInfo = v12.collectibleItemInfo

	local v27 = React.useCallback(function()
		v18.navigate(avatarScreen.ItemExperiencesMenu, {
			collectibleData = collectibleItemInfo,
			isLimited = module4.isLimitedCollectible(itemData2)
		})
	end, { v18, collectibleItemInfo })

	local itemSubType = v12.itemSubType
	local isItemToggledOn = v12.isItemToggledOn
	local v28

	if fFlagAXShowFaeUpsell then
		local v30 = if itemData2 then itemData2.name else nil
		v28 = module16(p3, p4, itemSubType, isItemToggledOn, v30)
	else
		v28 = nil
	end

	local v29 = module15(collectibleItemInfo)
	local useMemo = React.useMemo
	local function fn3()
		if buttonType == module13.Loading then
			return {
				buttonActionType = if fFlagAXDurables2Option then buttonType else nil,
				buttonText = "",
				buttonIcon = nil,
				buttonIconPadding = 0,
				buttonIconSize = 0,
				buttonIsDisabled = true,
				buttonIsLoading = true,
				buttonColor = v21.Color.ActionEmphasis.Background.Color3,
				buttonTextColor = v21.Color.ActionEmphasis.Foreground.Color3,
				onActivated = function() end
			}
		elseif buttonType == module13.ExperienceLink then
			local v30 = {
				buttonActionType = if fFlagAXDurables2Option then buttonType else nil,
				buttonText = 0,
				buttonIcon = nil,
				buttonIconPadding = 0,
				buttonIconSize = 0,
				buttonIsDisabled = false,
				buttonIsLoading = false,
				buttonColor = 0,
				buttonTextColor = 0,
				onActivated = 0
			}

			local v32 = if v29 > 1 then v20.inMultipleExperiences:gsub("{NUM_EXPERIENCES}", v29) else v20.inSingleExperience
			v30.buttonText = v32

			v30.buttonColor = v21.Color.ActionSubEmphasis.Background.Color3
			v30.buttonTextColor = v21.Color.ActionSubEmphasis.Foreground.Color3
			v30.onActivated = v27
			return v30
		elseif buttonType == module13.SoldOut then
			return {
				buttonActionType = if fFlagAXDurables2Option then buttonType else nil,
				buttonText = v20.soldOut,
				buttonIcon = nil,
				buttonIconPadding = 0,
				buttonIconSize = 0,
				buttonIsDisabled = true,
				buttonIsLoading = false,
				buttonColor = v21.Color.ActionEmphasis.Background.Color3,
				buttonTextColor = v21.Color.ActionEmphasis.Foreground.Color3,
				onActivated = function() end
			}
		elseif buttonType == module13.CustomizeLink then
			local v30 = {
				buttonActionType = buttonType,
				buttonIsDisabled = v17.opaque.name == avatarScreen.AvatarEditor,
				buttonText = "",
				buttonIcon = iconsmenuavatar_on,
				buttonIconPadding = v21.Gap.XSmall,
				buttonIconSize = v21.Size.Size_500,
				buttonIsLoading = false,
				buttonColor = 0,
				buttonTextColor = 0,
				onActivated = 0
			}

			local v31 = if v17.opaque.name == avatarScreen.AvatarEditor then v21.Color.ActionSubEmphasis.Background.Color3 else v21.Color.ActionEmphasis.Background.Color3
			v30.buttonColor = v31

			v30.buttonTextColor = v21.Color.ActionEmphasis.Foreground.Color3
			v30.onActivated = v17.opaque.name == avatarScreen.AvatarEditor and function() end or v26
			return v30
		elseif fFlagAXShowFaeUpsell and buttonType == module13.UnlockableItem then
			local v30 = if p8 and p8.showFaeUpsell then v28 elseif p8 and p8.canClaimFaeItem then v26 else nil

			local v31 = {
				buttonActionType = if fFlagAXDurables2Option then buttonType else nil,
				buttonText = 0,
				buttonIcon = nil,
				buttonIconPadding = 0,
				buttonIconSize = 0,
				buttonIsDisabled = false,
				buttonIsLoading = false,
				buttonColor = 0,
				buttonTextColor = 0,
				onActivated = 0
			}

			local v33 = if p8 and p8.showFaeUpsell then v20.unlockButtonText else v20.freeText
			v31.buttonText = v33

			v31.buttonColor = v21.Color.ActionEmphasis.Background.Color3
			v31.buttonTextColor = v21.Color.ActionEmphasis.Foreground.Color3
			v31.onActivated = v30 or function() end
			return v31
		elseif buttonType == module13.PurchaseFromRoblox then
			local v30

			if p7 then
				v30 = if p5 then v20.buyButtonWithTimedOptionDays else v20.buyButtonWithTimedOptionPermanent
			else
				v30 = if p5 or p6 then v20.buyButtonTextForRentalItem else v16
			end

			local v31 = {
				buttonActionType = if fFlagAXDurables2Option then buttonType else nil,
				buttonIsDisabled = false,
				buttonText = v30,
				buttonIcon = nil,
				buttonIconPadding = 0,
				buttonIconSize = 0,
				buttonIsLoading = false,
				buttonColor = 0,
				buttonTextColor = 0,
				onActivated = 0
			}
			local v33 = if not (p5 or p6) then iconscommonrobux else nil
			v31.buttonIcon = v33
			v31.buttonIconPadding = v21.Gap.XSmall
			v31.buttonIconSize = v21.Size.Size_500

			v31.buttonColor = v21.Color.ActionEmphasis.Background.Color3
			v31.buttonTextColor = v21.Color.ActionEmphasis.Foreground.Color3
			v31.onActivated = v26
			return v31
		elseif buttonType == module13.Free then
			return {
				buttonActionType = if fFlagAXDurables2Option then buttonType else nil,
				buttonText = v20.freeText,
				buttonIcon = nil,
				buttonIconPadding = 0,
				buttonIconSize = 0,
				buttonIsDisabled = false,
				buttonIsLoading = false,
				buttonColor = v21.Color.ActionEmphasis.Background.Color3,
				buttonTextColor = v21.Color.ActionEmphasis.Foreground.Color3,
				onActivated = v26
			}
		else
			if buttonType ~= module13.PurchaseFromResale then
				return {
					buttonIsDisabled = true,
					buttonText = "",
					buttonIcon = iconsactionsblock,
					buttonIconPadding = v21.Gap.XSmall,
					buttonIconSize = v21.Size.Size_500,
					buttonIsLoading = false,
					buttonColor = v21.Color.ActionSubEmphasis.Background.Color3,
					buttonTextColor = v21.Color.ActionSubEmphasis.Foreground.Color3,
					onActivated = function() end
				}
			end

			return {
				buttonActionType = if fFlagAXDurables2Option then buttonType else nil,
				buttonText = string.gsub(v20.fromResale, "{itemPrice}", v16),
				buttonIsDisabled = false,
				buttonIcon = iconscommonrobux,
				buttonIconPadding = v21.Gap.XSmall,
				buttonIconSize = v21.Size.Size_500,
				buttonIsLoading = false,
				buttonColor = v21.Color.ActionEmphasis.Background.Color3,
				buttonTextColor = v21.Color.ActionEmphasis.Foreground.Color3,
				onActivated = v26
			}
		end
	end

	local v31 = if fFlagAXShowFaeUpsell then v28 else nil
	return useMemo(fn3, {
		buttonType,
		v21,
		v26,
		v20,
		v16,
		v27,
		v29,
		v31,
		if fFlagAXShowFaeUpsell then p8 else nil
	})
end

return useBuyActionBarButtonProps
