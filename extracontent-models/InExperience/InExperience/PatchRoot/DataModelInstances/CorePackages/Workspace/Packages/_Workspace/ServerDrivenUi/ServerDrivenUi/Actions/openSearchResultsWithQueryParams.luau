local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local RobloxAppEnums = require(parent.RobloxAppEnums)
local SearchTypes = RobloxAppEnums.SearchTypes

local DiscoveryUtils = require(parent.DiscoveryUtils)
local isSearchTypeInOmniSearch = DiscoveryUtils.isSearchTypeInOmniSearch

require(parent.SduiCoreSystem)
local OpenSearchResultsWithQueryParams = {}

function OpenSearchResultsWithQueryParams.resolveSearchQuery(p)
	local actionParams

	if p then
		actionParams = p.actionParams
	end

	if actionParams == nil then
		return nil
	end

	local searchQuery = actionParams.searchQuery

	if typeof(searchQuery) == "string" and searchQuery ~= "" then
		return searchQuery
	end

	return nil
end

function OpenSearchResultsWithQueryParams.resolveSearchType(p)
	local actionParams

	if p then
		actionParams = p.actionParams
	end

	local searchType

	if actionParams then
		searchType = actionParams.searchType
	end

	if searchType == nil or searchType == "" then
		return SearchTypes.TopResults
	end

	if typeof(searchType) ~= "string" or SearchTypes[searchType] == nil then
		return nil
	end

	if isSearchTypeInOmniSearch(searchType) then
		return searchType
	end

	return nil
end

function OpenSearchResultsWithQueryParams.resolveIsAutocompleteSuggestion(p): boolean
	local actionParams

	if p then
		actionParams = p.actionParams
	end

	local v

	if actionParams then
		v = actionParams.isAutocompleteSuggestion
	end

	return v == true
end

return OpenSearchResultsWithQueryParams
