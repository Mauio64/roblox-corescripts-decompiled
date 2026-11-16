local InExperienceIntervention = script:FindFirstAncestor("InExperienceIntervention")
local Players = game:GetService("Players")
local parent = InExperienceIntervention.Parent
local InterventionShared = require(parent.InterventionShared)
local Constants = InterventionShared.Utils.Constants
local React = require(parent.React)
local InterventionContestFeedbackFooter = require(InExperienceIntervention.Components.InterventionContestFeedbackFooter)

local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local Text = Foundation.Text
local View = Foundation.View
local Button = Foundation.Button
local useTokens = Foundation.Hooks.useTokens

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local useStyle = UIBlox.Core.Style.useStyle
local useLayerCollector = UIBlox.Core.Layout.LayerCollector.useLayerCollector

local LocalPlayer = Players.LocalPlayer
local InExperienceInterventionAnalytics = require(InExperienceIntervention.InExperienceInterventionAnalytics)
local ScrollView = Foundation.ScrollView
local ScrollBarVisibility = Foundation.Enums.ScrollBarVisibility
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local GuiObjectUtils = require(parent.GuiObjectUtils)
local useProperty = GuiObjectUtils.useProperty

local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

local focusNavigationService = ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)

function ChatNudgeCustomDialog(props)
	local ref = React.useRef(DateTime.now().UnixTimestampMillis)
	local ref2 = React.useRef(nil)
	local state, setState = React.useState(0)
	React.useEffect(function()
		InExperienceInterventionAnalytics.sendAnalyticsEvent(
			InExperienceInterventionAnalytics.Constants.EventTypes.ModalAppeared,
			InExperienceInterventionAnalytics.Constants.InterventionTypes.Nudge,
			ref.current,
			props.eventId,
			props.violatingChatLine,
			nil
		)
	end, { ref })
	local v = useLocalization(Constants.localizationKeys)
	local v2 = useStyle()
	local v3 = useLayerCollector()
	local v4 = useTokens()

	local v5 = useProperty(ref2, "AbsoluteSize")

	React.useEffect(function()
		local v6 = not v5 and 0 or v5.Y
		setState((math.min(v3.absoluteSize.Y - Constants.UNIBAR_HEIGHT - Constants.DIALOG_HEADER_HEIGHT, v6)))
	end, { v3.absoluteSize.Y, v5 })
	local text

	if LocalPlayer then
		text = `{LocalPlayer.DisplayName}: {props.violatingChatLine}`
	else
		text = props.violatingChatLine
	end

	local onActivated = React.useCallback(function()
		InExperienceInterventionAnalytics.sendAnalyticsEvent(
			InExperienceInterventionAnalytics.Constants.EventTypes.CtaClicked,
			InExperienceInterventionAnalytics.Constants.InterventionTypes.Nudge,
			ref.current,
			props.eventId,
			props.violatingChatLine,
			nil
		)

		props.onDismiss()
	end, { ref })
	local middleContent

	if props.violatingChatLine then
		middleContent = React.createElement(
			View,
			{ Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 1 },
			{
				Layout = React.createElement("UIListLayout", {
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, Constants.STANDARD_PADDING / 2)
				}),
				ChatIncludesTextFrame = React.createElement(
					View,
					{
						Size = UDim2.new(1, 0, 0, 0),
						LayoutOrder = 1,
						AutomaticSize = Enum.AutomaticSize.Y
					},
					{
						ChatIncludesText = React.createElement(Text, {
							Text = v.ChatIncludesText,
							fontStyle = v4.Typography.BodySmall,
							TextXAlignment = Enum.TextXAlignment.Left,
							AnchorPoint = Vector2.new(0, 0),
							AutomaticSize = Enum.AutomaticSize.XY
						})
					}
				),
				ViolatingTextFrame = React.createElement(View, {
					Size = UDim2.new(1, 0, 0, Constants.VIOLATION_HEIGHT),
					LayoutOrder = 2,
					BackgroundTransparency = 0,
					BackgroundColor3 = v2.Theme.BackgroundUIDefault.Color,
					tag = "col gap-small align-x-center align-y-center padding-x-large radius-medium stroke-default"
				}, {
					ViolationText = React.createElement(Text, {
						LayoutOrder = 2,
						Text = text,
						textStyle = v2.Theme.TextMuted,
						fontStyle = v2.Font.Body,
						Size = UDim2.new(1, 0, 0, 0),
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center,
						AutomaticSize = Enum.AutomaticSize.Y,
						TextWrapped = true,
						TextTruncate = Enum.TextTruncate.AtEnd
					})
				})
			}
		)
	end

	return React.createElement(PartialPageModal, {
		title = v.ChatBreaksRulesText,
		screenSize = v3.absoluteSize
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
							MiddleContent = middleContent,
							WarningText = React.createElement(Text, {
								LayoutOrder = 3,
								Text = v.TextChatMayBeSuspendedText,
								textStyle = v2.Theme.TextEmphasis,
								fontStyle = v2.Font.Body,
								Size = UDim2.new(1, 0, 0, 0),
								TextXAlignment = Enum.TextXAlignment.Center,
								TextYAlignment = Enum.TextYAlignment.Center,
								AutomaticSize = Enum.AutomaticSize.Y,
								TextWrapped = true
							}),
							UnderstandButtonFrame = React.createElement(
								View,
								{
									Size = UDim2.new(1, 0, 0, 0),
									AutomaticSize = Enum.AutomaticSize.Y,
									LayoutOrder = 4
								},
								{
									UnderstandButton = React.createElement(Button, {
										text = v.IUnderstandText,
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
									LayoutOrder = 5
								},
								{
									FeedbackFooter = React.createElement(InterventionContestFeedbackFooter, {
										onDismiss = props.onDismiss,
										renderTimestamp = ref.current,
										interventionType = InExperienceInterventionAnalytics.Constants.InterventionTypes.Nudge,
										eventId = props.eventId,
										violatingChatLine = props.violatingChatLine,
										duration = nil
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

return ChatNudgeCustomDialog
