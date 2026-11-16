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

local module3 = require("@luauforge/bundled/dxy")
local module4 = require("@luauforge/bundled/dRQ")
local module5 = require("@luauforge/deferred/fuT")
local module6 = require("@luauforge/bundled/fvF")
local module7 = require("@luauforge/bundled/dwB")
local module8 = require("@luauforge/bundled/eeH")
local module9 = require("@luauforge/bundled/edB")
local module10 = require("@luauforge/bundled/dME")
local module11 = require("@luauforge/bundled/eda")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals
local getTryOnItemReducerKey = AvatarExperienceCommon.Utils.getTryOnItemReducerKey
local itemData = AvatarExperienceCommon.State.Selectors.ItemData
local useShouldFetchCartPricingForPurchasePrompt = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog").Hooks.useShouldFetchCartPricingForPurchasePrompt

local module13 = require("@luauforge/deferred/fvU")
local module14 = require("@luauforge/deferred/fvV")
local module15 = require("@luauforge/deferred/fvW")
local module16 = require("@luauforge/deferred/fvX")

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

	local v11 = useSelector(React.useCallback(fn, {
		p3,
		p4,
		v8,
		if fFlagAXShowFaeUpsell then p8 else nil
	}), getUseSelectorDeepEquals())
	local buttonType = v11.buttonType
	local itemData2 = v11.itemData
	local v12

	if itemData2 then
		if buttonType == module13.PurchaseFromResale then
			v12 = itemData2.lowestResalePrice
		else
			v12 = itemData2.priceInRobux
		end
	else
		v12 = 0
	end

	local v13 = v12 and string.format("%.0f", v12)
	local v14 = module8(module9)
	local v15 = if v12 then numberLocalization.localize(v13, v14:GetLocale()) else nil

	local v16 = useAvatarRoute()
	local v17 = useNavigation()
	local v18 = module8(module6)
	local v19 = useLocalization({
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

	local v20 = useTokens()

	local v21 = fFlagPurchasePromptSubtitleForTimedOptions and (not fFlagAXDurables2Option or p5) and {
		componentName = "TIMED_OPTIONS_SUBTITLE",
		props = { timedOptionDays = p5 }
	} or nil

	local v22 = useShouldFetchCartPricingForPurchasePrompt(itemData2)

	local function fn2()
		return v5(module5(
			v6,
			v18,
			p2,
			v17,
			v16,
			p3,
			p4,
			v7,
			{
				toastMessage = v19.purchaseNotAvailableOnHeadSet,
				isLocalized = true,
				toastType = module7.InformationMessage
			},
			p5,
			if fFlagPurchasePromptSubtitleForTimedOptions then v21 else nil,
			v22
		))
	end

	local v25 = React.useCallback(fn2, {
		v19,
		v6,
		v18,
		p2,
		v17,
		v16,
		p3,
		p4,
		v7,
		p5,
		if fFlagPurchasePromptSubtitleForTimedOptions then v21 else nil,
		v22,
		v5
	})

	local collectibleItemInfo = v11.collectibleItemInfo

	local v26 = React.useCallback(function()
		v17.navigate(avatarScreen.ItemExperiencesMenu, {
			collectibleData = collectibleItemInfo,
			isLimited = module4.isLimitedCollectible(itemData2)
		})
	end, { v17, collectibleItemInfo })

	local itemSubType = v11.itemSubType
	local isItemToggledOn = v11.isItemToggledOn
	local v27

	if fFlagAXShowFaeUpsell then
		local v29 = if itemData2 then itemData2.name else nil
		v27 = module16(p3, p4, itemSubType, isItemToggledOn, v29)
	else
		v27 = nil
	end

	local v28 = module15(collectibleItemInfo)
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
				buttonColor = v20.Color.ActionEmphasis.Background.Color3,
				buttonTextColor = v20.Color.ActionEmphasis.Foreground.Color3,
				onActivated = function() end
			}
		elseif buttonType == module13.ExperienceLink then
			local v29 = {
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

			local v31 = if v28 > 1 then v19.inMultipleExperiences:gsub("{NUM_EXPERIENCES}", v28) else v19.inSingleExperience
			v29.buttonText = v31

			v29.buttonColor = v20.Color.ActionSubEmphasis.Background.Color3
			v29.buttonTextColor = v20.Color.ActionSubEmphasis.Foreground.Color3
			v29.onActivated = v26
			return v29
		elseif buttonType == module13.SoldOut then
			return {
				buttonActionType = if fFlagAXDurables2Option then buttonType else nil,
				buttonText = v19.soldOut,
				buttonIcon = nil,
				buttonIconPadding = 0,
				buttonIconSize = 0,
				buttonIsDisabled = true,
				buttonIsLoading = false,
				buttonColor = v20.Color.ActionEmphasis.Background.Color3,
				buttonTextColor = v20.Color.ActionEmphasis.Foreground.Color3,
				onActivated = function() end
			}
		elseif buttonType == module13.CustomizeLink then
			local v29 = {
				buttonActionType = buttonType,
				buttonIsDisabled = v16.opaque.name == avatarScreen.AvatarEditor,
				buttonText = "",
				buttonIcon = iconsmenuavatar_on,
				buttonIconPadding = v20.Gap.XSmall,
				buttonIconSize = v20.Size.Size_500,
				buttonIsLoading = false,
				buttonColor = 0,
				buttonTextColor = 0,
				onActivated = 0
			}

			local v30 = if v16.opaque.name == avatarScreen.AvatarEditor then v20.Color.ActionSubEmphasis.Background.Color3 else v20.Color.ActionEmphasis.Background.Color3
			v29.buttonColor = v30

			v29.buttonTextColor = v20.Color.ActionEmphasis.Foreground.Color3
			v29.onActivated = v16.opaque.name == avatarScreen.AvatarEditor and function() end or v25
			return v29
		elseif fFlagAXShowFaeUpsell and buttonType == module13.UnlockableItem then
			local v29 = if p8 and p8.showFaeUpsell then v27 elseif p8 and p8.canClaimFaeItem then v25 else nil

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

			local v32 = if p8 and p8.showFaeUpsell then v19.unlockButtonText else v19.freeText
			v30.buttonText = v32

			v30.buttonColor = v20.Color.ActionEmphasis.Background.Color3
			v30.buttonTextColor = v20.Color.ActionEmphasis.Foreground.Color3
			v30.onActivated = v29 or function() end
			return v30
		elseif buttonType == module13.PurchaseFromRoblox then
			local v29

			if p7 then
				v29 = if p5 then v19.buyButtonWithTimedOptionDays else v19.buyButtonWithTimedOptionPermanent
			else
				v29 = if p5 or p6 then v19.buyButtonTextForRentalItem else v15
			end

			local v30 = {
				buttonActionType = if fFlagAXDurables2Option then buttonType else nil,
				buttonIsDisabled = false,
				buttonText = v29,
				buttonIcon = nil,
				buttonIconPadding = 0,
				buttonIconSize = 0,
				buttonIsLoading = false,
				buttonColor = 0,
				buttonTextColor = 0,
				onActivated = 0
			}
			local v32 = if not (p5 or p6) then iconscommonrobux else nil
			v30.buttonIcon = v32
			v30.buttonIconPadding = v20.Gap.XSmall
			v30.buttonIconSize = v20.Size.Size_500

			v30.buttonColor = v20.Color.ActionEmphasis.Background.Color3
			v30.buttonTextColor = v20.Color.ActionEmphasis.Foreground.Color3
			v30.onActivated = v25
			return v30
		elseif buttonType == module13.Free then
			return {
				buttonActionType = if fFlagAXDurables2Option then buttonType else nil,
				buttonText = v19.freeText,
				buttonIcon = nil,
				buttonIconPadding = 0,
				buttonIconSize = 0,
				buttonIsDisabled = false,
				buttonIsLoading = false,
				buttonColor = v20.Color.ActionEmphasis.Background.Color3,
				buttonTextColor = v20.Color.ActionEmphasis.Foreground.Color3,
				onActivated = v25
			}
		else
			if buttonType ~= module13.PurchaseFromResale then
				return {
					buttonIsDisabled = true,
					buttonText = "",
					buttonIcon = iconsactionsblock,
					buttonIconPadding = v20.Gap.XSmall,
					buttonIconSize = v20.Size.Size_500,
					buttonIsLoading = false,
					buttonColor = v20.Color.ActionSubEmphasis.Background.Color3,
					buttonTextColor = v20.Color.ActionSubEmphasis.Foreground.Color3,
					onActivated = function() end
				}
			end

			return {
				buttonActionType = if fFlagAXDurables2Option then buttonType else nil,
				buttonText = string.gsub(v19.fromResale, "{itemPrice}", v15),
				buttonIsDisabled = false,
				buttonIcon = iconscommonrobux,
				buttonIconPadding = v20.Gap.XSmall,
				buttonIconSize = v20.Size.Size_500,
				buttonIsLoading = false,
				buttonColor = v20.Color.ActionEmphasis.Background.Color3,
				buttonTextColor = v20.Color.ActionEmphasis.Foreground.Color3,
				onActivated = v25
			}
		end
	end

	local v30 = if fFlagAXShowFaeUpsell then v27 else nil
	return useMemo(fn3, {
		buttonType,
		v20,
		v25,
		v19,
		v15,
		v26,
		v28,
		v30,
		if fFlagAXShowFaeUpsell then p8 else nil
	})
end

return useBuyActionBarButtonProps
