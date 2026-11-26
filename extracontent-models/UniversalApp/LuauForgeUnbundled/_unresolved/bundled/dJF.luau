local module = require("@luauforge/bundled/dJC")

local screenSizeSelector = require("@luauforge/bundled/dJD").screenSizeSelector
local getMiddleContentWidth = require("@luauforge/bundled/dJD").getMiddleContentWidth

local useSelector = module.Hooks.RoactRodux.useSelector

return function(callback)
	local middleContentWidth = getMiddleContentWidth(useSelector(screenSizeSelector).X)
	return function()
		return callback(middleContentWidth)
	end
end
