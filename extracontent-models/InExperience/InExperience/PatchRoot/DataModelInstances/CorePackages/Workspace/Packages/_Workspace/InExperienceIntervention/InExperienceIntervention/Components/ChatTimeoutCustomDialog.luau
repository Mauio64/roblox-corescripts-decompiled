local InExperienceIntervention = script:FindFirstAncestor("InExperienceIntervention")
local parent = InExperienceIntervention.Parent

local React = require(parent.React)
local InterventionContestFeedbackFooter = require(InExperienceIntervention.Components.InterventionContestFeedbackFooter)

local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local Text = Foundation.Text
local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local useLayerCollector = UIBlox.Core.Layout.LayerCollector.useLayerCollector
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local useStyle = UIBlox.Core.Style.useStyle
local InterventionShared = require(parent.InterventionShared)
local Constants = InterventionShared.Utils.Constants
local InExperienceInterventionAnalytics = require(InExperienceIntervention.InExperienceInterventionAnalytics)
local View = Foundation.View
local Button = Foundation.Button
local ScrollView = Foundation.ScrollView
local ScrollBarVisibility = Foundation.Enums.ScrollBarVisibility
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local useTokens = Foundation.Hooks.useTokens
local GuiObjectUtils = require(parent.GuiObjectUtils)
local useProperty = GuiObjectUtils.useProperty

local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

local focusNavigationService = ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)

function ChatTimeoutCustomDialog(props)
	local v = useLayerCollector()
	local ref = React.useRef(DateTime.now().UnixTimestampMillis)
	local ref2 = React.useRef(nil)
	local state, setState = React.useState(0)
	local v2 = useTokens()

	local v3 = useStyle()
	local v4 = useLocalization(Constants.localizationKeys)

	local v5 = useProperty(ref2, "AbsoluteSize")

	local onActivated = React.useCallback(function()
		InExperienceInterventionAnalytics.sendAnalyticsEvent(
			InExperienceInterventionAnalytics.Constants.EventTypes.CtaClicked,
			InExperienceInterventionAnalytics.Constants.InterventionTypes.Timeout,
			ref.current,
			props.eventId,
			props.violatingChatLine,
			props.duration
		)

		props.onDismiss()
	end, { ref })

	React.useEffect(function()
		InExperienceInterventionAnalytics.sendAnalyticsEvent(
			InExperienceInterventionAnalytics.Constants.EventTypes.ModalAppeared,
			InExperienceInterventionAnalytics.Constants.InterventionTypes.Timeout,
			ref.current,
			props.eventId,
			props.violatingChatLine,
			props.duration
		)
	end, { ref })

	React.useEffect(function()
		local v6 = not v5 and 0 or v5.Y
		setState((math.min(v.absoluteSize.Y - Constants.UNIBAR_HEIGHT - Constants.DIALOG_HEADER_HEIGHT, v6)))
	end, { v.absoluteSize.Y, v5 })
	local text

	if props.duration <= 60 then
		text = v4.CannotSend1MinText
	else
		text = useLocalization({
			value = {
				Constants.localizationKeys.CannotSendText,
				number = math.ceil(props.duration / 60)
			}
		}).value
	end

	return React.createElement(PartialPageModal, {
		title = v4.TextChatSuspensionText,
		screenSize = v.absoluteSize
	}, {
		ScrollView = React.createElement(ScrollView, {
			Size = UDim2.new(1, 0, 0, state),
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.new(1, 0, 1, 0),
				scrollBarVisibility = ScrollBarVisibility.Always,
				ScrollingDirection = Enum.ScrollingDirection.Y
			}
		}, {
			FocusNavigationCoreScriptsProvider = React.createElement(
				ReactFocusNavigation.FocusNavigationContext.Provider,
				{ value = focusNavigationService },
				{
					FocusNavigationCoreScriptsWrapper = React.createElement(FocusRoot, {
						surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
						isIsolated = true,
						isAutoFocusRoot = true,
						frameProps = {
							Size = UDim2.new(1, 0, 0, 0),
							AutomaticSize = Enum.AutomaticSize.Y
						}
					}, {
						InnerContent = React.createElement(View, {
							ref = ref2,
							Size = UDim2.new(1, -Constants.SCROLL_BAR_WIDTH, 0, 0),
							AutomaticSize = Enum.AutomaticSize.Y,
							tag = "col gap-large align-x-center align-y-center padding-x-small padding-top-large"
						}, {
							ChatDisabledText = React.createElement(Text, {
								LayoutOrder = 1,
								Text = text,
								textStyle = v3.Theme.TextEmphasis,
								fontStyle = v2.Typography.LabelLarge,
								Size = UDim2.new(1, 0, 0, 0),
								TextXAlignment = Enum.TextXAlignment.Center,
								TextYAlignment = Enum.TextYAlignment.Center,
								AutomaticSize = Enum.AutomaticSize.Y,
								TextWrapped = true
							}),
							WarningTextLabel = React.createElement(Text, {
								LayoutOrder = 2,
								Text = v4.MayLoseAccessText,
								tag = "padding-small size-full-800 text-wrap",
								TextWrapped = true,
								AutomaticSize = Enum.AutomaticSize.Y
							}),
							UnderstandButtonFrame = React.createElement(
								View,
								{
									Size = UDim2.new(1, 0, 0, 0),
									AutomaticSize = Enum.AutomaticSize.Y,
									LayoutOrder = 3
								},
								{
									UnderstandButton = React.createElement(Button, {
										text = v4.IUnderstandText,
										variant = ButtonVariant.Standard,
										onActivated = onActivated,
										fillBehavior = FillBehavior.Fill,
										FillDirection = Enum.FillDirection.Horizontal
									})
								}
							),
							FeedbackFrame = React.createElement(
								View,
								{
									Size = UDim2.new(1, 0, 0, 0),
									AutomaticSize = Enum.AutomaticSize.Y,
									LayoutOrder = 4
								},
								{
									FeedbackFooter = React.createElement(InterventionContestFeedbackFooter, {
										onDismiss = props.onDismiss,
										renderTimestamp = ref.current,
										interventionType = InExperienceInterventionAnalytics.Constants.InterventionTypes.Timeout,
										eventId = props.eventId,
										violatingChatLine = props.violatingChatLine,
										duration = props.duration
									})
								}
							)
						})
					})
				}
			)
		})
	})
end

return ChatTimeoutCustomDialog
