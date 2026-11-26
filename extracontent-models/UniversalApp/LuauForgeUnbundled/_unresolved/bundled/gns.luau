local module = require("@luauforge/bundled/geZ")

local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

local accountRecoveryContainer = require("@luauforge/bundled/gnt").Components.AccountRecoveryContainer

return function()
	return React.createElement(accountRecoveryContainer, {
		monoDeps = { LaunchApp = module }
	})
end
