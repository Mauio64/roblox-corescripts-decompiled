local RunService = game:GetService("RunService")
local CorePackages = game:GetService("CorePackages")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local t = InGameMenuDependencies.t
local LeavePrompt = require(script.Parent.LeavePrompt)
local ParentParent = script.Parent.Parent.Parent.Parent
local withLocalization = require(ParentParent.Localization.withLocalization)
local Constants = require(ParentParent.Resources.Constants)
local CloseMenu = require(ParentParent.Thunks.CloseMenu)
local SendAnalytics = require(ParentParent.Utility.SendAnalytics)
local GetDefaultQualityLevel = require(CorePackages.Workspace.Packages.AppCommonLib).GetDefaultQualityLevel
local GetFFlagEnableVRFTUXExperience = require(RobloxGui.Modules.FTUX.Flags.GetFFlagEnableVRFTUXExperience)
local IsFTUXExperience = require(RobloxGui.Modules.FTUX.Utility.IsFTUXExperience)
local PlatformEnum = require(RobloxGui.Modules.FTUX.Enums.PlatformEnum)
local v18 = Roact.PureComponent:extend("LeaveGamePrompt")

v18.validateProps = t.strictInterface({
	closeMenu = t.callback,
	canGamepadCaptureFocus = t.optional(t.boolean),
	canKeyboardCaptureFocus = t.optional(t.boolean),
	onConfirm = t.optional(t.callback)
})

function v18.init(p1) -- line: 35
	-- upvalues: SendAnalytics (copy), Constants (copy), RunService (copy), GetDefaultQualityLevel (copy)
	function p1.leaveGameConfirm() -- line: 36
		-- upvalues: SendAnalytics (copy), Constants (copy), RunService (copy), GetDefaultQualityLevel (copy)
		SendAnalytics(Constants.AnalyticsInGameMenuName, Constants.AnalyticsLeaveGameName, {
			confirmed = Constants.AnalyticsConfirmedName
		})
		RunService.Heartbeat:Wait()
		game:Shutdown()
		settings().Rendering.QualityLevel = GetDefaultQualityLevel()
	end
end
function v18.render(p2) -- line: 48
	-- upvalues: withLocalization (copy), GetFFlagEnableVRFTUXExperience (copy), IsFTUXExperience (copy), PlatformEnum (copy), Roact (copy), LeavePrompt (copy)
	return withLocalization({
		titleText = "CoreScripts.InGameMenu.Prompt.LeaveGameTitle",
		confirmText = "CoreScripts.InGameMenu.Prompt.LeaveGame",
		cancelText = "CoreScripts.InGameMenu.Prompt.ResumeGame",
		bodyText = (not GetFFlagEnableVRFTUXExperience() or not IsFTUXExperience(PlatformEnum.QuestVR)) and "CoreScripts.InGameMenu.Prompt.LeaveGameBodyText" or "CoreScripts.InGameMenu.Prompt.VRFTUXLeaveGameBodyText"
	})(function(p3) -- line: 56
		-- upvalues: Roact (copy), LeavePrompt (copy), p2 (copy)
		return Roact.createElement(LeavePrompt, {
			titleText = p3.titleText,
			bodyText = p3.bodyText,
			confirmText = p3.confirmText,
			cancelText = p3.cancelText,
			onConfirm = p2.props.onConfirm or p2.leaveGameConfirm,
			onCancel = p2.props.closeMenu,
			canGamepadCaptureFocus = p2.props.canGamepadCaptureFocus,
			canKeyboardCaptureFocus = p2.props.canKeyboardCaptureFocus
		})
	end)
end

return RoactRodux.UNSTABLE_connect2(function(p4, _) -- line: 70
	-- upvalues: Constants (copy)
	local v23 = p4.menuPage == Constants.LeaveGamePromptPageKey and (p4.displayOptions.inputType == Constants.InputType.Gamepad and (not p4.respawn.dialogOpen and p4.currentZone == 1))
	local v24 = p4.menuPage == Constants.LeaveGamePromptPageKey and (p4.displayOptions.inputType == Constants.InputType.MouseAndKeyboard and not p4.respawn.dialogOpen)

	return {
		canGamepadCaptureFocus = v23,
		canKeyboardCaptureFocus = v24
	}
end, function(p6) -- line: 84
	-- upvalues: CloseMenu (copy), SendAnalytics (copy), Constants (copy)
	return {
		closeMenu = function() -- line: 86
			-- upvalues: p6 (copy), CloseMenu (copy), SendAnalytics (copy), Constants (copy)
			p6(CloseMenu)
			SendAnalytics(Constants.AnalyticsInGameMenuName, Constants.AnalyticsLeaveGameName, {
				confirmed = Constants.AnalyticsCancelledName
			})
		end
	}
end)(v18)
