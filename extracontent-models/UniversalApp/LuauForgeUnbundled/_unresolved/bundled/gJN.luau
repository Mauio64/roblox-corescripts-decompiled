require("@luauforge/bundled/dKU")
require("@luauforge/bundled/dPs")
local module = require("@luauforge/bundled/dRk")
local module2 = require("@luauforge/bundled/dRm")

local module3 = require("@luauforge/bundled/dSE")
local module4 = require("@luauforge/bundled/fCI")

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
