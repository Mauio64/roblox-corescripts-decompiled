local appPage = require("@luauforge/bundled/hwj").AppPage
local getSduiApiStore = require("@luauforge/bundled/hwr").getSduiApiStore

local module = require("@luauforge/bundled/hwC")

local function getBuyRobuxPageInputData()
	return getSduiApiStore().getInputData(appPage.BuyRobux, module.PageEntryIdentifier)
end

return getBuyRobuxPageInputData
