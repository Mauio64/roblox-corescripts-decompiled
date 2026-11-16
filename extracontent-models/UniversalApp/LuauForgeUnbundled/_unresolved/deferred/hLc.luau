local CorePackages = game:GetService("CorePackages")

local UserInputService = game:GetService("UserInputService")
local appFonts = require("@game/CorePackages/Workspace/Packages/Style").AppFonts
local module = require("@luauforge/bundled/fuu")

local module2 = require("@luauforge/bundled/ecR")
local useSheetNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/FoundationFork/Sheet/useSheetNavigation")
local module4 = require("@luauforge/bundled/eda")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module5 = require("@luauforge/bundled/fMG")

local module6 = require("@luauforge/deferred/hLd")
local module7 = require("@luauforge/deferred/hLe")
local module8 = require("@luauforge/deferred/hLf")

local module9 = require("@luauforge/bundled/eee")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dCu").NavigationCommands
else
	navigationCommands = nil
end

local formFactor = require("@luauforge/bundled/dDI").Enums.FormFactor

local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")

local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local module11 = require("@luauforge/bundled/edC")

local linkButton = UIBlox.App.Button.LinkButton

local module12 = require("@luauforge/bundled/fsy")

local module13 = require("@luauforge/bundled/fvl")
local module14 = require("@luauforge/bundled/hBa")
local module15 = require("@luauforge/deferred/hLg")

local extended = module2.PureComponent:extend("VerifyPhoneNumber")

local module16 = require("@luauforge/deferred/hLi")
local module17 = require("@luauforge/bundled/dwB")
local module18 = require("@luauforge/bundled/dCh")
local module19 = require("@luauforge/bundled/ecW")

local images = UIBlox.App.ImageSet.Images
local imageSetButton = UIBlox.Core.ImageSet.ImageSetButton

local udim = UDim2.new(0, 36, 0, 36)
local iconsnavigationclose = images["icons/navigation/close"]

local Foundation = require(CorePackages.Packages.Foundation)
local button = Foundation.Button
local buttonVariant = Foundation.Enums.ButtonVariant
local buttonSize = Foundation.Enums.ButtonSize

extended.defaultProps = { phoneNumber = "" }

function extended:init()
	self:setState({
		errorText = "",
		hasMadeTooManyResendCodeAttempts = false,
		codeBoxesValue = "",
		isContinuingInProgress = false,
		challenge = self.props.challenge
	})

	function self.updateIsContinuingInProgress(p2)
		spawn(function()
			local isContinuingInProgress = self.state.isContinuingInProgress

			if self.isMounted and isContinuingInProgress ~= p2 then
				self:setState({ isContinuingInProgress = p2 })
			end
		end)
	end

	function self.onResendButtonActivated()
		if self.state.isContinuingInProgress then
			return
		end

		module14(self.props.networking, self.props.deliveryTarget):andThen(function(p2)
			self:setState({ challenge = p2.challenge })
		end, function(p2)
			if p2 ~= "Authentication.TwoStepVerification.Response.TooManyAttempts" then
				self.props.showErrorToast()

				return
			end

			self.props.showTooManyAttemptsErrorToast(p2)
			self:setState({ hasMadeTooManyResendCodeAttempts = true })
		end)

		self.props.authAnalytics.reportInteractWithAction(
			module12.Context.PhoneVerification,
			module12.Field.ResendCode,
			module12.ActionType.Click,
			"",
			""
		)
	end

	function self.handlePhoneNumberVerificationSequence(p2)
		local networking = self.props.networking
		local verifyCode = self.props.verifyCode
		local setBackNavigationDisabled = self.props.setBackNavigationDisabled

		local focusedTextBox = UserInputService:GetFocusedTextBox()

		if focusedTextBox ~= nil then
			focusedTextBox:ReleaseFocus()
		end

		setBackNavigationDisabled(true)
		verifyCode(networking, p2, self.state.challenge):andThen(function(p3)
			setBackNavigationDisabled(false)
			self.props.verifyPhoneNumberCallback(p3.voucher)
			self.props.closeAlert()
		end, function(p3)
			setBackNavigationDisabled(false)

			if self.isMounted then
				self:setState({ errorText = p3, codeBoxesValue = "" })
			end

			if p3 == "Authentication.TwoStepVerification.Label.InvalidCode" then
				self.props.authAnalytics.reportInteractWithAction(
					module12.Context.PhoneVerification,
					module12.Field.InvalidCode,
					module12.ActionType.Shown,
					"",
					""
				)
			end

			self.updateIsContinuingInProgress(false)
		end)
	end

	function self.onContinueButtonActivated()
		if #self.state.codeBoxesValue < 6 or self.state.isContinuingInProgress then
			return
		end

		self.updateIsContinuingInProgress(true)

		self.handlePhoneNumberVerificationSequence(self.state.codeBoxesValue)

		self.props.authAnalytics.reportButtonClicked(
			module12.Context.PhoneVerification,
			module12.Button.Continue
		)
	end

	function self.onUseEmailClicked()
		self.props.closeAlert()
		self.props.useEmailOptionClickedCallback()
		self.props.authAnalytics.reportInteractWithAction(
			module12.Context.PhoneVerification,
			module12.Field.UseEmail,
			module12.ActionType.Click,
			"",
			""
		)
	end

	function self.onFocusLost(p2, p3, p4)
		if p3 or p4 and p4.KeyCode == Enum.KeyCode.Return then
			self.onContinueButtonActivated()
		end
	end

	function self.onValueChanged(p2)
		if self.state.codeBoxesValue == p2 or not self.isMounted then
			return
		end

		self:setState({ codeBoxesValue = p2, errorText = "" })
	end

	self.invisibleTextBoxDidGainFocus = false
	function self.onInvisibleTextBoxFocused(object2)
		if self.state.isContinuingInProgress then
			object2:ReleaseFocus()
		end

		if not self.invisibleTextBoxDidGainFocus then
			self.invisibleTextBoxDidGainFocus = true
		end

		self.props.authAnalytics.reportInteractWithAction(
			module12.Context.PhoneVerification,
			module12.Field.VerificationCode,
			module12.ActionType.Focus,
			"",
			""
		)
	end
end

function extended:didMount()
	self.isMounted = true
end

function extended:willUnmount()
	self.isMounted = false

	if self.keyboardVisibleChanged then
		self.keyboardVisibleChanged:disconnect()
		self.keyboardVisibleChanged = nil
	end
end

function extended.render(data)
	local errorText = if data.state.errorText ~= "" then data.state.errorText or nil else nil
	local hasMadeTooManyResendCodeAttempts = data.state.hasMadeTooManyResendCodeAttempts

	local v5 = Enum.TextInputType.Number
	pcall(function()
		v5 = Enum.TextInputType.OneTimePassword
	end)

	return withStyle(function(p2)
		return module11({
			localizedError = errorText,
			verifyPhoneNumber = "Feature.VerificationUpsell.Label.VerifyPhoneNumber",
			enterCode = "Feature.VerificationUpsell.Label.EnterCode",
			changePhoneNumber = "Feature.VerificationUpsell.Action.ChangeNumber",
			didNotReceive = "Authentication.TwoStepVerification.Label.DidNotReceive",
			resend = "Authentication.TwoStepVerification.Label.Resend",
			continueText = "Authentication.SignUp.Label.Continue",
			codeBoxPlaceholder = "Authentication.TwoStepVerification.Label.CodeInputPlaceholderText",
			useEmail = "Feature.VerificationUpsell.Action.UserEmail"
		})(function(props)
			local v6 = data.props.formFactor == formFactor.WIDE
			local v7 = #data.state.codeBoxesValue == 6

			local udim2 = UDim2.new(0, 0, 0.5, 0)
			local vector2 = Vector2.new(0, 0.5)
			local v8

			if v6 then
				v8 = 1
			else
				v8 = p2.Theme.BackgroundDefault.Transparency
				udim2 = UDim2.new(0, 0, 1, 0)
				vector2 = Vector2.new(0, 1)
			end

			return module2.createElement(module16, {
				Contents = {
					UISizeConstraint = v6 and module2.createElement("UISizeConstraint", {
						MaxSize = Vector2.new(400, 1e999)
					}) or nil,
					VerifyPhoneNumberContents = module2.createElement(FitChildren.FitImageLabel, {
						Size = UDim2.new(1, 0, 0, 0),
						fitAxis = FitChildren.FitAxis.Height,
						Position = udim2,
						BackgroundColor3 = p2.Theme.BackgroundDefault.Color,
						BackgroundTransparency = v8,
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(9, 9, 9, 9),
						Image = "LuaApp/buttons/buttonFill",
						ImageColor3 = p2.Theme.BackgroundDefault.Color,
						ImageTransparency = p2.Theme.BackgroundDefault.Transparency,
						BorderSizePixel = 0,
						AnchorPoint = vector2,
						Visible = true
					}, {
						UIListLayout = module2.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Vertical,
							SortOrder = Enum.SortOrder.LayoutOrder,
							HorizontalAlignment = Enum.HorizontalAlignment.Center
						}),
						HeaderFrame = module2.createElement(
							"Frame",
							{ Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1 },
							{
								BackButton = module2.createElement(imageSetButton, {
									Size = udim,
									AutoButtonColor = false,
									BorderSizePixel = 0,
									BackgroundTransparency = 1,
									Position = UDim2.new(0, 10, 0, -35),
									AnchorPoint = Vector2.new(0, 0),
									ScaleType = Enum.ScaleType.Fit,
									Image = iconsnavigationclose,
									ImageColor3 = p2.Theme.UIEmphasis.Color,
									[module2.Event.Activated] = data.props.closeAlert
								})
							}
						),
						Header = module2.createElement(
							"Frame",
							{
								Size = UDim2.new(1, 0, 0, 48),
								BackgroundTransparency = 1,
								BorderSizePixel = 0,
								LayoutOrder = 1
							},
							{
								TextLabel = module2.createElement("TextLabel", {
									Size = UDim2.new(1, -40, 0, 28),
									Position = UDim2.new(0, 20, 0.5, 0),
									AnchorPoint = Vector2.new(0, 0.5),
									TextSize = 20,
									BackgroundTransparency = 1,
									TextColor3 = Color3.new(1, 1, 1),
									TextXAlignment = Enum.TextXAlignment.Left,
									Font = appFonts.default:getBold(),
									Text = props.verifyPhoneNumber
								}),
								LinkButton = module2.createElement(linkButton, {
									fontStyle = "Footer",
									size = UDim2.fromScale(0, 1),
									text = props.useEmail,
									colorStyleDefault = "TextEmphasis",
									colorStyleHover = "TextEmphasis",
									onActivated = data.onUseEmailClicked,
									position = UDim2.new(0.7, 0, 0.05, 0)
								})
							}
						),
						Messages = module2.createElement(FitChildren.FitFrame, {
							Size = UDim2.new(1, 0, 0, 81),
							fitAxis = FitChildren.FitAxis.Height,
							AnchorPoint = Vector2.new(0.5, 0),
							BackgroundColor3 = p2.Theme.BackgroundMuted.Color or Color3.new(24 / 255, 25 / 255, 27 / 255),
							BorderSizePixel = 0,
							LayoutOrder = 2
						}, {
							UIListLayout = module2.createElement("UIListLayout", {
								FillDirection = Enum.FillDirection.Vertical,
								SortOrder = Enum.SortOrder.LayoutOrder,
								Padding = UDim.new(0, 10)
							}),
							UIPadding = module2.createElement("UIPadding", {
								PaddingTop = UDim.new(0, 10),
								PaddingBottom = UDim.new(0, 10),
								PaddingLeft = UDim.new(0, 20),
								PaddingRight = UDim.new(0, 20)
							}),
							Help = module2.createElement(module6, {
								LayoutOrder = 2,
								fontStyle = "Footer",
								Width = UDim.new(1, 0),
								AnchorPoint = Vector2.new(0, 0.5),
								textLabelColor = p2.Theme.TextDefault.Color,
								textLabelText = string.gsub(
									props.enterCode,
									"{phoneNumber}",
									data.props.phoneNumber
								),
								linkColorStyle = "TextEmphasis",
								linkText = props.changePhoneNumber,
								onActivated = data.props.closeAlert
							}),
							Resend = not hasMadeTooManyResendCodeAttempts and module2.createElement(module7, {
								LayoutOrder = 3,
								fontStyle = "Footer",
								Width = UDim.new(1, 0),
								textLabelColor = p2.Theme.TextDefault.Color,
								textLabelText = props.didNotReceive,
								linkColorStyle = "TextEmphasis",
								linkText = props.resend,
								textButtonEnabled = not data.state.isContinuingInProgress,
								onActivated = data.onResendButtonActivated
							}),
							TryEmail = hasMadeTooManyResendCodeAttempts and module2.createElement(module7, {
								LayoutOrder = 3,
								fontStyle = "Footer",
								Width = UDim.new(1, 0),
								textLabelColor = p2.Theme.TextDefault.Color,
								textLabelText = props.didNotReceive,
								linkColorStyle = "TextEmphasis",
								linkText = props.useEmail,
								textButtonEnabled = not data.state.isContinuingInProgress,
								onActivated = data.onUseEmailClicked
							})
						}),
						Form = module2.createElement(
							FitChildren.FitFrame,
							{
								Size = UDim2.new(1, 0, 0, 0),
								fitAxis = FitChildren.FitAxis.Height,
								BackgroundTransparency = 1,
								LayoutOrder = 3
							},
							{
								UIListLayout = module2.createElement("UIListLayout", {
									FillDirection = Enum.FillDirection.Vertical,
									SortOrder = Enum.SortOrder.LayoutOrder,
									Padding = UDim.new(0, 10)
								}),
								UIPadding = module2.createElement("UIPadding", {
									PaddingTop = UDim.new(0, 15),
									PaddingBottom = UDim.new(0, 15),
									PaddingLeft = UDim.new(0, 20),
									PaddingRight = UDim.new(0, 20)
								}),
								CodeBoxesAndErrorContainer = module2.createElement(
									FitChildren.FitFrame,
									{
										Size = UDim2.new(1, 0, 0, 0),
										fitAxis = FitChildren.FitAxis.Height,
										BackgroundTransparency = 1,
										LayoutOrder = 1
									},
									{
										UIListLayout = module2.createElement("UIListLayout", {
											FillDirection = Enum.FillDirection.Vertical,
											SortOrder = Enum.SortOrder.LayoutOrder,
											Padding = UDim.new(0, 5)
										}),
										CodeBoxes = module2.createElement(module8, {
											characterCount = 6,
											PlaceholderText = string.gsub(props.codeBoxPlaceholder, "{.-}", 6),
											LayoutOrder = 1,
											TextInputType = v5,
											textFilter = "%D",
											errorState = errorText ~= nil,
											shouldFocus = not data.state.isContinuingInProgress,
											onFocused = data.onInvisibleTextBoxFocused,
											onFocusLost = data.onFocusLost,
											onValueChanged = data.onValueChanged,
											ManualFocusRelease = true
										}),
										ErrorText = errorText and module2.createElement("TextLabel", {
											Size = UDim2.new(1, 0, 0, 17),
											Text = props.localizedError or "",
											Font = appFonts.default:getDefault(),
											TextSize = 12,
											TextXAlignment = Enum.TextXAlignment.Left,
											TextYAlignment = Enum.TextYAlignment.Center,
											TextColor3 = Color3.new(247 / 255, 75 / 255, 82 / 255),
											BackgroundTransparency = 1,
											LayoutOrder = 2
										})
									}
								),
								ContinueButton = module2.createElement(button, {
									testId = "--auth-signup-button-verify-continue",
									variant = buttonVariant.SubEmphasis,
									size = buttonSize.Large,
									text = props.continueText,
									isDisabled = not v7,
									isLoading = data.state.isContinuingInProgress,
									onActivated = data.onContinueButtonActivated,
									width = UDim.new(1, 0),
									LayoutOrder = 3
								})
							}
						)
					})
				}
			})
		end)
	end)
end

local v5 = roactServices.connect({ networking = module4, authAnalytics = module5 })(extended)

return (useSheetNavigation.connect(function(p2, p3)
	return { formFactor = p2.FormFactor }
end, function(callback)
	return {
		setBackNavigationDisabled = function(p2)
			return module.setDisabled(p2)
		end,
		verifyCode = function(p2, p3, p4)
			return callback(module15(p2, p3, p4))
		end,
		navigateToPage = function(p2)
			if fFlagSignalsNavP3Dispatch then
				return navigationCommands.down(navigationCommands.fromLegacyPage(p2))
			end

			return callback(module9(p2))
		end,
		closeAlert = function()
			return callback(module13())
		end,
		showTooManyAttemptsErrorToast = function(p2)
			return callback(module18({
				toastType = module17.NetworkingError,
				toastMessage = p2
			}))
		end,
		showErrorToast = function()
			return callback(module19({ HttpError = Enum.HttpError.OK }))
		end
	}
end)(v5))
