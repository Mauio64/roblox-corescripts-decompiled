local module = require("@luauforge/bundled/dHR")
local module2 = require("@luauforge/bundled/dHS")

local headShape = require("@luauforge/bundled/dHT").Enums.HeadShape

local module3 = require("@luauforge/bundled/dHU")
local module4 = require("@luauforge/bundled/dHV")

local function getDefaultState()
	return { availableHeadShapes = {}, lastSelectedHeadShape = headShape.Default }
end

return module.createReducer({
	availableHeadShapes = {},
	lastSelectedHeadShape = headShape.Default
}, {
	[module3.name] = function(p2, p3)
		return module2.Dictionary.join(p2, { availableHeadShapes = p3.headShapes })
	end,
	[module4.name] = function(p2, p3)
		return module2.Dictionary.join(p2, { lastSelectedHeadShape = p3.headShape })
	end
})
