local module = require("@luauforge/bundled/fAH")

local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

local accountRecoveryContainer = require("@luauforge/bundled/fIY").Components.AccountRecoveryContainer

return function()
	return React.createElement(accountRecoveryContainer, {
		monoDeps = { LaunchApp = module }
	})
end
