local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local Lock = require(Modules.LuaApp.Components.AccountSecurity.Common.Lock)
local ModalBase = require(Modules.LuaApp.Components.AccountSecurity.Common.ModalBase)
local ModalBodyText = require(Modules.LuaApp.Components.AccountSecurity.Common.ModalBodyText)
local ModalButtonConfig = require(Modules.LuaApp.Components.AccountSecurity.Common.ModalButtonConfig)
local OpenWebview = require(Modules.LuaApp.Thunks.OpenWebview)
local PromptAssignmentAction = require(Modules.LuaApp.Enum.AccountSecurity.PromptAssignmentAction)
local PromptConstants = require(Modules.LuaApp.Components.AccountSecurity.Common.PromptConstants)
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
	action = "Feature.AccountSecurityPrompt.Action.SetUpEmail2SV",
	description = "Feature.AccountSecurityPrompt.Description.Email2SVUpsellMessageBody",
	header = "Feature.AccountSecurityPrompt.Header.Email2SVUpsell",
	settingsTitle = "CommonUI.Features.Label.Settings"
}
local v21 = Roact.PureComponent:extend(script.Name)

function v21.init(p1) -- line: 33
	-- upvalues: PromptConstants (copy), PromptAssignmentAction (copy)
	p1:setState({
		requestError = nil,
		requestInFlight = false
	})

	function p1.continueToSecuritySettingsPage(p2) -- line: 41
		-- upvalues: p1 (copy), PromptConstants (copy), PromptAssignmentAction (copy)
		return function() -- line: 42
			-- upvalues: p1 (copy), PromptConstants (copy), p2 (copy), PromptAssignmentAction (copy)
			p1:setState({
				requestInFlight = true
			})
			p1.props.openWebView(PromptConstants.getWebViewUrlEmailHighlight(), p2.settingsTitle)
			p1.props.closeOverlay()
			p1.props.updatePromptAssignment(p1.props.networking, p1.props.promptType, PromptAssignmentAction.DismissPrompt)
		end
	end
	function p1.closeCallback() -- line: 57
		-- upvalues: p1 (copy), PromptAssignmentAction (copy)
		p1.props.updatePromptAssignment(p1.props.networking, p1.props.promptType, PromptAssignmentAction.DismissPrompt)
	end
end
function v21.render(p3) -- line: 66
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
						text = p4.description
					})
				})
			end,
			buttonConfig = ModalButtonConfig({{
				isDisabled = requestInFlight,
				isLoading = requestInFlight,
				onActivated = p3.continueToSecuritySettingsPage(p4),
				text = p4.action,
				type = ButtonType.PrimarySystem
			}})
		})
	end)
end

local v22 = RoactRodux.connect(function(p6, _) -- line: 98
	return {
		metadata = p6.AccountSecurityPrompt.metadata
	}
end, function(p8) -- line: 102
	-- upvalues: CloseCentralOverlay (copy), OpenWebview (copy), UpdatePromptAssignment (copy)
	return {
		closeOverlay = function() -- line: 104
			-- upvalues: p8 (copy), CloseCentralOverlay (copy)
			return p8(CloseCentralOverlay())
		end,
		openWebView = function(p9, p10) -- line: 107
			-- upvalues: p8 (copy), OpenWebview (copy)
			p8(OpenWebview(p9, p10))
		end,
		updatePromptAssignment = function(p11, p12, p13) -- line: 110
			-- upvalues: p8 (copy), UpdatePromptAssignment (copy)
			return p8(UpdatePromptAssignment(p11, p12, p13))
		end
	}
end)(v21)

return (RoactServices.connect({
	analytics = RoactAnalytics,
	networking = RoactNetworking
})(v22))
