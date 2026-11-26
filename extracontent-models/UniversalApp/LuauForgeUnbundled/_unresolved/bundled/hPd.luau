local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local module = require("@luauforge/bundled/egZ")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module2 = require("@luauforge/bundled/egx")
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local image = Foundation.Image
local useTokens = Foundation.Hooks.useTokens
local view = Foundation.View
local text = Foundation.Text
local textInput = Foundation.TextInput
local inputSize = Foundation.Enums.InputSize

local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local getTextSize = require("@game/CorePackages/Workspace/Packages/Style").GetTextSize
local module3 = require("@luauforge/bundled/gyh")
local module4 = require("@luauforge/bundled/grb")
local module5 = require("@luauforge/bundled/fzS")

local module6 = require("@luauforge/bundled/gyj")

local module7 = require("@luauforge/bundled/fJl")

local module8 = require("@luauforge/bundled/hPe")

local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")
local FitFrame = require(CorePackages.Packages.FitFrame)
local fitTextLabel = FitFrame.FitTextLabel

local module10 = require("@luauforge/bundled/hPf")
local AuthCommon = require("@game/CorePackages/Workspace/Packages/AuthCommon")
local textInputBoxWithBorder = AuthCommon.Components.TextInputBoxWithBorder
local authStatefulRoundCornerBorder = AuthCommon.Components.AuthStatefulRoundCornerBorder
local button = UIBlox.App.Button.Button
local buttonType = UIBlox.App.Button.Enum.ButtonType
local module12 = require("@luauforge/bundled/hPh")

local module13 = require("@luauforge/bundled/hPi")

local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/TextChannelWindow/TextChannelWindow/Logger")

local getFFlagEnableAuthsecImageUpdate = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableAuthsecImageUpdate

local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local iconsgraphiclock_xxlarge = images["icons/graphic/lock_xxlarge"]

local function sanitizeEnterCode(value)
	return value:gsub("[^%w]", ""):upper():sub(1, 6)
end

local function getLocalPlayerDisplayName()
	local localPlayer = Players.LocalPlayer

	if not localPlayer then
		return "Player"
	end

	local displayName = localPlayer.DisplayName

	if displayName and displayName ~= "" then
		return displayName
	end

	return localPlayer.Name
end

local function escapeForRichText(value)
	return value:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
end

local extended = Roact.PureComponent:extend("CrossDeviceEnterCodePage")

function extended:init()
	self.latestSanitizedCode = ""

	self:setState({
		inputCode = "",
		inputErrorKey = "",
		placeholderTextOverride = "",
		disableSubmissionForBadCode = false,
		isConfirming = false,
		isFocused = false
	})

	function self.onFocus()
		self:setState({ inputErrorKey = "", isFocused = true })
	end

	function self.onFocusLost(p2, p3)
		if p3 and #self.state.inputCode == 6 then
			self.confirmButtonPressed()
		else
			self:setState({ isFocused = false })
		end
	end

	function self.getVerifyCodeImage(p2): string
		if p2 == Foundation.Enums.ColorMode.Dark then
			return "icons/graphic/verifyCode_dark"
		end

		return "icons/graphic/verifyCode_light"
	end

	function self.onTextChanged(p2)
		local success, result = pcall(function()
			local v5 = p2.Text:gsub("[^%w]", ""):upper():sub(1, 6)

			if v5 == p2.Text then
				self:setState({ inputCode = p2.Text })
			else
				p2.Text = v5
			end
		end)

		if not success then
			Logger:warning(string.format(
				"Text validation error in CrossDeviceEnderCodeView: %s",
				(tostring(result))
			))
		end
	end

	function self.onRefreshCodeChanged(value)
		local success, result = pcall(function()
			local v5 = value:gsub("[^%w]", ""):upper():sub(1, 6)

			self.latestSanitizedCode = v5
			self.setInputText(v5)
			self:setState({ inputCode = v5 })
		end)

		if not success then
			Logger:warning(string.format(
				"Text validation error in CrossDeviceEnderCodeView: %s",
				(tostring(result))
			))
		end
	end

	self.attemptDeeplinkCode = true
	self.confirmingCode = false
	function self.confirmButtonPressed()
		if not self.confirmingCode then
			self.confirmingCode = true
			self:setState({ isConfirming = true, isFocused = false })
			local v5, v6

			if module7() and self.attemptDeeplinkCode and self.props.code then
				v5 = self.props.code
				v6 = "qrCode"
			else
				v5 = self.state.inputCode
				v6 = "alphaNumericCode"
			end

			if module8() and v6 == "alphaNumericCode" then
				v5 = self.latestSanitizedCode
			end

			self.attemptDeeplinkCode = false

			module10(self.props.authAnalytics, v6)

			self.props.validateCode(self.props.networking, v5):andThen(function(p2)
				self.acceptInputCode(v5, p2)
			end, self.clearInputCode)
		end
	end

	local binding, v5 = Roact.createBinding("")
	self.inputText = binding
	self.setInputText = v5
	function self.clearInputCode(p2)
		self.confirmingCode = false
		self.latestSanitizedCode = ""
		self.setInputText("")

		self:setState({
			inputCode = "",
			inputErrorKey = p2.Body == "\"CodeInvalid\"" and "Authentication.CrossDevice.Response.InvalidCode" or p2.Body == "\"InvalidLocation\"" and "Authentication.CrossDevice.Label.InvalidLocationError" or "Authentication.Login.Response.SomethingWentWrong",
			isConfirming = false
		})
	end

	function self.acceptInputCode(p2, data)
		if self.props.confirmDeviceCode then
			self.props.confirmDeviceCode(p2, data.DeviceInfo, data.Location, data.MapImagePath)
		end
	end
end

function extended:didMount()
	if self.props.code then
		local v5 = self.props.code:gsub("[^%w]", ""):upper():sub(1, 6)
		self.setInputText(v5)
		self.latestSanitizedCode = v5
		self:setState({ inputCode = v5 })

		self.confirmButtonPressed()
	end

	self.isMounted = true
	self.props.authAnalytics.reportScreenLoaded(module5.Context.QuickLogin)

	module6(self.props.networking, "PlayerApp.CrossDeviceLogin.ConfirmCode", { "HintTextOverride" }):andThen(
		function(p2)
			local responseBody = p2 and p2.responseBody

			if responseBody and self.isMounted then
				self:setState({
					placeholderTextOverride = responseBody.HintTextOverride or "",
					disableSubmissionForBadCode = responseBody.ShouldDisableSubmissionForBadCode or false
				})
			end
		end,
		function() end
	)
end

function extended:didUpdate(p2)
	if (self.props.confirmFailureCount or 0) > (p2.confirmFailureCount or 0) then
		self.confirmingCode = false
		self:setState({
			inputErrorKey = "Authentication.CrossDevice.Response.LoginFailedTryAgain",
			isConfirming = false
		})
	end
end

function extended:willUnmount()
	self.isMounted = false
end

function extended:renderEnterCodeRefresh(p2, p3, p4)
	return module({
		refreshHeadline = "Authentication.CrossDevice.Heading.SigninAnotherDevice",
		refreshIntro = "Authentication.CrossDevice.Label.SigninInstructionHeading",
		refreshStep1 = "Authentication.CrossDevice.Label.SigninInstructionOne",
		refreshStep2 = "Authentication.CrossDevice.Label.SigninInstructionTwo",
		refreshStep3 = "Authentication.CrossDevice.Label.SigninInstructionThree",
		refreshSecurityFooter = "Authentication.CrossDevice.Label.QuickSignInWarning",
		refreshContinue = "Authentication.CrossDevice.Label.Continue",
		refreshPlaceholder = "Authentication.CrossDevice.Label.EnterCodeTextBox"
	})(function(props)
		local inputCode = self.state.inputCode
		local v5 = self.state.inputErrorKey == ""
		local isConfirming = self.state.isConfirming

		local designTokens = self.props.designTokens
		local color3 = designTokens.LuaApps.CrossDeviceLogin.bodyTextColor.Color3
		local transparency = designTokens.LuaApps.CrossDeviceLogin.headerTextColor.Transparency
		local color3_2 = designTokens.LuaApps.CrossDeviceLogin.textAlertColor.Color3
		local continueButtonFont = designTokens.LuaApps.CrossDeviceLogin.continueButtonFont
		local continueButtonHorizontalPad = designTokens.LuaApps.CrossDeviceLogin.continueButtonHorizontalPad

		local refreshContinue = props.refreshContinue
		local v6 = getTextSize(
			refreshContinue,
			continueButtonFont.FontSize,
			continueButtonFont.Font,
			Vector2.new(10000, 10000)
		).X + continueButtonHorizontalPad
		local refreshIntro = props.refreshIntro
		local localPlayer = Players.LocalPlayer
		local v9

		if localPlayer then
			v9 = localPlayer.DisplayName

			if not v9 or v9 == "" then
				v9 = localPlayer.Name
			end
		else
			v9 = "Player"
		end

		local v10 = refreshIntro:gsub(
			"{username}",
			"<b>" .. v9:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;") .. "</b>"
		)

		local placeholderTextOverride = self.state.placeholderTextOverride ~= ""
			and self.state.placeholderTextOverride
			or props.refreshPlaceholder

		local size_1000 = self.props.tokens.Size.Size_1000
		local size_300 = designTokens.Size.Size_300
		local keyboardOffset = self.props.keyboardOffset or 0

		local createElement = Roact.createElement
		local v14 = {
			tag = "col align-x-left gap-xsmall size-full-0 auto-y",
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Position = 0,
			padding = 0
		}

		local v15 = if keyboardOffset > 0 then UDim2.new(0, 0, 0, -keyboardOffset) else nil
		v14.Position = v15
		v14.padding = { left = UDim.new(0, 0), right = UDim.new(0, 0) }

		local children = {
			CopyBlock = Roact.createElement(view, {
				tag = "col align-x-left gap-xsmall size-full-0 auto-y",
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				padding = { bottom = UDim.new(0, size_300) }
			}, {
				HeadlineWrap = Roact.createElement(view, {
					tag = "col size-full-0 auto-y",
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					padding = { bottom = UDim.new(0, size_300) }
				}, {
					Headline = Roact.createElement(text, {
						tag = "size-full-0 auto-xy text-heading-small text-wrap text-align-x-left",
						LayoutOrder = 1,
						Text = props.refreshHeadline,
						TextWrapped = true
					})
				}),
				Intro = Roact.createElement(text, {
					tag = "size-full-0 auto-xy text-body-medium text-wrap text-align-x-left",
					LayoutOrder = 2,
					Text = v10,
					RichText = true,
					TextWrapped = true
				}),
				StepsIndent = Roact.createElement(view, {
					tag = "col gap-xxsmall size-full-0 auto-y",
					LayoutOrder = 3,
					BackgroundTransparency = 1,
					padding = { left = UDim.new(0, 18) }
				}, {
					Step1 = Roact.createElement(text, {
						tag = "size-full-0 auto-xy text-body-medium text-wrap text-align-x-left",
						LayoutOrder = 1,
						Text = props.refreshStep1,
						TextWrapped = true
					}),
					Step2 = Roact.createElement(text, {
						tag = "size-full-0 auto-xy text-body-medium text-wrap text-align-x-left",
						LayoutOrder = 2,
						Text = props.refreshStep2,
						TextWrapped = true
					}),
					Step3 = Roact.createElement(text, {
						tag = "size-full-0 auto-xy text-body-medium text-wrap text-align-x-left",
						LayoutOrder = 3,
						Text = props.refreshStep3,
						TextWrapped = true
					})
				})
			}),
			InputRow = Roact.createElement(view, {
				tag = "row items-stretch gap-small size-full-0 auto-y",
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				padding = { bottom = UDim.new(0, size_300) }
			}, {
				InputWrap = Roact.createElement(
					view,
					{ tag = "grow auto-y", LayoutOrder = 1, BackgroundTransparency = 1 },
					{
						CodeField = Roact.createElement(textInput, {
							LayoutOrder = 1,
							testId = "--auth-login-textinput-code",
							label = "",
							text = self.inputText,
							onChanged = self.onRefreshCodeChanged,
							placeholder = placeholderTextOverride,
							width = UDim.new(1, 0),
							hasError = not v5,
							size = inputSize.Medium,
							ref = self.props.codeFieldRef,
							onFocusGained = self.onFocus,
							onFocusLost = function()
								self:setState({ isFocused = false })
							end,
							onReturnPressed = function()
								if #self.state.inputCode == 6 then
									self.confirmButtonPressed()
								end
							end
						})
					}
				),
				ContinueButtonWrap = Roact.createElement(
					view,
					{
						tag = "col",
						LayoutOrder = 2,
						Size = UDim2.new(0, v6, 0, size_1000),
						BackgroundTransparency = 1
					},
					{
						ContinueButton = Roact.createElement(button, {
							buttonType = buttonType.PrimarySystem,
							size = UDim2.new(1, 0, 1, 0),
							text = refreshContinue,
							isDisabled = self.state.disableSubmissionForBadCode and #inputCode < 6 and true or inputCode == "",
							isLoading = isConfirming,
							onActivated = self.confirmButtonPressed,
							[Roact.Ref] = self.props.continueButtonRef
						})
					}
				)
			}),
			InputError = 0,
			SecurityFooter = 0
		}
		local v23 = if not v5 then Roact.createElement(view, {
			tag = "col size-full-0 auto-y",
			LayoutOrder = 4,
			BackgroundTransparency = 1,
			padding = { bottom = UDim.new(0, size_300) }
		}, {
			ErrorText = Roact.createElement(text, {
				tag = "size-full-0 auto-xy text-body-small text-wrap text-align-x-left",
				LayoutOrder = 1,
				Text = p3.inputError,
				TextWrapped = true,
				textStyle = { Color3 = color3_2, Transparency = transparency }
			})
		}) or nil else nil
		children.InputError = v23
		children.SecurityFooter = Roact.createElement(text, {
			tag = "size-full-0 auto-xy text-body-small text-wrap text-align-x-left",
			LayoutOrder = 6,
			Text = props.refreshSecurityFooter,
			TextWrapped = true,
			textStyle = { Color3 = color3, Transparency = transparency }
		})
		return createElement(view, v14, children)
	end)
end

function extended:render()
	local isWideView = self.props.isWideView

	local inputCode = self.state.inputCode
	local v5 = self.state.inputErrorKey == ""
	local isConfirming = self.state.isConfirming
	local isFocused = self.state.isFocused

	return withStyle(function(p2)
		local v8 = if not v5 then self.state.inputErrorKey or nil else nil
		return module({
			tabletHeader = "Authentication.CrossDevice.Heading.LoginAnotherDevice",
			warningHeader = "Authentication.CrossDevice.Heading.LoginWarning",
			warning1 = "Authentication.CrossDevice.Label.Warning1",
			warning2 = "Authentication.CrossDevice.Label.Warning2",
			placeholderText = "Authentication.CrossDevice.Label.EnterOtherDeviceCode",
			enter = "Authentication.CrossDevice.Action.Enter",
			inputError = v8
		})(function(props)
			local designTokens = self.props.designTokens
			local v9 = isWideView and self.props.tokens.Size.Size_2000 * 2
				or self.props.tokens.Size.Size_2000 * 4
			local size_2200 = isWideView and self.props.tokens.Size.Size_2200
				or self.props.tokens.Size.Size_2200 * 2
			local v10 = isWideView and 0 or self.props.tokens.Size.Size_350 or 0
			local udim = UDim2.fromOffset(
				designTokens.LuaApps.CrossDeviceLogin.iconSize,
				designTokens.LuaApps.CrossDeviceLogin.iconSize
			)

			local fontSize = designTokens.LuaApps.CrossDeviceLogin.headerFont.FontSize
			local color3 = designTokens.LuaApps.CrossDeviceLogin.headerTextColor.Color3
			local headerPadding = designTokens.LuaApps.CrossDeviceLogin.headerPadding
			local font = designTokens.LuaApps.CrossDeviceLogin.bodyFont.Font
			local fontSize2 = designTokens.LuaApps.CrossDeviceLogin.bodyFont.FontSize
			local color3_2 = designTokens.LuaApps.CrossDeviceLogin.bodyTextColor.Color3
			local transparency = designTokens.LuaApps.CrossDeviceLogin.headerTextColor.Transparency
			local fontSize3 = designTokens.LuaApps.CrossDeviceLogin.textAlertFont.FontSize
			local color3_3 = designTokens.LuaApps.CrossDeviceLogin.textAlertColor.Color3
			local baseSize = p2.Font.BaseSize

			local placeholderTextOverride = self.state.placeholderTextOverride ~= ""
				and self.state.placeholderTextOverride
				or props.placeholderText

			if module8() then
				return self:renderEnterCodeRefresh(p2, props, isWideView)
			end

			return Roact.createElement(isWideView and module13 or module12, {
				TabletHeaderText = props.tabletHeader,
				Style = p2,
				HighKeyboardMode = self.props.highKeyboardMode,
				Icon = getFFlagEnableAuthsecImageUpdate() and Roact.createElement("Frame", {
					LayoutOrder = 1,
					Size = isWideView and udim or UDim2.new(0, v9, 0, size_2200 - v10),
					BackgroundTransparency = 1
				}, {
					Image = Roact.createElement(image, {
						Image = self.getVerifyCodeImage(self.props.tokens.Config.ColorMode.Name),
						ScaleType = Enum.ScaleType.Fit,
						Size = UDim2.new(0, v9, 0, size_2200),
						Position = UDim2.new(0.5, 0, 0.5, -v10 / 2),
						AnchorPoint = Vector2.new(0.5, 0.5)
					})
				}) or Roact.createElement(imageSetLabel, {
					Size = udim,
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					ScaleType = Enum.ScaleType.Fit,
					Image = iconsgraphiclock_xxlarge,
					ImageColor3 = p2.Theme.UIEmphasis.Color,
					ImageTransparency = 0
				}),
				WarningText = Roact.createElement(
					FitChildren.FitFrame,
					{
						LayoutOrder = 2,
						Size = UDim2.new(1, -20, 0, 0),
						fitAxis = FitChildren.FitAxis.Height,
						BackgroundTransparency = 1
					},
					{
						Align = Roact.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Vertical,
							HorizontalAlignment = Enum.HorizontalAlignment.Right,
							Padding = UDim.new(0, 6),
							SortOrder = Enum.SortOrder.LayoutOrder
						}),
						TopWarning = Roact.createElement(fitTextLabel, {
							LayoutOrder = 1,
							Size = UDim2.new(1, 0, 0, 0),
							Text = props.warningHeader,
							TextWrapped = true,
							Font = normalizeFontFace(designTokens.LuaApps.CrossDeviceLogin.headerTypography.Font),
							TextSize = fontSize,
							TextColor3 = color3,
							TextTransparency = transparency,
							TextXAlignment = isWideView and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
							width = UDim.new(1, 0),
							BackgroundTransparency = 1
						}),
						Padding = Roact.createElement("Frame", {
							LayoutOrder = 2,
							Size = UDim2.new(1, 0, 0, headerPadding),
							BackgroundTransparency = 1
						}),
						BulletPoint1 = Roact.createElement(fitTextLabel, {
							LayoutOrder = 3,
							Size = UDim2.new(1, 0, 0, 0),
							Text = props.warning1,
							TextWrapped = true,
							Font = normalizeFontFace(designTokens.Typography.BodyLarge.Font),
							TextSize = fontSize2,
							TextColor3 = color3_2,
							TextTransparency = transparency,
							TextXAlignment = Enum.TextXAlignment.Left,
							width = UDim.new(1, 0),
							BackgroundTransparency = 1
						}),
						BulletPoint2 = Roact.createElement(fitTextLabel, {
							LayoutOrder = 4,
							Size = UDim2.new(1, 0, 0, 0),
							Text = props.warning2,
							TextWrapped = true,
							Font = normalizeFontFace(designTokens.Typography.BodyLarge.Font),
							TextSize = fontSize2,
							TextColor3 = color3_2,
							TextTransparency = transparency,
							TextXAlignment = Enum.TextXAlignment.Left,
							width = UDim.new(1, 0),
							BackgroundTransparency = 1
						})
					}
				),
				InputBox = Roact.createElement(textInputBoxWithBorder, {
					layoutOrder = 3,
					placeholderText = placeholderTextOverride,
					borderState = not v5 and authStatefulRoundCornerBorder.BorderState.Error or isFocused and authStatefulRoundCornerBorder.BorderState.Focused or authStatefulRoundCornerBorder.BorderState.Default,
					text = self.inputText,
					onFocused = self.onFocus,
					onFocusLost = self.onFocusLost,
					onChangeTextCallback = self.onTextChanged
				}),
				InputWarning = not v5 and Roact.createElement(fitTextLabel, {
					LayoutOrder = 4,
					Size = UDim2.new(1, -6, 0, fontSize3),
					Position = UDim2.new(0, 3, 1, 3),
					BackgroundTransparency = 1,
					Font = normalizeFontFace(designTokens.Typography.BodySmall.Font),
					TextSize = fontSize3,
					TextColor3 = color3_3,
					TextTransparency = transparency,
					TextXAlignment = Enum.TextXAlignment.Left,
					Text = props.inputError,
					TextWrapped = true,
					width = UDim.new(1, -6)
				}),
				ConfirmCodeButton = Roact.createElement(button, {
					buttonType = buttonType.PrimarySystem,
					size = UDim2.new(1, 0, 1, 0),
					text = props.enter,
					[Roact.Ref] = self.props.continueButtonRef,
					onActivated = self.confirmButtonPressed,
					isLoading = isConfirming,
					isDisabled = self.state.disableSubmissionForBadCode and #inputCode < 6 and true or inputCode == ""
				}),
				ConfirmCodeButtonWidth = getTextSize(props.enter, baseSize, font, Vector2.new(10000, 10000)).X + 40
			})
		end)
	end)
end

local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local appUserLayers = require("@luauforge/bundled/dPQ").AppUserLayers

local v5 = RoactAppExperiment.connectUserLayer(
	{ appUserLayers.ExposureLayer, appUserLayers.AccessLayer },
	function(p2, p3)
		return {}
	end
)(extended)

local v6 = roactServices.connect({ networking = module2, authAnalytics = module4 })(v5)

local v7 = RoactRodux.connect(function(p2, p3)
	return { screenSize = p2.ScreenSize }
end, function(callback)
	return {
		validateCode = function(p2, p3)
			return callback(module3.EnterCode(p2, p3))
		end
	}
end)(v6)

return function(p2)
	local v8 = useDesignTokens()
	local v9 = useTokens()

	return React.createElement(v7, Cryo.Dictionary.join(p2, {
		designTokens = v8,
		tokens = v9
	}))
end
