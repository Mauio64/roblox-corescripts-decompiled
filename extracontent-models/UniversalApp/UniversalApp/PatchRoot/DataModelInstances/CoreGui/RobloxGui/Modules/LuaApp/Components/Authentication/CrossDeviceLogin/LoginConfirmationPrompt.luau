local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local withLocalization = require(Modules.LuaApp.withLocalization)
local RoactAnalyticsAuthEvents = require(Modules.LuaApp.Services.RoactAnalyticsAuthEvents)
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local GetFFlagEnableCrossDeviceEnterCodeRefresh = require(Modules.LuaApp.Flags.GetFFlagEnableCrossDeviceEnterCodeRefresh)
local UIBlox = require(CorePackages.Packages.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local v13 = Roact.PureComponent:extend("LoginConfirmationPrompt")

function v13.init(p1) -- line: 28
	function p1.retryCodeCallback() -- line: 29
		-- upvalues: p1 (copy)
		p1.props.closeCentralOverlay()

		if p1.props.retryCallback then
			p1.props.retryCallback()
		end
	end
	function p1.closePageCallback() -- line: 36
		-- upvalues: p1 (copy)
		p1.props.closeCentralOverlay()

		if p1.props.closeCallback then
			p1.props.closeCallback()
		end
	end
end
function v13.didMount(p2) -- line: 44
	p2.props.authAnalytics.reportScreenLoaded(not p2.props.loginSuccess and "quickLoginFailed" or "quickLoginSucceeded")
end
function v13.render(p3) -- line: 48
	-- upvalues: GetFFlagEnableCrossDeviceEnterCodeRefresh (copy), withLocalization (copy), Roact (copy), InteractiveAlert (copy), ButtonType (copy)
	local loginSuccess = p3.props.loginSuccess
	local v19 = not GetFFlagEnableCrossDeviceEnterCodeRefresh() and "Authentication.CrossDevice.Action.Done" or "Authentication.CrossDevice.Label.OK"

	return withLocalization({
		errorMessage = "Authentication.CrossDevice.Label.CodeNotVerified",
		retryButtonText = "Authentication.CrossDevice.Action.TryAgain",
		cancelButtonText = "Authentication.CrossDevice.Action.CancelLogin",
		alertTitle = not loginSuccess and "Authentication.CrossDevice.Response.LoginFail" or "Authentication.CrossDevice.Response.LoginSuccess",
		successButtonText = v19
	})(function(p4) -- line: 59
		-- upvalues: loginSuccess (copy), p3 (copy), Roact (copy), InteractiveAlert (copy), ButtonType (copy)
		local v24 = loginSuccess and p3.props.deviceString or p4.errorMessage

		return Roact.createElement(InteractiveAlert, {
			title = p4.alertTitle,
			bodyText = v24,
			buttonStackInfo = {
				buttons = loginSuccess and {{
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = p3.closePageCallback,
						text = p4.successButtonText
					}
				}} or {
					{
						buttonType = ButtonType.Secondary,
						props = {
							onActivated = p3.closePageCallback,
							text = p4.cancelButtonText
						}
					},
					{
						buttonType = ButtonType.PrimarySystem,
						props = {
							onActivated = p3.retryCodeCallback,
							text = p4.retryButtonText
						}
					}
				}
			},
			screenSize = p3.props.screenSize
		})
	end)
end

local v14 = RoactServices.connect({
	authAnalytics = RoactAnalyticsAuthEvents
})(v13)

return (RoactRodux.connect(function(p5, _) -- line: 100
	return {
		screenSize = p5.ScreenSize
	}
end, function(p7) -- line: 104
	-- upvalues: CloseCentralOverlay (copy)
	return {
		closeCentralOverlay = function() -- line: 106
			-- upvalues: p7 (copy), CloseCentralOverlay (copy)
			return p7(CloseCentralOverlay())
		end
	}
end)(v14))
