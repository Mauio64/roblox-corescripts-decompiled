local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module = require("@luauforge/bundled/egZ")
local module2 = require("@luauforge/bundled/grb")

local module3 = require("@luauforge/bundled/fCM")

local module4 = require("@luauforge/bundled/hPe")

local UIBlox = require(CorePackages.Packages.UIBlox)
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType

local extended = Roact.PureComponent:extend("LoginConfirmationPrompt")

function extended:init()
	function self.retryCodeCallback()
		self.props.closeCentralOverlay()

		if self.props.retryCallback then
			self.props.retryCallback()
		end
	end

	function self.closePageCallback()
		self.props.closeCentralOverlay()

		if self.props.closeCallback then
			self.props.closeCallback()
		end
	end
end

function extended.didMount(p2)
	p2.props.authAnalytics.reportScreenLoaded(p2.props.loginSuccess and "quickLoginSucceeded" or "quickLoginFailed")
end

function extended.render(data)
	local loginSuccess = data.props.loginSuccess
	return module({
		alertTitle = loginSuccess and "Authentication.CrossDevice.Response.LoginSuccess" or "Authentication.CrossDevice.Response.LoginFail",
		errorMessage = "Authentication.CrossDevice.Label.CodeNotVerified",
		successButtonText = module4() and "Authentication.CrossDevice.Label.OK" or "Authentication.CrossDevice.Action.Done",
		retryButtonText = "Authentication.CrossDevice.Action.TryAgain",
		cancelButtonText = "Authentication.CrossDevice.Action.CancelLogin"
	})(function(props)
		local deviceString = loginSuccess and data.props.deviceString or props.errorMessage

		local createElement = Roact.createElement
		local v7 = {
			title = props.alertTitle,
			bodyText = deviceString,
			buttonStackInfo = 0,
			screenSize = 0
		}

		local v9 = loginSuccess and {
			{
				buttonType = buttonType.PrimarySystem,
				props = {
					onActivated = data.closePageCallback,
					text = props.successButtonText
				}
			}
		}

		if not v9 then
			v9 = {
				{
					buttonType = buttonType.Secondary,
					props = {
						onActivated = data.closePageCallback,
						text = props.cancelButtonText
					}
				},
				{
					buttonType = buttonType.PrimarySystem,
					props = {
						onActivated = data.retryCodeCallback,
						text = props.retryButtonText
					}
				}
			}
		end

		v7.buttonStackInfo = { buttons = v9 }

		v7.screenSize = data.props.screenSize
		return createElement(interactiveAlert, v7)
	end)
end

local v5 = roactServices.connect({ authAnalytics = module2 })(extended)

return (RoactRodux.connect(function(p2, p3)
	return { screenSize = p2.ScreenSize }
end, function(callback)
	return {
		closeCentralOverlay = function()
			return callback(module3())
		end
	}
end)(v5))
