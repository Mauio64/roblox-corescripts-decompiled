local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local module = require("@luauforge/deferred/gQH")
require("@luauforge/deferred/gRV")
local module2 = require("@luauforge/deferred/gRW")

local function BackgroundsPlusInventoryLayout(p2)
	local v5 = module2(p2)
	return React.createElement(module, v5)
end

return BackgroundsPlusInventoryLayout
