local appPage = require("@luauforge/bundled/hwj").AppPage
local module = require("@luauforge/bundled/hwV")

local function getBuyRobuxPageScope()
	return module.getSduiClientPageScope(appPage.BuyRobux)
end

return getBuyRobuxPageScope
