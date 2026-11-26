local appPage = require("@luauforge/bundled/fwi").AppPage
local module = require("@luauforge/bundled/fwh")
local module2 = require("@luauforge/bundled/fwu")
local sduiErrors = module2.SduiErrors
local sduiLogger = module2.SduiLogger
local sduiParseHelpers = module2.SduiParseHelpers

local sduiLoadTimer = module.SduiLoadTimer

local function prewarmSearchResultsTemplates()
	local loadTimer = sduiLoadTimer.createLoadTimer(`{appPage.SearchPage}Prewarm`)
	loadTimer.start("preload")

	local sduiTemplates = module.fetchSduiTemplates({
		surfaceKeys = { appPage.SearchPage },
		loadTimer = loadTimer
	})

	sduiTemplates:catch(function(p2)
		sduiLogger.reportError(
			sduiErrors.SduiErrorType.FailedToPrewarmTemplates,
			{
				message = sduiParseHelpers.stringifyValue(p2),
				name = appPage.SearchPage
			},
			appPage.SearchPage
		)
	end)

	return sduiTemplates
end

return prewarmSearchResultsTemplates
