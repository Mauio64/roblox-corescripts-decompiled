local appPage = require("@luauforge/bundled/fwi").AppPage
local sduiLoadTimer = require("@luauforge/bundled/fwh").SduiLoadTimer

local module = require("@luauforge/bundled/fwl")

local function navigateToSearchResults(p2, p3, p4, callback)
	if p2 ~= nil and p2 ~= "" then
		local loadTimer = sduiLoadTimer.createLoadTimer(appPage.SearchPage)
		loadTimer.start("navigate")
		module(p2, p3, p4, loadTimer)
	end

	callback()
end

return navigateToSearchResults
