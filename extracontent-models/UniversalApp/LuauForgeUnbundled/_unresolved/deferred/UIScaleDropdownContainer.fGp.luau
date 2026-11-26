local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local module = require("@luauforge/deferred/fGq")
local module2 = require("@luauforge/deferred/fGr")

local function UIScaleDropdownContainer(p2)
	local v5 = module2(p2)
	return React.createElement(module, v5)
end

return UIScaleDropdownContainer
