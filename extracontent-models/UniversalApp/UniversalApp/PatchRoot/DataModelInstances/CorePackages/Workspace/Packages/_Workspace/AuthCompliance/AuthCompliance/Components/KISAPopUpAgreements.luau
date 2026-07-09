local ParentParent = script.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local ParentParentParent = ParentParent.Parent
local AnalyticsEvents = require(ParentParent.Analytics.AnalyticsEvents)
local EventConstants = require(ParentParent.Analytics.EventConstants)
local React = dependencies.React
local UIBlox = dependencies.UIBlox
local Foundation = dependencies.Foundation
local FFlagKISAUserAgreementsRedesign = dependencies.SharedFlags.FFlagKISAUserAgreementsRedesign
local Checkbox = Foundation.Checkbox
local Button = Foundation.Button
local FoundationText = Foundation.Text
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local RoactRodux = dependencies.RoactRodux
local useLocalization = dependencies.Localization.Hooks.useLocalization
local FormFactor = require(ParentParentParent.FormFactor).Enums.FormFactor
local FitFrame = dependencies.FitFrame
local useDesignTokens = dependencies.Style.useDesignTokens
local CloseCentralOverlay = dependencies.CentralOverlay.Thunks.CloseCentralOverlay
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useState = React.useState
local useStyle = UIBlox.Core.Style.useStyle
local Button2 = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local IconButton = UIBlox.App.Button.IconButton
local Images = UIBlox.App.ImageSet.Images
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local UserAgreementsList = dependencies.UserAgreements.UserAgreementsList
local KISAComplianceUtils = require(ParentParent.KISAComplianceUtils)
local rect = Rect.new(8, 8, 9, 9)

return (RoactRodux.connect(function(p1) -- line: 500
	return {
		screenSize = p1.ScreenSize,
		formFactor = p1.FormFactor
	}
end, function(p2) -- line: 505
	-- upvalues: CloseCentralOverlay (copy)
	return {
		closeCentralOverlay = function() -- line: 507
			-- upvalues: p2 (copy), CloseCentralOverlay (copy)
			return p2(CloseCentralOverlay())
		end
	}
end)(function(t1: {[any]: any}) -- line: 64
	-- upvalues: useStyle (copy), FormFactor (copy), useDesignTokens (copy), useLocalization (copy), useState (copy), KISAComplianceUtils (copy), ImageSetLabel (copy), rect (copy), EventConstants (copy), AnalyticsEvents (copy), React (copy), IconButton (copy), Images (copy), FFlagKISAUserAgreementsRedesign (copy), FoundationText (copy), StyledTextLabel (copy), Checkbox (copy), UserAgreementsList (copy), FitFrame (copy), Button (copy), ButtonVariant (copy), InputSize (copy), Button2 (copy), ButtonType (copy)
	t1.isUnderAgeFlow = t1.isUnderAgeFlow or false

	local screenSize = t1.screenSize
	local v34 = useStyle()
	local Theme = v34.Theme
	local Font = v34.Font
	local v37 = tostring(t1.formFactor) == tostring(FormFactor.WIDE)
	local v38 = useDesignTokens()
	local AuthCompliance = v38.LuaApps.AuthCompliance
	local v40 = useLocalization({
		title = "Authentication.OneTimePasscode.Label.ConsentNeeded",
		message = "CommonUI.UserAgreements.Popup.KISAMessage",
		agreeButton = "CommonUI.UserAgreements.Popup.Agree2",
		checkbox = "CommonUI.UserAgreements.Popup.CheckboxMessage",
		errorMessage = "CommonUI.UserAgreements.Popup.FailAndRetryMessage",
		underAgeFlowTitle = "Authentication.OneTimePasscode.Label.ParentConsentNeeded",
		underAgeFlowMessage = "Authentication.OneTimePasscode.Description.ReviewAndConsentToTerms"
	})
	local v41, v42 = useState({})
	local v43, v44 = useState({})

	if v43 ~= t1.agreements then
		v44(t1.agreements)

		local t2 = {}

		for _, v in pairs(t1.agreements) do
			t2[v.id] = false
		end

		v42(t2)
	end

	local v48, v49, v50 = KISAComplianceUtils.getCheckBoxStatusVariables(v41, t1.agreements)
	local v51 = not v48
	local v52, v53 = (function(p3, p4) -- line: 106
		-- upvalues: ImageSetLabel (copy), rect (copy)
		if p3 then
			return ImageSetLabel, {
				Image = "LuaApp/buttons/buttonFill",
				BorderSizePixel = 0,
				Size = UDim2.new(0, 540, 0, 0),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = p4.BackgroundUIDefault.Color,
				ImageColor3 = p4.BackgroundUIDefault.Color,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = rect,
				AutomaticSize = Enum.AutomaticSize.Y
			}
		end

		return "Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = p4.BackgroundUIDefault.Color
		}
	end)(v37, Theme)

	local function v54(p5) -- line: 135
		-- upvalues: EventConstants (copy), AnalyticsEvents (copy), v41 (copy), v42 (copy)
		local v60 = if not p5 then EventConstants.btn.disagreeAllCheckboxes else EventConstants.btn.agreeAllCheckboxes

		AnalyticsEvents.sendButtonClickEvent(EventConstants.ctx.kisaAgreements, EventConstants.origin.signup, v60)

		local t3 = {}

		for k, _ in pairs(v41) do
			t3[k] = p5
		end

		v42(t3)
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, screenSize.Y)
	}, {
		Layout = React.createElement(v52, v53, {
			ListLayout = v37 and React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Padding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, AuthCompliance.paddingTop),
				PaddingBottom = UDim.new(0, AuthCompliance.paddingBottom)
			}),
			Content = React.createElement("Frame", {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, screenSize.Y - 150)
			}, {
				Layout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				Title = React.createElement("Frame", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, 0)
				}, {
					AreaAboveFirstDivider = React.createElement("Frame", {
						LayoutOrder = 1,
						BorderSizePixel = 0,
						BackgroundTransparency = 1,
						AutomaticSize = Enum.AutomaticSize.Y,
						Size = UDim2.new(1, 0, 0, 0)
					}, {
						ListLayout = React.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Horizontal,
							VerticalAlignment = Enum.VerticalAlignment.Center,
							SortOrder = Enum.SortOrder.LayoutOrder
						}),
						Padding = React.createElement("UIPadding", {
							PaddingLeft = UDim.new(0, AuthCompliance.paddingLeft)
						}),
						CrossXButton = React.createElement(IconButton, {
							layoutOrder = 1,
							anchorPoint = Vector2.new(0.5, 0.5),
							size = UDim2.new(0, tonumber(AuthCompliance.xButtonSize), 0, (tonumber(AuthCompliance.xButtonSize))),
							position = UDim2.new(0, 0, 0, 0),
							icon = Images["icons/navigation/close"],
							onActivated = function() -- line: 222
								-- upvalues: t1 (copy)
								if t1.onAbandonFunction then
									t1.onAbandonFunction()
								end

								t1.closeCentralOverlay()
							end
						}),
						TitleText = if not FFlagKISAUserAgreementsRedesign then React.createElement(StyledTextLabel, {
							layoutOrder = 2,
							size = UDim2.new(0.75, 0, 0, AuthCompliance.xButtonSize),
							text = if not t1.isUnderAgeFlow then v40.title else v40.underAgeFlowTitle,
							fontStyle = Font.Header1,
							colorStyle = Theme.TextEmphasis,
							textXAlignment = Enum.TextXAlignment.Center,
							textYAlignment = Enum.TextYAlignment.Center,
							textTruncate = Enum.TextTruncate.AtEnd
						}) else React.createElement(FoundationText, {
							LayoutOrder = 2,
							BackgroundTransparency = 1,
							tag = "text-heading-small text-align-x-center text-align-y-center content-emphasis",
							Size = UDim2.new(0.75, 0, 0, AuthCompliance.xButtonSize),
							Text = if not t1.isUnderAgeFlow then v40.title else v40.underAgeFlowTitle,
							TextTruncate = Enum.TextTruncate.AtEnd
						})
					}),
					FirstDivider = React.createElement("Frame", {
						LayoutOrder = 2,
						BorderSizePixel = 0,
						BackgroundTransparency = 1,
						AutomaticSize = Enum.AutomaticSize.Y,
						Size = UDim2.new(1, 0, 0, 0)
					}, {
						Padding = React.createElement("UIPadding", {
							PaddingTop = UDim.new(0, AuthCompliance.dividerPaddingTop),
							PaddingRight = if not FFlagKISAUserAgreementsRedesign then UDim.new(0, AuthCompliance.paddingRight) else UDim.new(0, 0),
							PaddingLeft = if not FFlagKISAUserAgreementsRedesign then UDim.new(0, AuthCompliance.paddingLeft) else UDim.new(0, 0)
						}),
						Divider = React.createElement("Frame", {
							BorderSizePixel = 0,
							Size = UDim2.new(1, 0, 0, 1),
							AnchorPoint = Vector2.new(0, 0),
							BackgroundColor3 = if not FFlagKISAUserAgreementsRedesign then v38.Color.Shift.Shift_200.Color3 else v38.Color.Stroke.Default.Color3,
							BackgroundTransparency = not FFlagKISAUserAgreementsRedesign and 0 or v38.Color.Stroke.Default.Transparency
						})
					})
				}),
				Message = React.createElement("Frame", {
					LayoutOrder = 2,
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0)
				}, {
					Padding = React.createElement("UIPadding", {
						PaddingTop = UDim.new(0, if not v37 then AuthCompliance.messagePaddingTopExtended else AuthCompliance.messagePaddingTopWideViewExtended),
						PaddingRight = UDim.new(0, AuthCompliance.paddingRight),
						PaddingBottom = UDim.new(0, if not v37 then AuthCompliance.messagePaddingBottomReduced else AuthCompliance.messagePaddingBottomWideView),
						PaddingLeft = UDim.new(0, AuthCompliance.paddingLeft)
					}),
					MessageText = React.createElement("TextLabel", {
						BackgroundTransparency = 1,
						TextWrapped = true,
						Text = if not t1.isUnderAgeFlow then v40.message else v40.underAgeFlowMessage,
						TextSize = if not FFlagKISAUserAgreementsRedesign then AuthCompliance.messageSize else v38.Typography.BodyMedium.FontSize,
						TextColor3 = v38.Color.Content.Emphasis.Color3,
						TextTransparency = v34.Theme.TextDefault.Transparency,
						Font = if not FFlagKISAUserAgreementsRedesign then v34.Font.Body.Font else v38.Typography.BodyMedium.Font,
						TextXAlignment = Enum.TextXAlignment.Left,
						AutomaticSize = Enum.AutomaticSize.Y,
						Size = UDim2.new(1, 0, 0, 0)
					})
				}),
				AgreementsContainer = React.createElement("Frame", {
					LayoutOrder = 3,
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0)
				}, {
					Padding = React.createElement("UIPadding", {
						PaddingTop = UDim.new(0, 0),
						PaddingRight = UDim.new(0, AuthCompliance.paddingRight),
						PaddingBottom = UDim.new(0, AuthCompliance.checkboxPaddingBottom),
						PaddingLeft = UDim.new(0, AuthCompliance.paddingLeft)
					}),
					CheckBox = React.createElement(Checkbox, {
						label = "",
						isChecked = v50,
						onActivated = function() -- line: 348
							-- upvalues: v54 (copy), v50 (copy)
							v54(not v50)
						end
					}),
					MessageButton = React.createElement("TextButton", {
						Size = UDim2.new(1, -((tonumber(AuthCompliance.checkboxSize) or 0) + (tonumber(AuthCompliance.checkboxPadding) or 0)), 1, 0),
						Position = UDim2.new(0, (tonumber(AuthCompliance.checkboxSize) or 0) + (tonumber(AuthCompliance.checkboxPadding) or 0), 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundTransparency = 1,
						Text = v40.checkbox,
						Font = if not FFlagKISAUserAgreementsRedesign then Font.Body.Font else v38.Typography.BodyMedium.Font,
						TextSize = if not FFlagKISAUserAgreementsRedesign then AuthCompliance.messageSize else v38.Typography.BodyMedium.FontSize,
						TextColor3 = if not FFlagKISAUserAgreementsRedesign then Theme.TextMuted.Color else Theme.TextEmphasis.Color,
						TextTransparency = if not FFlagKISAUserAgreementsRedesign then Theme.TextMuted.Transparency else Theme.TextEmphasis.Transparency,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextWrapped = true,
						[React.Event.Activated] = nil
					})
				}),
				SecondDivider = React.createElement("Frame", {
					LayoutOrder = 4,
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0)
				}, {
					Padding = React.createElement("UIPadding", {
						PaddingTop = UDim.new(0, 0),
						PaddingRight = UDim.new(0, AuthCompliance.paddingRight),
						PaddingBottom = UDim.new(0, 0),
						PaddingLeft = UDim.new(0, AuthCompliance.paddingLeft)
					}),
					Divider = React.createElement("Frame", {
						BorderSizePixel = 0,
						Size = UDim2.new(1, 0, 0, 1),
						AnchorPoint = Vector2.new(0, 0),
						BackgroundColor3 = if not FFlagKISAUserAgreementsRedesign then v38.Color.Shift.Shift_200.Color3 else v38.Color.Stroke.Default.Color3,
						BackgroundTransparency = not FFlagKISAUserAgreementsRedesign and 0 or v38.Color.Stroke.Default.Transparency
					})
				}),
				AgreementsList = React.createElement(UserAgreementsList, {
					LayoutOrder = 5,
					verticalSpaceOffset = 300,
					useScrollableFrame = true,
					agreements = t1.agreements,
					checkBoxStates = v41,
					setCheckBoxStates = function(p6, p7, p8) -- line: 149
						-- upvalues: EventConstants (copy), AnalyticsEvents (copy), v42 (copy)
						local v67 = if not p8 then EventConstants.btn.unchecked else EventConstants.btn.checked

						AnalyticsEvents.sendFormInteractionEvent(EventConstants.ctx.kisaCheckbox, p7, v67)
						v42(p6)
					end,
					separateRequiredOptional = v49,
					margin = FitFrame.Rect.quad(AuthCompliance.paddingTop, AuthCompliance.paddingRight, AuthCompliance.listPaddingBottom, AuthCompliance.paddingLeft),
					isAgreeAllChecked = v50
				})
			}),
			AgreeZone = React.createElement("Frame", {
				LayoutOrder = 2,
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0),
				Position = UDim2.new(0.5, 0, 1, -AuthCompliance.agreeButtonPaddingBottom),
				AnchorPoint = Vector2.new(0.5, 1)
			}, {
				Padding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 0),
					PaddingRight = UDim.new(0, AuthCompliance.paddingRight),
					PaddingBottom = UDim.new(0, AuthCompliance.agreeButtonPaddingBottom),
					PaddingLeft = UDim.new(0, AuthCompliance.paddingLeft)
				}),
				React.createElement(FitFrame.FitFrameVertical, {
					BackgroundTransparency = 1,
					width = UDim.new(1, 0)
				}, {
					ErrorLabel = nil,
					AgreeButton = if not FFlagKISAUserAgreementsRedesign then React.createElement(Button2, {
						layoutOrder = 2,
						buttonType = ButtonType.PrimarySystem,
						size = UDim2.new(1, 0, 0, AuthCompliance.agreeButtonHeight),
						anchorPoint = Vector2.new(0, 0),
						isDisabled = v51,
						text = v40.agreeButton,
						fontStyle = Font.SubHeader1,
						onActivated = function() -- line: 490
							-- upvalues: v41 (copy), t1 (copy)
							local v70 = v41

							t1.onAgreeFunction(v70)
							t1.closeCentralOverlay()
						end
					}) else React.createElement(Button, {
						LayoutOrder = 2,
						variant = if not v51 then ButtonVariant.Emphasis else ButtonVariant.Standard,
						size = InputSize.Large,
						width = UDim.new(1, 0),
						isDisabled = v51,
						text = v40.agreeButton,
						onActivated = function() -- line: 478
							-- upvalues: v41 (copy), t1 (copy)
							local v69 = v41

							t1.onAgreeFunction(v69)
							t1.closeCentralOverlay()
						end
					})
				})
			})
		})
	})
end))
