require("@luauforge/bundled/dHL")
require("@luauforge/bundled/dMc")
local module = require("@luauforge/bundled/dNU")
local module2 = require("@luauforge/bundled/dNW")

local module3 = require("@luauforge/bundled/dPo")
local module4 = require("@luauforge/bundled/fvh")

return function(items, p2)
	return function(object)
		local rangeAndSliderValueForColor3s = {}

		for k, item in pairs(items) do
			local rangeAndSliderValueForColor3, v5 = module4.findRangeAndSliderValueForColor3(item, p2)
			module3(rangeAndSliderValueForColor3, k, v5, item)
			rangeAndSliderValueForColor3s[k] = rangeAndSliderValueForColor3
		end

		object:dispatch(module2(items))

		object:dispatch(module(rangeAndSliderValueForColor3s))
	end
end
