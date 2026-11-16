local module = require("@luauforge/bundled/dGx")

local screenSizeSelector = require("@luauforge/bundled/dGy").screenSizeSelector
local getMiddleContentWidth = require("@luauforge/bundled/dGy").getMiddleContentWidth

local useSelector = module.Hooks.RoactRodux.useSelector

return function(callback)
	local middleContentWidth = getMiddleContentWidth(useSelector(screenSizeSelector).X)
	return function()
		return callback(middleContentWidth)
	end
end
