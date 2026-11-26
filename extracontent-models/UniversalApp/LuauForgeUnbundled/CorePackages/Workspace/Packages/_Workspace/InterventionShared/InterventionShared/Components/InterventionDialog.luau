local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/Foundation")
local text = Foundation.Text
local modalWindow = UIBlox.App.Dialog.Modal.ModalWindow
local useLayerCollector = UIBlox.Core.Layout.LayerCollector.useLayerCollector
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/Localization").Hooks.useLocalization
local useStyle = UIBlox.Core.Style.useStyle
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/InterventionShared/Utils/Constants")
local InterventionAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/InterventionShared/InterventionAnalytics")
local icon = Foundation.Icon
local view = Foundation.View
local scrollView = Foundation.ScrollView
local scrollBarVisibility = Foundation.Enums.ScrollBarVisibility
local useTokens = Foundation.Hooks.useTokens
local NotificationModalsManager = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/NotificationModalsManager")
local iconsactionsaccept = UIBlox.App.ImageSet.Images["icons/actions/accept"]
local buttonStack = UIBlox.App.Button.ButtonStack
local buttonType = UIBlox.App.Button.Enum.ButtonType
local useScrollFrameHeightCalculation = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/InterventionShared/Hooks/useScrollFrameHeightCalculation")
local useCursor = UIBlox.App.SelectionCursor.useCursor
local useInterventionPlacement = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/InterventionShared/Hooks/useInterventionPlacement")
local useDeviceInsets = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/Responsive").useDeviceInsets
local fFlagLuaAppSupportDeviceSafeInsets = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/SharedFlags").FFlagLuaAppSupportDeviceSafeInsets
local defineFastFlag = game:DefineFastFlag("AppChatInterventionDeviceSafeInsets", false)

local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/FocusNavigationUtils")
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local focusRoot = FocusNavigationUtils.FocusRoot

function LUAUFORGE_MODULE_GLOBALS_hAh_InterventionDialog(props)
	local v5 = useLayerCollector().absoluteSize
	local ref = React.useRef(DateTime.now().UnixTimestampMillis)
	local v6 = useTokens()
	local v7 = useStyle()
	local v8 = useInterventionPlacement()
	local v9 = nil

	if defineFastFlag and fFlagLuaAppSupportDeviceSafeInsets then
		local v10 = useDeviceInsets()

		if v8 == Constants.InterventionPlacementType.InApp then
			v5 = Vector2.new(
				math.max(0, v5.X - v10.left - v10.right),
				(math.max(0, v5.Y - v10.top - v10.bottom))
			)
			v9 = v10
		end
	end

	local v10 = useLocalization(Constants.localizationKeys)

	local v11 = React.useCallback(function()
		InterventionAnalytics.sendAnalyticsEvent(InterventionAnalytics.TelemetryConfigs.DialogCtaClicked, {
			eventType = InterventionAnalytics.Constants.EventTypes.CtaClicked,
			counterNamespace = props.namespaceForAnalytics,
			interventionType = props.interventionTypeForAnalytics,
			placement = v8,
			renderedTimestamp = ref.current,
			eventId = props.eventId,
			evidence = props.evidence,
			duration = props.durationForAnalytics
		})

		props.onDismiss()
	end, {
		ref,
		props.interventionTypeForAnalytics,
		props.eventId,
		props.evidence,
		props.durationForAnalytics,
		props.onDismiss
	})

	local v12 = React.useCallback(function()
		props.onDismiss()
		NotificationModalsManager.SetUIBloxToast({
			iconImage = iconsactionsaccept,
			toastTitle = v10.TakeALookText,
			toastSubtitle = v10.FeedbackHelpsText,
			sequenceNumber = DateTime.now().UnixTimestamp,
			iconColorStyle = {
				Color = v7.Tokens.Color.System.Success.Color3,
				Transparency = 0
			}
		})

		InterventionAnalytics.sendAnalyticsEvent(InterventionAnalytics.TelemetryConfigs.DialogAppealClicked, {
			eventType = InterventionAnalytics.Constants.EventTypes.AppealClicked,
			counterNamespace = props.namespaceForAnalytics,
			interventionType = props.interventionTypeForAnalytics,
			placement = v8,
			renderedTimestamp = ref.current,
			eventId = props.eventId,
			evidence = props.evidence,
			duration = props.durationForAnalytics
		})
	end, {
		props.onDismiss,
		props.interventionTypeForAnalytics,
		props.eventId,
		props.evidence,
		props.durationForAnalytics
	})

	React.useEffect(function()
		InterventionAnalytics.sendAnalyticsEvent(InterventionAnalytics.TelemetryConfigs.DialogRendered, {
			eventType = InterventionAnalytics.Constants.EventTypes.ModalAppeared,
			counterNamespace = props.namespaceForAnalytics,
			interventionType = props.interventionTypeForAnalytics,
			placement = v8,
			renderedTimestamp = ref.current,
			eventId = props.eventId,
			evidence = props.evidence,
			duration = props.durationForAnalytics
		})
	end, { ref, props.eventId })

	local v16 = useScrollFrameHeightCalculation({
		screenSize = if v9 then v5 else nil
	})

	local v17 = v5.X > 540 and "gap-xlarge" or "gap-medium"

	local v18 = useCursor(
		UDim.new(0, v7.Tokens.Radius.Medium),
		v7.Tokens.Size.Size_100,
		v7.Tokens.Size.Size_50
	)

	local createElement = React.createElement

	local createElement2 = React.createElement
	local v23 = {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		tag = "padding-x-xlarge padding-y-large"
	}

	local createElement3 = React.createElement
	local v26 = {
		Size = UDim2.new(1, 0, 0, v16.scrollFrameContainerHeight),
		scroll = {
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.new(1, 0, 1, 0),
			scrollBarVisibility = scrollBarVisibility.Always,
			ScrollingDirection = Enum.ScrollingDirection.Y
		}
	}

	local createElement4 = React.createElement
	local v29 = {
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp,
		isIsolated = true,
		isAutoFocusRoot = v8 ~= Constants.InterventionPlacementType.InApp,
		frameProps = {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}
	}

	local createElement5 = React.createElement
	local v32 = {
		Size = UDim2.new(1, not v16.shouldShowScrollBar and 0 or -Constants.SCROLL_BAR_WIDTH, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		tag = `col {v17} align-x-center align-y-center` .. (v16.shouldShowScrollBar and " padding-right-xsmall" or ""),
		onAbsoluteSizeChanged = v16.onInnerContentSizeChanged
	}

	local createElement6 = React.createElement
	local v34 = {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		tag = 0,
		LayoutOrder = 1
	}
	local v35 = if v5.X > 540 then `col {v17} align-x-center` else `row {v17} align-x-center align-y-center`
	v34.tag = v35

	local v37 = if props.iconName then React.createElement(icon, {
		size = props.iconSize,
		name = props.iconName,
		style = props.iconStyle,
		LayoutOrder = 1
	}) else nil

	local createElement7 = React.createElement
	local v39 = {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 2,
		tag = "col fill"
	}
	local v41

	if props.titleText then
		local createElement8 = React.createElement
		local v43 = {
			LayoutOrder = 1,
			Text = props.titleText,
			textStyle = v6.Color.Content.Emphasis,
			fontStyle = v6.Typography.TitleLarge,
			TextXAlignment = 0,
			TextYAlignment = 0,
			Size = 0,
			AutomaticSize = 0,
			TextWrapped = true
		}
		local v44 = if v5.X > 540 then Enum.TextXAlignment.Center else Enum.TextXAlignment.Left
		v43.TextXAlignment = v44

		v43.TextYAlignment = Enum.TextYAlignment.Center
		v43.Size = UDim2.new(1, 0, 0, 0)
		v43.AutomaticSize = Enum.AutomaticSize.Y
		v41 = createElement8(text, v43)
	end

	local v42

	if props.bodyText then
		local createElement8 = React.createElement
		local v44 = {
			LayoutOrder = 2,
			Text = props.bodyText,
			textStyle = v6.Color.Content.Default,
			fontStyle = v6.Typography.BodyMedium,
			TextXAlignment = 0,
			TextYAlignment = 0,
			Size = 0,
			AutomaticSize = 0,
			TextWrapped = true
		}
		local v45 = if v5.X > 540 then Enum.TextXAlignment.Center else Enum.TextXAlignment.Left
		v44.TextXAlignment = v45

		v44.TextYAlignment = Enum.TextYAlignment.Center
		v44.Size = UDim2.new(1, 0, 0, 0)
		v44.AutomaticSize = Enum.AutomaticSize.Y
		v42 = createElement8(text, v44)
	end

	local element = createElement(modalWindow, { screenSize = v5, isFullHeight = false }, {
		ContentContainer = createElement2(view, v23, {
			ScrollView = createElement3(scrollView, v26, {
				FocusNavigationCoreScriptsWrapper = createElement4(focusRoot, v29, {
					InnerContent = createElement5(view, v32, {
						IconAndText = createElement6(view, v34, {
							Icon = v37,
							TextContent = createElement7(view, v39, {
								TitleText = v41,
								BodyText = v42
							})
						}),
						ButtonContainer = React.createElement(
							view,
							{
								Size = UDim2.new(1, 0, 0, 0),
								AutomaticSize = Enum.AutomaticSize.Y,
								tag = "padding-x-xxsmall",
								LayoutOrder = 2
							},
							{
								ButtonStack = React.createElement(buttonStack, {
									buttons = {
										{
											buttonType = buttonType.PrimarySystem,
											props = {
												cursor = v18,
												text = v10.IUnderstandText,
												onActivated = v11,
												layoutOrder = 1
											}
										},
										{
											buttonType = buttonType.Secondary,
											props = {
												cursor = v18,
												text = v10.MistakeText,
												onActivated = v12,
												layoutOrder = 2
											}
										}
									}
								})
							}
						)
					})
				})
			})
		})
	})

	if v9 then
		return React.createElement(view, {
			Position = UDim2.fromOffset(v9.left, v9.top),
			Size = UDim2.new(1, -v9.left - v9.right, 1, -v9.top - v9.bottom),
			testId = "intervention-dialog-safe-area"
		}, { Dialog = element })
	end

	return element
end

return React.memo(LUAUFORGE_MODULE_GLOBALS_hAh_InterventionDialog)
