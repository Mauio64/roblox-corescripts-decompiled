local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local Lock = require(Modules.LuaApp.Components.AccountSecurity.Common.Lock)
local ModalBase = require(Modules.LuaApp.Components.AccountSecurity.Common.ModalBase)
local ModalBodyText = require(Modules.LuaApp.Components.AccountSecurity.Common.ModalBodyText)
local ModalButtonConfig = require(Modules.LuaApp.Components.AccountSecurity.Common.ModalButtonConfig)
local NavigateDownToSecuritySettings = require(Modules.LuaApp.Thunks.NavigateDownToSecuritySettings)
local PromptAssignmentAction = require(Modules.LuaApp.Enum.AccountSecurity.PromptAssignmentAction)
local Roact = require(CorePackages.Packages.Roact)
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local UIBlox = require(CorePackages.Packages.UIBlox)
local UpdatePromptAssignment = require(Modules.LuaApp.Thunks.AccountSecurity.UpdatePromptAssignment)
local withLocalization = require(Modules.LuaApp.withLocalization)
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local t1 = {
	action = "Feature.AccountSecurityPrompt.Action.SetUpAuthenticatorAccountRestoresPolicyUpsell",
	description = "Feature.AccountSecurityPrompt.Description.AccountRestoresPolicyUpsellMessageBody",
	header = "Feature.AccountSecurityPrompt.Header.AccountRestoresPolicyUpsell",
	settingsTitle = "CommonUI.Features.Label.Settings"
}
local v20 = Roact.PureComponent:extend(script.Name)

function v20.init(p1) -- line: 32
	-- upvalues: PromptAssignmentAction (copy)
	p1:setState({
		requestInFlight = false
	})

	function p1.continueToAuthenticatorAppScreen(_) -- line: 39
		-- upvalues: p1 (copy), PromptAssignmentAction (copy)
		return function() -- line: 40
			-- upvalues: p1 (copy), PromptAssignmentAction (copy)
			p1:setState({
				requestInFlight = true
			})
			p1.props.navigateToSecuritySettings()
			p1.props.closeOverlay()
			p1.props.updatePromptAssignment(p1.props.networking, p1.props.promptType, PromptAssignmentAction.DismissPrompt)
		end
	end
	function p1.closeCallback() -- line: 57
		-- upvalues: p1 (copy), PromptAssignmentAction (copy)
		p1.props.updatePromptAssignment(p1.props.networking, p1.props.promptType, PromptAssignmentAction.DismissPrompt)
	end
end
function v20.render(p3) -- line: 66
	-- upvalues: withLocalization (copy), t1 (copy), Roact (copy), ModalBase (copy), Lock (copy), ModalBodyText (copy), ModalButtonConfig (copy), ButtonType (copy)
	local requestInFlight = p3.state.requestInFlight

	return withLocalization(t1)(function(p4) -- line: 69
		-- upvalues: Roact (copy), ModalBase (copy), p3 (copy), Lock (copy), ModalBodyText (copy), ModalButtonConfig (copy), requestInFlight (copy), ButtonType (copy)
		return Roact.createElement(ModalBase, {
			title = p4.header,
			closeCallback = p3.closeCallback,
			makeBodyFragment = function(p5) -- line: 73
				-- upvalues: Roact (copy), Lock (copy), ModalBodyText (copy), p4 (copy)
				return Roact.createFragment({
					Lock = Roact.createElement(Lock, {
						layoutOrder = 1
					}),
					ModalBodyText = Roact.createElement(ModalBodyText, {
						layoutOrder = 2,
						contentWidth = p5,
						text = p4.description:gsub("{linkStartSettings}", ""):gsub("{linkEndSettings}", "")
					})
				})
			end,
			buttonConfig = ModalButtonConfig({{
				isDisabled = requestInFlight,
				isLoading = requestInFlight,
				onActivated = p3.continueToAuthenticatorAppScreen(p4),
				text = p4.action,
				type = ButtonType.PrimarySystem
			}})
		})
	end)
end

local v21 = RoactRodux.connect(function(_, _) -- line: 98
	return {}
end, function(p8) -- line: 100
	-- upvalues: CloseCentralOverlay (copy), NavigateDownToSecuritySettings (copy), UpdatePromptAssignment (copy)
	return {
		closeOverlay = function() -- line: 102
			-- upvalues: p8 (copy), CloseCentralOverlay (copy)
			return p8(CloseCentralOverlay())
		end,
		navigateToSecuritySettings = function() -- line: 105
			-- upvalues: p8 (copy), NavigateDownToSecuritySettings (copy)
			p8(NavigateDownToSecuritySettings())
		end,
		updatePromptAssignment = function(p9, p10, p11) -- line: 108
			-- upvalues: p8 (copy), UpdatePromptAssignment (copy)
			return p8(UpdatePromptAssignment(p9, p10, p11))
		end
	}
end)(v20)

return (RoactServices.connect({
	analytics = RoactAnalytics,
	networking = RoactNetworking
})(v21))
