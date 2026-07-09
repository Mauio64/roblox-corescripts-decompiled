local AccountRecovery = script:FindFirstAncestor("AccountRecovery")
local AccountRecoveryParent = AccountRecovery.Parent
local React = require(AccountRecoveryParent.React)
local RoactNavigation = require(AccountRecoveryParent.RoactNavigation)
local AccountRecoveryPageState = require(AccountRecovery.Enums.AccountRecoveryPageState)

require(AccountRecoveryParent.Navigation)

local RequestRecoveryScreen = require(AccountRecovery.Components.RequestRecoveryScreen)
local SendCodeScreen = require(AccountRecovery.Components.SendCodeScreen)
local ChooseVerificationMethodScreen = require(AccountRecovery.Components.ChooseVerificationMethodScreen)
local AccountVerifiedConfirmationScreen = require(AccountRecovery.Components.AccountVerifiedConfirmationScreen)
local VerifyCodeScreen = require(AccountRecovery.Components.VerifyCodeScreen)
local ChooseAccountScreen = require(AccountRecovery.Components.ChooseAccountScreen)
local ResetPasswordScreen = require(AccountRecovery.Components.ResetPasswordScreen)
local ContinueFallbackScreen = require(AccountRecovery.Components.ContinueFallbackScreen)
local CannotRecoverAccountScreen = require(AccountRecovery.Components.CannotRecoverAccountScreen)
local t1 = {
	{
		[AccountRecoveryPageState.RequestRecoveryScreen] = {
			screen = function(p1) -- line: 22
				-- upvalues: React (copy), RequestRecoveryScreen (copy)
				return React.createElement(RequestRecoveryScreen, p1)
			end,
			navigationOptions = {
				title = AccountRecoveryPageState.RequestRecoveryScreen
			}
		}
	},
	{
		[AccountRecoveryPageState.SendCodeScreen] = {
			screen = function(p2) -- line: 32
				-- upvalues: React (copy), SendCodeScreen (copy)
				return React.createElement(SendCodeScreen, p2)
			end,
			navigationOptions = {
				title = AccountRecoveryPageState.SendCodeScreen
			}
		}
	},
	{
		[AccountRecoveryPageState.ChooseVerificationMethodScreen] = {
			screen = function(p3) -- line: 42
				-- upvalues: React (copy), ChooseVerificationMethodScreen (copy)
				return React.createElement(ChooseVerificationMethodScreen, p3)
			end,
			navigationOptions = {
				title = AccountRecoveryPageState.ChooseVerificationMethodScreen
			}
		}
	},
	{
		[AccountRecoveryPageState.AccountVerifiedConfirmationScreen] = {
			screen = function(p4) -- line: 52
				-- upvalues: React (copy), AccountVerifiedConfirmationScreen (copy)
				return React.createElement(AccountVerifiedConfirmationScreen, p4)
			end,
			navigationOptions = {
				title = AccountRecoveryPageState.AccountVerifiedConfirmationScreen
			}
		}
	},
	{
		[AccountRecoveryPageState.VerifyCodeScreen] = {
			screen = function(p5) -- line: 62
				-- upvalues: React (copy), VerifyCodeScreen (copy)
				return React.createElement(VerifyCodeScreen, p5)
			end,
			navigationOptions = {
				title = AccountRecoveryPageState.VerifyCodeScreen
			}
		}
	},
	{
		[AccountRecoveryPageState.ChooseAccountScreen] = {
			screen = function(p6) -- line: 72
				-- upvalues: React (copy), ChooseAccountScreen (copy)
				return React.createElement(ChooseAccountScreen, p6)
			end,
			navigationOptions = {
				title = AccountRecoveryPageState.ChooseAccountScreen
			}
		}
	},
	{
		[AccountRecoveryPageState.ResetPasswordScreen] = {
			screen = function(p7) -- line: 82
				-- upvalues: React (copy), ResetPasswordScreen (copy)
				return React.createElement(ResetPasswordScreen, p7)
			end,
			navigationOptions = {
				title = AccountRecoveryPageState.ResetPasswordScreen
			}
		}
	},
	{
		[AccountRecoveryPageState.ContinueFallbackScreen] = {
			screen = function(p8) -- line: 92
				-- upvalues: React (copy), ContinueFallbackScreen (copy)
				return React.createElement(ContinueFallbackScreen, p8)
			end,
			navigationOptions = {
				title = AccountRecoveryPageState.ContinueFallbackScreen
			}
		}
	},
	{
		[AccountRecoveryPageState.CannotRecoverAccountScreen] = {
			screen = function(p9) -- line: 102
				-- upvalues: React (copy), CannotRecoverAccountScreen (copy)
				return React.createElement(CannotRecoverAccountScreen, p9)
			end,
			navigationOptions = {
				title = AccountRecoveryPageState.CannotRecoverAccountScreen
			}
		}
	}
}

return (RoactNavigation.createRobloxStackNavigator(t1, {
	keepVisitedScreensMounted = false,
	initialRouteName = AccountRecoveryPageState.RequestRecoveryScreen,
	backBehavior = RoactNavigation.BackBehavior.History,
	transitionConfig = function() -- line: 112
		return {
			transitionSpec = {
				frequency = 1000000,
				dampingRatio = 1
			}
		}
	end
}))
