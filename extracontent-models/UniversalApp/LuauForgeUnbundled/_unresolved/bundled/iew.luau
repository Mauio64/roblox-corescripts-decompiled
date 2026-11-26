local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local module = require("@luauforge/bundled/iex")
local useDrawerShouldMount = require("@luauforge/bundled/iaK").Hooks.useDrawerShouldMount

local function FlyoutSidePanelWrapper(p2)
	if useDrawerShouldMount() then
		return React.createElement(module, p2)
	end

	return nil
end

return React.memo(FlyoutSidePanelWrapper)
