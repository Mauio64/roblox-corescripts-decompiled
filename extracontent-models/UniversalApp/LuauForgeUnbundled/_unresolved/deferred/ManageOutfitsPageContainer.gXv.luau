local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local module = require("@luauforge/deferred/gXw")
local module2 = require("@luauforge/deferred/gXx")

local function ManageOutfitsPageContainer()
	local v5 = module2()
	return React.createElement(module, v5)
end

return ManageOutfitsPageContainer
