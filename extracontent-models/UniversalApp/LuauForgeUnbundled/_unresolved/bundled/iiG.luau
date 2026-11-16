local actionHandlers = require("@luauforge/bundled/iix").ActionHandlers
local getSiteMessageStore = require("@luauforge/bundled/frA").GetSiteMessageStore
local module = require("@luauforge/bundled/dwJ")
local module2 = require("@luauforge/bundled/dwK")

local function handleNavigationSiteAlertRefresh(): boolean
	getSiteMessageStore(false).refreshSiteAlertInfo(true)
	return false
end

return function(p2)
	actionHandlers.register(p2, module.name, handleNavigationSiteAlertRefresh)
	actionHandlers.register(p2, module2.name, handleNavigationSiteAlertRefresh)
end
