return {
	getSearchKeywordFromSearchesParameters = function(object, p2)
		if not p2 then
			return nil
		end

		local state = object:getState()
		local v5 = state.SearchesParameters and state.SearchesParameters[p2]

		if v5 and v5.searchKeyword then
			return v5.searchKeyword
		end

		return nil
	end,
	getShouldFetchCatalogOrganicAfterWidgets = function(p2, value)
		local v5 = typeof(value) == "string" and value ~= ""
		return not p2 or v5
	end
}
