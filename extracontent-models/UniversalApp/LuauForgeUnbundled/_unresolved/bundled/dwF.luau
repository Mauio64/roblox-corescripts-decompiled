local module = require("@luauforge/bundled/dtg")
local retrievalStatus = require("@luauforge/bundled/dus").Enum.RetrievalStatus
local module2 = require("@luauforge/bundled/dtp")
local gameSortGroups = module2.GameSortGroups
local module3 = require("@luauforge/bundled/duu")
local fetchStatusReducer = module3.FetchStatusReducer
local fetchStatusNamespace = module3.FetchStatusNamespace
local setFetchStatus = module3.SetFetchStatus
local gameFiltersReducer = require("@luauforge/bundled/dvF").DataStore.GameFiltersReducer
local getSelectedGameFilterOptions = require("@luauforge/bundled/dvF").DataStore.getSelectedGameFilterOptions

local module4 = require("@luauforge/bundled/dwG")
local module5 = require("@luauforge/bundled/dvH")
local module6 = require("@luauforge/bundled/dvG")

local function fn(name, p2)
	return setFetchStatus(fetchStatusNamespace.GameSorts, name, p2)
end

return function(p2, p3, p4, options)
	return function(object)
		if p3 == nil or p3.name == nil then
			return module.resolve("Invalid sort request")
		end

		assert(p3, "sort should always exist; assert for linter")

		if p3.dataSource ~= module2.DataSourceType.ExploreApi then
			return module.resolve(`Could not fetch games for {p3.name}; expected an ExploreApi sort but the sort is from {p3.dataSource}`)
		end

		if object:getState().Personalization[fetchStatusReducer.key][fetchStatusNamespace.GameSorts][p3.name] == retrievalStatus.Fetching then
			return module.resolve("Request for sort " .. p3.name .. " has been debounced")
		end

		local selectedGameFilterOptions = options or {}
		selectedGameFilterOptions.sortId = p3.name
		selectedGameFilterOptions.sessionId = module6:Get()

		local v5 = object:getState().Personalization[gameFiltersReducer.key][gameSortGroups.Games]

		local selectedGameFilterOptions2 = getSelectedGameFilterOptions(not v5 and {} or v5.allFilters)

		for k, selectedGameFilterOption in selectedGameFilterOptions2 do
			if selectedGameFilterOptions[k] then
				warn(`URL parameter {k} already exists`)
			else
				selectedGameFilterOptions[k] = selectedGameFilterOption
			end
		end

		object:dispatch(fn(p3.name, retrievalStatus.Fetching))

		return module4(p2, selectedGameFilterOptions):andThen(function(p5)
			module5(p2, object, p5.responseBody, p4)
			object:dispatch(fn(p3.name, retrievalStatus.Done))
		end, function(p5)
			object:dispatch(fn(p3.name, retrievalStatus.Failed))
			return module.reject(p5)
		end)
	end
end
