local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local module = require("@luauforge/deferred/gXf")
local module2 = require("@luauforge/deferred/gXn")

local function UpdateOutfitPageContainer()
	local v5 = module2()
	return React.createElement(module, v5)
end

return UpdateOutfitPageContainer
