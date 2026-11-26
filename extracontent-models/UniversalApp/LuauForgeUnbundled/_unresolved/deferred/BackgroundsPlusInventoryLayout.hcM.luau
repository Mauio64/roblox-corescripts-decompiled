local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local module = require("@luauforge/deferred/hcN")
require("@luauforge/deferred/heh")
local module2 = require("@luauforge/deferred/hei")

local function BackgroundsPlusInventoryLayout(p2)
	local v5 = module2(p2)
	return React.createElement(module, v5)
end

return BackgroundsPlusInventoryLayout
