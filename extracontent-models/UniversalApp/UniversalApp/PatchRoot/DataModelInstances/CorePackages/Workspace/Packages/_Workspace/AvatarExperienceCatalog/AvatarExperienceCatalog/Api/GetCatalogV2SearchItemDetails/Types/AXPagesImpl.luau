require(script.Parent.AXPagesTypes)

return {
	new = function(p1, s1: string?, p2: ((...any) -> ...any)) -- line: 5
		return {
			_currentPage = p1,
			_cursor = s1,
			_fetchNextPage = p2,
			IsFinished = s1 == nil or s1 == "",
			GetCurrentPage = function(p3) -- line: 12
				return p3._currentPage
			end,
			AdvanceToNextPageAsync = function(p4) -- line: 16
				if p4.IsFinished then
					return
				end

				local v6 = p4._fetchNextPage(p4._cursor)

				p4._currentPage = v6.data
				p4._cursor = v6.nextPageCursor
				p4.IsFinished = p4._cursor == nil or p4._cursor == ""
			end
		}
	end
}
