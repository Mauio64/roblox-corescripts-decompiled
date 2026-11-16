local actionHandlers = require("@luauforge/bundled/iix").ActionHandlers
local getStartupStore = require("@luauforge/bundled/fBl").GetStartupStore
local module = require("@luauforge/bundled/cgq")

local function handleClearUserSpecificData(): boolean
	getStartupStore(false).reset()
	return false
end

return function(p2)
	actionHandlers.register(p2, module.name, handleClearUserSpecificData)
end
