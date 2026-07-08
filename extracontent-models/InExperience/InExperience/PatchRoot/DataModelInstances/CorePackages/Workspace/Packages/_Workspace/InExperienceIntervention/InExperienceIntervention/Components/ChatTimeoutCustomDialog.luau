local InExperienceIntervention = script:FindFirstAncestor("InExperienceIntervention")
local InExperienceInterventionParent = InExperienceIntervention.Parent
local React = require(InExperienceInterventionParent.React)
local InterventionContestFeedbackFooter = require(InExperienceIntervention.Components.InterventionContestFeedbackFooter)
local UIBlox = require(InExperienceInterventionParent.UIBlox)
local Foundation = require(InExperienceInterventionParent.Foundation)
local FoundationText = Foundation.Text
local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local useLayerCollector = UIBlox.Core.Layout.LayerCollector.useLayerCollector
local useLocalization = require(InExperienceInterventionParent.Localization).Hooks.useLocalization
local useStyle = UIBlox.Core.Style.useStyle
local Constants = require(InExperienceInterventionParent.InterventionShared).Utils.Constants
local InExperienceInterventionAnalytics = require(InExperienceIntervention.InExperienceInterventionAnalytics)
local View = Foundation.View
local Button = Foundation.Button
local ScrollView = Foundation.ScrollView
local ScrollBarVisibility = Foundation.Enums.ScrollBarVisibility
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local useTokens = Foundation.Hooks.useTokens
local useProperty = require(InExperienceInterventionParent.GuiObjectUtils).useProperty
local ReactFocusNavigation = require(InExperienceInterventionParent.ReactFocusNavigation)
local FocusNavigationUtils = require(InExperienceInterventionParent.FocusNavigationUtils)
local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local v26 = ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)

function ChatTimeoutCustomDialog(t1: {[any]: any}) -- line: 39
	-- upvalues: useLayerCollector (copy), React (copy), useTokens (copy), useStyle (copy), useLocalization (copy), Constants (copy), useProperty (copy), InExperienceInterventionAnalytics (copy), PartialPageModal (copy), ScrollView (copy), ScrollBarVisibility (copy), ReactFocusNavigation (copy), v26 (copy), FocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy), View (copy), FoundationText (copy), Button (copy), ButtonVariant (copy), FillBehavior (copy), InterventionContestFeedbackFooter (copy)
	local v28 = useLayerCollector()
	local v29 = React.useRef(DateTime.now().UnixTimestampMillis)
	local v30 = React.useRef(nil)
	local v31, v32 = React.useState(0)
	local v33 = useTokens()
	local v34 = useStyle()
	local v35 = useLocalization(Constants.localizationKeys)
	local v36 = useProperty(v30, "AbsoluteSize")
	local v37 = React.useCallback(function() -- line: 53
		-- upvalues: InExperienceInterventionAnalytics (copy), v29 (copy), t1 (copy)
		InExperienceInterventionAnalytics.sendAnalyticsEvent(InExperienceInterventionAnalytics.Constants.EventTypes.CtaClicked, InExperienceInterventionAnalytics.Constants.InterventionTypes.Timeout, v29.current, t1.eventId, t1.violatingChatLine, t1.duration)
		t1.onDismiss()
	end, { v29 })

	React.useEffect(function() -- line: 65
		-- upvalues: InExperienceInterventionAnalytics (copy), v29 (copy), t1 (copy)
		InExperienceInterventionAnalytics.sendAnalyticsEvent(InExperienceInterventionAnalytics.Constants.EventTypes.ModalAppeared, InExperienceInterventionAnalytics.Constants.InterventionTypes.Timeout, v29.current, t1.eventId, t1.violatingChatLine, t1.duration)
	end, { v29 })
	React.useEffect(function() -- line: 76
		-- upvalues: v36 (copy), v28 (copy), Constants (copy), v32 (copy)
		local v39 = not v36 and 0 or v36.Y
		local v40 = math.min(v28.absoluteSize.Y - Constants.UNIBAR_HEIGHT - Constants.DIALOG_HEADER_HEIGHT, v39)

		v32(v40)
	end, {
		v28.absoluteSize.Y,
		v36
	})

	local v38 = if not (t1.duration <= 60) then useLocalization({
		value = {
			Constants.localizationKeys.CannotSendText,
			number = math.ceil(t1.duration / 60)
		}
	}).value else v35.CannotSend1MinText

	return React.createElement(PartialPageModal, {
		title = v35.TextChatSuspensionText,
		screenSize = v28.absoluteSize
	}, {
		ScrollView = React.createElement(ScrollView, {
			Size = UDim2.new(1, 0, 0, v31),
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.new(1, 0, 1, 0),
				scrollBarVisibility = ScrollBarVisibility.Always,
				ScrollingDirection = Enum.ScrollingDirection.Y
			}
		}, {
			FocusNavigationCoreScriptsProvider = React.createElement(ReactFocusNavigation.FocusNavigationContext.Provider, {
				value = v26
			}, {
				FocusNavigationCoreScriptsWrapper = React.createElement(FocusRoot, {
					isIsolated = true,
					isAutoFocusRoot = true,
					surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
					frameProps = {
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y
					}
				}, {
					InnerContent = React.createElement(View, {
						tag = "col gap-large align-x-center align-y-center padding-x-small padding-top-large",
						ref = v30,
						Size = UDim2.new(1, -Constants.SCROLL_BAR_WIDTH, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y
					}, {
						ChatDisabledText = React.createElement(FoundationText, {
							LayoutOrder = 1,
							TextWrapped = true,
							Text = v38,
							textStyle = v34.Theme.TextEmphasis,
							fontStyle = v33.Typography.LabelLarge,
							Size = UDim2.new(1, 0, 0, 0),
							TextXAlignment = Enum.TextXAlignment.Center,
							TextYAlignment = Enum.TextYAlignment.Center,
							AutomaticSize = Enum.AutomaticSize.Y
						}),
						WarningTextLabel = React.createElement(FoundationText, {
							LayoutOrder = 2,
							tag = "padding-small size-full-800 text-wrap",
							TextWrapped = true,
							Text = v35.MayLoseAccessText,
							AutomaticSize = Enum.AutomaticSize.Y
						}),
						UnderstandButtonFrame = React.createElement(View, {
							LayoutOrder = 3,
							Size = UDim2.new(1, 0, 0, 0),
							AutomaticSize = Enum.AutomaticSize.Y
						}, {
							UnderstandButton = React.createElement(Button, {
								text = v35.IUnderstandText,
								variant = ButtonVariant.Standard,
								onActivated = v37,
								fillBehavior = FillBehavior.Fill,
								FillDirection = Enum.FillDirection.Horizontal
							})
						}),
						FeedbackFrame = React.createElement(View, {
							LayoutOrder = 4,
							Size = UDim2.new(1, 0, 0, 0),
							AutomaticSize = Enum.AutomaticSize.Y
						}, {
							FeedbackFooter = React.createElement(InterventionContestFeedbackFooter, {
								onDismiss = t1.onDismiss,
								renderTimestamp = v29.current,
								interventionType = InExperienceInterventionAnalytics.Constants.InterventionTypes.Timeout,
								eventId = t1.eventId,
								violatingChatLine = t1.violatingChatLine,
								duration = t1.duration
							})
						})
					})
				})
			})
		})
	})
end

return ChatTimeoutCustomDialog
