local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local accountSecurityPromptEvent = require(Modules.LuaApp.Analytics.Events.accountSecurityPromptEvent)
local EventStreamConstants = require(Modules.LuaApp.EventStreamConstants)
local AccountPinForm = require(Modules.LuaApp.Components.AccountSecurity.Modal.AccountPinForm)
local AccountRestoresPolicyUpsell = require(Modules.LuaApp.Components.AccountSecurity.Modal.AccountRestoresPolicyUpsell)
local Confirmation = require(Modules.LuaApp.Components.AccountSecurity.Modal.ChangePassword.Confirmation)
local Form = require(Modules.LuaApp.Components.AccountSecurity.Modal.ChangePassword.Form)
local IntroV2 = require(Modules.LuaApp.Components.AccountSecurity.Modal.ChangePassword.IntroV2)
local Intro = require(Modules.LuaApp.Components.AccountSecurity.Modal.AuthenticatorUpsell.Intro)
local InstallApps = require(Modules.LuaApp.Components.AccountSecurity.Modal.AuthenticatorUpsell.InstallApps)
local Email2SVUpsell = require(Modules.LuaApp.Components.AccountSecurity.Modal.Email2SVUpsell)
local DismissConfirmation = require(Modules.LuaApp.Components.AccountSecurity.Modal.DismissConfirmation)
local ModalState = require(Modules.LuaApp.Enum.AccountSecurity.ModalState)
local PromptType = require(Modules.LuaApp.Enum.AccountSecurity.PromptType)
local Roact = require(Modules.Common.Roact)
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local RoactRodux = require(Modules.Common.RoactRodux)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local t1 = {
	[ModalState.ChangePasswordIntro] = IntroV2,
	[ModalState.ChangePasswordForm] = Form,
	[ModalState.ChangePasswordConfirmation] = Confirmation,
	[ModalState.ChangePasswordDismissConfirmation] = DismissConfirmation,
	[ModalState.AccountPinForm] = AccountPinForm,
	[ModalState.AccountPinFormExpired] = AccountPinForm,
	[ModalState.AuthenticatorUpsellIntro] = Intro,
	[ModalState.AuthenticatorUpsellInstallApps] = InstallApps,
	[ModalState.AccountRestoresPolicyUpsell] = AccountRestoresPolicyUpsell,
	[ModalState.Email2SVUpsell] = Email2SVUpsell
}
local v21 = Roact.PureComponent:extend(script.Name)

function v21.init(p1) -- line: 52
	p1:setState({
		initialPromptType = p1.props.promptType,
		modalState = p1.props.modalState
	})

	function p1.setModalState(p2) -- line: 58
		-- upvalues: p1 (copy)
		if not p1.isMounted then
			return
		end

		p1:setState({
			modalState = p2
		})
	end
end
function v21.didMount(p3) -- line: 69
	-- upvalues: accountSecurityPromptEvent (copy), EventStreamConstants (copy), PromptType (copy), ModalState (copy)
	p3.isMounted = true

	if p3.state.initialPromptType ~= nil then
		accountSecurityPromptEvent(p3.props.analytics.EventStream, EventStreamConstants.Context.ModalStateViewed, PromptType.toRawValue(p3.state.initialPromptType), ModalState.toRawValue(p3.state.modalState))
	end
end
function v21.didUpdate(p4, _, p6) -- line: 82
	-- upvalues: accountSecurityPromptEvent (copy), EventStreamConstants (copy), PromptType (copy), ModalState (copy)
	if p4.state.initialPromptType ~= nil and p4.state.modalState ~= p6.modalState then
		accountSecurityPromptEvent(p4.props.analytics.EventStream, EventStreamConstants.Context.ModalStateViewed, PromptType.toRawValue(p4.state.initialPromptType), ModalState.toRawValue(p4.state.modalState))
	end
end
function v21.willUnmount(p7) -- line: 93
	-- upvalues: accountSecurityPromptEvent (copy), EventStreamConstants (copy), PromptType (copy)
	if p7.props.promptType ~= nil then
		accountSecurityPromptEvent(p7.props.analytics.EventStream, EventStreamConstants.Context.ModalStateViewed, PromptType.toRawValue(p7.props.promptType), "NONE")
	end

	p7.isMounted = false
end
function v21.render(p8) -- line: 107
	-- upvalues: t1 (copy), Roact (copy)
	local modalState = p8.state.modalState
	local v31 = t1[modalState]

	return v31 and Roact.createElement(v31, {
		modalState = modalState,
		navigateToModalState = p8.setModalState,
		openWebView = p8.props.openWebView,
		closeOverlay = p8.props.closeOverlay,
		updatePromptAssignment = p8.props.updatePromptAssignment,
		promptType = p8.props.promptType
	})
end

local v22 = RoactRodux.connect(function(p9, _) -- line: 122
	return {
		promptType = p9.AccountSecurityPrompt.promptType
	}
end)(v21)

return (RoactServices.connect({
	analytics = RoactAnalytics
})(v22))
