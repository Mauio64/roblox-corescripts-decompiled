local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local module = require("@luauforge/deferred/gYl")

local module2 = require("@luauforge/deferred/gYm")

local function AvatarSwitcherPageContainer()
	local v5 = module()
	return React.createElement(module2, v5)
end

return (require("@luauforge/deferred/gmV")(AvatarSwitcherPageContainer))
