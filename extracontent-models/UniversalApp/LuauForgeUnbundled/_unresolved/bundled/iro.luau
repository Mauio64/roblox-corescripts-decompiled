local actionHandlers = require("@luauforge/bundled/irf").ActionHandlers
local getSiteMessageStore = require("@luauforge/bundled/fyU").GetSiteMessageStore
local module = require("@luauforge/bundled/dzM")
local module2 = require("@luauforge/bundled/dzN")

local function handleNavigationSiteAlertRefresh(): boolean
	getSiteMessageStore(false).refreshSiteAlertInfo(true)
	return false
end

return function(p2)
	actionHandlers.register(p2, module.name, handleNavigationSiteAlertRefresh)
	actionHandlers.register(p2, module2.name, handleNavigationSiteAlertRefresh)
end
