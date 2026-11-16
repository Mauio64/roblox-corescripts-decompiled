local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local module = require("@luauforge/deferred/gVF")

local module2 = require("@luauforge/deferred/gVH")

local function ProfileTabPageContainer(p2)
	local v5 = module2(p2)
	return React.createElement(module, v5)
end

return ProfileTabPageContainer
