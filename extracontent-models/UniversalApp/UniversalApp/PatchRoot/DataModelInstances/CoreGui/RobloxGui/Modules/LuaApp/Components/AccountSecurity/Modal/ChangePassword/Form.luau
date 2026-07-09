local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local AccountPinError = require(Modules.LuaApp.Enum.AccountSecurity.AccountPinError)
local ChangePassword = require(Modules.LuaApp.Thunks.AccountSecurity.ChangePassword)
local InputHelpTextWithIcon = require(Modules.LuaApp.Components.AccountSecurity.Modal.ChangePassword.InputHelpTextWithIcon)
local LockAccountPin = require(Modules.LuaApp.Thunks.AccountSecurity.LockAccountPin)
local ModalBase = require(Modules.LuaApp.Components.AccountSecurity.Common.ModalBase)
local ModalBodyText = require(Modules.LuaApp.Components.AccountSecurity.Common.ModalBodyText)
local ModalButtonConfig = require(Modules.LuaApp.Components.AccountSecurity.Common.ModalButtonConfig)
local ModalState = require(Modules.LuaApp.Enum.AccountSecurity.ModalState)
local ModalTextInput = require(Modules.LuaApp.Components.AccountSecurity.Common.ModalTextInput)
local OpenWebview = require(Modules.LuaApp.Thunks.OpenWebview)
local PasswordError = require(Modules.LuaApp.Enum.AccountSecurity.PasswordError)
local Promise = require(Modules.LuaApp.Promise)
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local UpdateAccountPinUnlockTimeout = require(Modules.LuaApp.Actions.AccountSecurity.UpdateAccountPinUnlockTimeout)
local UpdatePromptTypeWithEvent = require(Modules.LuaApp.Thunks.AccountSecurity.UpdatePromptTypeWithEvent)
local Chained = require(Modules.LuaApp.Thunks.AccountSecurity.Validators.Chained)
local Equals = require(Modules.LuaApp.Thunks.AccountSecurity.Validators.Equals)
local Password = require(Modules.LuaApp.Thunks.AccountSecurity.Validators.Password)
local True = require(Modules.LuaApp.Thunks.AccountSecurity.Validators.True)
local withLocalization = require(Modules.LuaApp.withLocalization)
local Enum2 = AccountPinError.Enum
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Images = UIBlox.App.ImageSet.Images
local Enum3 = PasswordError.Enum
local validator = Password.validator
local withStyle = UIBlox.Style.withStyle
local v35 = Images["icons/graphic/lock_xxlarge"]
local v36 = Cryo.Dictionary.join({
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
}, PasswordError.localizationKeys, Password.localizationKeys)

local function v37(...) -- line: 58
	local t1 = { ... }

	return function(p1) -- line: 60
		-- upvalues: t1 (copy)
		for _, v in ipairs(t1) do
			v(p1)
		end
	end
end

local v38 = Roact.PureComponent:extend("ChangePassword" .. script.Name)

function v38.init(p2) -- line: 70
	-- upvalues: Roact (copy), Promise (copy), Enum2 (copy), ModalState (copy), Enum3 (copy), PasswordError (copy)
	p2:setState({
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

	function p2.setCurrentPassword(p3) -- line: 87
		-- upvalues: p2 (copy)
		p2:setState({
			currentPassword = p3
		})
	end
	function p2.setNewPassword(p4) -- line: 93
		-- upvalues: p2 (copy)
		p2:setState({
			newPassword = p4
		})
	end
	function p2.setConfirmNewPassword(p5) -- line: 99
		-- upvalues: p2 (copy)
		p2:setState({
			confirmNewPassword = p5
		})
	end
	function p2.setRequestError(p6) -- line: 105
		-- upvalues: p2 (copy), Roact (copy)
		p2:setState({
			requestError = p6 or Roact.None
		})
	end
	function p2.clearRequestError() -- line: 111
		-- upvalues: p2 (copy)
		p2.setRequestError(nil)
	end
	function p2.setCurrentPasswordError(p7) -- line: 115
		-- upvalues: p2 (copy), Roact (copy)
		p2:setState({
			currentPasswordError = p7 or Roact.None
		})
	end
	function p2.setNewPasswordError(p8) -- line: 121
		-- upvalues: p2 (copy), Roact (copy)
		p2:setState({
			newPasswordError = p8 or Roact.None
		})
	end
	function p2.clearNewPasswordError() -- line: 127
		-- upvalues: p2 (copy)
		p2.setNewPasswordError(nil)
	end
	function p2.setConfirmNewPasswordError(p9) -- line: 131
		-- upvalues: p2 (copy), Roact (copy)
		p2:setState({
			confirmNewPasswordError = p9 or Roact.None
		})
	end
	function p2.clearConfirmNewPasswordError() -- line: 137
		-- upvalues: p2 (copy)
		p2.setConfirmNewPasswordError(nil)
	end
	function p2.changePassword(p10) -- line: 141
		-- upvalues: p2 (copy), Promise (copy), Enum2 (copy), ModalState (copy), Enum3 (copy), PasswordError (copy)
		return function() -- line: 142
			-- upvalues: p2 (copy), Promise (copy), Enum2 (copy), ModalState (copy), Enum3 (copy), PasswordError (copy), p10 (copy)
			p2:setState({
				requestInFlight = true
			})
			p2.props.changePassword(p2.props.networking, p2.state.currentPassword, p2.state.newPassword):andThen(function(_) -- line: 150
				-- upvalues: Promise (copy), p2 (copy), Enum2 (copy), ModalState (copy)
				local v93 = Promise.resolve()

				if p2.props.accountPinUnlockedUntil ~= nil then
					v93 = p2.props.lockAccountPin(p2.props.networking):andThen(function(_) -- line: 157
						-- upvalues: p2 (copy)
						p2.props.updateAccountPinUnlockTimeout(nil)
					end):catch(function(p13) -- line: 160
						-- upvalues: Enum2 (copy), p2 (copy)
						if p13 == Enum2.AccountLocked then
							p2.props.updateAccountPinUnlockTimeout(nil)
						end
					end)
				end

				v93:andThen(function() -- line: 167
					-- upvalues: p2 (copy), ModalState (copy)
					p2.props.updatePromptType(p2.props.analytics, nil, nil, nil)

					if not p2.isMounted then
						return
					end

					p2.props.navigateToModalState(ModalState.ChangePasswordConfirmation)
				end)
			end):catch(function(p14) -- line: 176
				-- upvalues: p2 (copy), Enum3 (copy), ModalState (copy), PasswordError (copy), p10 (copy)
				if not p2.isMounted then
					return
				end

				p2:setState({
					requestInFlight = false
				})

				if p14 == Enum3.PinLocked then
					p2.props.navigateToModalState(ModalState.AccountPinFormExpired)

					return
				end

				p2:setState({
					requestError = PasswordError.toString(p10, p14),
					requestErrorForCurrentPassword = p14 == Enum3.InvalidCurrentPassword
				})
			end)
		end
	end
	function p2.openForgotPasswordSupportPage(p15) -- line: 199
		-- upvalues: p2 (copy)
		return function() -- line: 200
			-- upvalues: p2 (copy), p15 (copy)
			p2.props.openWebView("https://en.help.roblox.com/hc/articles/203313070-I-Forgot-My-Password", p15.webViewTitleForgotPassword)
		end
	end
end
function v38.didMount(p16) -- line: 206
	-- upvalues: ModalState (copy)
	p16.isMounted = true
	spawn(function() -- line: 210
		-- upvalues: p16 (copy), ModalState (copy)
		while p16.isMounted and p16.props.accountPinUnlockedUntil ~= nil do
			local accountPinUnlockedUntil = p16.props.accountPinUnlockedUntil
			local UnixTimestampMillis = DateTime.now().UnixTimestampMillis
			local UnixTimestampMillis2 = accountPinUnlockedUntil.UnixTimestampMillis

			if not (UnixTimestampMillis < UnixTimestampMillis2) then
				p16.props.navigateToModalState(ModalState.AccountPinFormExpired)

				return
			end

			local v78 = (UnixTimestampMillis2 - UnixTimestampMillis) / 1000

			p16:setState({
				accountPinUnlockedForMinutes = math.floor(v78 / 60),
				accountPinUnlockedForSeconds = math.floor(v78 % 60)
			})
			wait(1)
		end
	end)
end
function v38.willUnmount(p17) -- line: 235
	p17.isMounted = false
end
function v38.render(p18) -- line: 239
	-- upvalues: withStyle (copy), withLocalization (copy), v36 (copy), Roact (copy), ModalBase (copy), ModalBodyText (copy), ModalTextInput (copy), True (copy), InputHelpTextWithIcon (copy), v35 (copy), v37 (copy), Chained (copy), validator (copy), Equals (copy), ModalButtonConfig (copy), ButtonType (copy)
	local currentPassword = p18.state.currentPassword
	local currentPasswordError = p18.state.currentPasswordError
	local newPassword = p18.state.newPassword
	local newPasswordError = p18.state.newPasswordError
	local confirmNewPassword = p18.state.confirmNewPassword
	local confirmNewPasswordError = p18.state.confirmNewPasswordError
	local requestError = p18.state.requestError
	local requestErrorForCurrentPassword = p18.state.requestErrorForCurrentPassword
	local requestInFlight = p18.state.requestInFlight
	local accountPinUnlockedForMinutes = p18.state.accountPinUnlockedForMinutes
	local accountPinUnlockedForSeconds = p18.state.accountPinUnlockedForSeconds
	local accountPinUnlockedUntil = p18.props.accountPinUnlockedUntil
	local username = p18.props.username
	local networking = p18.props.networking
	local v59 = currentPassword ~= "" and (currentPasswordError == nil and (newPassword ~= "" and (newPasswordError == nil and (confirmNewPassword ~= "" and confirmNewPasswordError == nil))))

	return withStyle(function(p19) -- line: 264
		-- upvalues: withLocalization (copy), v36 (copy), Roact (copy), ModalBase (copy), accountPinUnlockedUntil (copy), ModalBodyText (copy), accountPinUnlockedForMinutes (copy), accountPinUnlockedForSeconds (copy), ModalTextInput (copy), currentPasswordError (copy), requestErrorForCurrentPassword (copy), requestError (copy), p18 (copy), True (copy), currentPassword (copy), newPasswordError (copy), InputHelpTextWithIcon (copy), v35 (copy), v37 (copy), Chained (copy), validator (copy), networking (copy), username (copy), confirmNewPassword (copy), Equals (copy), newPassword (copy), confirmNewPasswordError (copy), ModalButtonConfig (copy), requestInFlight (copy), v59 (copy), ButtonType (copy)
		return withLocalization(v36)(function(p20) -- line: 265
			-- upvalues: Roact (copy), ModalBase (copy), accountPinUnlockedUntil (copy), ModalBodyText (copy), accountPinUnlockedForMinutes (copy), accountPinUnlockedForSeconds (copy), ModalTextInput (copy), currentPasswordError (copy), requestErrorForCurrentPassword (copy), requestError (copy), p18 (copy), p19 (copy), True (copy), currentPassword (copy), newPasswordError (copy), InputHelpTextWithIcon (copy), v35 (copy), v37 (copy), Chained (copy), validator (copy), networking (copy), username (copy), confirmNewPassword (copy), Equals (copy), newPassword (copy), confirmNewPasswordError (copy), ModalButtonConfig (copy), requestInFlight (copy), v59 (copy), ButtonType (copy)
			return Roact.createElement(ModalBase, {
				title = p20.header,
				makeBodyFragment = function(p21) -- line: 268
					-- upvalues: Roact (copy), accountPinUnlockedUntil (copy), ModalBodyText (copy), p20 (copy), accountPinUnlockedForMinutes (copy), accountPinUnlockedForSeconds (copy), ModalTextInput (copy), currentPasswordError (copy), requestErrorForCurrentPassword (copy), requestError (copy), p18 (copy), p19 (copy), True (copy), currentPassword (copy), newPasswordError (copy), InputHelpTextWithIcon (copy), v35 (copy), v37 (copy), Chained (copy), validator (copy), networking (copy), username (copy), confirmNewPassword (copy), Equals (copy), newPassword (copy), confirmNewPasswordError (copy)
					return Roact.createFragment({
						ModalBodyText = accountPinUnlockedUntil ~= nil and Roact.createElement(ModalBodyText, {
							layoutOrder = 1,
							contentWidth = p21,
							text = p20.labelTimeRemaining .. "\n" .. string.format("%02d:%02d", accountPinUnlockedForMinutes, accountPinUnlockedForSeconds)
						}),
						ModalTextInputCurrentPassword = Roact.createElement(ModalTextInput, {
							layoutOrder = 2,
							placeholderText = "",
							errorText = currentPasswordError or (requestErrorForCurrentPassword and requestError or nil),
							helpComponent = Roact.createElement("TextButton", {
								[Roact.Event.Activated] = p18.openForgotPasswordSupportPage(p20),
								AutomaticSize = Enum.AutomaticSize.Y,
								BackgroundTransparency = 1,
								Font = p19.Font.CaptionBody.Font,
								Size = UDim2.fromScale(1, 0),
								Text = p20.labelIForgotMyPassword,
								TextColor3 = p19.Theme.TextLink.Color,
								TextSize = p19.Font.CaptionBody.RelativeSize * p19.Font.BaseSize,
								TextWrapped = true,
								TextXAlignment = Enum.TextXAlignment.Left
							}),
							labelText = p20.labelCurrentPassword,
							onChanged = p18.clearRequestError,
							setError = p18.setCurrentPasswordError,
							setValue = p18.setCurrentPassword,
							textInputType = Enum.TextInputType.Password,
							validate = True,
							value = currentPassword
						}),
						ModalTextInputNewPassword = Roact.createElement(ModalTextInput, {
							layoutOrder = 3,
							placeholderText = "",
							errorText = newPasswordError,
							helpComponent = Roact.createElement(InputHelpTextWithIcon, {
								helpText = p20.labelUseAUniquePassword,
								iconImage = v35
							}),
							labelText = p20.labelNewPassword,
							onChanged = p18.clearRequestError,
							setError = v37(p18.clearConfirmNewPasswordError, p18.setNewPasswordError),
							setValue = p18.setNewPassword,
							textInputType = Enum.TextInputType.Password,
							validate = Chained(validator(networking, p20, username), confirmNewPassword ~= "" and Equals(p20.errorPasswordsDoNotMatch, confirmNewPassword) or True),
							value = newPassword
						}),
						ModalTextInputConfirmNewPassword = Roact.createElement(ModalTextInput, {
							layoutOrder = 4,
							placeholderText = "",
							errorText = confirmNewPasswordError or (not requestErrorForCurrentPassword and requestError or nil),
							labelText = p20.labelConfirmNewPassword,
							onChanged = p18.clearRequestError,
							setError = v37(p18.clearNewPasswordError, p18.setConfirmNewPasswordError),
							setValue = p18.setConfirmNewPassword,
							textInputType = Enum.TextInputType.Password,
							validate = Chained(Equals(p20.errorPasswordsDoNotMatch, newPassword), validator(networking, p20, username)),
							value = confirmNewPassword
						})
					})
				end,
				buttonConfig = ModalButtonConfig({{
					isDisabled = requestInFlight or not v59,
					isLoading = requestInFlight,
					onActivated = p18.changePassword(p20),
					text = p20.action,
					type = ButtonType.PrimarySystem
				}})
			})
		end)
	end)
end

local v39 = RoactRodux.connect(function(p22, _) -- line: 363
	return {
		accountPinUnlockedUntil = p22.AccountSecurityPrompt.accountPinUnlockedUntil,
		username = p22.Users[p22.LocalUserId] and p22.Users[p22.LocalUserId].name or ""
	}
end, function(p24) -- line: 368
	-- upvalues: ChangePassword (copy), OpenWebview (copy), LockAccountPin (copy), UpdateAccountPinUnlockTimeout (copy), UpdatePromptTypeWithEvent (copy)
	return {
		changePassword = function(p25, p26, p27) -- line: 370
			-- upvalues: p24 (copy), ChangePassword (copy)
			return p24(ChangePassword(p25, p26, p27))
		end,
		openWebView = function(p28, p29) -- line: 373
			-- upvalues: p24 (copy), OpenWebview (copy)
			return p24(OpenWebview(p28, p29))
		end,
		lockAccountPin = function(p30) -- line: 376
			-- upvalues: p24 (copy), LockAccountPin (copy)
			return p24(LockAccountPin(p30))
		end,
		updateAccountPinUnlockTimeout = function(p31) -- line: 379
			-- upvalues: p24 (copy), UpdateAccountPinUnlockTimeout (copy)
			return p24(UpdateAccountPinUnlockTimeout(p31))
		end,
		updatePromptType = function(p32, p33, p34, p35) -- line: 382
			-- upvalues: p24 (copy), UpdatePromptTypeWithEvent (copy)
			return p24(UpdatePromptTypeWithEvent(p32, p33, p34, p35))
		end
	}
end)(v38)

return (RoactServices.connect({
	analytics = RoactAnalytics,
	networking = RoactNetworking
})(v39))
