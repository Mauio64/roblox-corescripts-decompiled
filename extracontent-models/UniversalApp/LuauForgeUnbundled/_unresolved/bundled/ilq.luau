local module = require("@luauforge/bundled/geZ")
local module2 = require("@luauforge/bundled/ggs")

local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

local authDeeplinkEventReceiver = require("@game/CorePackages/Workspace/Packages/AuthCommon").EventReceivers.AuthDeeplinkEventReceiver

return function()
	return React.createElement(authDeeplinkEventReceiver, {
		monoDeps = { LaunchApp = module, ResetAppState = module2 }
	})
end
