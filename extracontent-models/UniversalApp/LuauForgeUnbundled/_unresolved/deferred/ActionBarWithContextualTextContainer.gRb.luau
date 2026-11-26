local CorePackages = game:GetService("CorePackages")
local packages = CorePackages.Packages
local React = require(packages.React)

local module = require("@luauforge/deferred/gRc")
local module2 = require("@luauforge/deferred/gRd")

local function ActionBarWithContextualTextContainer(p2)
	local v5 = module2(p2)
	return React.createElement(module, v5)
end

return ActionBarWithContextualTextContainer
