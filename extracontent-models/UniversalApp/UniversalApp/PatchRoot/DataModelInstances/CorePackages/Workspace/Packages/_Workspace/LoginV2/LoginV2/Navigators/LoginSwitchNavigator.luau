local LoginV2 = script:FindFirstAncestor("LoginV2")
local LoginV2Parent = LoginV2.Parent
local React = require(LoginV2Parent.React)
local RoactNavigation = require(LoginV2Parent.RoactNavigation)
local LoginPageState = require(LoginV2.Enums.LoginPageState)

require(LoginV2Parent.Navigation)

local AuthenticationScreen = require(LoginV2.Components.AuthenticationScreen)
local LoginScreenV2 = require(LoginV2.Components.LoginScreenV2)
local EmailOtpScreen = require(LoginV2.Components.EmailOtpScreen)
local t1 = {
	{
		[LoginPageState.LoginScreenV2] = {
			screen = function(p1) -- line: 16
				-- upvalues: React (copy), LoginScreenV2 (copy)
				return React.createElement(LoginScreenV2, p1)
			end,
			navigationOptions = {
				title = LoginPageState.LoginScreenV2
			}
		}
	},
	{
		[LoginPageState.AuthenticationScreen] = {
			screen = function(p2) -- line: 26
				-- upvalues: React (copy), AuthenticationScreen (copy)
				return React.createElement(AuthenticationScreen, p2)
			end,
			navigationOptions = {
				title = LoginPageState.AuthenticationScreen
			}
		}
	},
	{
		[LoginPageState.EmailOtpScreen] = {
			screen = function(p3) -- line: 36
				-- upvalues: React (copy), EmailOtpScreen (copy)
				return React.createElement(EmailOtpScreen, p3)
			end,
			navigationOptions = {
				title = LoginPageState.EmailOtpScreen
			}
		}
	}
}

return (RoactNavigation.createRobloxSwitchNavigator(t1, {
	keepVisitedScreensMounted = false,
	initialRouteName = LoginPageState.LoginScreenV2,
	backBehavior = RoactNavigation.BackBehavior.InitialRoute
}))
