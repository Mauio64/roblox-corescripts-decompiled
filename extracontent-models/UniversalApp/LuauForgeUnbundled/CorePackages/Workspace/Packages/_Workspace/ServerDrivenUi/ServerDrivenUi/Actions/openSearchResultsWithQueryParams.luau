local searchTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RobloxAppEnums").SearchTypes

local isSearchTypeInOmniSearch = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DiscoveryUtils").isSearchTypeInOmniSearch

require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")

return {
	resolveSearchQuery = function(p2)
		local actionParams = if p2 then p2.actionParams else nil

		if actionParams == nil then
			return nil
		end

		local searchQuery = actionParams.searchQuery

		if typeof(searchQuery) == "string" and searchQuery ~= "" then
			return searchQuery
		end

		return nil
	end,
	resolveSearchType = function(p2)
		local actionParams = if p2 then p2.actionParams else nil
		local searchType = if actionParams then actionParams.searchType else nil

		if searchType == nil or searchType == "" then
			return searchTypes.TopResults
		end

		if typeof(searchType) ~= "string" or searchTypes[searchType] == nil then
			return nil
		end

		if isSearchTypeInOmniSearch(searchType) then
			return searchType
		end

		return nil
	end,
	resolveIsAutocompleteSuggestion = function(p2): boolean
		local actionParams = if p2 then p2.actionParams else nil
		return (if actionParams then actionParams.isAutocompleteSuggestion else nil) == true
	end
}
