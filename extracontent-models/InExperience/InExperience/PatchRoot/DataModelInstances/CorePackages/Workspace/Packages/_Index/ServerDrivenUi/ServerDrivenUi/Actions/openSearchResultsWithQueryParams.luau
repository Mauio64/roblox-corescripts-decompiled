local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local SearchTypes = require(Parent.RobloxAppEnums).SearchTypes
local isSearchTypeInOmniSearch = require(Parent.DiscoveryUtils).isSearchTypeInOmniSearch

require(Parent.SduiCoreSystem)

return {
	resolveSearchQuery = function(p1) -- line: 18
		local v5 = if not p1 then nil else p1.actionParams

		if v5 == nil then
			return nil
		end

		local searchQuery = v5.searchQuery

		if typeof(searchQuery) ~= "string" or searchQuery == "" then
			return nil
		end

		return searchQuery
	end,
	resolveSearchType = function(p2) -- line: 32
		-- upvalues: SearchTypes (copy), isSearchTypeInOmniSearch (copy)
		local v8 = if not p2 then nil else p2.actionParams
		local v9 = if not v8 then nil else v8.searchType

		if v9 == nil or v9 == "" then
			return SearchTypes.TopResults
		end

		if typeof(v9) ~= "string" or SearchTypes[v9] == nil then
			return nil
		end

		if not isSearchTypeInOmniSearch(v9) then
			return nil
		end

		return v9
	end
}
