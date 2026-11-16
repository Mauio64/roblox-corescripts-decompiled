local module = require("@luauforge/bundled/fAH")
local module2 = require("@luauforge/bundled/fBZ")
local module3 = require("@luauforge/bundled/fBP")

local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

local getFFlagAuthFlowProviderEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagAuthFlowProviderEnabled

local loginV2Container = require("@luauforge/bundled/fFi").LoginV2Container

return function(p2)
	local v5 = { LaunchApp = module, ResetAppState = module2, Logout = module3 }

	local isVisible = if p2 then p2.isVisible else nil

	if not getFFlagAuthFlowProviderEnabled() then
		return React.createElement(loginV2Container, {
			monoDeps = v5,
			isVisible = isVisible
		})
	end

	local module4 = require("@luauforge/bundled/fIO")
	return React.createElement(module4.AuthFlowProvider, {
		page = module4.AuthFlowPage.LoginV2,
		environment = v5,
		isVisible = isVisible
	})
end
