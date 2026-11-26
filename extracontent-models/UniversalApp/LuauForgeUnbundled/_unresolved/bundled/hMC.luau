local module = require("@luauforge/bundled/geZ")
local module2 = require("@luauforge/bundled/ggs")
local module3 = require("@luauforge/bundled/ggi")

local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

local multiPageSignupContainer = require("@luauforge/bundled/hMD").Components.MultiPageSignupContainer

return function()
	return React.createElement(multiPageSignupContainer, {
		monoDeps = { LaunchApp = module, ResetAppState = module2, Logout = module3 }
	})
end
