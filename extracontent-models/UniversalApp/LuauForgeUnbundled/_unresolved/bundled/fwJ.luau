local appPage = require("@luauforge/bundled/fwA").AppPage
local v5 = {
	PageSize = 24,
	["ApiBaseUrl"] = require("@luauforge/bundled/fwK").Url.APIS_URL .. "user-library",
	Pages = {
		library = {
			surfaceKey = appPage.UserLibrary,
			path = "/v1/library-page",
			getOverviewConfigKey = function(p2): string
				return "UserLibrary"
			end,
			getLibraryCollectionId = function(p2): nil
				return nil
			end
		},
		collection = {
			surfaceKey = appPage.UserLibraryCollection,
			path = "/v1/collection-page",
			getOverviewConfigKey = function(p2)
				return `UserLibraryCollection/{p2.libraryCollectionId}`
			end,
			getLibraryCollectionId = function(p2)
				return p2.libraryCollectionId
			end
		}
	},
	OverviewEntry = { Header = "header", Pills = "pills", Content = "content" },
	ViewScopeField = "libraryCategory"
}

function v5.getPage(p2)
	return v5.Pages[p2.kind]
end

function v5.getConfigKey(p2, p3, value)
	local overviewConfigKey = p2.getOverviewConfigKey(p3)

	if value == "VIEW_ALL" then
		return overviewConfigKey
	end

	return `{overviewConfigKey}/{string.lower((string.sub(value, 6)))}`
end

return v5
