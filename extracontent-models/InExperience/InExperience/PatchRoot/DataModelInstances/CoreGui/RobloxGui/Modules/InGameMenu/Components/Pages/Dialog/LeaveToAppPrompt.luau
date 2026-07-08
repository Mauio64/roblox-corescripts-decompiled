local RunService = game:GetService("RunService")
local CorePackages = game:GetService("CorePackages")
local LinkingProtocol = require(CorePackages.Workspace.Packages.LinkingProtocol).LinkingProtocol
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local t = InGameMenuDependencies.t
local LeavePrompt = require(script.Parent.LeavePrompt)
local ParentParent = script.Parent.Parent.Parent.Parent
local withLocalization = require(ParentParent.Localization.withLocalization)
local CloseMenu = require(ParentParent.Thunks.CloseMenu)
local SendAnalytics = require(ParentParent.Utility.SendAnalytics)
local Constants = require(ParentParent.Resources.Constants)
local v14 = Roact.PureComponent:extend("LeaveToAppPrompt")

v14.validateProps = t.strictInterface({
	closeMenu = t.callback,
	canGamepadCaptureFocus = t.optional(t.boolean),
	canKeyboardCaptureFocus = t.optional(t.boolean),
	onConfirm = t.optional(t.callback),
	linkingProtocol = t.table
})
v14.defaultProps = {
	linkingProtocol = LinkingProtocol.default
}

function v14.init(p1) -- line: 35
	-- upvalues: SendAnalytics (copy), Constants (copy), RunService (copy)
	function p1.goToHomePage() -- line: 36
		-- upvalues: SendAnalytics (copy), Constants (copy), RunService (copy), p1 (copy)
		SendAnalytics(Constants.AnalyticsLeaveToHomeName, Constants.AnalyticsLeaveToHomeName, {
			confirmed = Constants.AnalyticsLeaveToHomeName
		})
		RunService.Heartbeat:Wait()
		p1.props.linkingProtocol:detectURL("roblox://navigation/home")
		game:Shutdown()
	end
end
function v14.render(p2) -- line: 57
	-- upvalues: withLocalization (copy), Roact (copy), LeavePrompt (copy)
	return withLocalization({
		titleText = "CoreScripts.InGameMenu.Prompt.LeaveGameTitle",
		bodyText = "CoreScripts.InGameMenu.Prompt.LeaveGameBodyText",
		confirmText = "CoreScripts.InGameMenu.Prompt.BackToHome",
		cancelText = "CoreScripts.InGameMenu.Prompt.ResumeGame"
	})(function(p3) -- line: 63
		-- upvalues: Roact (copy), LeavePrompt (copy), p2 (copy)
		return Roact.createElement(LeavePrompt, {
			titleText = p3.titleText,
			bodyText = p3.bodyText,
			confirmText = p3.confirmText,
			cancelText = p3.cancelText,
			onConfirm = p2.props.onConfirm or p2.goToHomePage,
			onCancel = p2.props.closeMenu,
			canGamepadCaptureFocus = p2.props.canGamepadCaptureFocus,
			canKeyboardCaptureFocus = p2.props.canKeyboardCaptureFocus
		})
	end)
end

return RoactRodux.UNSTABLE_connect2(function(p4, _) -- line: 77
	-- upvalues: Constants (copy)
	local v19 = p4.menuPage == Constants.LeaveToAppPromptPageKey and (p4.displayOptions.inputType == Constants.InputType.Gamepad and (not p4.respawn.dialogOpen and p4.currentZone == 1))
	local v20 = p4.menuPage == Constants.LeaveToAppPromptPageKey and (p4.displayOptions.inputType == Constants.InputType.MouseAndKeyboard and not p4.respawn.dialogOpen)

	return {
		canGamepadCaptureFocus = v19,
		canKeyboardCaptureFocus = v20
	}
end, function(p6) -- line: 91
	-- upvalues: CloseMenu (copy)
	return {
		closeMenu = function() -- line: 93
			-- upvalues: p6 (copy), CloseMenu (copy)
			p6(CloseMenu)
		end
	}
end)(v14)
