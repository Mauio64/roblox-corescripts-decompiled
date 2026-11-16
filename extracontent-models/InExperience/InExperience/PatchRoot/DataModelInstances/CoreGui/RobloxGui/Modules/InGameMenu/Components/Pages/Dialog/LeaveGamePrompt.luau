local RunService = game:GetService("RunService")
local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local t = InGameMenuDependencies.t

local LeavePrompt = require(script.Parent.LeavePrompt)

local parent = script.Parent.Parent.Parent.Parent
local withLocalization = require(parent.Localization.withLocalization)

local Constants = require(parent.Resources.Constants)
local CloseMenu = require(parent.Thunks.CloseMenu)
local SendAnalytics = require(parent.Utility.SendAnalytics)

local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local GetDefaultQualityLevel = AppCommonLib.GetDefaultQualityLevel

local GetFFlagEnableVRFTUXExperience = require(RobloxGui.Modules.FTUX.Flags.GetFFlagEnableVRFTUXExperience)
local IsFTUXExperience = require(RobloxGui.Modules.FTUX.Utility.IsFTUXExperience)
local PlatformEnum = require(RobloxGui.Modules.FTUX.Enums.PlatformEnum)

local extended = Roact.PureComponent:extend("LeaveGamePrompt")

extended.validateProps = t.strictInterface({
	closeMenu = t.callback,
	canGamepadCaptureFocus = t.optional(t.boolean),
	canKeyboardCaptureFocus = t.optional(t.boolean),
	onConfirm = t.optional(t.callback)
})

function extended:init()
	function self.leaveGameConfirm()
		SendAnalytics(Constants.AnalyticsInGameMenuName, Constants.AnalyticsLeaveGameName, {
			confirmed = Constants.AnalyticsConfirmedName
		})

		RunService.Heartbeat:Wait()
		game:Shutdown()
		local settings = settings()
		settings.Rendering.QualityLevel = GetDefaultQualityLevel()
	end
end

function extended.render(p)
	return withLocalization({
		titleText = "CoreScripts.InGameMenu.Prompt.LeaveGameTitle",
		bodyText = GetFFlagEnableVRFTUXExperience() and IsFTUXExperience(PlatformEnum.QuestVR) and "CoreScripts.InGameMenu.Prompt.VRFTUXLeaveGameBodyText" or "CoreScripts.InGameMenu.Prompt.LeaveGameBodyText",
		confirmText = "CoreScripts.InGameMenu.Prompt.LeaveGame",
		cancelText = "CoreScripts.InGameMenu.Prompt.ResumeGame"
	})(function(props)
		return Roact.createElement(LeavePrompt, {
			titleText = props.titleText,
			bodyText = props.bodyText,
			confirmText = props.confirmText,
			cancelText = props.cancelText,
			onConfirm = p.props.onConfirm or p.leaveGameConfirm,
			onCancel = p.props.closeMenu,
			canGamepadCaptureFocus = p.props.canGamepadCaptureFocus,
			canKeyboardCaptureFocus = p.props.canKeyboardCaptureFocus
		})
	end)
end

return RoactRodux.UNSTABLE_connect2(function(data, _)
	return {
		canGamepadCaptureFocus = data.menuPage == Constants.LeaveGamePromptPageKey and data.displayOptions.inputType == Constants.InputType.Gamepad and not data.respawn.dialogOpen and data.currentZone == 1,
		canKeyboardCaptureFocus = data.menuPage == Constants.LeaveGamePromptPageKey and data.displayOptions.inputType == Constants.InputType.MouseAndKeyboard and not data.respawn.dialogOpen
	}
end, function(callback)
	return {
		closeMenu = function()
			callback(CloseMenu)
			SendAnalytics(Constants.AnalyticsInGameMenuName, Constants.AnalyticsLeaveGameName, {
				confirmed = Constants.AnalyticsCancelledName
			})
		end
	}
end)(extended)
