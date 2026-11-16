local UserInputService = game:GetService("UserInputService")
local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local Cryo = require(CorePackages.Packages.Cryo)
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local module2 = require("@luauforge/bundled/dMd")
local avatarEditorCategories = module2.Enums.AvatarEditorCategories
local avatarEditorSubcategories = module2.Enums.AvatarEditorSubcategories
local numberLocalization = require("@game/CorePackages/Workspace/Packages/Localization").NumberLocalization
local isGamepadInput = require("@game/CorePackages/Workspace/Packages/RoactUtils").isGamepadInput

local images = UIBlox.App.ImageSet.Images

local module3 = require("@luauforge/bundled/fuD")
require("@luauforge/bundled/dHK")

local module4 = require("@luauforge/bundled/fvF")
local module5 = require("@luauforge/bundled/edB")
local module6 = require("@luauforge/bundled/eda")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local navigateWithLock = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Thunks.NavigateWithLock
local module8 = require("@luauforge/deferred/glc")

local module9 = require("@luauforge/deferred/gms")
local logOnOverlayClosed = AvatarExperienceNavigation.Debug.logOnOverlayClosed
local module10 = require("@luauforge/deferred/gnT")
local module11 = require("@luauforge/bundled/dTM")
require("@luauforge/deferred/ggN")
local module12 = require("@luauforge/bundled/dMx")
local module13 = require("@luauforge/deferred/gnU")

local module14 = require("@luauforge/bundled/dMx")
local setTryOnManagerPeekViewState = require("@luauforge/bundled/dHL").Actions.SetTryOnManagerPeekViewState
local module15 = require("@luauforge/bundled/gnZ")
local fullView = AvatarExperienceCommon.Enums.FullView
local peekViewState = require("@luauforge/bundled/dzD").PeekViewState

local module16 = require("@luauforge/deferred/gnY")
local module17 = require("@luauforge/bundled/dME")

local React = require(CorePackages.Packages.React)
local useStyle = UIBlox.Core.Style.useStyle

local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local module18 = require("@luauforge/deferred/gfy")
local module19 = require("@luauforge/deferred/goa")
local module20 = require("@luauforge/bundled/eeH")
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals
local selectTryOnsLookId = AvatarExperienceCommon.State.Selectors.selectTryOnsLookId

require("@luauforge/bundled/dNl")

require("@game/CoreGui/RobloxGui/Modules/InspectAndBuy/Reducers/CollectibleResellableInstances")
require("@luauforge/bundled/dNx")
local module21 = require("@luauforge/bundled/dCh")
local module22 = require("@luauforge/bundled/dwB")
local defineFastFlag = game:DefineFastFlag("AXHideShareButtonForContextMenu", false)

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXLookDetailsBottomBarFavoriteLogging = AvatarExperienceFlags.FFlagAXLookDetailsBottomBarFavoriteLogging
local fFlagAXEnableUnifiedPurchaseFlowForLooks = AvatarExperienceFlags.FFlagAXEnableUnifiedPurchaseFlowForLooks

local fFlagAXCatalogMakeupSupport = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXCatalogMakeupSupport
local module24 = require("@luauforge/deferred/fvp")
local getTTIEventName = module24.getTTIEventName

local timeToInteractiveTracker = require("@luauforge/bundled/fvo").TimeToInteractiveTracker
local productPurchaseSurface = module24.Enums.ProductPurchaseSurface
local getIsUserEligibleForUnifiedPurchaseFlow = module24.getIsUserEligibleForUnifiedPurchaseFlow
require("@luauforge/bundled/dMa")
require("@luauforge/bundled/dMc")

local fFlagUnifiedPurchaseFlowMarketplaceUIImprovements = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUnifiedPurchaseFlowMarketplaceUIImprovements
local fFlagAXFixLookDetailsContextualMenu = AvatarExperienceFlags.FFlagAXFixLookDetailsContextualMenu

local fFlagAddPerformanceMetricsToUnifiedPurchaseModal = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAddPerformanceMetricsToUnifiedPurchaseModal

local fFlagAXLaunchUnifiedPurchaseFlowMarketplaceLooks = AvatarExperienceFlags.FFlagAXLaunchUnifiedPurchaseFlowMarketplaceLooks

local fFlagAXMISEnableMultiShoppingUnifiedEvents = AvatarExperienceFlags.FFlagAXMISEnableMultiShoppingUnifiedEvents

local defineFastFlag2 = game:DefineFastFlag("HideLookDiscountPercentWithIneligibleItems", false)

local fIntBlackbirdUpsellMinPriceForDiscountInclusive = require("@game/CorePackages/Workspace/Packages/SharedFlags").FIntBlackbirdUpsellMinPriceForDiscountInclusive

local fIntBlackbirdUpsellMaxPriceForDiscountInclusive = require("@game/CorePackages/Workspace/Packages/SharedFlags").FIntBlackbirdUpsellMaxPriceForDiscountInclusive

local iconscommonrobux = images["icons/common/robux"]
local iconsactionsblock = images["icons/actions/block"]
local iconsmenuavatar_on = images["icons/menu/avatar_on"]
local iconsactionsfeedback = images["icons/actions/feedback"]
local iconsactionsinfo = images["icons/actions/info"]
local iconsactionseditdelete = images["icons/actions/edit/delete"]

local function selectTryOnItems(p2)
	return p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
end

local function selectLookId(p2)
	return p2.AvatarExperience.AvatarScene.OutfitTryOn.LookId
end

local function selectLookDetails(p2)
	return p2.AvatarExperience.AvatarScene.Looks
end

local function selectLocalUserId(p2)
	return p2.LocalUserId
end

local function selectUserRobux(p2)
	return p2.UserRobux
end

local function selectCollectiblesItemInfo(p2)
	return p2.AvatarExperience.Common.Collectibles.CollectiblesItemInfo
end

local function selectCollectiblesResellersInstances(p2)
	return p2.AvatarExperience.Common.Collectibles.CollectiblesResellersInstances
end

local function selectResellableInstances(p2)
	return p2.AvatarExperience.Common.Collectibles.CollectiblesResellableInstances
end

local function selectPeekViewState(p2)
	return p2.AvatarExperience.Common.ItemDetailsPeekView.tryOnManagerViewState
end

local fn = fFlagAXEnableUnifiedPurchaseFlowForLooks and function(p2)
	return p2.AvatarExperience.AvatarScene.OutfitTryOn.LookAnalyticsInfo
end or nil

local fn2 = fFlagAXMISEnableMultiShoppingUnifiedEvents and function(p2)
	return p2.AvatarExperience.AvatarScene.OutfitTryOn.MakeupLookAnalyticsInfo
end or nil

local function fn3(items, p2, p3, p4, p5, p6)
	local count = 0
	local total = 0
	local total2 = 0
	local result = {}
	local v5 = false
	local v6 = false
	local v7 = false

	for k, item in items do
		if not item.selectedInTryOnManager then
			continue
		end

		count += 1

		local itemInfo = module16.getItemInfo(item.itemId, item.itemType, p5, p6)

		if itemInfo then
			if not (itemInfo and itemInfo.quantityOwned and itemInfo.quantityOwned > 0) then
				local priceForItem = module16.getPriceForItem(
					itemInfo,
					p2,
					p3,
					p4,
					item.selectedTimedOptionIndex
				)

				if priceForItem ~= nil then
					if itemInfo and itemInfo.discountInformation then
						local v8 = false

						if item.selectedTimedOptionIndex and itemInfo.timedOptions then
							local timedOption = itemInfo.timedOptions[item.selectedTimedOptionIndex]

							if timedOption and timedOption.discountInformation then
								total += timedOption.discountInformation.originalPrice
								v8 = true
							elseif
								timedOption
								and not timedOption.discountInformation
								and timedOption.days ~= 0
							then
								total += timedOption.price
								v8 = true
							end
						end

						if not v8 then
							total += itemInfo.discountInformation.originalPrice
						end
					else
						total += priceForItem
					end

					if defineFastFlag2 then
						local v8

						if itemInfo and itemInfo.discountInformation then
							v8 = itemInfo.discountInformation.originalPrice
						else
							v8 = priceForItem
						end

						local v9 = fIntBlackbirdUpsellMaxPriceForDiscountInclusive
						local v10 = v8 <= fIntBlackbirdUpsellMinPriceForDiscountInclusive
							or not (v9 == 0) and v9 <= v8

						if itemInfo and itemInfo.discountInformation and not v10 then
							v6 = true
						else
							v7 = true
						end
					end

					total2 += priceForItem
					result[item.itemId] = Cryo.Dictionary.join(item, {
						expectedPrice = priceForItem
					})
				end
			end
		elseif not v5 then
			v5 = true
		end
	end

	if defineFastFlag2 then
		return total2, count, result, v5, total, v6 and v7
	end

	return total2, count, result, v5, total, nil
end

local v5 = {
	addToMyAvatarsLabel = fFlagAXEnableUnifiedPurchaseFlowForLooks and "Feature.Avatar.Label.Title.AddToMyAvatars" or nil,
	wearAfterPurchaseLabel = fFlagAXEnableUnifiedPurchaseFlowForLooks and "Feature.Catalog.Label.WearAfterPurchase" or nil,
	wearAvatarAfterPurchaseLabel = fFlagUnifiedPurchaseFlowMarketplaceUIImprovements and "Feature.Catalog.Label.WearAvatarAfterPurchase" or nil,
	saveAsCharacterLabel = fFlagUnifiedPurchaseFlowMarketplaceUIImprovements and "Feature.Catalog.Label.SaveAsCharacter" or nil,
	saveAsMakeupLookLabel = fFlagAXCatalogMakeupSupport and "Feature.Avatar.Label.Title.AddToMyMakeupLooks" or nil,
	wearAfterPurchaseMakeupLabel = fFlagAXCatalogMakeupSupport and "Feature.Avatar.Label.Title.WearAfterPurchase" or nil,
	freeText = "Feature.Catalog.LabelFree",
	reportText = "Feature.Catalog.Action.Report",
	viewDetailsPageLabel = "Feature.Catalog.Action.ViewDetailsPage",
	deleteAvatarLabel = "Feature.Catalog.Action.DeleteAvatar"
}

local function LookDetailsBottomBar(props)
	local lastInputType = UserInputService:GetLastInputType()
	local state, setState = React.useState(isGamepadInput(lastInputType))
	local state2, setState2 = React.useState(false)
	local state3, setState3

	if
		fFlagAXEnableUnifiedPurchaseFlowForLooks
		and not fFlagAXLaunchUnifiedPurchaseFlowMarketplaceLooks
	then
		state3, setState3 = React.useState(false)
	else
		setState3 = nil
	end

	local v6 = useAvatarRoute()
	local v7 = useDispatch()

	local v8 = useSelector(selectLookDetails, getUseSelectorDeepEquals())
	local v10 = if fFlagAXCatalogMakeupSupport then selectTryOnsLookId else selectLookId
	local v11 = useSelector(v10, getUseSelectorDeepEquals())

	local v12 = not (v11 == nil or v8[v11] == nil) and (v8[v11].isFavorited or false)

	local v13 = useNavigation()
	local v14 = module20(module6)
	local v15 = module20(module5)
	local v16 = module20(module4)
	local v17

	if fFlagAXEnableUnifiedPurchaseFlowForLooks then
		v17 = useSelector(fn, getUseSelectorDeepEquals())
	end

	local v18, v19

	if fFlagAXMISEnableMultiShoppingUnifiedEvents then
		v18 = useSelector(fn2, getUseSelectorDeepEquals())

		v19 = if v11 and v8 and v8[v11] then v8[v11].lookType == module12.LookType.Makeup else false
	end

	local v20 = useLocalization(v5)

	local v21 = useStyle()
	local theme = v21.Theme
	local font = v21.Font
	local v22 = useDesignTokens()

	local v23 = useSelector(selectTryOnItems, getUseSelectorDeepEquals())
	local v24 = useSelector(selectLocalUserId, getUseSelectorDeepEquals())
	local v25 = useSelector(selectUserRobux, getUseSelectorDeepEquals())[v24]
	local v26 = useSelector(selectCollectiblesItemInfo, getUseSelectorDeepEquals())
	local v27 = useSelector(selectCollectiblesResellersInstances, getUseSelectorDeepEquals())
	local v28 = useSelector(selectResellableInstances, getUseSelectorDeepEquals())
	local v29 = useSelector(selectPeekViewState, getUseSelectorDeepEquals())

	local function fn4(p2)
		module11.closeOverlay(p2)

		local v30 = not v12
		local lookType = if v11 and v8[v11] then v8[v11].lookType else nil

		if fFlagAXLookDetailsBottomBarFavoriteLogging and v11 ~= nil then
			local v31 = lookType or module12.ItemType.Look
			v16.clickFavoriteItemButton(v11, v31, v30)
		end

		local v31

		if fFlagAXCatalogMakeupSupport then
			v31 = v7(module8(v14, v11, v30, lookType))
		else
			v31 = v7(module8(v14, v11, v30))
		end

		if v31 ~= nil and type(v31.catch) == "function" then
			v31:catch(function() end)
		end

		v7(module21({
			toastMessage = v30 and "Feature.Catalog.Toast.FavoritedLook" or "Feature.Catalog.Toast.UnfavoritedLook",
			toastType = module22.SuccessConfirmation
		}))
	end

	local v34 = module19(v11, v12, (React.useCallback(fn4, {
		v7,
		module21,
		module8,
		v11,
		v8,
		v14,
		v12,
		v13,
		if fFlagAXLookDetailsBottomBarFavoriteLogging then v16 else nil
	})))

	local v35 = React.useMemo(function()
		if not props.alwaysBuyAll then
			return nil
		end

		if v11 and v8 then
			return Cryo.Dictionary.union(v8[v11].lookAssetInfos or {}, v8[v11].lookBundleInfos or {})
		end

		return {}
	end, { v11, v8, props.alwaysBuyAll })

	if
		fFlagAXEnableUnifiedPurchaseFlowForLooks
		and not fFlagAXLaunchUnifiedPurchaseFlowMarketplaceLooks
	then
		React.useEffect(function()
			getIsUserEligibleForUnifiedPurchaseFlow(v14):andThen(function(p2)
				setState3(p2)
			end):catch(function(p2)
				setState3(false)
			end)
		end, { v14 })
	end

	local v36 = React.useCallback(function()
		v7(module21({
			toastMessage = "Feature.Catalog.Toast.AvatarUnderReview",
			toastType = module22.NetworkingError
		}))
	end, { v7 })
	local v37 = React.useMemo(function(): boolean
		if v8 and v11 then
			return v8[v11].moderationStatus == module12.ModerationStatus.Moderated
		end

		return false
	end, { v8, v11 })
	local v38 = React.useMemo(function(): boolean
		if v8 and v11 then
			return v8[v11].moderationStatus == module12.ModerationStatus.PendingModeration
		end

		return false
	end, { v8, v11 })
	local v39 = React.useMemo(function()
		return v6 and v6.opaque and v6.opaque.name == avatarScreen.MySharedAvatars
	end, { v6 })

	local v40 = module18(v11, module12.ItemType.Look, true, nil, v38 and v36 or nil)

	local v41 = React.useCallback(function(p2)
		v16.sendAXCounter(module12.Counter.ContextFrame.ViewDetailsPageClick)
		v7(module15(v16, v6.opaque.name, fullView.None))
		v7(setTryOnManagerPeekViewState(peekViewState.Brief))
		module11.closeOverlay(p2)
	end, { v16, v7, v6 })

	local v42 = React.useMemo(function()
		if not (v24 and v8 and v11) then
			return false
		end

		local v43 = v8[v11]

		local v44 = v43 and v43.curator

		if v44 then
			if tostring(v43.curator.id) == tostring(v24) then
				v44 = v43.curator.type == module17.CreatorType.User
			else
				v44 = false
			end
		end

		return v44
	end, { v8, v11, v24 })

	local v43 = React.useCallback(function()
		if state and v6.current.name == avatarScreen.LookDetails then
			logOnOverlayClosed("LookDetails")
		end
	end, { state, v6 })

	local v44 = React.useCallback(function(p2)
		v16.sendAXCounter(module12.Counter.ContextFrame.DeleteAvatarClick)
		module11.closeOverlay(p2)
		v7(navigateWithLock(function()
			local deleteAvatarConfirmationPrompt = avatarScreen.DeleteAvatarConfirmationPrompt
			v13.navigate(deleteAvatarConfirmationPrompt, {
				onOverlayClosed = v43,
				lookId = v11
			})
		end))
	end, { v16, v7, v11, v43 })

	local v45 = React.useCallback(function()
		local v46 = v29 == peekViewState.SuperBrief

		if fFlagAXFixLookDetailsContextualMenu then
			local v47 = {}

			if v46 then
				table.insert(v47, {
					icon = iconsactionsinfo,
					text = v20.viewDetailsPageLabel,
					onActivated = v41
				})
			end

			if not v37 then
				table.insert(v47, v34)
			end

			if not (defineFastFlag or v37 or v39) then
				table.insert(v47, v40)
			end

			if v42 and v39 then
				table.insert(v47, {
					icon = iconsactionseditdelete,
					text = v20.deleteAvatarLabel,
					onActivated = v44
				})
			end

			if not v42 then
				table.insert(v47, {
					icon = iconsactionsfeedback,
					text = v20.reportText,
					onActivated = function(p2)
						v7(module10(v14))
						module11.closeOverlay(p2)
					end
				})
			end

			return v47
		else
			local v48 = v46
				and {
					icon = iconsactionsinfo,
					text = v20.viewDetailsPageLabel,
					onActivated = v41
				}
				or nil
			local v49 = if not v37 then v34 else nil
			local v50 = if not (defineFastFlag or v37 or v39) then v40 else nil
			return {
				v48,
				v49,
				v50,
				v42 and v39 and {
					icon = iconsactionseditdelete,
					text = v20.deleteAvatarLabel,
					onActivated = v44
				} or nil,
				not v42 and {
					icon = iconsactionsfeedback,
					text = v20.reportText,
					onActivated = function(p2)
						v7(module10(v14))
						module11.closeOverlay(p2)
					end
				} or nil
			}
		end
	end, {
		v14,
		v20,
		v41,
		v44,
		v42,
		v7,
		v40,
		v34,
		v12,
		v29,
		v37,
		v39
	})

	local v46 = React.useCallback(function()
		setState2(false)
		v43()
	end, { v43 })

	local v47 = React.useCallback(function()
		v7(navigateWithLock(function()
			local v48

			if v45 then
				v48 = v45()
			else
				v48 = { nil, nil }
				local v50 = if not (defineFastFlag or v37 or v39) then v40 else nil
				v48[1], v48[2] = {
	icon = iconsactionsfeedback,
	text = v20.reportText,
	onActivated = function(p2)
		v7(module10(v14))
		module11.closeOverlay(p2)
	end
}, v50
			end

			v13.navigate(avatarScreen.ContextMenu, {
				centered = props.centered,
				contextButtons = v48,
				onOverlayClosed = v46
			})
		end))
	end, { v13, v7, v46, v20, v14, v40, v45 })

	local v48 = nil
	local v49 = nil
	local v50 = nil
	local v51, v52, v53, v54, v55

	if props.alwaysBuyAll then
		v51, v48, v49, v52, v53, v54, v55 = module16.getBottomBarInfoMIS(v35, v26, v27, v28, v8, v11, v23)
	else
		v51, v50, v53, v52, v54, v55 = fn3(v23, v26, v27, v28, v8, v11)
	end

	local v56

	if v35 and props.alwaysBuyAll then
		v56 = React.useCallback(function()
			local bottomBarInfoMIS, v57, v58, v59 = module16.getBottomBarInfoMIS(
				v35,
				v26,
				v27,
				v28,
				v8,
				v11,
				v23
			)

			local v60 = nil
			local v61

			if v25 < bottomBarInfoMIS then
				v60 = avatarScreen.InsufficientRobuxPrompt
				v61 = { onOverlayClosed = v43 }

				v16.sendAXCounter(module14.Counter.AvatarWidget.AvatarsWidgetBuyClickedInsufficientRobux)
			elseif v58 == 0 and v11 ~= nil then
				local getAvatarEditorCategoryIdsFromNavKey = module3.GetAvatarEditorCategoryIdsFromNavKey
				local v62

				if v8[v11].lookType == module12.LookType.Makeup then
					v62 = avatarEditorSubcategories.MakeupLooks
				else
					v62 = avatarEditorCategories.Avatars
				end

				local avatarEditorCategoryIdsFromNavKey, v63 = getAvatarEditorCategoryIdsFromNavKey(v62)

				v60 = avatarScreen.LeaveCatalogToAvatarPrompt
				v61 = {
					onOverlayClosed = v43,
					categoryOverride = avatarEditorCategoryIdsFromNavKey,
					subcategoryOverride = v63
				}

				v16.sendAXCounter(module14.Counter.AvatarWidget.AvatarsWidgetBuyClickedNoItemsToPurchase)
			else
				local ownedItemsInLook = module16.getOwnedItemsInLook(v35, v8, v11)

				if v11 == nil then
					v16.sendAXCounter(module14.Counter.AvatarWidget.AvatarsWidgetBuyClickedMissingLookId)

					v61 = { onOverlayClosed = v43 }
				else
					v60 = avatarScreen.PurchaseLookPrompt
					v61 = {
						lookId = v11,
						priceInRobux = bottomBarInfoMIS,
						showSaveAsCharacter = true,
						showWearAfterPurchase = true,
						fromAvatarRoute = v6,
						allLookItems = v35,
						ownedItemsInLook = ownedItemsInLook,
						isTryOnFromOutsideAX = props.isTryOnFromOutsideAX
					}

					if module11.isWithinViewContext(v6, avatarScreen.CatalogSearch) then
						v16.sendAXCounter(module14.Counter.AvatarWidget.AvatarsWidgetSearchBuyClicked)
					else
						v16.sendAXCounter(module14.Counter.AvatarWidget.AvatarsWidgetHomeBuyClicked)
					end
				end
			end

			v7(navigateWithLock(function()
				v13.navigate(v60, v61)
			end))
		end, {
			v26,
			v27,
			v28,
			v8,
			v11,
			v25,
			v7,
			v13,
			v43,
			v16,
			v6,
			v35,
			v23
		})
	else
		v56 = React.useCallback(function()
			local v57, v58, v59 = fn3(v23, v26, v27, v28, v8, v11)

			local v60 = nil

			if fFlagAddPerformanceMetricsToUnifiedPurchaseModal then
				local ttiEventName = getTTIEventName(productPurchaseSurface.Catalog)
				timeToInteractiveTracker.trackStart(ttiEventName)
				timeToInteractiveTracker.updateMetadata(ttiEventName, {
					page = productPurchaseSurface.Catalog,
					category = "legacy_purchase_modal"
				})
			end

			local v61

			if v25 < v57 then
				v60 = avatarScreen.InsufficientRobuxPrompt
				v61 = { onOverlayClosed = v43 }

				v16.sendAXCounter(module14.Counter.AvatarWidget.AvatarsWidgetBuyClickedInsufficientRobux)
			elseif Cryo.isEmpty(v59) and v11 ~= nil then
				local getAvatarEditorCategoryIdsFromNavKey = module3.GetAvatarEditorCategoryIdsFromNavKey
				local v62

				if v8[v11].lookType == module12.LookType.Makeup then
					v62 = avatarEditorSubcategories.MakeupLooks
				else
					v62 = avatarEditorCategories.Avatars
				end

				local avatarEditorCategoryIdsFromNavKey, v63 = getAvatarEditorCategoryIdsFromNavKey(v62)

				v60 = avatarScreen.LeaveCatalogToAvatarPrompt
				v61 = {
					onOverlayClosed = v43,
					categoryOverride = avatarEditorCategoryIdsFromNavKey,
					subcategoryOverride = v63
				}

				v16.sendAXCounter(module14.Counter.AvatarWidget.AvatarsWidgetBuyClickedNoItemsToPurchase)
			else
				local ownedTryOnItems = module16.getOwnedTryOnItems(v23, v8, v11)

				if v11 == nil then
					v16.sendAXCounter(module14.Counter.AvatarWidget.AvatarsWidgetBuyClickedMissingLookId)

					v61 = { onOverlayClosed = v43 }
				else
					v60 = avatarScreen.PurchaseLookPrompt
					v61 = {
						itemsToPurchase = v59,
						lookId = v11,
						ownedTryOnItems = ownedTryOnItems,
						priceInRobux = v57,
						showSaveAsCharacter = true,
						showWearAfterPurchase = true,
						fromAvatarRoute = v6,
						isTryOnFromOutsideAX = props.isTryOnFromOutsideAX
					}

					if module11.isWithinViewContext(v6, avatarScreen.CatalogSearch) then
						v16.sendAXCounter(module14.Counter.AvatarWidget.AvatarsWidgetSearchBuyClicked)
					else
						v16.sendAXCounter(module14.Counter.AvatarWidget.AvatarsWidgetHomeBuyClicked)
					end
				end
			end

			v7(navigateWithLock(function()
				v13.navigate(v60, v61)
			end))
		end, {
			v23,
			v26,
			v27,
			v28,
			v8,
			v11,
			v25,
			v7,
			v13,
			v43,
			v16,
			v6
		})
	end

	if fFlagAXEnableUnifiedPurchaseFlowForLooks then
		local v58 = {
			lookId = v11,
			totalPrice = v51,
			originalPrice = v54,
			tryOnItems = v23,
			lookDetailsObj = v8,
			lookAnalyticsInfo = nil,
			localized = nil,
			isTryOnFromOutsideAX = 0,
			itemsToPurchase = 0,
			userRobux = 0,
			onOverlayClosed = 0,
			hasNonDiscountedItems = 0
		}

		if not (fFlagAXMISEnableMultiShoppingUnifiedEvents and v19) then
			v18 = v17
		end

		v58.lookAnalyticsInfo = v18

		v58.localized = v20
		v58.isTryOnFromOutsideAX = props.isTryOnFromOutsideAX
		v58.itemsToPurchase = v53
		v58.userRobux = v25
		v58.onOverlayClosed = v43
		v58.hasNonDiscountedItems = v55
		local onButtonPressWithUnifiedPurchaseFlow = module13(v58).onButtonPressWithUnifiedPurchaseFlow

		if fFlagAXLaunchUnifiedPurchaseFlowMarketplaceLooks then
			v56 = onButtonPressWithUnifiedPurchaseFlow
		elseif state3 then
			v56 = onButtonPressWithUnifiedPurchaseFlow
		end
	end

	local v57

	if not props.alwaysBuyAll then
		v57 = React.useCallback(function(): boolean
			local count = 0

			for k, v58 in v23 do
				if not v58.selectedInTryOnManager then
					continue
				end

				local itemInfo = module16.getItemInfo(v58.itemId, v58.itemType, v8, v11)

				if not itemInfo or not itemInfo.quantityOwned or itemInfo.quantityOwned == 0 then
					return false
				end

				count += 1
			end

			return count > 0
		end, { v23, v8, v11 })
	end

	local v58 = React.useCallback(function(p2): boolean
		if v35 == nil or not props.alwaysBuyAll then
			return false
		end

		local count = 0

		for k, v59 in v35 do
			local v60 = if v59.itemType then module16.getItemInfo(v59.id, v59.itemType, v8, p2) else nil

			if not v60 or not v60.quantityOwned or v60.quantityOwned == 0 then
				return false
			end

			count += 1
		end

		return count > 0
	end, { v8, v35, props.alwaysBuyAll })

	local v59 = iconscommonrobux
	local v60 = false

	local v61 = v53 and Cryo.isEmpty(v53)

	if props.alwaysBuyAll then
		v61 = v49 == 0
	end

	local v62

	if v61 then
		v62 = ""

		local v63 = v57 and v57()

		if props.alwaysBuyAll then
			v63 = v58 and v58(v11) ~= nil
		end

		if v11 == nil or not v63 then
			v59 = iconsactionsblock
			v60 = true
		else
			v59 = iconsmenuavatar_on
		end
	elseif v51 == 0 then
		v62 = v20.freeText
		v59 = nil
	else
		v62 = numberLocalization.localize(string.format("%.0f", v51), v15:GetLocale())
	end

	local v63 = v25 == nil or v60

	if not props.alwaysBuyAll then
		v48 = v50
	end

	local formatted = v15:Format("Feature.Avatar.Label.TryOnManagerDescriptor", {
		numItems = v48
	})

	local hideDescriptor = props.hideDescriptor

	local createElement = Roact.createElement
	local v67 = {
		LayoutOrder = 1,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, v22.Size.Size_800),
		Text = formatted,
		TextSize = font.BaseSize * font.Header2.RelativeSize,
		Font = 0,
		FontFace = 0,
		TextColor3 = 0,
		TextTransparency = 0,
		TextTruncate = 0,
		TextXAlignment = 0,
		TextYAlignment = 0
	}
	local v68 = if not foundationFontFaceMigration then font.Header2.Font else nil
	v67.Font = v68

	local v69 = if foundationFontFaceMigration then normalizeFontFace(v22.Typography.TitleLarge.Font) else nil
	v67.FontFace = v69

	v67.TextColor3 = theme.SecondaryContent.Color
	v67.TextTransparency = theme.SecondaryContent.Transparency
	v67.TextTruncate = Enum.TextTruncate.AtEnd
	v67.TextXAlignment = Enum.TextXAlignment.Left
	v67.TextYAlignment = Enum.TextYAlignment.Top
	local element = createElement("TextLabel", v67)

	local v70 = React.useCallback(function()
		v47()
		setState2(true)
	end, { v47, setState2 })

	local v71 = React.useMemo(function()
		local v72 = {
			buttonText = v62,
			buttonIcon = v59,
			buttonIsLoading = v52,
			buttonIsDisabled = v63,
			buttonIconPadding = v22.Size.Size_100,
			buttonIconSize = v22.Size.Size_500,
			buttonColor = v21.Theme.ContextualPrimaryDefault.Color,
			buttonTextColor = v21.Theme.ContextualPrimaryContent.Color,
			onActivated = 0
		}
		local v73 = if not v63 then v56 or nil else nil
		v72.onActivated = v73
		return v72
	end, { v62, v59, v52, v63, v22, v21, v56 })
	local v72 = v39 and not v37 and v40 ~= nil
	local createElement2 = Roact.createElement

	local v75 = if v72 then v40.onActivated else nil
	local v76 = if v72 then v40.icon else nil

	if hideDescriptor then
		element = nil
	end

	return createElement2(module9, {
		bottomPadding = 0,
		buttonProps = v71,
		hideGradient = true,
		isMoreButtonSelected = state2,
		leftPadding = 0,
		onMoreButtonActivated = v70,
		rightPadding = 0,
		showMoreButton = true,
		showMiddleButton = v72,
		onMiddleButtonActivated = v75,
		middleButtonIcon = v76,
		topComponent = element,
		topComponentHeight = hideDescriptor and 0 or v22.Size.Size_800,
		ZIndex = 1
	})
end

return LookDetailsBottomBar
