local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local module = require("@luauforge/deferred/gXk")
local module2 = require("@luauforge/deferred/gXl")

return function(p2)
	local v5 = module(p2)
	return React.createElement(module2, v5)
end
