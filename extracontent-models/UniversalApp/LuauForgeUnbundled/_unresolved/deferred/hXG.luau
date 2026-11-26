local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/fzR")
local module2 = require("@luauforge/bundled/fzS")
local module3 = require("@luauforge/deferred/hXH")

local module4 = require("@luauforge/deferred/hXR")

local module5 = require("@luauforge/deferred/hXS")
local module6 = require("@luauforge/deferred/hXT")
local module7 = require("@luauforge/deferred/hYe")
local module8 = require("@luauforge/deferred/hYi")

local module9 = require("@luauforge/deferred/hYj")
local module10 = require("@luauforge/deferred/hYk")

local module11 = require("@luauforge/deferred/hYl")
local module12 = require("@luauforge/bundled/fzI")
local module13 = require("@luauforge/bundled/fzF")
local module14 = require("@luauforge/bundled/ego")
local React = require(CorePackages.Packages.React)
local module15 = require("@luauforge/bundled/ecq")
local useSheetNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/FoundationFork/Sheet/useSheetNavigation")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices

local Cryo = require(CorePackages.Packages.Cryo)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local fFlagUseSignalsForAccountSecurityPrompt = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForAccountSecurityPrompt
local getAccountSecurityPromptStore

if fFlagUseSignalsForAccountSecurityPrompt then
	getAccountSecurityPromptStore = require("@luauforge/bundled/fyY").Stores.GetAccountSecurityPromptStore
else
	getAccountSecurityPromptStore = nil
end

local modules = {
	[module12.ChangePasswordIntro] = module7,
	[module12.ChangePasswordForm] = module6,
	[module12.ChangePasswordConfirmation] = module5,
	[module12.ChangePasswordDismissConfirmation] = module11,
	[module12.AccountPinForm] = module3,
	[module12.AccountPinFormExpired] = module3,
	[module12.AuthenticatorUpsellIntro] = module8,
	[module12.AuthenticatorUpsellInstallApps] = module9,
	[module12.AccountRestoresPolicyUpsell] = module4,
	[module12.Email2SVUpsell] = module10
}

local extended = module14.PureComponent:extend("PromptOverlay")

function extended:init()
	self:setState({
		initialPromptType = self.props.promptType,
		modalState = self.props.modalState
	})

	function self.setModalState(p2)
		if not self.isMounted then
			return
		end

		self:setState({ modalState = p2 })
	end
end

function extended:didMount()
	self.isMounted = true

	if self.state.initialPromptType ~= nil then
		module(
			self.props.analytics.EventStream,
			module2.Context.ModalStateViewed,
			module13.toRawValue(self.state.initialPromptType),
			module12.toRawValue(self.state.modalState)
		)
	end
end

function extended.didUpdate(p2, p3, p4)
	if p2.state.initialPromptType ~= nil and p2.state.modalState ~= p4.modalState then
		module(
			p2.props.analytics.EventStream,
			module2.Context.ModalStateViewed,
			module13.toRawValue(p2.state.initialPromptType),
			module12.toRawValue(p2.state.modalState)
		)
	end
end

function extended:willUnmount()
	if self.props.promptType ~= nil then
		module(
			self.props.analytics.EventStream,
			module2.Context.ModalStateViewed,
			module13.toRawValue(self.props.promptType),
			"NONE"
		)
	end

	self.isMounted = false
end

function extended.render(props)
	local modalState = props.state.modalState
	local v5 = modules[modalState]

	return v5 and module14.createElement(v5, {
		modalState = modalState,
		navigateToModalState = props.setModalState,
		openWebView = props.props.openWebView,
		closeOverlay = props.props.closeOverlay,
		updatePromptAssignment = props.props.updatePromptAssignment,
		promptType = props.props.promptType
	})
end

local v5

if fFlagUseSignalsForAccountSecurityPrompt then
	v5 = React.memo(function(p2)
		local v6 = useSignalState(getAccountSecurityPromptStore(false).getPromptType)
		return module14.createElement(extended, Cryo.Dictionary.union(p2, {
			promptType = v6
		}))
	end)
else
	v5 = useSheetNavigation.connect(function(p2, p3)
		return { promptType = p2.AccountSecurityPrompt.promptType }
	end)(extended)
end

return (roactServices.connect({ analytics = module15 })(v5))
