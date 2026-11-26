local module = require("@luauforge/deferred/hcS")

local module2 = require("@luauforge/deferred/hdn")
local module3 = require("@luauforge/deferred/hdo")

local function GenerationResultActionsContainer(p2)
	local v5 = module3(p2)

	return module.createElement(module2, v5)
end

return GenerationResultActionsContainer
