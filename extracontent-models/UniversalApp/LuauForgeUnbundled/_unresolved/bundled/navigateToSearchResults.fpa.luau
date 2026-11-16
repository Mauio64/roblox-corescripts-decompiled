local appPage = require("@luauforge/bundled/foN").AppPage
local sduiLoadTimer = require("@luauforge/bundled/foM").SduiLoadTimer

local module = require("@luauforge/bundled/foQ")

local function navigateToSearchResults(p2, p3, p4, callback)
	if p2 ~= nil and p2 ~= "" then
		local loadTimer = sduiLoadTimer.createLoadTimer(appPage.SearchPage)
		loadTimer.start("navigate")
		module(p2, p3, p4, loadTimer)
	end

	callback()
end

return navigateToSearchResults
