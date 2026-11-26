local module = require("@luauforge/bundled/ggX")
local module2 = require("@luauforge/bundled/gln")
local module3 = require("@luauforge/bundled/ggQ")
require("@luauforge/bundled/glo")

local module4 = require("@luauforge/bundled/gjQ")
local module5 = require("@luauforge/bundled/glU")
local module6 = require("@luauforge/bundled/gng")
local module7 = require("@luauforge/bundled/gky")

local module8 = require("@luauforge/bundled/gkq")

local v8 = {
	{
		[module3.LoginScreenV2] = {
			screen = function(p2)
				return module.createElement(module5, p2)
			end,
			navigationOptions = { title = module3.LoginScreenV2 }
		}
	},
	{
		[module3.AuthenticationScreen] = {
			screen = function(p2)
				return module.createElement(module4, p2)
			end,
			navigationOptions = { title = module3.AuthenticationScreen }
		}
	},
	{
		[module3.EmailOtpScreen] = {
			screen = function(p2)
				return module.createElement(module7, p2)
			end,
			navigationOptions = { title = module3.EmailOtpScreen }
		}
	}
}

if module8 then
	local v9 = {
		[module3.EnterEmailScreen] = {
			screen = function(p2)
				return module.createElement(module6, p2)
			end,
			navigationOptions = { title = module3.EnterEmailScreen }
		}
	}

	table.insert(v8, v9)
end

return (module2.createRobloxSwitchNavigator(v8, {
	initialRouteName = module3.LoginScreenV2,
	keepVisitedScreensMounted = false,
	backBehavior = module2.BackBehavior.InitialRoute
}))
