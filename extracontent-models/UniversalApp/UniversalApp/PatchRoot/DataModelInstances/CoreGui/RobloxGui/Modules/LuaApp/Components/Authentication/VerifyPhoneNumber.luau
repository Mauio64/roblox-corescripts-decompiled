local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local UserInputService = game:GetService("UserInputService")
local AppFonts = require(CorePackages.Workspace.Packages.Style).AppFonts
local BackDisableStore = require(CorePackages.Workspace.Packages.BackDisableStore)
local Common = Modules.Common
local Roact = require(Common.Roact)
local RoactRodux = require(Common.RoactRodux)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactAnalyticsAuthEvents = require(Modules.LuaApp.Services.RoactAnalyticsAuthEvents)
local AdjacentTextAndLink = require(Modules.LuaApp.Components.AdjacentTextAndLink)
local FloodcheckTextAndLink = require(Modules.LuaApp.Components.Authentication.FloodcheckTextAndLink)
local CodeBox = require(Modules.LuaApp.Components.Authentication.CodeBox)
local SetBackNavigationDisabled = require(Modules.LuaApp.Actions.SetBackNavigationDisabled)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v18 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local FitChildren = require(Modules.LuaApp.FitChildren)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local withLocalization = require(Modules.LuaApp.withLocalization)
local LinkButton = UIBlox.App.Button.LinkButton
local EventStreamConstants = require(Modules.LuaApp.EventStreamConstants)
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local GetVerifiedSignupChallenge = require(Modules.LuaApp.Thunks.Authentication.GetVerifiedSignupChallenge)
local VerifyPhoneNumberCode = require(Modules.LuaApp.Thunks.Authentication.VerifyPhoneNumberCode)
local FFlagUseBackDisableSignalStore = require(CorePackages.Workspace.Packages.SharedFlags).FFlagUseBackDisableSignalStore
local v30 = Roact.PureComponent:extend("VerifyPhoneNumber")
local OnScreenKeyboardWindow = require(Modules.LuaApp.Components.OnScreenKeyboardWindow)
local ToastType = require(Modules.LuaApp.Enum.ToastType)
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local SetNetworkingErrorToast = require(Modules.LuaApp.Thunks.SetNetworkingErrorToast)
local Images = UIBlox.App.ImageSet.Images
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local uDim2 = UDim2.new(0, 36, 0, 36)
local v38 = Images["icons/navigation/close"]
local Foundation = require(CorePackages.Packages.Foundation)
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local ButtonSize = Foundation.Enums.ButtonSize

v30.defaultProps = {
	phoneNumber = ""
}

function v30.init(p1) -- line: 74
	-- upvalues: GetVerifiedSignupChallenge (copy), EventStreamConstants (copy), UserInputService (copy)
	p1:setState({
		errorText = "",
		hasMadeTooManyResendCodeAttempts = false,
		codeBoxesValue = "",
		isContinuingInProgress = false,
		challenge = p1.props.challenge
	})

	function p1.updateIsContinuingInProgress(p2) -- line: 83
		-- upvalues: p1 (copy)
		spawn(function() -- line: 84
			-- upvalues: p1 (copy), p2 (copy)
			local isContinuingInProgress = p1.state.isContinuingInProgress

			if p1.isMounted and isContinuingInProgress ~= p2 then
				p1:setState({
					isContinuingInProgress = p2
				})
			end
		end)
	end
	function p1.onResendButtonActivated() -- line: 94
		-- upvalues: p1 (copy), GetVerifiedSignupChallenge (copy), EventStreamConstants (copy)
		if p1.state.isContinuingInProgress then
			return
		end

		local networking = p1.props.networking
		local deliveryTarget = p1.props.deliveryTarget

		GetVerifiedSignupChallenge(networking, deliveryTarget):andThen(function(p3) -- line: 101
			-- upvalues: p1 (copy)
			p1:setState({
				challenge = p3.challenge
			})
		end, function(p4) -- line: 105
			-- upvalues: p1 (copy)
			if p4 == "Authentication.TwoStepVerification.Response.TooManyAttempts" then
				p1.props.showTooManyAttemptsErrorToast(p4)
				p1:setState({
					hasMadeTooManyResendCodeAttempts = true
				})

				return
			end

			p1.props.showErrorToast()
		end)
		p1.props.authAnalytics.reportInteractWithAction(EventStreamConstants.Context.PhoneVerification, EventStreamConstants.Field.ResendCode, EventStreamConstants.ActionType.Click, "", "")
	end
	function p1.handlePhoneNumberVerificationSequence(p5) -- line: 125
		-- upvalues: p1 (copy), UserInputService (copy), EventStreamConstants (copy)
		local networking = p1.props.networking
		local verifyCode = p1.props.verifyCode
		local setBackNavigationDisabled = p1.props.setBackNavigationDisabled
		local FocusedTextBox = UserInputService:GetFocusedTextBox()

		if FocusedTextBox ~= nil then
			FocusedTextBox:ReleaseFocus()
		end

		setBackNavigationDisabled(true)
		verifyCode(networking, p5, p1.state.challenge):andThen(function(p6) -- line: 136
			-- upvalues: setBackNavigationDisabled (copy), p1 (copy)
			setBackNavigationDisabled(false)
			p1.props.verifyPhoneNumberCallback(p6.voucher)
			p1.props.closeAlert()
		end, function(p7) -- line: 140
			-- upvalues: setBackNavigationDisabled (copy), p1 (copy), EventStreamConstants (copy)
			setBackNavigationDisabled(false)

			if p1.isMounted then
				p1:setState({
					codeBoxesValue = "",
					errorText = p7
				})
			end

			if p7 == "Authentication.TwoStepVerification.Label.InvalidCode" then
				p1.props.authAnalytics.reportInteractWithAction(EventStreamConstants.Context.PhoneVerification, EventStreamConstants.Field.InvalidCode, EventStreamConstants.ActionType.Shown, "", "")
			end

			p1.updateIsContinuingInProgress(false)
		end)
	end
	function p1.onContinueButtonActivated() -- line: 164
		-- upvalues: p1 (copy), EventStreamConstants (copy)
		if #p1.state.codeBoxesValue < 6 then
			return
		end

		if p1.state.isContinuingInProgress then
			return
		end

		p1.updateIsContinuingInProgress(true)
		p1.handlePhoneNumberVerificationSequence(p1.state.codeBoxesValue)
		p1.props.authAnalytics.reportButtonClicked(EventStreamConstants.Context.PhoneVerification, EventStreamConstants.Button.Continue)
	end
	function p1.onUseEmailClicked() -- line: 183
		-- upvalues: p1 (copy), EventStreamConstants (copy)
		p1.props.closeAlert()
		p1.props.useEmailOptionClickedCallback()
		p1.props.authAnalytics.reportInteractWithAction(EventStreamConstants.Context.PhoneVerification, EventStreamConstants.Field.UseEmail, EventStreamConstants.ActionType.Click, "", "")
	end
	function p1.onFocusLost(_, p9, p10) -- line: 195
		-- upvalues: p1 (copy)
		if p9 or p10 and p10.KeyCode == Enum.KeyCode.Return then
			p1.onContinueButtonActivated()
		end
	end
	function p1.onValueChanged(p11) -- line: 201
		-- upvalues: p1 (copy)
		if p11 == p1.state.codeBoxesValue or not p1.isMounted then
			return
		end

		p1:setState({
			errorText = "",
			codeBoxesValue = p11
		})
	end

	p1.invisibleTextBoxDidGainFocus = false

	function p1.onInvisibleTextBoxFocused(p12) -- line: 212
		-- upvalues: p1 (copy), EventStreamConstants (copy)
		if p1.state.isContinuingInProgress then
			p12:ReleaseFocus()
		end

		if not p1.invisibleTextBoxDidGainFocus then
			p1.invisibleTextBoxDidGainFocus = true
		end

		p1.props.authAnalytics.reportInteractWithAction(EventStreamConstants.Context.PhoneVerification, EventStreamConstants.Field.VerificationCode, EventStreamConstants.ActionType.Focus, "", "")
	end
end
function v30.didMount(p13) -- line: 230
	p13.isMounted = true
end
function v30.willUnmount(p14) -- line: 234
	p14.isMounted = false

	if p14.keyboardVisibleChanged then
		p14.keyboardVisibleChanged:disconnect()
		p14.keyboardVisibleChanged = nil
	end
end
function v30.render(p15) -- line: 243
	-- upvalues: withStyle (copy), withLocalization (copy), FormFactor (copy), Roact (copy), OnScreenKeyboardWindow (copy), FitChildren (copy), ImageSetButton (copy), uDim2 (copy), v38 (copy), AppFonts (copy), LinkButton (copy), AdjacentTextAndLink (copy), FloodcheckTextAndLink (copy), CodeBox (copy), Button (copy), ButtonVariant (copy), ButtonSize (copy)
	local v48 = p15.state.errorText ~= "" and p15.state.errorText or nil
	local hasMadeTooManyResendCodeAttempts = p15.state.hasMadeTooManyResendCodeAttempts
	local Number = Enum.TextInputType.Number

	pcall(function() -- line: 248
		-- upvalues: Number (ref)
		Number = Enum.TextInputType.OneTimePassword
	end)

	return withStyle(function(p16) -- line: 255
		-- upvalues: withLocalization (copy), v48 (copy), p15 (copy), FormFactor (copy), Roact (copy), OnScreenKeyboardWindow (copy), FitChildren (copy), ImageSetButton (copy), uDim2 (copy), v38 (copy), AppFonts (copy), LinkButton (copy), AdjacentTextAndLink (copy), hasMadeTooManyResendCodeAttempts (copy), FloodcheckTextAndLink (copy), CodeBox (copy), Number (ref), Button (copy), ButtonVariant (copy), ButtonSize (copy)
		return withLocalization({
			verifyPhoneNumber = "Feature.VerificationUpsell.Label.VerifyPhoneNumber",
			enterCode = "Feature.VerificationUpsell.Label.EnterCode",
			changePhoneNumber = "Feature.VerificationUpsell.Action.ChangeNumber",
			didNotReceive = "Authentication.TwoStepVerification.Label.DidNotReceive",
			resend = "Authentication.TwoStepVerification.Label.Resend",
			continueText = "Authentication.SignUp.Label.Continue",
			codeBoxPlaceholder = "Authentication.TwoStepVerification.Label.CodeInputPlaceholderText",
			useEmail = "Feature.VerificationUpsell.Action.UserEmail",
			localizedError = v48
		})(function(p17) -- line: 266
			-- upvalues: p15 (copy), FormFactor (copy), p16 (copy), Roact (copy), OnScreenKeyboardWindow (copy), FitChildren (copy), ImageSetButton (copy), uDim2 (copy), v38 (copy), AppFonts (copy), LinkButton (copy), AdjacentTextAndLink (copy), hasMadeTooManyResendCodeAttempts (copy), FloodcheckTextAndLink (copy), CodeBox (copy), Number (ref), v48 (copy), Button (copy), ButtonVariant (copy), ButtonSize (copy)
			local v80 = p15.props.formFactor == FormFactor.WIDE
			local v81 = #p15.state.codeBoxesValue == 6
			local n1 = 1
			local uDim2_2 = UDim2.new(0, 0, 0.5, 0)
			local vector2 = Vector2.new(0, 0.5)

			if not v80 then
				n1 = p16.Theme.BackgroundDefault.Transparency
				uDim2_2 = UDim2.new(0, 0, 1, 0)
				vector2 = Vector2.new(0, 1)
			end

			return Roact.createElement(OnScreenKeyboardWindow, {
				Contents = {
					UISizeConstraint = v80 and Roact.createElement("UISizeConstraint", {
						MaxSize = Vector2.new(400, 1e999)
					}) or nil,
					VerifyPhoneNumberContents = Roact.createElement(FitChildren.FitImageLabel, {
						Image = "LuaApp/buttons/buttonFill",
						BorderSizePixel = 0,
						Visible = true,
						Size = UDim2.new(1, 0, 0, 0),
						fitAxis = FitChildren.FitAxis.Height,
						Position = uDim2_2,
						BackgroundColor3 = p16.Theme.BackgroundDefault.Color,
						BackgroundTransparency = n1,
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(9, 9, 9, 9),
						ImageColor3 = p16.Theme.BackgroundDefault.Color,
						ImageTransparency = p16.Theme.BackgroundDefault.Transparency,
						AnchorPoint = vector2
					}, {
						UIListLayout = Roact.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Vertical,
							SortOrder = Enum.SortOrder.LayoutOrder,
							HorizontalAlignment = Enum.HorizontalAlignment.Center
						}),
						HeaderFrame = Roact.createElement("Frame", {
							BackgroundTransparency = 1,
							Size = UDim2.new(1, 0, 0, 0)
						}, {
							BackButton = Roact.createElement(ImageSetButton, {
								Size = uDim2,
								AutoButtonColor = false,
								BorderSizePixel = 0,
								BackgroundTransparency = 1,
								Position = UDim2.new(0, 10, 0, -35),
								AnchorPoint = Vector2.new(0, 0),
								ScaleType = Enum.ScaleType.Fit,
								Image = v38,
								ImageColor3 = p16.Theme.UIEmphasis.Color,
								[Roact.Event.Activated] = p15.props.closeAlert
							})
						}),
						Header = Roact.createElement("Frame", {
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							LayoutOrder = 1,
							Size = UDim2.new(1, 0, 0, 48)
						}, {
							TextLabel = Roact.createElement("TextLabel", {
								TextSize = 20,
								BackgroundTransparency = 1,
								Size = UDim2.new(1, -40, 0, 28),
								Position = UDim2.new(0, 20, 0.5, 0),
								AnchorPoint = Vector2.new(0, 0.5),
								TextColor3 = Color3.new(1, 1, 1),
								TextXAlignment = Enum.TextXAlignment.Left,
								Font = AppFonts.default:getBold(),
								Text = p17.verifyPhoneNumber
							}),
							LinkButton = Roact.createElement(LinkButton, {
								fontStyle = "Footer",
								colorStyleDefault = "TextEmphasis",
								colorStyleHover = "TextEmphasis",
								size = UDim2.fromScale(0, 1),
								text = p17.useEmail,
								onActivated = p15.onUseEmailClicked,
								position = UDim2.new(0.7, 0, 0.05, 0)
							})
						}),
						Messages = Roact.createElement(FitChildren.FitFrame, {
							BorderSizePixel = 0,
							LayoutOrder = 2,
							Size = UDim2.new(1, 0, 0, 81),
							fitAxis = FitChildren.FitAxis.Height,
							AnchorPoint = Vector2.new(0.5, 0),
							BackgroundColor3 = p16.Theme.BackgroundMuted.Color or Color3.new(0.09411764705882353, 0.09803921568627451, 0.10588235294117647)
						}, {
							UIListLayout = Roact.createElement("UIListLayout", {
								FillDirection = Enum.FillDirection.Vertical,
								SortOrder = Enum.SortOrder.LayoutOrder,
								Padding = UDim.new(0, 10)
							}),
							UIPadding = Roact.createElement("UIPadding", {
								PaddingTop = UDim.new(0, 10),
								PaddingBottom = UDim.new(0, 10),
								PaddingLeft = UDim.new(0, 20),
								PaddingRight = UDim.new(0, 20)
							}),
							Help = Roact.createElement(AdjacentTextAndLink, {
								LayoutOrder = 2,
								fontStyle = "Footer",
								linkColorStyle = "TextEmphasis",
								Width = UDim.new(1, 0),
								AnchorPoint = Vector2.new(0, 0.5),
								textLabelColor = p16.Theme.TextDefault.Color,
								textLabelText = string.gsub(p17.enterCode, "{phoneNumber}", p15.props.phoneNumber),
								linkText = p17.changePhoneNumber,
								onActivated = p15.props.closeAlert
							}),
							Resend = not hasMadeTooManyResendCodeAttempts and Roact.createElement(FloodcheckTextAndLink, {
								LayoutOrder = 3,
								fontStyle = "Footer",
								linkColorStyle = "TextEmphasis",
								Width = UDim.new(1, 0),
								textLabelColor = p16.Theme.TextDefault.Color,
								textLabelText = p17.didNotReceive,
								linkText = p17.resend,
								textButtonEnabled = not p15.state.isContinuingInProgress,
								onActivated = p15.onResendButtonActivated
							}),
							TryEmail = hasMadeTooManyResendCodeAttempts and Roact.createElement(FloodcheckTextAndLink, {
								LayoutOrder = 3,
								fontStyle = "Footer",
								linkColorStyle = "TextEmphasis",
								Width = UDim.new(1, 0),
								textLabelColor = p16.Theme.TextDefault.Color,
								textLabelText = p17.didNotReceive,
								linkText = p17.useEmail,
								textButtonEnabled = not p15.state.isContinuingInProgress,
								onActivated = p15.onUseEmailClicked
							})
						}),
						Form = Roact.createElement(FitChildren.FitFrame, {
							BackgroundTransparency = 1,
							LayoutOrder = 3,
							Size = UDim2.new(1, 0, 0, 0),
							fitAxis = FitChildren.FitAxis.Height
						}, {
							UIListLayout = Roact.createElement("UIListLayout", {
								FillDirection = Enum.FillDirection.Vertical,
								SortOrder = Enum.SortOrder.LayoutOrder,
								Padding = UDim.new(0, 10)
							}),
							UIPadding = Roact.createElement("UIPadding", {
								PaddingTop = UDim.new(0, 15),
								PaddingBottom = UDim.new(0, 15),
								PaddingLeft = UDim.new(0, 20),
								PaddingRight = UDim.new(0, 20)
							}),
							CodeBoxesAndErrorContainer = Roact.createElement(FitChildren.FitFrame, {
								BackgroundTransparency = 1,
								LayoutOrder = 1,
								Size = UDim2.new(1, 0, 0, 0),
								fitAxis = FitChildren.FitAxis.Height
							}, {
								UIListLayout = Roact.createElement("UIListLayout", {
									FillDirection = Enum.FillDirection.Vertical,
									SortOrder = Enum.SortOrder.LayoutOrder,
									Padding = UDim.new(0, 5)
								}),
								CodeBoxes = Roact.createElement(CodeBox, {
									characterCount = 6,
									LayoutOrder = 1,
									textFilter = "%D",
									ManualFocusRelease = true,
									PlaceholderText = string.gsub(p17.codeBoxPlaceholder, "{.-}", 6),
									TextInputType = Number,
									errorState = v48 ~= nil,
									shouldFocus = not p15.state.isContinuingInProgress,
									onFocused = p15.onInvisibleTextBoxFocused,
									onFocusLost = p15.onFocusLost,
									onValueChanged = p15.onValueChanged
								}),
								ErrorText = v48 and Roact.createElement("TextLabel", {
									TextSize = 12,
									BackgroundTransparency = 1,
									LayoutOrder = 2,
									Size = UDim2.new(1, 0, 0, 17),
									Text = p17.localizedError or "",
									Font = AppFonts.default:getDefault(),
									TextXAlignment = Enum.TextXAlignment.Left,
									TextYAlignment = Enum.TextYAlignment.Center,
									TextColor3 = Color3.new(0.9686274509803922, 0.29411764705882354, 0.3215686274509804)
								})
							}),
							ContinueButton = Roact.createElement(Button, {
								LayoutOrder = 3,
								variant = ButtonVariant.SubEmphasis,
								size = ButtonSize.Large,
								text = p17.continueText,
								isDisabled = not v81,
								isLoading = p15.state.isContinuingInProgress,
								onActivated = p15.onContinueButtonActivated,
								width = UDim.new(1, 0)
							})
						})
					})
				}
			})
		end)
	end)
end

local v43 = RoactServices.connect({
	networking = RoactNetworking,
	authAnalytics = RoactAnalyticsAuthEvents
})(v30)

return (RoactRodux.connect(function(p18, _) -- line: 490
	return {
		formFactor = p18.FormFactor
	}
end, function(p20) -- line: 494
	-- upvalues: FFlagUseBackDisableSignalStore (copy), BackDisableStore (copy), SetBackNavigationDisabled (copy), VerifyPhoneNumberCode (copy), FFlagSignalsNavP3Dispatch (copy), v18 (copy), NavigateDown (copy), CloseCentralOverlay (copy), SetCurrentToastMessage (copy), ToastType (copy), SetNetworkingErrorToast (copy)
	return {
		setBackNavigationDisabled = function(p21) -- line: 496
			-- upvalues: FFlagUseBackDisableSignalStore (copy), BackDisableStore (copy), p20 (copy), SetBackNavigationDisabled (copy)
			if FFlagUseBackDisableSignalStore then
				return (BackDisableStore.setDisabled(p21))
			end

			return (p20(SetBackNavigationDisabled(p21)))
		end,
		verifyCode = function(p22, p23, p24) -- line: 501
			-- upvalues: p20 (copy), VerifyPhoneNumberCode (copy)
			return p20(VerifyPhoneNumberCode(p22, p23, p24))
		end,
		navigateToPage = function(p25) -- line: 504
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v18 (copy), p20 (copy), NavigateDown (copy)
			if FFlagSignalsNavP3Dispatch then
				return v18.down(v18.fromLegacyPage(p25))
			end

			return p20(NavigateDown(p25))
		end,
		closeAlert = function() -- line: 511
			-- upvalues: p20 (copy), CloseCentralOverlay (copy)
			return p20(CloseCentralOverlay())
		end,
		showTooManyAttemptsErrorToast = function(p26) -- line: 514
			-- upvalues: p20 (copy), SetCurrentToastMessage (copy), ToastType (copy)
			return p20(SetCurrentToastMessage({
				toastType = ToastType.NetworkingError,
				toastMessage = p26
			}))
		end,
		showErrorToast = function() -- line: 520
			-- upvalues: p20 (copy), SetNetworkingErrorToast (copy)
			return p20(SetNetworkingErrorToast({
				HttpError = Enum.HttpError.OK
			}))
		end
	}
end)(v43))
