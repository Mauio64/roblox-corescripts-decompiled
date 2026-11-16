local module = require("@luauforge/bundled/fJc")
local module2 = require("@luauforge/bundled/fJd")
local module3 = require("@luauforge/bundled/fJZ")
require("@luauforge/bundled/fJf")

local module4 = require("@luauforge/bundled/fKa")
local module5 = require("@luauforge/bundled/fKq")
local module6 = require("@luauforge/bundled/fKR")
local module7 = require("@luauforge/bundled/fKT")
local module8 = require("@luauforge/bundled/fKU")
local module9 = require("@luauforge/bundled/fKZ")
local module10 = require("@luauforge/bundled/fLd")
local module11 = require("@luauforge/bundled/fMt")
local module12 = require("@luauforge/bundled/fMu")

local v5 = {
	[module3.RequestRecoveryScreen] = {
		screen = function(p2)
			return module.createElement(module4, p2)
		end,
		navigationOptions = { title = module3.RequestRecoveryScreen }
	}
}

local v6 = {
	[module3.SendCodeScreen] = {
		screen = function(p2)
			return module.createElement(module5, p2)
		end,
		navigationOptions = { title = module3.SendCodeScreen }
	}
}

local v7 = {
	[module3.ChooseVerificationMethodScreen] = {
		screen = function(p2)
			return module.createElement(module6, p2)
		end,
		navigationOptions = { title = module3.ChooseVerificationMethodScreen }
	}
}

local v8 = {
	[module3.AccountVerifiedConfirmationScreen] = {
		screen = function(p2)
			return module.createElement(module7, p2)
		end,
		navigationOptions = { title = module3.AccountVerifiedConfirmationScreen }
	}
}

local v9 = {
	[module3.VerifyCodeScreen] = {
		screen = function(p2)
			return module.createElement(module8, p2)
		end,
		navigationOptions = { title = module3.VerifyCodeScreen }
	}
}

local v10 = {
	[module3.ChooseAccountScreen] = {
		screen = function(p2)
			return module.createElement(module9, p2)
		end,
		navigationOptions = { title = module3.ChooseAccountScreen }
	}
}

local v11 = {
	[module3.ResetPasswordScreen] = {
		screen = function(p2)
			return module.createElement(module10, p2)
		end,
		navigationOptions = { title = module3.ResetPasswordScreen }
	}
}

local v12 = {
	[module3.ContinueFallbackScreen] = {
		screen = function(p2)
			return module.createElement(module11, p2)
		end,
		navigationOptions = { title = module3.ContinueFallbackScreen }
	}
}

local v13 = {
	[module3.CannotRecoverAccountScreen] = {
		screen = function(p2)
			return module.createElement(module12, p2)
		end,
		navigationOptions = { title = module3.CannotRecoverAccountScreen }
	}
}
return (module2.createRobloxStackNavigator({
	v5,
	v6,
	v7,
	v8,
	v9,
	v10,
	v11,
	v12,
	v13
}, {
	initialRouteName = module3.RequestRecoveryScreen,
	keepVisitedScreensMounted = false,
	backBehavior = module2.BackBehavior.History,
	transitionConfig = function()
		return {
			transitionSpec = { frequency = 1000000, dampingRatio = 1 }
		}
	end
}))
