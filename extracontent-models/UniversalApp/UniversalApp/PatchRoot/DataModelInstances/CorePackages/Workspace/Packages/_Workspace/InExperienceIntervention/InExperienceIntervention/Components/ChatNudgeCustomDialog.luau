local InExperienceIntervention = script:FindFirstAncestor("InExperienceIntervention")
local Players = game:GetService("Players")
local InExperienceInterventionParent = InExperienceIntervention.Parent
local Constants = require(InExperienceInterventionParent.InterventionShared).Utils.Constants
local React = require(InExperienceInterventionParent.React)
local InterventionContestFeedbackFooter = require(InExperienceIntervention.Components.InterventionContestFeedbackFooter)
local UIBlox = require(InExperienceInterventionParent.UIBlox)
local Foundation = require(InExperienceInterventionParent.Foundation)
local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local FoundationText = Foundation.Text
local View = Foundation.View
local Button = Foundation.Button
local useTokens = Foundation.Hooks.useTokens
local useLocalization = require(InExperienceInterventionParent.Localization).Hooks.useLocalization
local useStyle = UIBlox.Core.Style.useStyle
local useLayerCollector = UIBlox.Core.Layout.LayerCollector.useLayerCollector
local LocalPlayer = Players.LocalPlayer
local InExperienceInterventionAnalytics = require(InExperienceIntervention.InExperienceInterventionAnalytics)
local ScrollView = Foundation.ScrollView
local ScrollBarVisibility = Foundation.Enums.ScrollBarVisibility
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local useProperty = require(InExperienceInterventionParent.GuiObjectUtils).useProperty
local ReactFocusNavigation = require(InExperienceInterventionParent.ReactFocusNavigation)
local FocusNavigationUtils = require(InExperienceInterventionParent.FocusNavigationUtils)
local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local v28 = ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)

function ChatNudgeCustomDialog(t1: {[any]: any}) -- line: 41
	-- upvalues: React (copy), InExperienceInterventionAnalytics (copy), useLocalization (copy), Constants (copy), useStyle (copy), useLayerCollector (copy), useTokens (copy), useProperty (copy), LocalPlayer (copy), View (copy), FoundationText (copy), PartialPageModal (copy), ScrollView (copy), ScrollBarVisibility (copy), ReactFocusNavigation (copy), v28 (copy), FocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy), Button (copy), ButtonVariant (copy), FillBehavior (copy), InterventionContestFeedbackFooter (copy)
	local v30 = React.useRef(DateTime.now().UnixTimestampMillis)
	local v31 = React.useRef(nil)
	local v32, v33 = React.useState(0)

	React.useEffect(function() -- line: 45
		-- upvalues: InExperienceInterventionAnalytics (copy), v30 (copy), t1 (copy)
		InExperienceInterventionAnalytics.sendAnalyticsEvent(InExperienceInterventionAnalytics.Constants.EventTypes.ModalAppeared, InExperienceInterventionAnalytics.Constants.InterventionTypes.Nudge, v30.current, t1.eventId, t1.violatingChatLine, nil)
	end, { v30 })

	local v34 = useLocalization(Constants.localizationKeys)
	local v35 = useStyle()
	local v36 = useLayerCollector()
	local v37 = useTokens()
	local v38 = useProperty(v31, "AbsoluteSize")

	React.useEffect(function() -- line: 64
		-- upvalues: v38 (copy), v36 (copy), Constants (copy), v33 (copy)
		local v42 = not v38 and 0 or v38.Y
		local v43 = math.min(v36.absoluteSize.Y - Constants.UNIBAR_HEIGHT - Constants.DIALOG_HEADER_HEIGHT, v42)

		v33(v43)
	end, {
		v36.absoluteSize.Y,
		v38
	})

	local v39 = if not LocalPlayer then t1.violatingChatLine else `{ LocalPlayer.DisplayName }: { t1.violatingChatLine }`
	local v40 = React.useCallback(function() -- line: 75
		-- upvalues: InExperienceInterventionAnalytics (copy), v30 (copy), t1 (copy)
		InExperienceInterventionAnalytics.sendAnalyticsEvent(InExperienceInterventionAnalytics.Constants.EventTypes.CtaClicked, InExperienceInterventionAnalytics.Constants.InterventionTypes.Nudge, v30.current, t1.eventId, t1.violatingChatLine, nil)
		t1.onDismiss()
	end, { v30 })
	local v41 = if not t1.violatingChatLine then nil else React.createElement(View, {
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		Layout = React.createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, Constants.STANDARD_PADDING / 2)
		}),
		ChatIncludesTextFrame = React.createElement(View, {
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			ChatIncludesText = React.createElement(FoundationText, {
				Text = v34.ChatIncludesText,
				fontStyle = v37.Typography.BodySmall,
				TextXAlignment = Enum.TextXAlignment.Left,
				AnchorPoint = Vector2.new(0, 0),
				AutomaticSize = Enum.AutomaticSize.XY
			})
		}),
		ViolatingTextFrame = React.createElement(View, {
			LayoutOrder = 2,
			BackgroundTransparency = 0,
			tag = "col gap-small align-x-center align-y-center padding-x-large radius-medium stroke-default",
			Size = UDim2.new(1, 0, 0, Constants.VIOLATION_HEIGHT),
			BackgroundColor3 = v35.Theme.BackgroundUIDefault.Color
		}, {
			ViolationText = React.createElement(FoundationText, {
				LayoutOrder = 2,
				TextWrapped = true,
				Text = v39,
				textStyle = v35.Theme.TextMuted,
				fontStyle = v35.Font.Body,
				Size = UDim2.new(1, 0, 0, 0),
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				AutomaticSize = Enum.AutomaticSize.Y,
				TextTruncate = Enum.TextTruncate.AtEnd
			})
		})
	})

	return React.createElement(PartialPageModal, {
		title = v34.ChatBreaksRulesText,
		screenSize = v36.absoluteSize
	}, {
		ScrollView = React.createElement(ScrollView, {
			Size = UDim2.new(1, 0, 0, v32),
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.new(1, 0, 1, 0),
				scrollBarVisibility = ScrollBarVisibility.Always,
				ScrollingDirection = Enum.ScrollingDirection.Y
			}
		}, {
			FocusNavigationCoreScriptsProvider = React.createElement(ReactFocusNavigation.FocusNavigationContext.Provider, {
				value = v28
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
						ref = v31,
						Size = UDim2.new(1, -Constants.SCROLL_BAR_WIDTH, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y
					}, {
						MiddleContent = v41,
						WarningText = React.createElement(FoundationText, {
							LayoutOrder = 3,
							TextWrapped = true,
							Text = v34.TextChatMayBeSuspendedText,
							textStyle = v35.Theme.TextEmphasis,
							fontStyle = v35.Font.Body,
							Size = UDim2.new(1, 0, 0, 0),
							TextXAlignment = Enum.TextXAlignment.Center,
							TextYAlignment = Enum.TextYAlignment.Center,
							AutomaticSize = Enum.AutomaticSize.Y
						}),
						UnderstandButtonFrame = React.createElement(View, {
							LayoutOrder = 4,
							Size = UDim2.new(1, 0, 0, 0),
							AutomaticSize = Enum.AutomaticSize.Y
						}, {
							UnderstandButton = React.createElement(Button, {
								text = v34.IUnderstandText,
								variant = ButtonVariant.Standard,
								onActivated = v40,
								fillBehavior = FillBehavior.Fill,
								FillDirection = Enum.FillDirection.Horizontal
							})
						}),
						FeedbackFrame = React.createElement(View, {
							LayoutOrder = 5,
							Size = UDim2.new(1, 0, 0, 0),
							AutomaticSize = Enum.AutomaticSize.Y
						}, {
							FeedbackFooter = React.createElement(InterventionContestFeedbackFooter, {
								duration = nil,
								onDismiss = t1.onDismiss,
								renderTimestamp = v30.current,
								interventionType = InExperienceInterventionAnalytics.Constants.InterventionTypes.Nudge,
								eventId = t1.eventId,
								violatingChatLine = t1.violatingChatLine
							})
						})
					})
				})
			})
		})
	})
end

return ChatNudgeCustomDialog
