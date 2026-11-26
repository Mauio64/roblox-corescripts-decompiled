local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local module = require("@luauforge/deferred/hXI")
local module2 = require("@luauforge/deferred/hXU")

local AlertViewCheckbox = require("@game/CorePackages/Packages/_Index/SocialLibraries/SocialLibraries/Components/AlertView/AlertViewCheckbox")
local module4 = require("@luauforge/deferred/hXY")
local module5 = require("@luauforge/deferred/hXK")
local module6 = require("@luauforge/deferred/hXL")
local module7 = require("@luauforge/deferred/hXM")
local module8 = require("@luauforge/bundled/fzI")
local module9 = require("@luauforge/deferred/hXN")
local module10 = require("@luauforge/bundled/fzL")
local module11 = require("@luauforge/deferred/hXV")
local module12 = require("@luauforge/bundled/egs")
local module13 = require("@luauforge/bundled/ecq")
local module14 = require("@luauforge/bundled/egx")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module15 = require("@luauforge/bundled/hUM")
local module16 = require("@luauforge/bundled/fzQ")
local module17 = require("@luauforge/deferred/hYa")
local module18 = require("@luauforge/deferred/hYb")
local module19 = require("@luauforge/deferred/hYc")
local module20 = require("@luauforge/deferred/hXQ")
local module21 = require("@luauforge/bundled/egZ")

local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local fFlagUseSignalsForAccountSecurityPrompt = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForAccountSecurityPrompt
local getAccountSecurityPromptStore

if fFlagUseSignalsForAccountSecurityPrompt then
	getAccountSecurityPromptStore = require("@luauforge/bundled/fyY").Stores.GetAccountSecurityPromptStore
else
	getAccountSecurityPromptStore = nil
end

local enum = module.Enum
local buttonType = UIBlox.App.Button.Enum.ButtonType
local images = UIBlox.App.ImageSet.Images
local enum2 = module11.Enum
local validator = module19.validator
local withStyle = UIBlox.Style.withStyle

local iconsgraphiclock_xxlarge = images["icons/graphic/lock_xxlarge"]

local joined = Cryo.Dictionary.join({
	action = "Feature.AccountSecurityPrompt.Action.SubmitChangePassword",
	errorPasswordsDoNotMatch = "Feature.AccountSecurityPrompt.Message.Error.Input.PasswordsDoNotMatch",
	header = "Feature.AccountSecurityPrompt.Header.CreateAStrongPassword",
	labelConfirmNewPassword = "Feature.AccountSecurityPrompt.Label.ConfirmNewPassword",
	labelCurrentPassword = "Feature.AccountSecurityPrompt.Label.CurrentPassword",
	labelIForgotMyPassword = "Feature.AccountSecurityPrompt.Label.IForgotMyPassword",
	labelNewPassword = "Feature.AccountSecurityPrompt.Label.NewPassword",
	labelTimeRemaining = "Feature.AccountSecurityPrompt.Label.TimeRemaining",
	labelUseAUniquePassword = "Feature.AccountSecurityPrompt.Label.UseAUniquePassword",
	webViewTitleForgotPassword = "CommonUI.Features.Label.Help"
}, module11.localizationKeys, module19.localizationKeys)

local function fn(...)
	local v5 = { ... }
	return function(p2)
		for i, v6 in ipairs(v5) do
			v6(p2)
		end
	end
end

local extended = Roact.PureComponent:extend("ChangePasswordForm")

function extended:init()
	self:setState({
		currentPassword = "",
		currentPasswordError = nil,
		newPassword = "",
		newPasswordError = nil,
		confirmNewPassword = "",
		confirmNewPasswordError = nil,
		requestError = nil,
		requestErrorForCurrentPassword = false,
		requestInFlight = false,
		accountPinUnlockedForMinutes = 0,
		accountPinUnlockedForSeconds = 0
	})

	function self.setCurrentPassword(p2)
		self:setState({ currentPassword = p2 })
	end

	function self.setNewPassword(p2)
		self:setState({ newPassword = p2 })
	end

	function self.setConfirmNewPassword(p2)
		self:setState({ confirmNewPassword = p2 })
	end

	function self.setRequestError(p2)
		self:setState({
			requestError = p2 or Roact.None
		})
	end

	function self.clearRequestError()
		self.setRequestError(nil)
	end

	function self.setCurrentPasswordError(p2)
		self:setState({
			currentPasswordError = p2 or Roact.None
		})
	end

	function self.setNewPasswordError(p2)
		self:setState({
			newPasswordError = p2 or Roact.None
		})
	end

	function self.clearNewPasswordError()
		self.setNewPasswordError(nil)
	end

	function self.setConfirmNewPasswordError(p2)
		self:setState({
			confirmNewPasswordError = p2 or Roact.None
		})
	end

	function self.clearConfirmNewPasswordError()
		self.setConfirmNewPasswordError(nil)
	end

	function self.changePassword(p2)
		return function()
			self:setState({ requestInFlight = true })

			self.props.changePassword(
				self.props.networking,
				self.state.currentPassword,
				self.state.newPassword
			):andThen(function(p3)
				local v5 = module12.resolve()

				if self.props.accountPinUnlockedUntil ~= nil then
					v5 = self.props.lockAccountPin(self.props.networking):andThen(function(p4)
						self.props.updateAccountPinUnlockTimeout(nil)
					end):catch(function(p4)
						if p4 == enum.AccountLocked then
							self.props.updateAccountPinUnlockTimeout(nil)
						end
					end)
				end

				v5:andThen(function()
					self.props.updatePromptType(self.props.analytics, nil, nil, nil)

					if not self.isMounted then
						return
					end

					self.props.navigateToModalState(module8.ChangePasswordConfirmation)
				end)
			end):catch(function(p3)
				if not self.isMounted then
					return
				end

				self:setState({ requestInFlight = false })

				if p3 == enum2.PinLocked then
					self.props.navigateToModalState(module8.AccountPinFormExpired)
				else
					self:setState({
						requestError = module11.toString(p2, p3),
						requestErrorForCurrentPassword = p3 == enum2.InvalidCurrentPassword
					})
				end
			end)
		end
	end

	function self.openForgotPasswordSupportPage(p2)
		return function()
			self.props.openWebView(
				"https://en.help.roblox.com/hc/articles/203313070-I-Forgot-My-Password",
				p2.webViewTitleForgotPassword
			)
		end
	end
end

function extended:didMount()
	self.isMounted = true

	spawn(function()
		while self.isMounted and self.props.accountPinUnlockedUntil ~= nil do
			local accountPinUnlockedUntil = self.props.accountPinUnlockedUntil
			local unixTimestampMillis = DateTime.now().UnixTimestampMillis
			local unixTimestampMillis2 = accountPinUnlockedUntil.UnixTimestampMillis

			if unixTimestampMillis < unixTimestampMillis2 then
				local v5 = (unixTimestampMillis2 - unixTimestampMillis) / 1000
				self:setState({
					accountPinUnlockedForMinutes = math.floor(v5 / 60),
					accountPinUnlockedForSeconds = math.floor(v5 % 60)
				})

				wait(1)
			else
				self.props.navigateToModalState(module8.AccountPinFormExpired)
				break
			end
		end
	end)
end

function extended:willUnmount()
	self.isMounted = false
end

function extended.render(data)
	local currentPassword = data.state.currentPassword
	local currentPasswordError = data.state.currentPasswordError
	local newPassword = data.state.newPassword
	local newPasswordError = data.state.newPasswordError
	local confirmNewPassword = data.state.confirmNewPassword
	local confirmNewPasswordError = data.state.confirmNewPasswordError
	local requestError = data.state.requestError
	local requestErrorForCurrentPassword = data.state.requestErrorForCurrentPassword
	local requestInFlight = data.state.requestInFlight
	local accountPinUnlockedForMinutes = data.state.accountPinUnlockedForMinutes
	local accountPinUnlockedForSeconds = data.state.accountPinUnlockedForSeconds

	local accountPinUnlockedUntil = data.props.accountPinUnlockedUntil
	local username = data.props.username
	local networking = data.props.networking
	local v5

	if
		currentPassword == ""
		or currentPasswordError ~= nil
		or newPassword == ""
		or newPasswordError ~= nil
		or confirmNewPassword == ""
	then
		v5 = false
	else
		v5 = confirmNewPasswordError == nil
	end

	return withStyle(function(data2)
		return module21(joined)(function(props)
			return Roact.createElement(module5, {
				title = props.header,
				makeBodyFragment = function(p2)
					local createFragment = Roact.createFragment
					local children = {
						ModalBodyText = accountPinUnlockedUntil ~= nil and Roact.createElement(module6, {
							layoutOrder = 1,
							contentWidth = p2,
							text = props.labelTimeRemaining .. "\n" .. string.format(
								"%02d:%02d",
								accountPinUnlockedForMinutes,
								accountPinUnlockedForSeconds
							)
						}),
						ModalTextInputCurrentPassword = Roact.createElement(module9, {
							layoutOrder = 2,
							errorText = currentPasswordError or requestErrorForCurrentPassword and requestError or nil,
							helpComponent = Roact.createElement("TextButton", {
								[Roact.Event.Activated] = data.openForgotPasswordSupportPage(props),
								AutomaticSize = Enum.AutomaticSize.Y,
								BackgroundTransparency = 1,
								FontFace = normalizeFontFace(data2.Tokens.Typography.BodySmall.Font),
								Size = UDim2.fromScale(1, 0),
								Text = props.labelIForgotMyPassword,
								TextColor3 = data2.Theme.TextLink.Color,
								TextSize = data2.Font.CaptionBody.RelativeSize * data2.Font.BaseSize,
								TextWrapped = true,
								TextXAlignment = Enum.TextXAlignment.Left
							}),
							labelText = props.labelCurrentPassword,
							onChanged = data.clearRequestError,
							placeholderText = "",
							setError = data.setCurrentPasswordError,
							setValue = data.setCurrentPassword,
							textInputType = Enum.TextInputType.Password,
							validate = module20,
							value = currentPassword
						}),
						ModalTextInputNewPassword = Roact.createElement(module9, {
							layoutOrder = 3,
							errorText = newPasswordError,
							helpComponent = Roact.createElement(AlertViewCheckbox, {
								helpText = props.labelUseAUniquePassword,
								iconImage = iconsgraphiclock_xxlarge
							}),
							labelText = props.labelNewPassword,
							onChanged = data.clearRequestError,
							placeholderText = "",
							setError = fn(data.clearConfirmNewPasswordError, data.setNewPasswordError),
							setValue = data.setNewPassword,
							textInputType = Enum.TextInputType.Password,
							validate = module17(
								validator(networking, props, username),
								confirmNewPassword ~= "" and module18(props.errorPasswordsDoNotMatch, confirmNewPassword) or module20
							),
							value = newPassword
						}),
						ModalTextInputConfirmNewPassword = 0
					}

					local createElement3 = Roact.createElement

					local v12 = confirmNewPasswordError

					if not v12 then
						v12 = if not requestErrorForCurrentPassword then requestError or nil else nil
					end

					children.ModalTextInputConfirmNewPassword = createElement3(module9, {
						layoutOrder = 4,
						errorText = v12,
						labelText = props.labelConfirmNewPassword,
						onChanged = data.clearRequestError,
						placeholderText = "",
						setError = fn(data.clearNewPasswordError, data.setConfirmNewPasswordError),
						setValue = data.setConfirmNewPassword,
						textInputType = Enum.TextInputType.Password,
						validate = module17(
							module18(props.errorPasswordsDoNotMatch, newPassword),
							validator(networking, props, username)
						),
						value = confirmNewPassword
					})
					return createFragment(children)
				end,
				buttonConfig = module7({
					{
						isDisabled = requestInFlight or not v5,
						isLoading = requestInFlight,
						onActivated = data.changePassword(props),
						text = props.action,
						type = buttonType.PrimarySystem
					}
				})
			})
		end)
	end)
end

local v5 = RoactRodux.connect(function(data, p2)
	local v7 = if not fFlagUseSignalsForAccountSecurityPrompt then data.AccountSecurityPrompt.accountPinUnlockedUntil else nil
	return {
		accountPinUnlockedUntil = v7,
		username = data.Users[data.LocalUserId] and data.Users[data.LocalUserId].name or ""
	}
end, function(callback)
	return {
		changePassword = function(p2, p3, p4)
			return callback(module2(p2, p3, p4))
		end,
		openWebView = function(p2, p3)
			return callback(module10(p2, p3))
		end,
		lockAccountPin = function(p2)
			return callback(module4(p2))
		end,
		updateAccountPinUnlockTimeout = function(p2)
			if fFlagUseSignalsForAccountSecurityPrompt then
				getAccountSecurityPromptStore(false).updateAccountPinUnlockTimeout(p2)
			else
				callback(module15(p2))
			end
		end,
		updatePromptType = function(p2, p3, p4, p5)
			return callback(module16(p2, p3, p4, p5))
		end
	}
end)(extended)
local v6

if fFlagUseSignalsForAccountSecurityPrompt then
	v6 = React.memo(function(p2)
		local v7 = useSignalState(getAccountSecurityPromptStore(false).getAccountPinUnlockedUntil)
		return Roact.createElement(v5, Cryo.Dictionary.union(p2, {
			accountPinUnlockedUntil = v7
		}))
	end)
else
	v6 = v5
end

return (roactServices.connect({ analytics = module13, networking = module14 })(v6))
