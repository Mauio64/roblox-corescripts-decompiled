local RunService = game:GetService("RunService")
local CorePackages = game:GetService("CorePackages")

local LinkingProtocol = require(CorePackages.Workspace.Packages.LinkingProtocol)
local DeepLinkSource = LinkingProtocol.Enums.DeepLinkSource
local linkingProtocol = LinkingProtocol.LinkingProtocol

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local t = InGameMenuDependencies.t

local LeavePrompt = require(script.Parent.LeavePrompt)

local parent = script.Parent.Parent.Parent.Parent
local withLocalization = require(parent.Localization.withLocalization)

local CloseMenu = require(parent.Thunks.CloseMenu)
local SendAnalytics = require(parent.Utility.SendAnalytics)
local Constants = require(parent.Resources.Constants)

local extended = Roact.PureComponent:extend("LeaveToAppPrompt")

extended.validateProps = t.strictInterface({
	closeMenu = t.callback,
	canGamepadCaptureFocus = t.optional(t.boolean),
	canKeyboardCaptureFocus = t.optional(t.boolean),
	onConfirm = t.optional(t.callback),
	linkingProtocol = t.table
})

extended.defaultProps = { linkingProtocol = linkingProtocol.default }

function extended:init()
	function self.goToHomePage()
		SendAnalytics(Constants.AnalyticsLeaveToHomeName, Constants.AnalyticsLeaveToHomeName, {
			confirmed = Constants.AnalyticsLeaveToHomeName
		})

		if self.props.linkingProtocol:isInternalDlicEnabled() then
			local internalDlic = self.props.linkingProtocol:createInternalDlic(
				"roblox://navigation/home",
				DeepLinkSource.LuaInternal
			)

			RunService.Heartbeat:Wait()
			self.props.linkingProtocol:detectDeeplinkIntent(internalDlic)
		else
			RunService.Heartbeat:Wait()
			self.props.linkingProtocol:detectURL("roblox://navigation/home")
		end

		game:Shutdown()
	end
end

function extended.render(p)
	return withLocalization({
		titleText = "CoreScripts.InGameMenu.Prompt.LeaveGameTitle",
		bodyText = "CoreScripts.InGameMenu.Prompt.LeaveGameBodyText",
		confirmText = "CoreScripts.InGameMenu.Prompt.BackToHome",
		cancelText = "CoreScripts.InGameMenu.Prompt.ResumeGame"
	})(function(props)
		return Roact.createElement(LeavePrompt, {
			titleText = props.titleText,
			bodyText = props.bodyText,
			confirmText = props.confirmText,
			cancelText = props.cancelText,
			onConfirm = p.props.onConfirm or p.goToHomePage,
			onCancel = p.props.closeMenu,
			canGamepadCaptureFocus = p.props.canGamepadCaptureFocus,
			canKeyboardCaptureFocus = p.props.canKeyboardCaptureFocus
		})
	end)
end

return RoactRodux.UNSTABLE_connect2(function(data, _)
	return {
		canGamepadCaptureFocus = data.menuPage == Constants.LeaveToAppPromptPageKey and data.displayOptions.inputType == Constants.InputType.Gamepad and not data.respawn.dialogOpen and data.currentZone == 1,
		canKeyboardCaptureFocus = data.menuPage == Constants.LeaveToAppPromptPageKey and data.displayOptions.inputType == Constants.InputType.MouseAndKeyboard and not data.respawn.dialogOpen
	}
end, function(callback)
	return {
		closeMenu = function()
			callback(CloseMenu)
		end
	}
end)(extended)
