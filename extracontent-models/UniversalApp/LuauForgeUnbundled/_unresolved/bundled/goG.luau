local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)

local module = require("@luauforge/bundled/goH")

return function(p2)
	return function(p3)
		return Roact.createElement(module.Consumer, {
			render = function(p4)
				return Roact.createElement(p2, Cryo.Dictionary.join(p3, p4))
			end
		})
	end
end
