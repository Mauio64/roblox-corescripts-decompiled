local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local module = require("@luauforge/bundled/egZ")

local module2 = require("@luauforge/bundled/dVn")

local module3 = require("@luauforge/bundled/ehB")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dFz").NavigationCommands
else
	navigationCommands = nil
end

local module4 = require("@luauforge/bundled/fCM")
local module5 = require("@luauforge/bundled/fBF")
local module6 = require("@luauforge/bundled/dFu")

local UIBlox = require(CorePackages.Packages.UIBlox)
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType

local getFFlagEnableLuafiedRecoveryFlow = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableLuafiedRecoveryFlow

local enrolledInLuafiedRecoveryExperiment = require("@game/CorePackages/Workspace/Packages/AuthCommon").Experiments.enrolledInLuafiedRecoveryExperiment

local extended = Roact.PureComponent:extend("PasswordResetPrompt")

function extended:init()
	function self.callback()
		if getFFlagEnableLuafiedRecoveryFlow() and enrolledInLuafiedRecoveryExperiment() then
			self.props.navigateToPage({
				name = module6.AccountRecovery,
				extraProps = { identifier = "", recoverPassword = true }
			})
		else
			self.props.goToSecurityNotificationPage()
		end

		self.props.closeCentralOverlay()
	end
end

function extended.render(p2)
	return module({
		alertTitle = "CommonUI.Messages.Label.Alert",
		buttonText = "CommonUI.Messages.Action.OK",
		message = "Authentication.ResetPassword.Response.ResetPasswordStarted"
	})(function(props)
		return Roact.createElement(interactiveAlert, {
			title = props.alertTitle,
			bodyText = props.message,
			buttonStackInfo = {
				buttons = {
					{
						buttonType = buttonType.PrimarySystem,
						props = { onActivated = p2.callback, text = props.buttonText }
					}
				}
			},
			screenSize = p2.props.screenSize
		})
	end)
end

return (RoactRodux.connect(function(p2, p3)
	return { screenSize = p2.ScreenSize }
end, function(callback)
	return {
		closeCentralOverlay = function()
			return callback(module4())
		end,
		goToSecurityNotificationPage = function()
			local v5 = {
				name = module6.GenericWebPage,
				detail = string.format("%slogin/securityNotification", module2.BASE_URL),
				extraProps = { title = "", transitionAnimation = module5.None }
			}

			if fFlagSignalsNavP3Dispatch then
				return navigationCommands.down(navigationCommands.fromLegacyPage(v5))
			end

			return callback(module3(v5))
		end,
		navigateToPage = function(p2)
			if fFlagSignalsNavP3Dispatch then
				return navigationCommands.down(navigationCommands.fromLegacyPage(p2))
			end

			return callback(module3(p2))
		end
	}
end)(extended))
