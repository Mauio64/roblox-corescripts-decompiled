local module = require("@luauforge/bundled/foM")
local module2 = require("@luauforge/bundled/foZ")
local module3 = require("@luauforge/bundled/fpm")
local module4 = require("@luauforge/bundled/fpi")

local sduiLoadTimer = module.SduiLoadTimer
local sduiLogger = module2.SduiLogger
local sduiErrors = module2.SduiErrors
local v5 = false

local function hasAutocompleteTemplates(): boolean
	local sduiTemplateStore = module.getSduiTemplateStore()
	local cachedRobloxComponentToTemplateId = sduiTemplateStore.getCachedRobloxComponentToTemplateId(module4)
	local searchAutocompleteList = cachedRobloxComponentToTemplateId.SearchAutocompleteList
	local searchAutocompleteSuggestion = cachedRobloxComponentToTemplateId.SearchAutocompleteSuggestion
	return searchAutocompleteList ~= nil
		and searchAutocompleteSuggestion ~= nil
		and sduiTemplateStore.getTemplate(searchAutocompleteList) ~= nil
		and sduiTemplateStore.getTemplate(searchAutocompleteSuggestion) ~= nil
end

local function prewarmSearchAutocompleteTemplates()
	local fetchSduiTemplates = module.fetchSduiTemplates

	if fetchSduiTemplates == nil then
		return module3.reject("Autocomplete requires client-driven templates")
	end

	local loadTimer = sduiLoadTimer.createLoadTimer(`{module4}Prewarm`)
	loadTimer.start("preload")
	return fetchSduiTemplates({
		surfaceKeys = { module4 },
		loadTimer = loadTimer
	}, v5):andThen(function()
		if not hasAutocompleteTemplates() then
			return module3.reject("Autocomplete templates or mapping are missing")
		end

		v5 = false
	end):catch(function(p2)
		v5 = true
		sduiLogger.reportError(
			sduiErrors.SduiErrorType.FailedToPrewarmTemplates,
			{ message = tostring(p2), name = module4 },
			module4
		)

		return module3.reject(p2)
	end)
end

return prewarmSearchAutocompleteTemplates
