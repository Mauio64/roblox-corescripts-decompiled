local module = require("@luauforge/bundled/dOW")
local module2 = require("@luauforge/bundled/dOY")
local module3 = require("@luauforge/bundled/dNQ")

return function(data)
	return function(object)
		object:dispatch(module(
			data.minimumDeltaEBodyColorDifference,
			data.scales,
			data.accessoryRefinementTypes,
			data.accessoryRefinementLowerBounds,
			data.accessoryRefinementUpperBounds
		))

		object:dispatch(module2(module3.DefaultBodyColorRanges))
	end
end
