local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Cryo = require(CorePackages.Packages.Cryo)
local t = require(CorePackages.Packages.t)
local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Focusable = RoactGamepad.Focusable

require(Modules.AvatarExperience.Common.Types)

local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useTableWrappedCallbackRef = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.RoactGamepadMigration.useTableWrappedCallbackRef
local IntervalPerformanceTracker = require(CorePackages.Workspace.Packages.IntervalPerformanceTracker).IntervalPerformanceTracker
local CartIdService = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).Lib.CartIdService
local RoactFitComponents = AvatarExperienceDeps.RoactFitComponents
local FitFrameVertical = RoactFitComponents.FitFrameVertical
local FitTextLabel = RoactFitComponents.FitTextLabel
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local RobuxAmountDisplay = require(Modules.AvatarExperience.Common.Components.ItemDetails.RobuxAmountDisplay)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local addUnifiedEventLogging = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).addUnifiedEventLogging
local UnifiedEventLogEnums = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).UnifiedEventLogEnums
local UnifiedEventLoggingUtils = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).Utils.UnifiedEventLoggingUtils
local UnifiedEventLogConstants = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).UnifiedEventLogConstants
local PurchasePromptLite = require(CorePackages.Workspace.Packages.PurchasePromptLite)
local getTTIEventName = PurchasePromptLite.getTTIEventName
local TimeToInteractiveTracker = require(CorePackages.Workspace.Packages.TimeToInteractiveTracker).TimeToInteractiveTracker
local ProductPurchaseSurface = PurchasePromptLite.Enums.ProductPurchaseSurface
local UIBlox = require(CorePackages.Packages.UIBlox)
local Checkbox = require(CorePackages.Packages.Foundation).Checkbox
local withStyle = UIBlox.Style.withStyle
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local v37 = game:DefineFastFlag("AXFixPurchasePromptScrimClickThrough", false)
local FFlagAXCatalogMakeupSupport = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXCatalogMakeupSupport
local FFlagAXMISEnableMultiShoppingUnifiedEvents = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXMISEnableMultiShoppingUnifiedEvents
local FFlagAddTypesToWidgetItems = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAddTypesToWidgetItems
local v41 = game:DefineFastFlag("AXAddWearAndSaveToPurchaseLogging", false)
local FFlagAXMigratePurchasePromptInteractiveToFocusNavigation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigratePurchasePromptInteractiveToFocusNavigation
local FFlagAddPerformanceMetricsToUnifiedPurchaseModal = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAddPerformanceMetricsToUnifiedPurchaseModal
local FIntLegacyPurchaseFPSTrackingTimeout = require(CorePackages.Workspace.Packages.SharedFlags).FIntLegacyPurchaseFPSTrackingTimeout
local FIntTTIUnifiedPurchaseSamplingRate = require(CorePackages.Workspace.Packages.SharedFlags).FIntTTIUnifiedPurchaseSamplingRate
local t1 = {
	[Enum.KeyCode.ButtonX] = FocusNavigationEventNameEnum.SaveAsCharacter,
	[Enum.KeyCode.ButtonY] = FocusNavigationEventNameEnum.WearAfterPurchase
}

local function useFocusNavigationBindings(p1, p2: ((...any) -> ...any)?, p3: ((...any) -> ...any)?) -- line: 111
	-- upvalues: ReactFocusNavigation (copy), t1 (copy), React (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy)
	local v53 = ReactFocusNavigation.useEventMap(t1, p1)
	local v54 = React.useMemo(function() -- line: 117
		-- upvalues: FocusNavigationEventNameEnum (copy), p2 (copy), InputHandlers (copy), p3 (copy)
		return {
			[FocusNavigationEventNameEnum.SaveAsCharacter] = if not p2 then nil else {
				handler = InputHandlers.onRelease(p2)
			},
			[FocusNavigationEventNameEnum.WearAfterPurchase] = if not p3 then nil else {
				handler = InputHandlers.onRelease(p3)
			}
		}
	end, {
		p2,
		p3
	})

	return ReactFocusNavigation.useEventHandlerMap(v54, v53)
end

local v48 = Roact.PureComponent:extend("PurchasePromptInteractiveAlert")

v48.validateProps = t.strictInterface({
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
	focusNavigationRef = if not FFlagAXMigratePurchasePromptInteractiveToFocusNavigation then nil else t.table,
	saveIfWearAfterPurchase = t.optional(t.boolean),
	screenSize = t.Vector2
})

function v48.init(p4) -- line: 160
	-- upvalues: Roact (copy)
	p4.checkboxRef = Roact.createRef()
	p4.textButtonRef = Roact.createRef()
end
function v48.renderCheckboxContainer(p5, p6) -- line: 165
	-- upvalues: Roact (copy), Checkbox (copy)
	local showSaveAsCharacter = p5.props.showSaveAsCharacter
	local showWearAfterPurchase = p5.props.showWearAfterPurchase

	return (showSaveAsCharacter or showWearAfterPurchase) and Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = 2,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		UIPadding = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, -8)
		}),
		UIListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, 12),
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		WearAfterPurchaseCheckbox = showWearAfterPurchase and Roact.createElement(Checkbox, {
			LayoutOrder = 1,
			label = if not p5.props.isPurchasingOutfit then p6.wearItemLabel else p6.wearOutfitLabel,
			isChecked = p5.props.isWearAfterPurchaseChecked,
			onActivated = p5.props.toggleWearAfterPurchase,
			ref = p5.checkboxRef
		}),
		SaveAsCharacterCheckbox = showSaveAsCharacter and Roact.createElement(Checkbox, {
			LayoutOrder = 2,
			label = p6.saveAsCharacterLabel,
			isChecked = p5.props.isSaveAsCharacterChecked,
			onActivated = p5.props.toggleSaveAsCharacter,
			ref = p5.checkboxRef
		})
	})
end
function v48.renderMiddle(p7, p8, p9) -- line: 205
	-- upvalues: Roact (copy), Focusable (copy), FitFrameVertical (copy), RoactFitComponents (copy), FitTextLabel (copy), RobuxAmountDisplay (copy)
	local v63 = p7.props.priceInRobux or ""
	local v64 = v63 == 0
	local v65 = not v64
	local p8Font = p8.Font
	local Theme = p8.Theme
	local v68 = p8Font.BaseSize * p8Font.Body.RelativeSize
	local v69 = v65 and v68 or 0

	return Roact.createElement(Focusable[FitFrameVertical], {
		BackgroundTransparency = 1,
		width = UDim.new(1, 0),
		defaultChild = p7.checkboxRef
	}, {
		PriceContainer = not v64 and Roact.createElement(FitFrameVertical, {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			contentPadding = UDim.new(0, 6),
			VerticalAlignment = Enum.VerticalAlignment.Center,
			margin = RoactFitComponents.Rect.quad(0, 0, 24, 0),
			width = UDim.new(1, 0)
		}, {
			PriceLabel = Roact.createElement(FitTextLabel, {
				BackgroundTransparency = 1,
				LayoutOrder = 0,
				width = FitTextLabel.Width.FitToText,
				Font = p8Font.Body.Font,
				Text = p9.priceLabel,
				TextColor3 = Theme.TextDefault.Color,
				TextTransparency = Theme.TextDefault.Transparency,
				TextSize = v68
			}),
			RobuxContainer = Roact.createElement(RobuxAmountDisplay, {
				padding = 4,
				robuxAmountText = tostring(v63),
				iconSize = v69,
				textSize = v68,
				showRobuxIcon = v65
			})
		}),
		CheckboxContainer = p7:renderCheckboxContainer(p9)
	})
end
function v48.renderAlertLocalized(p10, p11, p12) -- line: 257
	-- upvalues: Roact (copy), v37 (copy), Focusable (copy), FFlagAXMigratePurchasePromptInteractiveToFocusNavigation (copy), RoactGamepad (copy), InteractiveAlert (copy), ButtonType (copy)
	return Roact.createElement(if not v37 then Focusable.Frame else Focusable.TextButton, {
		Text = if not v37 then nil else "",
		AutoButtonColor = not v37 and nil,
		Selectable = not v37 and nil,
		[Roact.Event.Activated] = if not v37 then nil else function() -- line: 265
			-- upvalues: p10 (copy)
			p10.props.onCancel()
		end,
		[Roact.Ref] = if not FFlagAXMigratePurchasePromptInteractiveToFocusNavigation then nil else p10.props.focusNavigationRef,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		SelectionGroup = true,
		SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
		SelectionBehaviorRight = Enum.SelectionBehavior.Stop,
		SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
		SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
		inputBindings = if not FFlagAXMigratePurchasePromptInteractiveToFocusNavigation then {
			SaveAsCharacter = if p10.props.toggleSaveAsCharacter == nil then nil else RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonX, p10.props.toggleSaveAsCharacter, {
				key = "Feature.Avatar.Heading.SaveCostume"
			}),
			WearAfterPurchase = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonY, p10.props.toggleWearAfterPurchase, {
				key = "Feature.Avatar.Heading.WearConfirmation"
			}),
			Confirm = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonA, function() -- line: 294
			end, {
				key = "CommonUI.Controls.Action.Confirm"
			})
		} else nil
	}, {
		PurchasePrompt = Roact.createElement(InteractiveAlert, {
			isMiddleContentFocusable = true,
			title = p10.props.titleText,
			bodyText = p10.props.bodyText,
			buttonStackInfo = {
				buttons = {
					{
						isDefaultChild = true,
						props = {
							onActivated = p10.props.onCancel,
							text = p12.cancelButtonText
						}
					},
					{
						isDefaultChild = false,
						buttonType = ButtonType.PrimarySystem,
						props = {
							isLoading = p10.props.isLoading,
							onActivated = p10.props.onConfirm,
							text = p10.props.confirmButtonText,
							buttonRef = p10.textButtonRef
						}
					}
				}
			},
			middleContent = function() -- line: 324
				-- upvalues: p10 (copy), p11 (copy), p12 (copy)
				return p10:renderMiddle(p11, p12)
			end,
			screenSize = p10.props.screenSize,
			defaultChildRef = p10.props.defaultChildRef
		})
	})
end
function v48.render(p13) -- line: 335
	-- upvalues: Constants (copy), FFlagAXCatalogMakeupSupport (copy), withStyle (copy), withLocalization (copy)
	local u74 = if not p13.props.lookType or p13.props.lookType ~= Constants.LookType.Avatar then if not FFlagAXCatalogMakeupSupport or (not p13.props.lookType or p13.props.lookType ~= Constants.LookType.Makeup) then {
		priceLabel = "Feature.Catalog.Label.PriceColon",
		cancelButtonText = "Feature.Catalog.Action.Cancel",
		saveAsCharacterLabel = "Feature.Avatar.Label.Title.AddToMyAvatars",
		wearItemLabel = not p13.props.saveIfWearAfterPurchase and "Feature.Catalog.Label.WearAfterPurchase" or "Feature.Avatar.Label.Title.WearAndSaveAfterPurchase",
		wearOutfitLabel = not p13.props.saveIfWearAfterPurchase and "Feature.Catalog.Label.WearOutfitAfterPurchase" or "Feature.Avatar.Label.Title.WearAndSaveAfterPurchase"
	} else {
		priceLabel = "Feature.Catalog.Label.PriceColon",
		cancelButtonText = "Feature.Catalog.Action.Cancel",
		saveAsCharacterLabel = "Feature.Avatar.Label.Title.AddToMyMakeupLooks",
		wearItemLabel = "Feature.Catalog.Checkout.WearAfterPurchase",
		wearOutfitLabel = "Feature.Catalog.Checkout.WearAfterPurchase"
	} else {
		priceLabel = "Feature.Catalog.Label.PriceColon",
		cancelButtonText = "Feature.Catalog.Action.Cancel",
		saveAsCharacterLabel = "Feature.Avatar.Label.Title.AddToMyAvatars",
		wearItemLabel = not p13.props.saveIfWearAfterPurchase and "Feature.Catalog.Label.WearAfterPurchase" or "Feature.Avatar.Label.Title.WearAndSaveAfterPurchase",
		wearOutfitLabel = not p13.props.saveIfWearAfterPurchase and "Feature.Catalog.Label.WearAvatarAfterPurchase" or "Feature.Avatar.Label.Title.WearAndSaveAfterPurchase"
	}

	return withStyle(function(p14) -- line: 375
		-- upvalues: withLocalization (copy), u74 (ref), p13 (copy)
		return withLocalization(u74)(function(p15) -- line: 376
			-- upvalues: p13 (copy), p14 (copy)
			return p13:renderAlertLocalized(p14, p15)
		end)
	end)
end
function v48.addUnifiedEventLogging(p16) -- line: 382
	-- upvalues: addUnifiedEventLogging (copy), Cryo (copy), UnifiedEventLogEnums (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), CartIdService (copy), UnifiedEventLoggingUtils (copy), v41 (copy), FFlagAddTypesToWidgetItems (copy), UnifiedEventLogConstants (copy)
	local v76 = p16.props.analyticsInfo or {}

	addUnifiedEventLogging(p16.textButtonRef, Cryo.Dictionary.join(v76, {
		action = UnifiedEventLogEnums.MarketplaceUnifiedAction.PURCHASE_ATTEMPT,
		cartId = if not FFlagAXMISEnableMultiShoppingUnifiedEvents then nil else CartIdService.getCartId(),
		itemType = if v76.itemType ~= "Asset" then if v76.itemType ~= "Bundle" then UnifiedEventLogEnums.MarketplaceUnifiedItemType.LOOK else UnifiedEventLogEnums.MarketplaceUnifiedItemType.BUNDLE else UnifiedEventLogEnums.MarketplaceUnifiedItemType.ASSET,
		organicLookType = if v76.widgetType or not p16.props.lookType then nil else UnifiedEventLoggingUtils.formatLookTypeAttribute(p16.props.lookType),
		widgetLookType = if not v76.widgetType or not p16.props.lookType then nil else UnifiedEventLoggingUtils.formatLookTypeAttribute(p16.props.lookType),
		widgetItemPrice = if not v76.widgetType then nil else p16.props.priceInRobux,
		organicItemPrice = if not v76.widgetType then p16.props.priceInRobux else nil,
		widgetItemWearAfterPurchase = if not v41 then nil else if not v76.widgetType then nil else p16.props.showWearAfterPurchase and p16.props.isWearAfterPurchaseChecked,
		widgetItemSaveToMyAvatars = if not v41 then nil else if not v76.widgetType then nil else p16.props.showSaveAsCharacter and p16.props.isSaveAsCharacterChecked,
		organicItemWearAfterPurchase = if not v41 then nil else if not v76.widgetType then p16.props.showWearAfterPurchase and p16.props.isWearAfterPurchaseChecked else nil,
		organicItemSaveToMyAvatars = if not v41 then nil else if not v76.widgetType then p16.props.showSaveAsCharacter and p16.props.isSaveAsCharacterChecked else nil,
		widgetAssetType = if not FFlagAddTypesToWidgetItems or not v76.widgetType then nil else v76.assetType,
		widgetBundleType = if not FFlagAddTypesToWidgetItems or not v76.widgetType then nil else v76.bundleType
	}), {
		sessionTagName = UnifiedEventLogConstants.L2_SESSION_TAG_NAME
	})
end
function v48.didMount(p17) -- line: 434
	-- upvalues: FFlagAddPerformanceMetricsToUnifiedPurchaseModal (copy), IntervalPerformanceTracker (copy), FIntLegacyPurchaseFPSTrackingTimeout (copy), getTTIEventName (copy), ProductPurchaseSurface (copy), TimeToInteractiveTracker (copy), FIntTTIUnifiedPurchaseSamplingRate (copy)
	if FFlagAddPerformanceMetricsToUnifiedPurchaseModal then
		IntervalPerformanceTracker:startTracking("PurchaseModal_ProductPurchaseContainerShown_Catalog", FIntLegacyPurchaseFPSTrackingTimeout, nil, true, true)
		IntervalPerformanceTracker:startTracking("PurchaseModal_LegacyFlowShown_Catalog", 2, nil, true, true)

		local v78 = getTTIEventName(ProductPurchaseSurface.Catalog)

		TimeToInteractiveTracker.trackEnd(v78, {
			samplingRateOverride = FIntTTIUnifiedPurchaseSamplingRate
		})
	end

	p17:addUnifiedEventLogging()
end
function v48.didUpdate(p18) -- line: 456
	p18:addUnifiedEventLogging()
end

local u49 = RoactRodux.connect(function(p19, _) -- line: 460
	return {
		screenSize = p19.ScreenSize
	}
end, nil)(v48)

if FFlagAXMigratePurchasePromptInteractiveToFocusNavigation then
	return function(t2: {[any]: any}) -- line: 467
		-- upvalues: React (copy), useFocusNavigationBindings (copy), Cryo (copy), useTableWrappedCallbackRef (copy), u49 (ref)
		local v83 = React.useCallback(function() -- line: 468
			-- upvalues: t2 (copy)
			if t2.toggleSaveAsCharacter then
				t2.toggleSaveAsCharacter()
			end
		end, { t2.toggleSaveAsCharacter })
		local v84 = React.useCallback(function() -- line: 473
			-- upvalues: t2 (copy)
			if t2.toggleWearAfterPurchase then
				t2.toggleWearAfterPurchase()
			end
		end, { t2.toggleWearAfterPurchase })
		local v85 = useFocusNavigationBindings(nil, if not t2.toggleSaveAsCharacter then nil else v83, if not t2.toggleWearAfterPurchase then nil else v84)
		local v86 = Cryo.Dictionary.join(t2, {
			focusNavigationRef = useTableWrappedCallbackRef(v85)
		})

		return React.createElement(u49, v86)
	end
end

return u49
