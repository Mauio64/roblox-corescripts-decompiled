local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local GetPromptAssignments = require(Modules.LuaApp.Thunks.AccountSecurity.GetPromptAssignments)
local Lock = require(Modules.LuaApp.Components.AccountSecurity.Common.Lock)
local ModalBase = require(Modules.LuaApp.Components.AccountSecurity.Common.ModalBase)
local ModalBodyText = require(Modules.LuaApp.Components.AccountSecurity.Common.ModalBodyText)
local ModalButtonConfig = require(Modules.LuaApp.Components.AccountSecurity.Common.ModalButtonConfig)
local ModalErrorText = require(Modules.LuaApp.Components.AccountSecurity.Common.ModalErrorText)
local ModalState = require(Modules.LuaApp.Enum.AccountSecurity.ModalState)
local PromptAssignmentAction = require(Modules.LuaApp.Enum.AccountSecurity.PromptAssignmentAction)
local PromptType = require(Modules.LuaApp.Enum.AccountSecurity.PromptType)
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local UpdatePromptAssignment = require(Modules.LuaApp.Thunks.AccountSecurity.UpdatePromptAssignment)
local UpdatePromptTypeWithEvent = require(Modules.LuaApp.Thunks.AccountSecurity.UpdatePromptTypeWithEvent)
local withLocalization = require(Modules.LuaApp.withLocalization)
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local v23 = Roact.PureComponent:extend(script.Name)

function v23.init(p1) -- line: 44
	-- upvalues: PromptType (copy), ModalState (copy)
	p1:setState({
		requestError = nil,
		requestInFlightDismissForever = false,
		requestInFlightDismissTemporary = false,
		requestInFlightSecureAccount = false
	})

	function p1.updatePromptAssignment(p2, p3) -- line: 54
		-- upvalues: p1 (copy), PromptType (copy)
		return function() -- line: 55
			-- upvalues: p1 (copy), PromptType (copy), p3 (copy), p2 (copy)
			p1:setState({
				requestInFlightDismissForever = true,
				requestInFlightDismissTemporary = false,
				requestInFlightSecureAccount = false
			})
			p1.props.updatePromptAssignment(p1.props.networking, PromptType.ChangePasswordSuspectedCompromise, p3):andThen(function() -- line: 65
				-- upvalues: p1 (copy)
				p1.props.updatePromptType(p1.props.analytics, nil, nil, nil)
				p1.props.closeOverlay()
			end):catch(function(_) -- line: 72
				-- upvalues: p1 (copy), p2 (copy)
				if not p1.isMounted then
					return
				end

				p1:setState({
					requestInFlightDismissForever = false,
					requestError = p2.messageError
				})
			end)
		end
	end
	function p1.secureAccount() -- line: 85
		-- upvalues: p1 (copy), ModalState (copy)
		p1:setState({
			requestInFlightDismissForever = false,
			requestInFlightDismissTemporary = false,
			requestInFlightSecureAccount = true
		})
		p1.props.navigateToModalState(ModalState.ChangePasswordIntro)
	end
end
function v23.didMount(p5) -- line: 98
	p5.isMounted = true
end
function v23.willUnmount(p6) -- line: 102
	p6.isMounted = false
end
function v23.render(p7) -- line: 106
	-- upvalues: withLocalization (copy), Roact (copy), ModalBase (copy), Lock (copy), ModalBodyText (copy), ModalErrorText (copy), ModalButtonConfig (copy), ButtonType (copy), PromptAssignmentAction (copy)
	local requestError = p7.state.requestError
	local requestInFlightDismissForever = p7.state.requestInFlightDismissForever
	local requestInFlightDismissTemporary = p7.state.requestInFlightDismissTemporary
	local requestInFlightSecureAccount = p7.state.requestInFlightSecureAccount
	local v34 = requestInFlightDismissForever or (requestInFlightDismissTemporary or requestInFlightSecureAccount)
	local _ = p7.props.modalState

	return withLocalization({
		actionDismissForever = "Feature.AccountSecurityPrompt.Action.DismissForever",
		actionDismissTemporary = "Feature.AccountSecurityPrompt.Action.DismissTemporary",
		actionSecureAccount = "Feature.AccountSecurityPrompt.Action.SecureAccount",
		description = "Feature.AccountSecurityPrompt.Description.AreYouSureDismissForeverChangePassword",
		header = "Feature.AccountSecurityPrompt.Header.AreYouSure",
		messageError = "Feature.AccountSecurityPrompt.Message.Error.PromptAssignments.Default"
	})(function(p8) -- line: 117
		-- upvalues: Roact (copy), ModalBase (copy), Lock (copy), ModalBodyText (copy), requestError (copy), ModalErrorText (copy), ModalButtonConfig (copy), v34 (copy), requestInFlightSecureAccount (copy), p7 (copy), ButtonType (copy), requestInFlightDismissForever (copy), PromptAssignmentAction (copy), requestInFlightDismissTemporary (copy)
		return Roact.createElement(ModalBase, {
			title = p8.header,
			makeBodyFragment = function(p9) -- line: 120
				-- upvalues: Roact (copy), Lock (copy), ModalBodyText (copy), p8 (copy), requestError (copy), ModalErrorText (copy)
				return Roact.createFragment({
					Lock = Roact.createElement(Lock, {
						layoutOrder = 1
					}),
					ModalBodyText = Roact.createElement(ModalBodyText, {
						layoutOrder = 2,
						contentWidth = p9,
						text = p8.description
					}),
					ModalErrorText = requestError and Roact.createElement(ModalErrorText, {
						layoutOrder = 3,
						contentWidth = p9,
						errorText = requestError
					})
				})
			end,
			buttonConfig = ModalButtonConfig({
				{
					isDisabled = v34,
					isLoading = requestInFlightSecureAccount,
					onActivated = p7.secureAccount,
					text = p8.actionSecureAccount,
					type = ButtonType.PrimarySystem
				},
				{
					isDisabled = v34,
					isLoading = requestInFlightDismissForever,
					onActivated = p7.updatePromptAssignment(p8, PromptAssignmentAction.DisablePrompt),
					text = p8.actionDismissForever,
					type = ButtonType.Secondary
				},
				{
					isDisabled = v34,
					isLoading = requestInFlightDismissTemporary,
					onActivated = p7.updatePromptAssignment(p8, PromptAssignmentAction.DismissPrompt),
					text = p8.actionDismissTemporary,
					type = ButtonType.Secondary
				}
			})
		})
	end)
end

local v24 = RoactRodux.connect(nil, function(p10) -- line: 164
	-- upvalues: CloseCentralOverlay (copy), GetPromptAssignments (copy), UpdatePromptTypeWithEvent (copy), UpdatePromptAssignment (copy)
	return {
		closeOverlay = function() -- line: 166
			-- upvalues: p10 (copy), CloseCentralOverlay (copy)
			return p10(CloseCentralOverlay())
		end,
		getPromptAssignments = function(p11) -- line: 169
			-- upvalues: p10 (copy), GetPromptAssignments (copy)
			return p10(GetPromptAssignments(p11))
		end,
		updatePromptType = function(p12, p13, p14, p15) -- line: 172
			-- upvalues: p10 (copy), UpdatePromptTypeWithEvent (copy)
			return p10(UpdatePromptTypeWithEvent(p12, p13, p14, p15))
		end,
		updatePromptAssignment = function(p16, p17, p18) -- line: 175
			-- upvalues: p10 (copy), UpdatePromptAssignment (copy)
			return p10(UpdatePromptAssignment(p16, p17, p18))
		end
	}
end)(v23)

return (RoactServices.connect({
	analytics = RoactAnalytics,
	networking = RoactNetworking
})(v24))
