local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local roactRodux = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux
local useSelector = roactRodux.useSelector
local useDispatch = roactRodux.useDispatch
local module = require("@luauforge/bundled/dKU")
local module2 = require("@luauforge/deferred/gTb")
local peekViewState = require("@luauforge/bundled/dCI").PeekViewState

local module3 = require("@luauforge/bundled/dPN")
require("@luauforge/bundled/dKT")
local module4 = require("@luauforge/bundled/dPU")
require("@luauforge/bundled/dPq")
local module5 = require("@luauforge/deferred/gOU")
local module6 = require("@luauforge/bundled/gJS")
local module7 = require("@luauforge/deferred/gTd")
local module8 = require("@luauforge/deferred/gSy")
local module9 = require("@luauforge/bundled/gxM")

local fFlagEnableSplitPane = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableSplitPane

local fFlagUnifiedPurchaseFlowMarketplaceUIImprovements = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUnifiedPurchaseFlowMarketplaceUIImprovements

local fFlagAXCatalogMakeupSupport = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXCatalogMakeupSupport

local fFlagAXMomentsLookTryOnCloseAfterPurchase = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXMomentsLookTryOnCloseAfterPurchase

local fFlagAXMomentsLookTryOnDelayAutoSave = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXMomentsLookTryOnDelayAutoSave
local defineFastInt = game:DefineFastInt("AXMomentsLookTryOnAutoSaveDelayMs", 5000)
local fFlagMomentsAvatarLookTryOn = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagMomentsAvatarLookTryOn

local fFlagAXEnableUnifiedLoggingAvatarMoment = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXEnableUnifiedLoggingAvatarMoment
local v5 = if fFlagEnableSplitPane then require("@luauforge/bundled/fCo") else nil

local clearTryOns = module.Actions.ClearTryOns
local setTryOnManagerPeekViewState = module.Actions.SetTryOnManagerPeekViewState
local getTryOnItemsTotalPrice = module2.Utils.getTryOnItemsTotalPrice
local formatNumber = module2.Utils.formatNumber

local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")
local sendUnifiedEventLog = AvatarExperienceAnalytics.sendUnifiedEventLog
local marketplaceUnifiedAction = AvatarExperienceAnalytics.UnifiedEventLogEnums.MarketplaceUnifiedAction
local marketplaceUnifiedItemType = AvatarExperienceAnalytics.UnifiedEventLogEnums.MarketplaceUnifiedItemType
local unifiedLoggingElementNameEnums = AvatarExperienceAnalytics.Enums.UnifiedLoggingElementNameEnums

local unifiedLoggingSurface = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.UnifiedLoggingSurface

local v6 = module4.ActionBar.ActionBarHeight * 2 + module4.ActionBar.ActionBarPadding

local function selectPeekViewState(p2)
	return p2.AvatarExperience.Common.ItemDetailsPeekView.tryOnManagerViewState
end

local function selectTopBarHeight(p2)
	return p2.TopBar.topBarHeight
end

local function selectScreenHeight(p2)
	return p2.ScreenSize.Y
end

local function selectLookId(p2)
	return p2.AvatarExperience.AvatarScene.OutfitTryOn.LookId
end

local function selectTryOnItems(p2)
	return p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
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

local function selectLookAnalyticsInfo(p2)
	return p2.AvatarExperience.AvatarScene.OutfitTryOn.LookAnalyticsInfo
end

local v7 = {
	buyLabel = "Feature.Catalog.Action.Buy",
	addToMyAvatarsLabel = "Feature.Avatar.Label.Title.AddToMyAvatars",
	wearAfterPurchaseLabel = "Feature.Catalog.Label.WearAfterPurchase",
	wearAvatarAfterPurchaseLabel = fFlagUnifiedPurchaseFlowMarketplaceUIImprovements and "Feature.Catalog.Label.WearAvatarAfterPurchase" or nil,
	saveAsCharacterLabel = fFlagUnifiedPurchaseFlowMarketplaceUIImprovements and "Feature.Catalog.Label.SaveAsCharacter" or nil,
	saveAsMakeupLookLabel = fFlagAXCatalogMakeupSupport and "Feature.Avatar.Label.Title.AddToMyMakeupLooks" or nil,
	wearAfterPurchaseMakeupLabel = fFlagAXCatalogMakeupSupport and "Feature.Avatar.Label.Title.WearAfterPurchase" or nil
}

require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")

local function useMomentsLookTryOnPeekViewModel(p2)
	local v8 = useDispatch()
	local v9 = useSelector(selectPeekViewState)
	local v10 = useSelector(module6)
	local v11 = useSelector(selectTopBarHeight)
	local v12 = useSelector(selectScreenHeight)
	local v13 = useSelector(selectLookId)
	local v14 = useSelector(selectTryOnItems)
	local v15 = useSelector(selectLookDetails)
	local v16 = useSelector(selectLocalUserId)
	local v17 = useSelector(selectUserRobux)
	local v18 = useSelector(selectLookAnalyticsInfo)
	local v19 = module9(v7)

	local v20 = module7()
	local tryOnItemsTotalPrice = getTryOnItemsTotalPrice(v20)
	local v21 = #v20

	if fFlagAXEnableUnifiedLoggingAvatarMoment then
		React.useEffect(function()
			local params = if p2 and p2.state then p2.state.params else nil
			local clone = table.clone(not (params and params.shopMetadata) and {} or params.shopMetadata)
			clone.tryOnViewId = HttpService:GenerateGUID(false)

			local function sendTryOnEvent(p3)
				local v23 = {
					action = p3,
					surface = unifiedLoggingSurface.SHOP_AVATAR_MOMENT,
					itemId = 0,
					itemType = 0,
					elementName = 0,
					elementMetadata = 0
				}
				local v24 = if params then params.itemId else nil
				v23.itemId = v24
				v23.itemType = marketplaceUnifiedItemType.LOOK
				v23.elementName = unifiedLoggingElementNameEnums.AVATAR_MOMENTS.MOMENT_LOOK_TRY_ON
				v23.elementMetadata = HttpService:JSONEncode(clone)
				sendUnifiedEventLog(v23)
			end

			sendTryOnEvent(marketplaceUnifiedAction.PAGE_VIEW)
			return function()
				sendTryOnEvent(marketplaceUnifiedAction.PAGE_EXIT)
			end
		end, {})
	end

	local v22 = React.useCallback(function(p3, p4)
		v8(setTryOnManagerPeekViewState(p3))
	end, { v8 })

	local v23 = v9 == peekViewState.Full or v9 == peekViewState.Extended

	local v24 = React.useCallback(function()
		v8(setTryOnManagerPeekViewState(peekViewState.SuperBrief))
	end, { v8 })

	local v25 = React.useCallback(function()
		v8(clearTryOns())
		v8(setTryOnManagerPeekViewState(peekViewState.Closed))
		v8(module5(p2))
	end, { v8, p2 })
	local v26

	if fFlagMomentsAvatarLookTryOn then
		v26 = React.useCallback(function()
			v8(function(object)
				local tryOnManagerViewState = object:getState().AvatarExperience.Common.ItemDetailsPeekView.tryOnManagerViewState

				if
					tryOnManagerViewState == peekViewState.Brief
					or tryOnManagerViewState == peekViewState.Full
					or tryOnManagerViewState == peekViewState.Extended
				then
					object:dispatch(setTryOnManagerPeekViewState(peekViewState.SuperBrief))
				end
			end)

			if fFlagAXMomentsLookTryOnCloseAfterPurchase then
				v25()
			end
		end, { v8, v25 })
	end

	local openUnifiedPurchasePrompt = module8({
		lookId = v13,
		totalPrice = tryOnItemsTotalPrice.totalPrice,
		originalPrice = tryOnItemsTotalPrice.originalPrice,
		tryOnItems = v14,
		lookDetailsObj = v15,
		lookAnalyticsInfo = v18,
		localized = v19,
		isTryOnFromOutsideAX = true,
		itemsToPurchase = nil,
		userRobux = v17 and v16 and v17[v16] or 0,
		onOverlayClosed = nil,
		hasNonDiscountedItems = tryOnItemsTotalPrice.hasNonDiscountedItems,
		onPurchaseFlowCompleted = v26,
		autoSaveDelayMs = if fFlagAXMomentsLookTryOnDelayAutoSave then defineFastInt else nil
	}).openUnifiedPurchasePrompt

	local v30 = {
		leftLabel = module9({
			leftLabel = {
				"Feature.Catalog.Label.TotalItemsFraction",
				itemCount = tryOnItemsTotalPrice.itemCount,
				itemTotal = v21
			}
		}).leftLabel,
		priceInRobux = formatNumber(tryOnItemsTotalPrice.totalPrice)
	}

	local v31 = {
		purchaseButtonText = v19.buyLabel,
		onPurchase = openUnifiedPurchasePrompt,
		isDisabled = tryOnItemsTotalPrice.itemCount == 0 or v13 == nil,
		variant = Foundation.Enums.ButtonVariant.Emphasis
	}
	local v32

	if fFlagEnableSplitPane and v5 ~= nil then
		v32 = v5.getLandscapeSceneWidth()
	else
		v32 = module3.LandscapeSceneWidth
	end

	local v33 = v23 and 0 or v11
	local v34 = if v10 then UDim2.new(1, 0, 1, -v33) else UDim2.new(v32, 0, 1, -v33)

	return {
		priceLabel = v30,
		purchaseButtonProps = v31,
		peekViewState = v9,
		barHeight = v6,
		onViewStateChanged = v22,
		onClose = v25,
		isExpanded = v23,
		onMinimize = v24,
		contentMinHeight = v12,
		panelSize = v34,
		panelPosition = UDim2.new(0.5, 0, 0, v33),
		panelAnchorPoint = Vector2.new(0.5, 0)
	}
end

return useMomentsLookTryOnPeekViewModel
