local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)

local module = require("@luauforge/deferred/gJJ")

return function(p2)
	return function(p3)
		return Roact.createElement(module, { overlayComponent = p2, arguments = p3 })
	end
end
