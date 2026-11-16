local module = require("@luauforge/deferred/gpo")

local module2 = require("@luauforge/deferred/gpp")
local module3 = require("@luauforge/deferred/gpt")

local function PhotoboothMomentsButtonContainer(p2)
	local v5 = module3(p2)
	return module.createElement(module2, v5)
end

return PhotoboothMomentsButtonContainer
