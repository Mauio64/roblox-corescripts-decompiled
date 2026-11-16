require(script.Parent.AXPagesTypes)

return {
	new = function(currentPage, cursor: string?, fetchNextPage)
		return {
			_currentPage = currentPage,
			_cursor = cursor,
			_fetchNextPage = fetchNextPage,
			IsFinished = cursor == nil or cursor == "",
			GetCurrentPage = function(p)
				return p._currentPage
			end,
			AdvanceToNextPageAsync = function(state)
				if state.IsFinished then
					return
				end

				local nextPage = state._fetchNextPage(state._cursor)
				state._currentPage = nextPage.data
				state._cursor = nextPage.nextPageCursor
				state.IsFinished = state._cursor == nil or state._cursor == ""
			end
		}
	end
}
