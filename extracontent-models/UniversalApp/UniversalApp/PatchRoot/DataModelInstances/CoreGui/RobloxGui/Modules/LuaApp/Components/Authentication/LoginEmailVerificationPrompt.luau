local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local withLocalization = require(Modules.LuaApp.withLocalization)
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local VerifyCredentials = require(Modules.LuaApp.Thunks.Authentication.VerifyCredentials)
local UIBlox = require(CorePackages.Packages.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local v13 = Roact.PureComponent:extend("LoginEmailVerificationPrompt")

function v13.init(p1) -- line: 23
	function p1.resendCallback() -- line: 24
		-- upvalues: p1 (copy)
		p1.props.verifyCredentials(p1.props.networking, p1.props.credentialValue, p1.props.password)
		p1.props.onClose(p1.props.credentialValue)
		p1.props.closeCentralOverlay()
	end
	function p1.closeCallback() -- line: 30
		-- upvalues: p1 (copy)
		p1.props.onClose(p1.props.credentialValue)
		p1.props.closeCentralOverlay()
	end
end
function v13.render(p2) -- line: 36
	-- upvalues: withLocalization (copy), Roact (copy), InteractiveAlert (copy), ButtonType (copy)
	return withLocalization({
		alertTitle = "Authentication.Login.Label.EmailNeedsVerification",
		buttonText = "Authentication.Login.Action.SendVerificationEmail",
		cancelText = "Feature.Chat.Action.Cancel",
		message = "Authentication.Login.Label.UnverifiedEmailInstructions"
	})(function(p3) -- line: 42
		-- upvalues: Roact (copy), InteractiveAlert (copy), ButtonType (copy), p2 (copy)
		return Roact.createElement(InteractiveAlert, {
			title = p3.alertTitle,
			bodyText = p3.message,
			buttonStackInfo = {
				buttons = {
					{
						buttonType = ButtonType.Secondary,
						props = {
							onActivated = p2.closeCallback,
							text = p3.cancelText
						}
					},
					{
						buttonType = ButtonType.PrimarySystem,
						props = {
							onActivated = p2.resendCallback,
							text = p3.buttonText
						}
					}
				}
			},
			screenSize = p2.props.screenSize
		})
	end)
end

local v14 = RoactServices.connect({
	networking = RoactNetworking
})(v13)

return (RoactRodux.connect(function(p4, _) -- line: 73
	return {
		screenSize = p4.ScreenSize
	}
end, function(p6) -- line: 77
	-- upvalues: VerifyCredentials (copy), CloseCentralOverlay (copy)
	return {
		verifyCredentials = function(p7, p8, p9) -- line: 79
			-- upvalues: p6 (copy), VerifyCredentials (copy)
			return p6(VerifyCredentials(p7, "Email", p8, p9))
		end,
		closeCentralOverlay = function() -- line: 82
			-- upvalues: p6 (copy), CloseCentralOverlay (copy)
			return p6(CloseCentralOverlay())
		end
	}
end)(v14))
