local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Images = require(CorePackages.Packages.UIBlox).App.ImageSet.Images
local React = require(CorePackages.Packages.React)
local useTokens = require(CorePackages.Packages.Foundation).Hooks.useTokens
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local NumberLocalization = require(CorePackages.Workspace.Packages.Localization).NumberLocalization
local useAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).useAppPolicy
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local tutils = require(CorePackages.Packages.tutils)
local RetrievalStatus = require(Modules.LuaApp.Enum.RetrievalStatus)
local ItemData = require(Modules.AvatarExperience.Common.Selectors.ItemData)
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local OpenItemPrompt = require(Modules.AvatarExperience.Common.Thunks.OpenItemPrompt)
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local ToastType = require(Modules.LuaApp.Enum.ToastType)
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local RoactLocalization = require(Modules.LuaApp.Services.RoactLocalization)
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals
local getTryOnItemReducerKey = AvatarExperienceCommon.Utils.getTryOnItemReducerKey
local useShouldFetchCartPricingForPurchasePrompt = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog).Hooks.useShouldFetchCartPricingForPurchasePrompt
local BuyActionButtonTypeEnum = require(script.Parent.BuyActionButtonTypeEnum)
local getActionButtonType = require(script.Parent.getActionButtonType)
local getExperienceCount = require(script.Parent.getExperienceCount)
local useOpenFAEPage = require(script.Parent.useOpenFAEPage)
local GetFFlagAXDisableActionButtonOnOwnedItemInCustomize = require(Modules.AvatarExperience.Flags.GetFFlagAXDisableActionButtonOnOwnedItemInCustomize)
local FFlagAXMISEnableMultiShopping = AvatarExperienceFlags.FFlagAXMISEnableMultiShopping
local FFlagAXShowFaeUpsell = AvatarExperienceFlags.FFlagAXShowFaeUpsell
local FFlagAXDurables2Option = AvatarExperienceFlags.FFlagAXDurables2Option
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagPurchasePromptSubtitleForTimedOptions = SharedFlags.FFlagPurchasePromptSubtitleForTimedOptions
local FFlagPurchasePromptFetchCartPricing = SharedFlags.FFlagPurchasePromptFetchCartPricing
local v43 = Images["icons/menu/avatar_on"]
local v44 = Images["icons/common/robux"]
local v45 = Images["icons/actions/block"]

local function selectUserRobux(p1) -- line: 57
	local LocalUserId = p1.LocalUserId

	return p1.UserRobux[LocalUserId]
end
local function useLocalizedPrice(n1: number?) -- line: 62
	-- upvalues: useRoactService (copy), RoactLocalization (copy), NumberLocalization (copy)
	local v55 = n1 and string.format("%.0f", n1)
	local v56 = useRoactService(RoactLocalization)

	if n1 then
		return (NumberLocalization.localize(v55, v56:GetLocale()))
	end

	return nil
end
local function selectCollectibleItemInfo(p2, s1: string?) -- line: 68
	local CollectiblesItemInfo = p2.AvatarExperience.Common.Collectibles.CollectiblesItemInfo

	if s1 then
		return CollectiblesItemInfo[s1]
	end

	return nil
end
local function selectIsLoadingState(p3, s2: string?, s3: string) -- line: 74
	-- upvalues: ItemData (copy), PerformFetch (copy), CatalogUtils (copy), RetrievalStatus (copy), FFlagAXMISEnableMultiShopping (copy), CatalogConstants (copy)
	if not s2 then
		return true
	end

	local v63 = ItemData(p3.AvatarExperience.Common, s2, s3)
	local v64 = if not v63 then nil else v63.collectibleItemId
	local CollectiblesItemInfo = p3.AvatarExperience.Common.Collectibles.CollectiblesItemInfo
	local v66 = if not v64 then nil else CollectiblesItemInfo[v64]
	local v67 = v64 ~= nil and v64 ~= ""
	local v68 = PerformFetch.GetStatus(p3, CatalogUtils.GetItemDetailsKey(s2, s3))
	local v69 = v68 == RetrievalStatus.Fetching or v68 == RetrievalStatus.NotStarted

	if FFlagAXMISEnableMultiShopping then
		local v70 = v63 and v63.receivedCatalogData

		v69 = (v68 == RetrievalStatus.Fetching or v68 == RetrievalStatus.NotStarted) and not v70
	end

	local v71 = v67 and not v66
	local LocalUserId = p3.LocalUserId
	local v73 = p3.UserRobux[LocalUserId]
	local v74 = if not v64 then nil else PerformFetch.GetStatus(p3, CatalogConstants.FetchCollectibleResellableInstancesKey .. tostring(v64))
	local v75 = if not v74 then nil else v74 == RetrievalStatus.Fetching or v74 == RetrievalStatus.NotStarted

	return v69 or (v71 or (v75 or v73 == nil))
end
local function selectBuyActionBarStateWithItemIdAndType(p4, s4: string?, s5: string, b1: boolean, t1: {[any]: any}?) -- line: 111
	-- upvalues: ItemData (copy), tutils (copy), selectIsLoadingState (copy), getActionButtonType (copy), FFlagAXShowFaeUpsell (copy), getTryOnItemReducerKey (copy)
	local v81 = ItemData(p4.AvatarExperience.Common, s4, s5)
	local v82 = if not v81 then nil else v81.collectibleItemId
	local CollectiblesItemInfo = p4.AvatarExperience.Common.Collectibles.CollectiblesItemInfo
	local v84 = if not v82 then nil else CollectiblesItemInfo[v82]
	local v85 = p4.AvatarExperience.Common.Collectibles.CollectiblesResellableInstances[v82]
	local v86 = not v85 and 0 or tutils.fieldCount(v85)
	local v87 = selectIsLoadingState(p4, s4, s5)
	local v88 = b1 and v82
	local v89 = getActionButtonType(v81, v84, v86, v87, not v88, if not FFlagAXShowFaeUpsell then nil else t1)
	local v90 = if not FFlagAXShowFaeUpsell or not v81 then nil else v81.assetType or v81.bundleType
	local v91 = if not FFlagAXShowFaeUpsell or not s4 then nil else p4.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems[getTryOnItemReducerKey(s4, s5)] ~= nil

	return {
		itemData = v81,
		buttonType = v89,
		collectibleItemInfo = v84,
		localUserId = p4.LocalUserId,
		itemSubType = v90,
		isItemToggledOn = v91
	}
end
local function useBuyActionBarButtonProps(p5, p6, p7, n2: number?, b2: boolean?, b3: boolean?, t2: {[any]: any}?) -- line: 166
	-- upvalues: useDispatch (copy), useRoactService (copy), RoactNetworking (copy), useAppPolicy (copy), React (copy), selectBuyActionBarStateWithItemIdAndType (copy), FFlagAXShowFaeUpsell (copy), useSelector (copy), getUseSelectorDeepEquals (copy), BuyActionButtonTypeEnum (copy), RoactLocalization (copy), NumberLocalization (copy), useAvatarRoute (copy), useNavigation (copy), Analytics (copy), useLocalization (copy), useTokens (copy), FFlagPurchasePromptSubtitleForTimedOptions (copy), FFlagAXDurables2Option (copy), FFlagPurchasePromptFetchCartPricing (copy), useShouldFetchCartPricingForPurchasePrompt (copy), ToastType (copy), OpenItemPrompt (copy), AvatarScreen (copy), CatalogUtils (copy), useOpenFAEPage (copy), getExperienceCount (copy), FFlagAXMISEnableMultiShopping (copy), GetFFlagAXDisableActionButtonOnOwnedItemInCustomize (copy), v43 (copy), v44 (copy), v45 (copy)
	local v99 = useDispatch()
	local v100 = useRoactService(RoactNetworking)
	local v101, v102 = useAppPolicy(function(p8) -- line: 178
		return p8.getDisableIAPEntryPoint(), p8.getDisableResellingCollectiblesForCompliance()
	end)
	local v103 = React.useCallback(function(p9) -- line: 183
		-- upvalues: selectBuyActionBarStateWithItemIdAndType (copy), p6 (copy), p7 (copy), v102 (copy), FFlagAXShowFaeUpsell (copy), t2 (copy)
		return (selectBuyActionBarStateWithItemIdAndType(p9, p6, p7, v102, if not FFlagAXShowFaeUpsell then nil else t2))
	end, {
		p6,
		p7,
		v102,
		if not FFlagAXShowFaeUpsell then nil else t2
	})
	local v104 = useSelector(v103, getUseSelectorDeepEquals())
	local buttonType = v104.buttonType
	local itemData = v104.itemData
	local v107 = not itemData and 0 or if buttonType ~= BuyActionButtonTypeEnum.PurchaseFromResale then itemData.priceInRobux else itemData.lowestResalePrice
	local v108 = v107 and string.format("%.0f", v107)
	local v109 = useRoactService(RoactLocalization)
	local v110 = if not v107 then nil else NumberLocalization.localize(v108, v109:GetLocale())
	local v111 = useAvatarRoute()
	local v112 = useNavigation()
	local v113 = useRoactService(Analytics)
	local v114 = useLocalization({
		freeText = "Feature.Catalog.LabelFree",
		soldOut = "Feature.Catalog.Label.SoldOut",
		fromResale = "Feature.Catalog.Label.PriceFromResale",
		inMultipleExperiences = "Feature.Catalog.Label.InMultipleExperiences",
		inSingleExperience = "Feature.Catalog.Label.InSingleExperience",
		purchaseNotAvailableOnHeadSet = "IAPExperience.RobuxUpsell.Text.PurchaseNotAvailableOnHeadSet",
		buyButtonTextForRentalItem = "Feature.Durables.BottomBar.BuyButton",
		buyButtonWithTimedOptionPermanent = "Feature.Durables.ItemDetails.BottomBar.BuyButton.Permanent",
		unlockButtonText = if not FFlagAXShowFaeUpsell then nil else "Feature.MarketplaceFAEUpsell.ActionBar.PrimaryButton.Text",
		buyButtonWithTimedOptionDays = {
			"Feature.Durables.ItemDetails.BottomBar.BuyButton.Days",
			num = n2
		}
	})
	local v115 = useTokens()
	local t3 = nil

	if FFlagPurchasePromptSubtitleForTimedOptions and (not FFlagAXDurables2Option or n2) then
		t3 = {
			componentName = "TIMED_OPTIONS_SUBTITLE",
			props = {
				timedOptionDays = n2
			}
		}
	end

	local v117 = if not FFlagPurchasePromptFetchCartPricing then nil else useShouldFetchCartPricingForPurchasePrompt(itemData)
	local v118 = React.useCallback(function() -- line: 247
		-- upvalues: v114 (copy), ToastType (copy), v99 (copy), OpenItemPrompt (copy), v100 (copy), v113 (copy), p5 (copy), v112 (copy), v111 (copy), p6 (copy), p7 (copy), v101 (copy), n2 (copy), FFlagPurchasePromptSubtitleForTimedOptions (copy), t3 (ref), FFlagPurchasePromptFetchCartPricing (copy), v117 (copy)
		local t4 = {
			isLocalized = true,
			toastMessage = v114.purchaseNotAvailableOnHeadSet,
			toastType = ToastType.InformationMessage
		}

		return v99(OpenItemPrompt(v100, v113, p5, v112, v111, p6, p7, v101, t4, n2, if not FFlagPurchasePromptSubtitleForTimedOptions then nil else t3, if not FFlagPurchasePromptFetchCartPricing then nil else v117))
	end, {
		v114,
		v100,
		v113,
		p5,
		v112,
		v111,
		p6,
		p7,
		v101,
		n2,
		if not FFlagPurchasePromptSubtitleForTimedOptions then nil else t3,
		v117,
		v99
	})
	local collectibleItemInfo = v104.collectibleItemInfo
	local v120 = React.useCallback(function() -- line: 287
		-- upvalues: v112 (copy), AvatarScreen (copy), collectibleItemInfo (copy), CatalogUtils (copy), itemData (copy)
		v112.navigate(AvatarScreen.ItemExperiencesMenu, {
			collectibleData = collectibleItemInfo,
			isLimited = CatalogUtils.isLimitedCollectible(itemData)
		})
	end, {
		v112,
		collectibleItemInfo
	})
	local itemSubType = v104.itemSubType
	local isItemToggledOn = v104.isItemToggledOn
	local v123 = if not FFlagAXShowFaeUpsell then nil else useOpenFAEPage(p6, p7, itemSubType, isItemToggledOn, if not itemData then nil else itemData.name)
	local v124 = getExperienceCount(collectibleItemInfo)

	return React.useMemo(function() -- line: 303
		-- upvalues: buttonType (copy), BuyActionButtonTypeEnum (copy), FFlagAXDurables2Option (copy), v115 (copy), v124 (copy), v114 (copy), v120 (copy), FFlagAXMISEnableMultiShopping (copy), GetFFlagAXDisableActionButtonOnOwnedItemInCustomize (copy), v111 (copy), AvatarScreen (copy), v43 (copy), v118 (copy), FFlagAXShowFaeUpsell (copy), t2 (copy), v123 (copy), b3 (copy), n2 (copy), b2 (copy), v110 (copy), v44 (copy), v45 (copy)
		if buttonType == BuyActionButtonTypeEnum.Loading then
			return {
				buttonText = "",
				buttonIcon = nil,
				buttonIconPadding = 0,
				buttonIconSize = 0,
				buttonIsDisabled = true,
				buttonIsLoading = true,
				buttonActionType = if not FFlagAXDurables2Option then nil else buttonType,
				buttonColor = v115.Color.ActionEmphasis.Background.Color3,
				buttonTextColor = v115.Color.ActionEmphasis.Foreground.Color3,
				onActivated = function() -- line: 315
				end
			}
		end

		if buttonType == BuyActionButtonTypeEnum.ExperienceLink then
			return {
				buttonIcon = nil,
				buttonIconPadding = 0,
				buttonIconSize = 0,
				buttonIsDisabled = false,
				buttonIsLoading = false,
				buttonActionType = if not FFlagAXDurables2Option then nil else buttonType,
				buttonText = if not (v124 > 1) then v114.inSingleExperience else v114.inMultipleExperiences:gsub("{NUM_EXPERIENCES}", v124),
				buttonColor = v115.Color.ActionSubEmphasis.Background.Color3,
				buttonTextColor = v115.Color.ActionSubEmphasis.Foreground.Color3,
				onActivated = v120
			}
		end

		if buttonType == BuyActionButtonTypeEnum.SoldOut then
			return {
				buttonIcon = nil,
				buttonIconPadding = 0,
				buttonIconSize = 0,
				buttonIsDisabled = true,
				buttonIsLoading = false,
				buttonActionType = if not FFlagAXDurables2Option then nil else buttonType,
				buttonText = v114.soldOut,
				buttonColor = v115.Color.ActionEmphasis.Background.Color3,
				buttonTextColor = v115.Color.ActionEmphasis.Foreground.Color3,
				onActivated = function() -- line: 343
				end
			}
		end

		if buttonType == BuyActionButtonTypeEnum.CustomizeLink then
			return {
				buttonText = "",
				buttonIsLoading = false,
				buttonActionType = if not FFlagAXMISEnableMultiShopping then nil else buttonType,
				buttonIsDisabled = not not GetFFlagAXDisableActionButtonOnOwnedItemInCustomize() and v111.opaque.name == AvatarScreen.AvatarEditor,
				buttonIcon = v43,
				buttonIconPadding = v115.Gap.XSmall,
				buttonIconSize = if not FFlagAXMISEnableMultiShopping then v115.Size.Size_800 else v115.Size.Size_500,
				buttonColor = if not GetFFlagAXDisableActionButtonOnOwnedItemInCustomize() or v111.opaque.name ~= AvatarScreen.AvatarEditor then v115.Color.ActionEmphasis.Background.Color3 else v115.Color.ActionSubEmphasis.Background.Color3,
				buttonTextColor = v115.Color.ActionEmphasis.Foreground.Color3,
				onActivated = if not GetFFlagAXDisableActionButtonOnOwnedItemInCustomize() or v111.opaque.name ~= AvatarScreen.AvatarEditor then v118 else function() -- line: 365
				end
			}
		end

		if FFlagAXShowFaeUpsell and buttonType == BuyActionButtonTypeEnum.UnlockableItem then
			local v128 = nil

			if t2 and t2.showFaeUpsell then
				v128 = v123
			elseif t2 and t2.canClaimFaeItem then
				v128 = v118
			end

			return {
				buttonIcon = nil,
				buttonIconPadding = 0,
				buttonIconSize = 0,
				buttonIsDisabled = false,
				buttonIsLoading = false,
				buttonActionType = if not FFlagAXDurables2Option then nil else buttonType,
				buttonText = if not t2 or not t2.showFaeUpsell then v114.freeText else v114.unlockButtonText,
				buttonColor = v115.Color.ActionEmphasis.Background.Color3,
				buttonTextColor = v115.Color.ActionEmphasis.Foreground.Color3,
				onActivated = v128 or function() -- line: 387
				end
			}
		end

		if buttonType == BuyActionButtonTypeEnum.PurchaseFromRoblox then
			local v129 = if not b3 then if not n2 and not b2 then v110 else v114.buyButtonTextForRentalItem else if not n2 then v114.buyButtonWithTimedOptionPermanent else v114.buyButtonWithTimedOptionDays

			return {
				buttonIsDisabled = false,
				buttonIsLoading = false,
				buttonActionType = if not FFlagAXDurables2Option then nil else buttonType,
				buttonText = v129,
				buttonIcon = if not n2 and not b2 then v44 else nil,
				buttonIconPadding = v115.Gap.XSmall,
				buttonIconSize = if not FFlagAXMISEnableMultiShopping then v115.Size.Size_800 else v115.Size.Size_500,
				buttonColor = v115.Color.ActionEmphasis.Background.Color3,
				buttonTextColor = v115.Color.ActionEmphasis.Foreground.Color3,
				onActivated = v118
			}
		end

		if buttonType == BuyActionButtonTypeEnum.Free then
			return {
				buttonIcon = nil,
				buttonIconPadding = 0,
				buttonIconSize = 0,
				buttonIsDisabled = false,
				buttonIsLoading = false,
				buttonActionType = if not FFlagAXDurables2Option then nil else buttonType,
				buttonText = v114.freeText,
				buttonColor = v115.Color.ActionEmphasis.Background.Color3,
				buttonTextColor = v115.Color.ActionEmphasis.Foreground.Color3,
				onActivated = v118
			}
		end

		if buttonType == BuyActionButtonTypeEnum.PurchaseFromResale then
			return {
				buttonIsDisabled = false,
				buttonIsLoading = false,
				buttonActionType = if not FFlagAXDurables2Option then nil else buttonType,
				buttonText = string.gsub(v114.fromResale, "{itemPrice}", v110),
				buttonIcon = v44,
				buttonIconPadding = v115.Gap.XSmall,
				buttonIconSize = if not FFlagAXMISEnableMultiShopping then v115.Size.Size_800 else v115.Size.Size_500,
				buttonColor = v115.Color.ActionEmphasis.Background.Color3,
				buttonTextColor = v115.Color.ActionEmphasis.Foreground.Color3,
				onActivated = v118
			}
		end

		return {
			buttonIsDisabled = true,
			buttonText = "",
			buttonIsLoading = false,
			buttonIcon = v45,
			buttonIconPadding = v115.Gap.XSmall,
			buttonIconSize = if not FFlagAXMISEnableMultiShopping then v115.Size.Size_800 else v115.Size.Size_500,
			buttonColor = v115.Color.ActionSubEmphasis.Background.Color3,
			buttonTextColor = v115.Color.ActionSubEmphasis.Foreground.Color3,
			onActivated = function() -- line: 458
			end
		}
	end, {
		buttonType,
		v115,
		v118,
		v114,
		v110,
		v120,
		v124,
		if not FFlagAXShowFaeUpsell then nil else v123,
		if not FFlagAXShowFaeUpsell then nil else t2
	})
end

return useBuyActionBarButtonProps
