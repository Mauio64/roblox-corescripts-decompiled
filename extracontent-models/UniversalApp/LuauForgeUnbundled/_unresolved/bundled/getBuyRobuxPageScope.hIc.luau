local appPage = require("@luauforge/bundled/hHo").AppPage
local module = require("@luauforge/bundled/hId")

local function getBuyRobuxPageScope()
	return module.getSduiClientPageScope(appPage.BuyRobux)
end

return getBuyRobuxPageScope
