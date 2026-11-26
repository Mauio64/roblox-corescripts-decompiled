local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local navigationEvents = RoactNavigation.NavigationEvents
local module = require("@luauforge/bundled/dPR")

local function OnFocusExposureLogger(p2)
	local v5 = module.useLogExposureOnce(p2.ixpTest)

	if p2.ixpTest.isEnabled() then
		return React.createElement(navigationEvents, { onDidFocus = v5 })
	end

	return nil
end

return OnFocusExposureLogger
