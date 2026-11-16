local fFlagSduiUseInputData = require("@luauforge/bundled/foP").FFlagSduiUseInputData

local module = require("@luauforge/bundled/foJ")
local appPage = require("@luauforge/bundled/foN").AppPage
local module2 = require("@luauforge/bundled/foZ")
local sduiErrors = module2.SduiErrors
local sduiLogger = module2.SduiLogger

local module3 = require("@luauforge/bundled/foM")
local useInputData = module3.useInputData
local useUiStatus = module3.useUiStatus
local uiStatus = module3.UiStatus

local function useIsSearchResultsPageEmpty(p2)
	local v5 = useUiStatus(p2)
	local v6 = if fFlagSduiUseInputData then useInputData(p2, "search_results_feed") else nil

	local v7, v8 = module.useMemo(function(): (boolean, boolean)
		if v5 ~= uiStatus.Resolved or typeof(v6) ~= "table" then
			return false, false
		end

		local entry_order = v6.entry_order
		local entry_map = v6.entry_map
		local v9 = typeof(entry_map) == "table" and next(entry_map) ~= nil

		if entry_order == nil then
			return not v9, false
		end

		local v10 = typeof(entry_order) == "table" and next(entry_order) ~= nil

		return not (v10 and v9), v10 ~= v9
	end, { v5, v6 })

	module.useEffect(function()
		if v8 then
			sduiLogger.reportError(
				sduiErrors.SduiErrorType.InvalidFeedInResponse,
				{
					message = "SDUI search results feed empty with mismatched entry_order/entry_map",
					name = "useIsSearchResultsPageEmpty"
				},
				appPage.SearchPage
			)
		end
	end, { v8 })

	return v7
end

return useIsSearchResultsPageEmpty
