local module = require("@luauforge/bundled/fAH")
local module2 = require("@luauforge/bundled/fBZ")
local module3 = require("@luauforge/bundled/fBP")

local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

local multiPageSignupContainer = require("@luauforge/bundled/hBm").Components.MultiPageSignupContainer

return function()
	return React.createElement(multiPageSignupContainer, {
		monoDeps = { LaunchApp = module, ResetAppState = module2, Logout = module3 }
	})
end
