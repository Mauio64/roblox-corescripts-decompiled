local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)

local module = require("@luauforge/bundled/ehY")
local module2 = require("@luauforge/bundled/ehl")
local module3 = require("@luauforge/bundled/ehm")
require("@luauforge/bundled/ehZ")

return function(p2)
	return function(object)
		object:dispatch(module3(module2.PlayerContextualMenu, Cryo.Dictionary.join({
			joinExperience = function(p3, p4)
				module:ByUser({ id = p3 }, p4)
			end
		}, p2)))
	end
end
