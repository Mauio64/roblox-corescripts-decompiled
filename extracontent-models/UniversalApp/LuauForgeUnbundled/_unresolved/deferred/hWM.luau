local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module = require("@luauforge/bundled/egx")
local module2 = require("@luauforge/bundled/egZ")

local module3 = require("@luauforge/bundled/fCM")
local module4 = require("@luauforge/deferred/hWN")

local UIBlox = require(CorePackages.Packages.UIBlox)
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType

local extended = Roact.PureComponent:extend("LoginEmailVerificationPrompt")

function extended:init()
	function self.resendCallback()
		self.props.verifyCredentials(self.props.networking, self.props.credentialValue, self.props.password)
		self.props.onClose(self.props.credentialValue)
		self.props.closeCentralOverlay()
	end

	function self.closeCallback()
		self.props.onClose(self.props.credentialValue)
		self.props.closeCentralOverlay()
	end
end

function extended.render(data)
	return module2({
		alertTitle = "Authentication.Login.Label.EmailNeedsVerification",
		buttonText = "Authentication.Login.Action.SendVerificationEmail",
		cancelText = "Feature.Chat.Action.Cancel",
		message = "Authentication.Login.Label.UnverifiedEmailInstructions"
	})(function(props)
		return Roact.createElement(interactiveAlert, {
			title = props.alertTitle,
			bodyText = props.message,
			buttonStackInfo = {
				buttons = {
					{
						buttonType = buttonType.Secondary,
						props = {
							onActivated = data.closeCallback,
							text = props.cancelText
						}
					},
					{
						buttonType = buttonType.PrimarySystem,
						props = {
							onActivated = data.resendCallback,
							text = props.buttonText
						}
					}
				}
			},
			screenSize = data.props.screenSize
		})
	end)
end

local v5 = roactServices.connect({ networking = module })(extended)

return (RoactRodux.connect(function(p2, p3)
	return { screenSize = p2.ScreenSize }
end, function(callback)
	return {
		verifyCredentials = function(p2, p3, p4)
			return callback(module4(p2, "Email", p3, p4))
		end,
		closeCentralOverlay = function()
			return callback(module3())
		end
	}
end)(v5))
