local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local AccountPinError = require(Modules.LuaApp.Enum.AccountSecurity.AccountPinError)
local GetAccountPinState = require(Modules.LuaApp.Thunks.AccountSecurity.GetAccountPinState)
local GetDaysRemainingToForceResetString = require(Modules.LuaApp.Components.AccountSecurity.Helpers.GetDaysRemainingToForceResetString)
local Lock = require(Modules.LuaApp.Components.AccountSecurity.Common.Lock)
local ModalBase = require(Modules.LuaApp.Components.AccountSecurity.Common.ModalBase)
local ModalBodyText = require(Modules.LuaApp.Components.AccountSecurity.Common.ModalBodyText)
local ModalButtonConfig = require(Modules.LuaApp.Components.AccountSecurity.Common.ModalButtonConfig)
local ModalErrorText = require(Modules.LuaApp.Components.AccountSecurity.Common.ModalErrorText)
local ModalState = require(Modules.LuaApp.Enum.AccountSecurity.ModalState)
local PromptType = require(Modules.LuaApp.Enum.AccountSecurity.PromptType)
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local UpdateAccountPinUnlockTimeout = require(Modules.LuaApp.Actions.AccountSecurity.UpdateAccountPinUnlockTimeout)
local withLocalization = require(Modules.LuaApp.withLocalization)
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local t1 = {
	[PromptType.ChangePasswordSuspectedCompromise] = Cryo.Dictionary.join({
		action = "Feature.AccountSecurityPrompt.Action.ContinueChangePassword",
		descriptionEnd = "Feature.AccountSecurityPrompt.Description.ChangeYourPassword",
		descriptionStart = "Feature.AccountSecurityPrompt.Description.UnusualActivity",
		header = "Feature.AccountSecurityPrompt.Header.ChangeYourPassword"
	}, AccountPinError.localizationKeys),
	[PromptType.ChangePasswordBreachedCredential] = Cryo.Dictionary.join({
		action = "Feature.AccountSecurityPrompt.Action.ContinueChangePassword",
		descriptionEnd = "Feature.AccountSecurityPrompt.Description.NoChangeForceReset",
		descriptionEndSingular = "Feature.AccountSecurityPrompt.Description.NoChangeForceResetSingular",
		descriptionStart = "Feature.AccountSecurityPrompt.Description.ChangeYourPassword",
		header = "Feature.AccountSecurityPrompt.Header.ChangeYourPassword"
	}, AccountPinError.localizationKeys)
}
local v24 = Roact.PureComponent:extend("ChangePassword" .. script.Name)

function v24.init(p1) -- line: 48
	-- upvalues: ModalState (copy), AccountPinError (copy)
	p1:setState({
		requestError = nil,
		requestInFlight = false
	})

	function p1.continueToChangePassword(p2) -- line: 56
		-- upvalues: p1 (copy), ModalState (copy), AccountPinError (copy)
		return function() -- line: 57
			-- upvalues: p1 (copy), ModalState (copy), AccountPinError (copy), p2 (copy)
			p1:setState({
				requestInFlight = true
			})
			p1.props.getAccountPinState(p1.props.networking):andThen(function(p3) -- line: 65
				-- upvalues: p1 (copy), ModalState (copy)
				if p3.unlockedUntil ~= nil and p3.unlockedUntil > 0 or not p3.isEnabled then
					if p3.unlockedUntil ~= nil then
						local v46 = math.floor(p3.unlockedUntil * 1000)
						local v47 = DateTime.now().UnixTimestampMillis + v46

						p1.props.updateAccountPinUnlockTimeout(DateTime.fromUnixTimestampMillis(v47))
					else
						p1.props.updateAccountPinUnlockTimeout(nil)
					end

					if not p1.isMounted then
						return
					end

					p1.props.navigateToModalState(ModalState.ChangePasswordForm)

					return
				end

				if not p1.isMounted then
					return
				end

				p1.props.navigateToModalState(ModalState.AccountPinForm)
			end):catch(function(p4) -- line: 93
				-- upvalues: p1 (copy), AccountPinError (copy), p2 (copy)
				if not p1.isMounted then
					return
				end

				p1:setState({
					requestInFlight = false,
					requestError = AccountPinError.toString(p2, p4)
				})
			end)
		end
	end
end
function v24.didMount(p5) -- line: 107
	p5.isMounted = true
end
function v24.willUnmount(p6) -- line: 111
	p6.isMounted = false
end
function v24.render(p7) -- line: 115
	-- upvalues: t1 (copy), PromptType (copy), withLocalization (copy), GetDaysRemainingToForceResetString (copy), Roact (copy), ModalBase (copy), Lock (copy), ModalBodyText (copy), ModalErrorText (copy), ModalButtonConfig (copy), ButtonType (copy)
	local promptType = p7.props.promptType
	local metadata = p7.props.metadata
	local requestError = p7.state.requestError
	local requestInFlight = p7.state.requestInFlight
	local v34 = t1[promptType] or t1[PromptType.ChangePasswordSuspectedCompromise]

	return withLocalization(v34)(function(p8) -- line: 124
		-- upvalues: promptType (copy), PromptType (copy), GetDaysRemainingToForceResetString (copy), metadata (copy), Roact (copy), ModalBase (copy), Lock (copy), ModalBodyText (copy), requestError (copy), ModalErrorText (copy), ModalButtonConfig (copy), requestInFlight (copy), p7 (copy), ButtonType (copy)
		local descriptionEnd = p8.descriptionEnd

		if promptType == PromptType.ChangePasswordBreachedCredential then
			descriptionEnd = GetDaysRemainingToForceResetString(p8.descriptionEndSingular, p8.descriptionEnd, metadata.forceResetTimestamp)
		end

		local v41 = p8.descriptionStart .. " " .. descriptionEnd

		return Roact.createElement(ModalBase, {
			title = p8.header,
			makeBodyFragment = function(p9) -- line: 138
				-- upvalues: Roact (copy), Lock (copy), ModalBodyText (copy), v41 (copy), requestError (copy), ModalErrorText (copy)
				return Roact.createFragment({
					Lock = Roact.createElement(Lock, {
						layoutOrder = 1
					}),
					ModalBodyText = Roact.createElement(ModalBodyText, {
						layoutOrder = 2,
						richText = true,
						contentWidth = p9,
						text = v41
					}),
					ModalErrorText = requestError and Roact.createElement(ModalErrorText, {
						layoutOrder = 3,
						contentWidth = p9,
						errorText = requestError
					})
				})
			end,
			buttonConfig = ModalButtonConfig({{
				isDisabled = requestInFlight,
				isLoading = requestInFlight,
				onActivated = p7.continueToChangePassword(p8),
				text = p8.action,
				type = ButtonType.PrimarySystem
			}})
		})
	end)
end

local v25 = RoactRodux.connect(function(p10, _) -- line: 169
	return {
		promptType = p10.AccountSecurityPrompt.promptType,
		metadata = p10.AccountSecurityPrompt.metadata
	}
end, function(p12) -- line: 174
	-- upvalues: GetAccountPinState (copy), UpdateAccountPinUnlockTimeout (copy)
	return {
		getAccountPinState = function(p13) -- line: 176
			-- upvalues: p12 (copy), GetAccountPinState (copy)
			return p12(GetAccountPinState(p13))
		end,
		updateAccountPinUnlockTimeout = function(p14) -- line: 179
			-- upvalues: p12 (copy), UpdateAccountPinUnlockTimeout (copy)
			return p12(UpdateAccountPinUnlockTimeout(p14))
		end
	}
end)(v24)

return (RoactServices.connect({
	analytics = RoactAnalytics,
	networking = RoactNetworking
})(v25))
