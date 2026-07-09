local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local withLocalization = require(Modules.LuaApp.withLocalization)
local Url = require(Modules.LuaApp.Http.Url)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v9 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local TransitionAnimation = require(Modules.LuaApp.Enum.TransitionAnimation)
local AppPage = require(Modules.LuaApp.AppPage)
local UIBlox = require(CorePackages.Packages.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local GetFFlagEnableLuafiedRecoveryFlow = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableLuafiedRecoveryFlow
local enrolledInLuafiedRecoveryExperiment = require(CorePackages.Workspace.Packages.AuthCommon).Experiments.enrolledInLuafiedRecoveryExperiment
local v18 = Roact.PureComponent:extend("PasswordResetPrompt")

function v18.init(p1) -- line: 34
	-- upvalues: GetFFlagEnableLuafiedRecoveryFlow (copy), enrolledInLuafiedRecoveryExperiment (copy), AppPage (copy)
	function p1.callback() -- line: 35
		-- upvalues: GetFFlagEnableLuafiedRecoveryFlow (copy), enrolledInLuafiedRecoveryExperiment (copy), p1 (copy), AppPage (copy)
		if GetFFlagEnableLuafiedRecoveryFlow() and enrolledInLuafiedRecoveryExperiment() then
			p1.props.navigateToPage({
				name = AppPage.AccountRecovery,
				extraProps = {
					identifier = "",
					recoverPassword = true
				}
			})
		else
			p1.props.goToSecurityNotificationPage()
		end

		p1.props.closeCentralOverlay()
	end
end
function v18.render(p2) -- line: 51
	-- upvalues: withLocalization (copy), Roact (copy), InteractiveAlert (copy), ButtonType (copy)
	return withLocalization({
		alertTitle = "CommonUI.Messages.Label.Alert",
		buttonText = "CommonUI.Messages.Action.OK",
		message = "Authentication.ResetPassword.Response.ResetPasswordStarted"
	})(function(p3) -- line: 56
		-- upvalues: Roact (copy), InteractiveAlert (copy), ButtonType (copy), p2 (copy)
		return Roact.createElement(InteractiveAlert, {
			title = p3.alertTitle,
			bodyText = p3.message,
			buttonStackInfo = {
				buttons = {{
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = p2.callback,
						text = p3.buttonText
					}
				}}
			},
			screenSize = p2.props.screenSize
		})
	end)
end

return (RoactRodux.connect(function(p4, _) -- line: 76
	return {
		screenSize = p4.ScreenSize
	}
end, function(p6) -- line: 80
	-- upvalues: CloseCentralOverlay (copy), AppPage (copy), Url (copy), TransitionAnimation (copy), FFlagSignalsNavP3Dispatch (copy), v9 (copy), NavigateDown (copy)
	return {
		closeCentralOverlay = function() -- line: 82
			-- upvalues: p6 (copy), CloseCentralOverlay (copy)
			return p6(CloseCentralOverlay())
		end,
		goToSecurityNotificationPage = function() -- line: 85
			-- upvalues: AppPage (copy), Url (copy), TransitionAnimation (copy), FFlagSignalsNavP3Dispatch (copy), v9 (copy), p6 (copy), NavigateDown (copy)
			local t1 = {
				name = AppPage.GenericWebPage,
				detail = string.format("%slogin/securityNotification", Url.BASE_URL),
				extraProps = {
					title = "",
					transitionAnimation = TransitionAnimation.None
				}
			}

			if FFlagSignalsNavP3Dispatch then
				return v9.down(v9.fromLegacyPage(t1))
			end

			return p6(NavigateDown(t1))
		end,
		navigateToPage = function(p7) -- line: 100
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v9 (copy), p6 (copy), NavigateDown (copy)
			if FFlagSignalsNavP3Dispatch then
				return v9.down(v9.fromLegacyPage(p7))
			end

			return p6(NavigateDown(p7))
		end
	}
end)(v18))
