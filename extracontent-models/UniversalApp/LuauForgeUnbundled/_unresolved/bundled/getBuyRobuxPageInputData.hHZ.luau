local appPage = require("@luauforge/bundled/hHo").AppPage
local getSduiApiStore = require("@luauforge/bundled/hHx").getSduiApiStore

local module = require("@luauforge/bundled/hHI")

local function getBuyRobuxPageInputData()
	return getSduiApiStore().getInputData(appPage.BuyRobux, module.PageEntryIdentifier)
end

return getBuyRobuxPageInputData
