local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local module = require("@luauforge/deferred/eXm")
local module2 = require("@luauforge/deferred/gVE")

local extended = React.PureComponent:extend("ProfileTabPage")

function extended.render(p2)
	return React.createElement(module2, p2.props)
end

extended.router = module.router

return extended
