local module = require("@luauforge/bundled/fAH")
local module2 = require("@luauforge/bundled/fBZ")

local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

local authDeeplinkEventReceiver = require("@game/CorePackages/Workspace/Packages/AuthCommon").EventReceivers.AuthDeeplinkEventReceiver

return function()
	return React.createElement(authDeeplinkEventReceiver, {
		monoDeps = { LaunchApp = module, ResetAppState = module2 }
	})
end
