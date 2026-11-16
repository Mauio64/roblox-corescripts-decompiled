local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)

local module = require("@luauforge/bundled/eeB")
local module2 = require("@luauforge/bundled/edO")
local module3 = require("@luauforge/bundled/edP")
require("@luauforge/bundled/eeC")

return function(p2)
	return function(object)
		object:dispatch(module3(module2.PlayerContextualMenu, Cryo.Dictionary.join({
			joinExperience = function(p3, p4)
				module:ByUser({ id = p3 }, p4)
			end
		}, p2)))
	end
end
