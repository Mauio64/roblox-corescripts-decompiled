return {
	getSearchKeywordFromSearchesParameters = function(p1, s1: string?) -- line: 8
		if not s1 then
			return nil
		end

		local v3 = p1:getState()
		local v4 = v3.SearchesParameters and v3.SearchesParameters[s1]

		if v4 and v4.searchKeyword then
			return v4.searchKeyword
		end

		return nil
	end,
	getShouldFetchCatalogOrganicAfterWidgets = function(b1: boolean?, s2: string?) -- line: 21
		local v7 = typeof(s2) == "string" and s2 ~= ""

		return not b1 or v7
	end
}
