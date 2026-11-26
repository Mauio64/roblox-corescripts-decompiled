require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Api/GetCatalogV2SearchItemDetails/Types/AXPagesTypes")

return {
	new = function(p2, p3, p4)
		return {
			_currentPage = p2,
			_cursor = p3,
			_fetchNextPage = p4,
			IsFinished = p3 == nil or p3 == "",
			GetCurrentPage = function(self)
				return self._currentPage
			end,
			AdvanceToNextPageAsync = function(self)
				if self.IsFinished then
					return
				end

				local nextPage = self._fetchNextPage(self._cursor)
				self._currentPage = nextPage.data
				self._cursor = nextPage.nextPageCursor
				self.IsFinished = self._cursor == nil or self._cursor == ""
			end
		}
	end
}
