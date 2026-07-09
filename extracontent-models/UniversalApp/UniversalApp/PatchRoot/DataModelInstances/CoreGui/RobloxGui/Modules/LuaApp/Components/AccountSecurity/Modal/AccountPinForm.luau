local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local AccountPinError = require(Modules.LuaApp.Enum.AccountSecurity.AccountPinError)
local Lock = require(Modules.LuaApp.Components.AccountSecurity.Common.Lock)
local ModalBase = require(Modules.LuaApp.Components.AccountSecurity.Common.ModalBase)
local ModalBodyText = require(Modules.LuaApp.Components.AccountSecurity.Common.ModalBodyText)
local ModalButtonConfig = require(Modules.LuaApp.Components.AccountSecurity.Common.ModalButtonConfig)
local ModalState = require(Modules.LuaApp.Enum.AccountSecurity.ModalState)
local ModalTextInput = require(Modules.LuaApp.Components.AccountSecurity.Common.ModalTextInput)
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local UpdateAccountPinUnlockTimeout = require(Modules.LuaApp.Actions.AccountSecurity.UpdateAccountPinUnlockTimeout)
local UnlockAccountPin = require(Modules.LuaApp.Thunks.AccountSecurity.UnlockAccountPin)
local True = require(Modules.LuaApp.Thunks.AccountSecurity.Validators.True)
local withLocalization = require(Modules.LuaApp.withLocalization)
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local v22 = Cryo.Dictionary.join({
	action = "Feature.AccountSecurityPrompt.Action.UnlockAccountPin",
	description = "Feature.AccountSecurityPrompt.Description.EnterYourAccountPin",
	header = "Feature.AccountSecurityPrompt.Header.AccountPinRequired",
	headerExpired = "Feature.AccountSecurityPrompt.Header.AccountPinExpired",
	label = "Feature.AccountSecurityPrompt.Label.AccountPin"
}, AccountPinError.localizationKeys)
local v23 = Roact.PureComponent:extend(script.Name)

function v23.init(p1) -- line: 38
	-- upvalues: Roact (copy), ModalState (copy), AccountPinError (copy)
	p1:setState({
		accountPin = "",
		accountPinError = nil,
		requestError = nil,
		requestInFlight = false
	})

	function p1.setAccountPin(p2) -- line: 48
		-- upvalues: p1 (copy)
		p1:setState({
			accountPin = p2
		})
	end
	function p1.setAccountPinError(p3) -- line: 54
		-- upvalues: p1 (copy), Roact (copy)
		p1:setState({
			accountPinError = p3 or Roact.None
		})
	end
	function p1.clearRequestError() -- line: 60
		-- upvalues: p1 (copy), Roact (copy)
		p1:setState({
			requestError = Roact.None
		})
	end
	function p1.unlockAccountPin(p4) -- line: 66
		-- upvalues: p1 (copy), ModalState (copy), AccountPinError (copy)
		return function() -- line: 67
			-- upvalues: p1 (copy), ModalState (copy), AccountPinError (copy), p4 (copy)
			p1:setState({
				requestInFlight = true
			})
			p1.props.unlockAccountPin(p1.props.networking, p1.state.accountPin):andThen(function(p5) -- line: 75
				-- upvalues: p1 (copy), ModalState (copy)
				local v44 = math.floor(p5.unlockedUntil * 1000)
				local v45 = DateTime.now().UnixTimestampMillis + v44

				p1.props.updateAccountPinUnlockTimeout(DateTime.fromUnixTimestampMillis(v45))

				if not p1.isMounted then
					return
				end

				p1.props.navigateToModalState(ModalState.ChangePasswordForm)
			end):catch(function(p6) -- line: 90
				-- upvalues: p1 (copy), AccountPinError (copy), p4 (copy)
				if not p1.isMounted then
					return
				end

				p1:setState({
					requestInFlight = false,
					requestError = AccountPinError.toString(p4, p6)
				})
			end)
		end
	end
end
function v23.didMount(p7) -- line: 104
	p7.isMounted = true
end
function v23.willUnmount(p8) -- line: 108
	p8.isMounted = false
end
function v23.render(p9) -- line: 112
	-- upvalues: withLocalization (copy), v22 (copy), ModalState (copy), Roact (copy), ModalBase (copy), Lock (copy), ModalBodyText (copy), ModalTextInput (copy), True (copy), ModalButtonConfig (copy), ButtonType (copy)
	local accountPin = p9.state.accountPin
	local requestError = p9.state.requestError
	local requestInFlight = p9.state.requestInFlight
	local v32 = accountPin ~= ""

	return withLocalization(v22)(function(p10) -- line: 118
		-- upvalues: p9 (copy), ModalState (copy), Roact (copy), ModalBase (copy), Lock (copy), ModalBodyText (copy), ModalTextInput (copy), requestError (copy), True (copy), accountPin (copy), ModalButtonConfig (copy), requestInFlight (copy), v32 (copy), ButtonType (copy)
		local v38 = if p9.props.modalState ~= ModalState.AccountPinForm then p10.headerExpired else p10.header

		return Roact.createElement(ModalBase, {
			title = v38,
			makeBodyFragment = function(p11) -- line: 128
				-- upvalues: Roact (copy), Lock (copy), ModalBodyText (copy), p10 (copy), ModalTextInput (copy), requestError (copy), p9 (copy), True (copy), accountPin (copy)
				return Roact.createFragment({
					Lock = Roact.createElement(Lock, {
						layoutOrder = 1
					}),
					ModalBodyText = Roact.createElement(ModalBodyText, {
						layoutOrder = 2,
						contentWidth = p11,
						text = p10.description
					}),
					ModalTextInput = Roact.createElement(ModalTextInput, {
						layoutOrder = 3,
						placeholderText = "",
						errorText = requestError,
						labelText = p10.label,
						onChanged = p9.clearRequestError,
						setError = p9.setAccountPinError,
						setValue = p9.setAccountPin,
						textInputType = Enum.TextInputType.Password,
						validate = True,
						value = accountPin
					})
				})
			end,
			buttonConfig = ModalButtonConfig({{
				isDisabled = requestInFlight or not v32,
				isLoading = requestInFlight,
				onActivated = p9.unlockAccountPin(p10),
				text = p10.action,
				type = ButtonType.PrimarySystem
			}})
		})
	end)
end

local v24 = RoactRodux.connect(nil, function(p12) -- line: 165
	-- upvalues: UpdateAccountPinUnlockTimeout (copy), UnlockAccountPin (copy)
	return {
		updateAccountPinUnlockTimeout = function(p13) -- line: 167
			-- upvalues: p12 (copy), UpdateAccountPinUnlockTimeout (copy)
			return p12(UpdateAccountPinUnlockTimeout(p13))
		end,
		unlockAccountPin = function(p14, p15) -- line: 170
			-- upvalues: p12 (copy), UnlockAccountPin (copy)
			return p12(UnlockAccountPin(p14, p15))
		end
	}
end)(v23)

return (RoactServices.connect({
	analytics = RoactAnalytics,
	networking = RoactNetworking
})(v24))
