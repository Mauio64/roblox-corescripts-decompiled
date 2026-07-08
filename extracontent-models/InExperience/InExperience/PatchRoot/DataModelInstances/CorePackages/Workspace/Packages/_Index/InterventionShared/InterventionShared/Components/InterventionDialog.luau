local InterventionShared = script:FindFirstAncestor("InterventionShared")
local InterventionSharedParent = InterventionShared.Parent
local React = require(InterventionSharedParent.React)
local UIBlox = require(InterventionSharedParent.UIBlox)
local Foundation = require(InterventionSharedParent.Foundation)
local FoundationText = Foundation.Text
local ModalWindow = UIBlox.App.Dialog.Modal.ModalWindow
local useLayerCollector = UIBlox.Core.Layout.LayerCollector.useLayerCollector
local useLocalization = require(InterventionSharedParent.Localization).Hooks.useLocalization
local useStyle = UIBlox.Core.Style.useStyle
local Constants = require(InterventionShared.Utils.Constants)
local InterventionAnalytics = require(InterventionShared.InterventionAnalytics)
local Icon = Foundation.Icon
local View = Foundation.View
local ScrollView = Foundation.ScrollView
local ScrollBarVisibility = Foundation.Enums.ScrollBarVisibility
local useTokens = Foundation.Hooks.useTokens
local NotificationModalsManager = require(InterventionSharedParent.NotificationModalsManager)
local v19 = UIBlox.App.ImageSet.Images["icons/actions/accept"]
local ButtonStack = UIBlox.App.Button.ButtonStack
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local useScrollFrameHeightCalculation = require(InterventionShared.Hooks.useScrollFrameHeightCalculation)
local useCursor = UIBlox.App.SelectionCursor.useCursor
local useInterventionPlacement = require(InterventionShared.Hooks.useInterventionPlacement)
local FocusNavigationUtils = require(InterventionSharedParent.FocusNavigationUtils)
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusRoot = FocusNavigationUtils.FocusRoot

function InterventionDialog(t1: {[any]: any}) -- line: 48
	-- upvalues: useLayerCollector (copy), React (copy), useTokens (copy), useStyle (copy), useInterventionPlacement (copy), useLocalization (copy), Constants (copy), InterventionAnalytics (copy), NotificationModalsManager (copy), v19 (copy), useScrollFrameHeightCalculation (copy), useCursor (copy), ModalWindow (copy), View (copy), ScrollView (copy), ScrollBarVisibility (copy), FocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy), Icon (copy), FoundationText (copy), ButtonStack (copy), ButtonType (copy)
	local absoluteSize = useLayerCollector().absoluteSize
	local v30 = React.useRef(DateTime.now().UnixTimestampMillis)
	local v31 = useTokens()
	local v32 = useStyle()
	local v33 = useInterventionPlacement()
	local v34 = useLocalization(Constants.localizationKeys)
	local v35 = React.useCallback(function() -- line: 59
		-- upvalues: InterventionAnalytics (copy), t1 (copy), v33 (copy), v30 (copy)
		InterventionAnalytics.sendAnalyticsEvent(InterventionAnalytics.TelemetryConfigs.DialogCtaClicked, {
			eventType = InterventionAnalytics.Constants.EventTypes.CtaClicked,
			counterNamespace = t1.namespaceForAnalytics,
			interventionType = t1.interventionTypeForAnalytics,
			placement = v33,
			renderedTimestamp = v30.current,
			eventId = t1.eventId,
			evidence = t1.evidence,
			duration = t1.durationForAnalytics
		})
		t1.onDismiss()
	end, {
		v30,
		t1.interventionTypeForAnalytics,
		t1.eventId,
		t1.evidence,
		t1.durationForAnalytics,
		t1.onDismiss
	})
	local v36 = React.useCallback(function() -- line: 83
		-- upvalues: t1 (copy), NotificationModalsManager (copy), v19 (copy), v34 (copy), v32 (copy), InterventionAnalytics (copy), v33 (copy), v30 (copy)
		t1.onDismiss()
		NotificationModalsManager.SetUIBloxToast({
			iconImage = v19,
			toastTitle = v34.TakeALookText,
			toastSubtitle = v34.FeedbackHelpsText,
			sequenceNumber = DateTime.now().UnixTimestamp,
			iconColorStyle = {
				Transparency = 0,
				Color = v32.Tokens.Color.System.Success.Color3
			}
		})
		InterventionAnalytics.sendAnalyticsEvent(InterventionAnalytics.TelemetryConfigs.DialogAppealClicked, {
			eventType = InterventionAnalytics.Constants.EventTypes.AppealClicked,
			counterNamespace = t1.namespaceForAnalytics,
			interventionType = t1.interventionTypeForAnalytics,
			placement = v33,
			renderedTimestamp = v30.current,
			eventId = t1.eventId,
			evidence = t1.evidence,
			duration = t1.durationForAnalytics
		})
	end, {
		t1.onDismiss,
		t1.interventionTypeForAnalytics,
		t1.eventId,
		t1.evidence,
		t1.durationForAnalytics
	})

	React.useEffect(function() -- line: 118
		-- upvalues: InterventionAnalytics (copy), t1 (copy), v33 (copy), v30 (copy)
		InterventionAnalytics.sendAnalyticsEvent(InterventionAnalytics.TelemetryConfigs.DialogRendered, {
			eventType = InterventionAnalytics.Constants.EventTypes.ModalAppeared,
			counterNamespace = t1.namespaceForAnalytics,
			interventionType = t1.interventionTypeForAnalytics,
			placement = v33,
			renderedTimestamp = v30.current,
			eventId = t1.eventId,
			evidence = t1.evidence,
			duration = t1.durationForAnalytics
		})
	end, {
		v30,
		t1.eventId
	})

	local v37 = useScrollFrameHeightCalculation({})
	local v38 = not (absoluteSize.X > 540) and "gap-medium" or "gap-xlarge"
	local v39 = useCursor(UDim.new(0, v32.Tokens.Radius.Medium), v32.Tokens.Size.Size_100, v32.Tokens.Size.Size_50)

	return React.createElement(ModalWindow, {
		isFullHeight = false,
		screenSize = absoluteSize
	}, {
		ContentContainer = React.createElement(View, {
			tag = "padding-x-xlarge padding-y-large",
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			ScrollView = React.createElement(ScrollView, {
				Size = UDim2.new(1, 0, 0, v37.scrollFrameContainerHeight),
				scroll = {
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					CanvasSize = UDim2.new(1, 0, 1, 0),
					scrollBarVisibility = ScrollBarVisibility.Always,
					ScrollingDirection = Enum.ScrollingDirection.Y
				}
			}, {
				FocusNavigationCoreScriptsWrapper = React.createElement(FocusRoot, {
					isIsolated = true,
					surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
					isAutoFocusRoot = v33 ~= Constants.InterventionPlacementType.InApp,
					frameProps = {
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y
					}
				}, {
					InnerContent = React.createElement(View, {
						Size = UDim2.new(1, not v37.shouldShowScrollBar and 0 or -Constants.SCROLL_BAR_WIDTH, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						tag = `col { v38 } align-x-center align-y-center` .. (not v37.shouldShowScrollBar and "" or " padding-right-xsmall"),
						onAbsoluteSizeChanged = v37.onInnerContentSizeChanged
					}, {
						IconAndText = React.createElement(View, {
							LayoutOrder = 1,
							Size = UDim2.new(1, 0, 0, 0),
							AutomaticSize = Enum.AutomaticSize.Y,
							tag = if not (absoluteSize.X > 540) then `row { v38 } align-x-center align-y-center` else `col { v38 } align-x-center`
						}, {
							Icon = if not t1.iconName then nil else React.createElement(Icon, {
								LayoutOrder = 1,
								size = t1.iconSize,
								name = t1.iconName,
								style = t1.iconStyle
							}),
							TextContent = React.createElement(View, {
								LayoutOrder = 2,
								tag = "col fill",
								Size = UDim2.new(1, 0, 0, 0),
								AutomaticSize = Enum.AutomaticSize.Y
							}, {
								TitleText = if not t1.titleText then nil else React.createElement(FoundationText, {
									LayoutOrder = 1,
									TextWrapped = true,
									Text = t1.titleText,
									textStyle = v31.Color.Content.Emphasis,
									fontStyle = v31.Typography.TitleLarge,
									TextXAlignment = if not (absoluteSize.X > 540) then Enum.TextXAlignment.Left else Enum.TextXAlignment.Center,
									TextYAlignment = Enum.TextYAlignment.Center,
									Size = UDim2.new(1, 0, 0, 0),
									AutomaticSize = Enum.AutomaticSize.Y
								}),
								BodyText = if not t1.bodyText then nil else React.createElement(FoundationText, {
									LayoutOrder = 2,
									TextWrapped = true,
									Text = t1.bodyText,
									textStyle = v31.Color.Content.Default,
									fontStyle = v31.Typography.BodyMedium,
									TextXAlignment = if not (absoluteSize.X > 540) then Enum.TextXAlignment.Left else Enum.TextXAlignment.Center,
									TextYAlignment = Enum.TextYAlignment.Center,
									Size = UDim2.new(1, 0, 0, 0),
									AutomaticSize = Enum.AutomaticSize.Y
								})
							})
						}),
						ButtonContainer = React.createElement(View, {
							LayoutOrder = 2,
							Size = UDim2.new(1, 0, 0, 0),
							AutomaticSize = Enum.AutomaticSize.Y
						}, {
							ButtonStack = React.createElement(ButtonStack, {
								buttons = {
									{
										buttonType = ButtonType.PrimarySystem,
										props = {
											layoutOrder = 1,
											cursor = v39,
											text = v34.IUnderstandText,
											onActivated = v35
										}
									},
									{
										buttonType = ButtonType.Secondary,
										props = {
											layoutOrder = 2,
											cursor = v39,
											text = v34.MistakeText,
											onActivated = v36
										}
									}
								}
							})
						})
					})
				})
			})
		})
	})
end

return React.memo(InterventionDialog)
