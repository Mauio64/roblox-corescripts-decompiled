local actionHandlers = require("@luauforge/bundled/irf").ActionHandlers
local getStartupStore = require("@luauforge/bundled/gfE").GetStartupStore
local module = require("@luauforge/bundled/ciD")

local function handleClearUserSpecificData(): boolean
	getStartupStore(false).reset()
	return false
end

return function(p2)
	actionHandlers.register(p2, module.name, handleClearUserSpecificData)
end
