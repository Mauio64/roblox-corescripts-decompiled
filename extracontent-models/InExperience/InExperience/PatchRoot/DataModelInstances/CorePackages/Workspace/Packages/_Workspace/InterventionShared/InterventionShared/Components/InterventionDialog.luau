local InterventionShared = script:FindFirstAncestor("InterventionShared")
local parent = InterventionShared.Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local Text = Foundation.Text
local ModalWindow = UIBlox.App.Dialog.Modal.ModalWindow
local useLayerCollector = UIBlox.Core.Layout.LayerCollector.useLayerCollector
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local useStyle = UIBlox.Core.Style.useStyle
local Constants = require(InterventionShared.Utils.Constants)
local InterventionAnalytics = require(InterventionShared.InterventionAnalytics)
local Icon = Foundation.Icon
local View = Foundation.View
local ScrollView = Foundation.ScrollView
local ScrollBarVisibility = Foundation.Enums.ScrollBarVisibility
local useTokens = Foundation.Hooks.useTokens
local NotificationModalsManager = require(parent.NotificationModalsManager)
local iconsactionsaccept = UIBlox.App.ImageSet.Images["icons/actions/accept"]
local ButtonStack = UIBlox.App.Button.ButtonStack
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local useScrollFrameHeightCalculation = require(InterventionShared.Hooks.useScrollFrameHeightCalculation)
local useCursor = UIBlox.App.SelectionCursor.useCursor
local useInterventionPlacement = require(InterventionShared.Hooks.useInterventionPlacement)
local Responsive = require(parent.Responsive)
local useDeviceInsets = Responsive.useDeviceInsets
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppSupportDeviceSafeInsets = SharedFlags.FFlagLuaAppSupportDeviceSafeInsets
local defineFastFlag = game:DefineFastFlag("AppChatInterventionDeviceSafeInsets", false)

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusRoot = FocusNavigationUtils.FocusRoot

function InterventionDialog(props)
	local screenSize = useLayerCollector().absoluteSize
	local ref = React.useRef(DateTime.now().UnixTimestampMillis)
	local v = useTokens()
	local v2 = useStyle()
	local placement = useInterventionPlacement()
	local v3 = nil

	if defineFastFlag and FFlagLuaAppSupportDeviceSafeInsets then
		local v4 = useDeviceInsets()

		if placement == Constants.InterventionPlacementType.InApp then
			screenSize = Vector2.new(
				math.max(0, screenSize.X - v4.left - v4.right),
				(math.max(0, screenSize.Y - v4.top - v4.bottom))
			)
			v3 = v4
		end
	end

	local v4 = useLocalization(Constants.localizationKeys)

	local onActivated = React.useCallback(function()
		InterventionAnalytics.sendAnalyticsEvent(InterventionAnalytics.TelemetryConfigs.DialogCtaClicked, {
			eventType = InterventionAnalytics.Constants.EventTypes.CtaClicked,
			counterNamespace = props.namespaceForAnalytics,
			interventionType = props.interventionTypeForAnalytics,
			placement = placement,
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

	local onActivated2 = React.useCallback(function()
		props.onDismiss()
		NotificationModalsManager.SetUIBloxToast({
			iconImage = iconsactionsaccept,
			toastTitle = v4.TakeALookText,
			toastSubtitle = v4.FeedbackHelpsText,
			sequenceNumber = DateTime.now().UnixTimestamp,
			iconColorStyle = { Color = v2.Tokens.Color.System.Success.Color3, Transparency = 0 }
		})

		InterventionAnalytics.sendAnalyticsEvent(InterventionAnalytics.TelemetryConfigs.DialogAppealClicked, {
			eventType = InterventionAnalytics.Constants.EventTypes.AppealClicked,
			counterNamespace = props.namespaceForAnalytics,
			interventionType = props.interventionTypeForAnalytics,
			placement = placement,
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
			placement = placement,
			renderedTimestamp = ref.current,
			eventId = props.eventId,
			evidence = props.evidence,
			duration = props.durationForAnalytics
		})
	end, { ref, props.eventId })
	local screenSize2

	if v3 then
		screenSize2 = screenSize
	end

	local v5 = useScrollFrameHeightCalculation({ screenSize = screenSize2 })

	local v6 = screenSize.X > 540 and "gap-xlarge" or "gap-medium"

	local cursor = useCursor(UDim.new(0, v2.Tokens.Radius.Medium), v2.Tokens.Size.Size_100, v2.Tokens.Size.Size_50)

	local createElement = React.createElement

	local createElement2 = React.createElement
	local v7 = {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		tag = "padding-x-xlarge padding-y-large"
	}

	local createElement3 = React.createElement
	local v8 = {
		Size = UDim2.new(1, 0, 0, v5.scrollFrameContainerHeight),
		scroll = {
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.new(1, 0, 1, 0),
			scrollBarVisibility = ScrollBarVisibility.Always,
			ScrollingDirection = Enum.ScrollingDirection.Y
		}
	}

	local createElement4 = React.createElement
	local v9 = {
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
		isIsolated = true,
		isAutoFocusRoot = placement ~= Constants.InterventionPlacementType.InApp,
		frameProps = { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y }
	}

	local createElement5 = React.createElement
	local v10 = {
		Size = UDim2.new(1, not v5.shouldShowScrollBar and 0 or -Constants.SCROLL_BAR_WIDTH, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		tag = `col {v6} align-x-center align-y-center` .. (v5.shouldShowScrollBar and " padding-right-xsmall" or ""),
		onAbsoluteSizeChanged = v5.onInnerContentSizeChanged
	}

	local createElement6 = React.createElement
	local v11 = {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		tag = 0,
		LayoutOrder = 1
	}
	local tag

	if screenSize.X > 540 then
		tag = `col {v6} align-x-center`
	else
		tag = `row {v6} align-x-center align-y-center`
	end

	v11.tag = tag
	local icon

	if props.iconName then
		icon = React.createElement(Icon, {
			size = props.iconSize,
			name = props.iconName,
			style = props.iconStyle,
			LayoutOrder = 1
		})
	end

	local createElement7 = React.createElement
	local v12 = {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 2,
		tag = "col fill"
	}
	local titleText

	if props.titleText then
		local createElement8 = React.createElement
		local v13 = {
			LayoutOrder = 1,
			Text = props.titleText,
			textStyle = v.Color.Content.Emphasis,
			fontStyle = v.Typography.TitleLarge,
			TextXAlignment = 0,
			TextYAlignment = 0,
			Size = 0,
			AutomaticSize = 0,
			TextWrapped = true
		}
		local textXAlignment

		if screenSize.X > 540 then
			textXAlignment = Enum.TextXAlignment.Center
		else
			textXAlignment = Enum.TextXAlignment.Left
		end

		v13.TextXAlignment = textXAlignment

		v13.TextYAlignment = Enum.TextYAlignment.Center
		v13.Size = UDim2.new(1, 0, 0, 0)
		v13.AutomaticSize = Enum.AutomaticSize.Y
		titleText = createElement8(Text, v13)
	end

	local bodyText

	if props.bodyText then
		local createElement8 = React.createElement
		local v13 = {
			LayoutOrder = 2,
			Text = props.bodyText,
			textStyle = v.Color.Content.Default,
			fontStyle = v.Typography.BodyMedium,
			TextXAlignment = 0,
			TextYAlignment = 0,
			Size = 0,
			AutomaticSize = 0,
			TextWrapped = true
		}
		local textXAlignment

		if screenSize.X > 540 then
			textXAlignment = Enum.TextXAlignment.Center
		else
			textXAlignment = Enum.TextXAlignment.Left
		end

		v13.TextXAlignment = textXAlignment

		v13.TextYAlignment = Enum.TextYAlignment.Center
		v13.Size = UDim2.new(1, 0, 0, 0)
		v13.AutomaticSize = Enum.AutomaticSize.Y
		bodyText = createElement8(Text, v13)
	end

	local element = createElement(ModalWindow, { screenSize = screenSize, isFullHeight = false }, {
		ContentContainer = createElement2(View, v7, {
			ScrollView = createElement3(ScrollView, v8, {
				FocusNavigationCoreScriptsWrapper = createElement4(FocusRoot, v9, {
					InnerContent = createElement5(View, v10, {
						IconAndText = createElement6(View, v11, {
							Icon = icon,
							TextContent = createElement7(View, v12, {
								TitleText = titleText,
								BodyText = bodyText
							})
						}),
						ButtonContainer = React.createElement(
							View,
							{
								Size = UDim2.new(1, 0, 0, 0),
								AutomaticSize = Enum.AutomaticSize.Y,
								tag = "padding-x-xxsmall",
								LayoutOrder = 2
							},
							{
								ButtonStack = React.createElement(ButtonStack, {
									buttons = {
										{
											buttonType = ButtonType.PrimarySystem,
											props = {
												cursor = cursor,
												text = v4.IUnderstandText,
												onActivated = onActivated,
												layoutOrder = 1
											}
										},
										{
											buttonType = ButtonType.Secondary,
											props = {
												cursor = cursor,
												text = v4.MistakeText,
												onActivated = onActivated2,
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

	if v3 then
		return React.createElement(View, {
			Position = UDim2.fromOffset(v3.left, v3.top),
			Size = UDim2.new(1, -v3.left - v3.right, 1, -v3.top - v3.bottom),
			testId = "intervention-dialog-safe-area"
		}, { Dialog = element })
	end

	return element
end

return React.memo(InterventionDialog)
