local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Cryo = require(CorePackages.Packages.Cryo)
local t = require(CorePackages.Packages.t)
local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable
require("@luauforge/bundled/dMc")

local module = require("@luauforge/bundled/eeo")
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local focusNavigationEventNameEnum = module.FocusNavigationEventNameEnum
local useTableWrappedCallbackRef = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useTableWrappedCallbackRef

local intervalPerformanceTracker = require("@luauforge/bundled/fvL").IntervalPerformanceTracker
local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")
local cartIdService = AvatarExperienceAnalytics.Lib.CartIdService
local getMarketplaceUnifiedAssetType = AvatarExperienceAnalytics.Utils.getMarketplaceUnifiedAssetType
local getMarketplaceUnifiedBundleType = AvatarExperienceAnalytics.Utils.getMarketplaceUnifiedBundleType
local getMarketplaceUnifiedLookType = AvatarExperienceAnalytics.Utils.getMarketplaceUnifiedLookType

local roactFitComponents = AvatarExperienceDeps.RoactFitComponents
local fitFrameVertical = roactFitComponents.FitFrameVertical
local fitTextLabel = roactFitComponents.FitTextLabel
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local module3 = require("@luauforge/deferred/gfJ")
local module4 = require("@luauforge/bundled/dMx")
local addUnifiedEventLogging = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").addUnifiedEventLogging
local unifiedEventLogEnums = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").UnifiedEventLogEnums

local unifiedEventLoggingUtils = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").Utils.UnifiedEventLoggingUtils

local unifiedEventLogConstants = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").UnifiedEventLogConstants
local module5 = require("@luauforge/deferred/fvp")
local getTTIEventName = module5.getTTIEventName

local timeToInteractiveTracker = require("@luauforge/bundled/fvo").TimeToInteractiveTracker
local productPurchaseSurface = module5.Enums.ProductPurchaseSurface

local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local checkbox = Foundation.Checkbox

local withStyle = UIBlox.Style.withStyle
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType

local defineFastFlag = game:DefineFastFlag("AXFixPurchasePromptScrimClickThrough", false)

local fFlagAXCatalogMakeupSupport = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXCatalogMakeupSupport

local fFlagAXMISEnableMultiShoppingUnifiedEvents = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXMISEnableMultiShoppingUnifiedEvents

local fFlagAXUnifiedEventStrictPayloads = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXUnifiedEventStrictPayloads

local fFlagAddPerformanceMetricsToUnifiedPurchaseModal = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAddPerformanceMetricsToUnifiedPurchaseModal

local fIntLegacyPurchaseFPSTrackingTimeout = require("@game/CorePackages/Workspace/Packages/SharedFlags").FIntLegacyPurchaseFPSTrackingTimeout

local fIntTTIUnifiedPurchaseSamplingRate = require("@game/CorePackages/Workspace/Packages/SharedFlags").FIntTTIUnifiedPurchaseSamplingRate

local v5 = {
	[Enum.KeyCode.ButtonX] = focusNavigationEventNameEnum.SaveAsCharacter,
	[Enum.KeyCode.ButtonY] = focusNavigationEventNameEnum.WearAfterPurchase
}

local function useFocusNavigationBindings(p2, p3, p4)
	local v6 = ReactFocusNavigation.useEventMap(v5, p2)
	local v7 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.SaveAsCharacter] = p3 and {
				handler = InputHandlers.onRelease(p3)
			} or nil,
			[focusNavigationEventNameEnum.WearAfterPurchase] = p4 and {
				handler = InputHandlers.onRelease(p4)
			} or nil
		}
	end, { p3, p4 })
	return ReactFocusNavigation.useEventHandlerMap(v7, v6)
end

local extended = Roact.PureComponent:extend("PurchasePromptInteractiveAlert")

extended.validateProps = t.strictInterface({
	priceInRobux = t.number,
	showSaveAsCharacter = t.optional(t.boolean),
	showWearAfterPurchase = t.boolean,
	isWearAfterPurchaseChecked = t.boolean,
	isSaveAsCharacterChecked = t.optional(t.boolean),
	toggleSaveAsCharacter = t.optional(t.callback),
	toggleWearAfterPurchase = t.callback,
	lookType = t.optional(t.string),
	analyticsInfo = t.optional(t.table),
	titleText = t.string,
	bodyText = t.string,
	confirmButtonText = t.string,
	onConfirm = t.callback,
	onCancel = t.callback,
	isLoading = t.boolean,
	defaultChildRef = t.optional(t.table),
	isPurchasingOutfit = t.optional(t.boolean),
	focusNavigationRef = t.table,
	saveIfWearAfterPurchase = t.optional(t.boolean),
	surface = t.optional(t.number),
	itemId = t.optional(t.string),
	screenSize = t.Vector2
})

function extended:init()
	self.checkboxRef = Roact.createRef()
	self.textButtonRef = Roact.createRef()
end

function extended:renderCheckboxContainer(props)
	local showSaveAsCharacter = self.props.showSaveAsCharacter
	local checkboxContainer = self.props.showWearAfterPurchase

	if not (showSaveAsCharacter or checkboxContainer) then
		return checkboxContainer
	end

	local createElement = Roact.createElement
	local v7 = {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = 2
	}

	local v8 = {
		UIPadding = Roact.createElement("UIPadding", { PaddingLeft = UDim.new(0, -8) }),
		UIListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, 12),
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		WearAfterPurchaseCheckbox = 0,
		SaveAsCharacterCheckbox = 0
	}

	if checkboxContainer then
		local createElement2 = Roact.createElement
		local v11 = if self.props.isPurchasingOutfit then props.wearOutfitLabel else props.wearItemLabel
		checkboxContainer = createElement2(checkbox, {
			label = v11,
			isChecked = self.props.isWearAfterPurchaseChecked,
			onActivated = self.props.toggleWearAfterPurchase,
			LayoutOrder = 1,
			ref = self.checkboxRef
		})
	end

	v8.WearAfterPurchaseCheckbox = checkboxContainer

	v8.SaveAsCharacterCheckbox = showSaveAsCharacter and Roact.createElement(checkbox, {
		label = props.saveAsCharacterLabel,
		isChecked = self.props.isSaveAsCharacterChecked,
		onActivated = self.props.toggleSaveAsCharacter,
		LayoutOrder = 2,
		ref = self.checkboxRef
	})
	checkboxContainer = createElement("Frame", v7, v8)
	return checkboxContainer
end

function extended:renderMiddle(p2, p3)
	local priceInRobux = self.props.priceInRobux or ""
	local v6 = priceInRobux == 0
	local v7 = not v6

	local font = p2.Font
	local theme = p2.Theme
	local v8 = font.BaseSize * font.Body.RelativeSize

	return Roact.createElement(
		focusable[fitFrameVertical],
		{
			BackgroundTransparency = 1,
			width = UDim.new(1, 0),
			defaultChild = self.checkboxRef
		},
		{
			PriceContainer = not v6 and Roact.createElement(fitFrameVertical, {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				contentPadding = UDim.new(0, 6),
				VerticalAlignment = Enum.VerticalAlignment.Center,
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				margin = roactFitComponents.Rect.quad(0, 0, 24, 0),
				width = UDim.new(1, 0)
			}, {
				PriceLabel = Roact.createElement(fitTextLabel, {
					width = fitTextLabel.Width.FitToText,
					BackgroundTransparency = 1,
					Font = font.Body.Font,
					Text = p3.priceLabel,
					TextColor3 = theme.TextDefault.Color,
					TextTransparency = theme.TextDefault.Transparency,
					TextSize = v8,
					LayoutOrder = 0
				}),
				RobuxContainer = Roact.createElement(module3, {
					robuxAmountText = tostring(priceInRobux),
					iconSize = v7 and v8 or 0,
					textSize = v8,
					padding = 4,
					showRobuxIcon = v7
				})
			}),
			CheckboxContainer = self:renderCheckboxContainer(p3)
		}
	)
end

function extended:renderAlertLocalized(p2, p3)
	local createElement = Roact.createElement
	local v6 = if defineFastFlag then focusable.TextButton else focusable.Frame
	return createElement(v6, {
		Text = defineFastFlag and "" or nil,
		AutoButtonColor = if defineFastFlag then false else nil,
		Selectable = if defineFastFlag then false else nil,
		[Roact.Event.Activated] = defineFastFlag and function()
			self.props.onCancel()
		end or nil,
		[Roact.Ref] = self.props.focusNavigationRef,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		SelectionGroup = true,
		SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
		SelectionBehaviorRight = Enum.SelectionBehavior.Stop,
		SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
		SelectionBehaviorDown = Enum.SelectionBehavior.Stop
	}, {
		PurchasePrompt = Roact.createElement(interactiveAlert, {
			title = self.props.titleText,
			bodyText = self.props.bodyText,
			buttonStackInfo = {
				buttons = {
					{
						props = {
							onActivated = self.props.onCancel,
							text = p3.cancelButtonText
						},
						isDefaultChild = true
					},
					{
						buttonType = buttonType.PrimarySystem,
						props = {
							isLoading = self.props.isLoading,
							onActivated = self.props.onConfirm,
							text = self.props.confirmButtonText,
							buttonRef = self.textButtonRef
						},
						isDefaultChild = false
					}
				}
			},
			middleContent = function()
				return self:renderMiddle(p2, p3)
			end,
			screenSize = self.props.screenSize,
			defaultChildRef = self.props.defaultChildRef,
			isMiddleContentFocusable = true
		})
	})
end

function extended:render()
	local v6

	if self.props.lookType and self.props.lookType == module4.LookType.Avatar then
		v6 = {
			priceLabel = "Feature.Catalog.Label.PriceColon",
			cancelButtonText = "Feature.Catalog.Action.Cancel",
			saveAsCharacterLabel = "Feature.Avatar.Label.Title.AddToMyAvatars",
			wearItemLabel = self.props.saveIfWearAfterPurchase and "Feature.Avatar.Label.Title.WearAndSaveAfterPurchase" or "Feature.Catalog.Label.WearAfterPurchase",
			wearOutfitLabel = self.props.saveIfWearAfterPurchase and "Feature.Avatar.Label.Title.WearAndSaveAfterPurchase" or "Feature.Catalog.Label.WearAvatarAfterPurchase"
		}
	else
		v6 = fFlagAXCatalogMakeupSupport
			and self.props.lookType
			and self.props.lookType == module4.LookType.Makeup
			and {
				priceLabel = "Feature.Catalog.Label.PriceColon",
				cancelButtonText = "Feature.Catalog.Action.Cancel",
				saveAsCharacterLabel = "Feature.Avatar.Label.Title.AddToMyMakeupLooks",
				wearItemLabel = "Feature.Catalog.Checkout.WearAfterPurchase",
				wearOutfitLabel = "Feature.Catalog.Checkout.WearAfterPurchase"
			}
			or {
				priceLabel = "Feature.Catalog.Label.PriceColon",
				cancelButtonText = "Feature.Catalog.Action.Cancel",
				saveAsCharacterLabel = "Feature.Avatar.Label.Title.AddToMyAvatars",
				wearItemLabel = self.props.saveIfWearAfterPurchase and "Feature.Avatar.Label.Title.WearAndSaveAfterPurchase" or "Feature.Catalog.Label.WearAfterPurchase",
				wearOutfitLabel = self.props.saveIfWearAfterPurchase and "Feature.Avatar.Label.Title.WearAndSaveAfterPurchase" or "Feature.Catalog.Label.WearOutfitAfterPurchase"
			}
	end

	return withStyle(function(p2)
		return withLocalization(v6)(function(p3)
			return self:renderAlertLocalized(p2, p3)
		end)
	end)
end

function extended:addUnifiedEventLogging()
	local analyticsInfo = self.props.analyticsInfo or {}

	local textButtonRef = self.textButtonRef
	local join = Cryo.Dictionary.join
	local v7 = {
		action = unifiedEventLogEnums.MarketplaceUnifiedAction.PURCHASE_ATTEMPT,
		surface = self.props.surface,
		cartId = 0,
		itemId = 0,
		itemType = 0,
		assetType = 0,
		bundleType = 0,
		organicLookType = 0,
		widgetLookType = 0,
		widgetItemPrice = 0,
		organicItemPrice = 0,
		widgetItemWearAfterPurchase = 0,
		widgetItemSaveToMyAvatars = 0,
		organicItemWearAfterPurchase = 0,
		organicItemSaveToMyAvatars = 0,
		widgetAssetType = 0,
		widgetBundleType = 0
	}
	local v8 = if fFlagAXMISEnableMultiShoppingUnifiedEvents then cartIdService.getCartId() else nil
	v7.cartId = v8
	local v9 = if fFlagAXUnifiedEventStrictPayloads then analyticsInfo.itemId or self.props.itemId else nil
	v7.itemId = v9
	local v10

	if analyticsInfo.itemType == "Asset" then
		v10 = unifiedEventLogEnums.MarketplaceUnifiedItemType.ASSET
	elseif analyticsInfo.itemType == "Bundle" then
		v10 = unifiedEventLogEnums.MarketplaceUnifiedItemType.BUNDLE
	else
		v10 = unifiedEventLogEnums.MarketplaceUnifiedItemType.LOOK
	end

	v7.itemType = v10

	local v11 = if fFlagAXUnifiedEventStrictPayloads and not analyticsInfo.widgetType then getMarketplaceUnifiedAssetType(analyticsInfo.assetType) else nil
	v7.assetType = v11

	local v12 = if fFlagAXUnifiedEventStrictPayloads and not analyticsInfo.widgetType then getMarketplaceUnifiedBundleType(analyticsInfo.bundleType) else nil
	v7.bundleType = v12
	local v13

	if not (analyticsInfo.widgetType or not self.props.lookType) then
		if fFlagAXUnifiedEventStrictPayloads then
			v13 = getMarketplaceUnifiedLookType(self.props.lookType)
		else
			v13 = unifiedEventLoggingUtils.formatLookTypeAttribute(self.props.lookType)
		end
	end

	v7.organicLookType = v13
	local v14

	if analyticsInfo.widgetType and self.props.lookType then
		if fFlagAXUnifiedEventStrictPayloads then
			v14 = getMarketplaceUnifiedLookType(self.props.lookType)
		else
			v14 = unifiedEventLoggingUtils.formatLookTypeAttribute(self.props.lookType)
		end
	end

	v7.widgetLookType = v14

	local v15 = if analyticsInfo.widgetType then self.props.priceInRobux else nil
	v7.widgetItemPrice = v15
	local v16 = if not analyticsInfo.widgetType then self.props.priceInRobux else nil
	v7.organicItemPrice = v16
	local v17 = if analyticsInfo.widgetType then self.props.showWearAfterPurchase and self.props.isWearAfterPurchaseChecked else nil
	v7.widgetItemWearAfterPurchase = v17

	local v18 = if analyticsInfo.widgetType then self.props.showSaveAsCharacter and self.props.isSaveAsCharacterChecked else nil
	v7.widgetItemSaveToMyAvatars = v18

	local v19 = if not analyticsInfo.widgetType then self.props.showWearAfterPurchase and self.props.isWearAfterPurchaseChecked else nil
	v7.organicItemWearAfterPurchase = v19

	local v20 = if not analyticsInfo.widgetType then self.props.showSaveAsCharacter and self.props.isSaveAsCharacterChecked else nil
	v7.organicItemSaveToMyAvatars = v20
	local v21

	if analyticsInfo.widgetType then
		if fFlagAXUnifiedEventStrictPayloads then
			v21 = getMarketplaceUnifiedAssetType(analyticsInfo.assetType)
		else
			v21 = analyticsInfo.assetType
		end
	end

	v7.widgetAssetType = v21
	local v22

	if analyticsInfo.widgetType then
		if fFlagAXUnifiedEventStrictPayloads then
			v22 = getMarketplaceUnifiedBundleType(analyticsInfo.bundleType)
		else
			v22 = analyticsInfo.bundleType
		end
	end

	v7.widgetBundleType = v22
	addUnifiedEventLogging(textButtonRef, join(analyticsInfo, v7), {
		sessionTagName = unifiedEventLogConstants.L2_SESSION_TAG_NAME
	})
end

function extended:didMount()
	if fFlagAddPerformanceMetricsToUnifiedPurchaseModal then
		intervalPerformanceTracker:startTracking(
			"PurchaseModal_ProductPurchaseContainerShown_Catalog",
			fIntLegacyPurchaseFPSTrackingTimeout,
			nil,
			true,
			true
		)

		intervalPerformanceTracker:startTracking(
			"PurchaseModal_LegacyFlowShown_Catalog",
			2,
			nil,
			true,
			true
		)
		local ttiEventName = getTTIEventName(productPurchaseSurface.Catalog)
		timeToInteractiveTracker.trackEnd(ttiEventName, {
			samplingRateOverride = fIntTTIUnifiedPurchaseSamplingRate
		})
	end

	self:addUnifiedEventLogging()
end

function extended:didUpdate()
	self:addUnifiedEventLogging()
end

local v6 = RoactRodux.connect(function(p2, p3)
	return { screenSize = p2.ScreenSize }
end, nil)(extended)

return function(p2)
	local v7 = React.useCallback(function()
		if p2.toggleSaveAsCharacter then
			p2.toggleSaveAsCharacter()
		end
	end, { p2.toggleSaveAsCharacter })
	local v8 = React.useCallback(function()
		if p2.toggleWearAfterPurchase then
			p2.toggleWearAfterPurchase()
		end
	end, { p2.toggleWearAfterPurchase })

	if not p2.toggleSaveAsCharacter then
		v7 = nil
	end

	if not p2.toggleWearAfterPurchase then
		v8 = nil
	end

	local v11 = useFocusNavigationBindings(nil, v7, v8)

	local joined = Cryo.Dictionary.join(p2, {
		focusNavigationRef = useTableWrappedCallbackRef(v11)
	})

	return React.createElement(v6, joined)
end
