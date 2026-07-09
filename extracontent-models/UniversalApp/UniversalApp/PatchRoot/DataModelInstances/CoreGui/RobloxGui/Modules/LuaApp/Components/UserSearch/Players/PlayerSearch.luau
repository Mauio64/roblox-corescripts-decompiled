local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(Modules.Common.Roact)
local RoactRodux = require(Modules.Common.RoactRodux)
local Constants = require(Modules.LuaApp.Constants)
local getAutoFetchingStatus = require(Modules.LuaApp.Thunks.Search.getAutoFetchingStatus)
local FetchDataWithErrorToasts = require(Modules.LuaApp.Thunks.FetchDataWithErrorToasts)
local RetrievalStatus = require(CorePackages.Workspace.Packages.Http).Enum.RetrievalStatus
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local Dash = require(CorePackages.Packages.Dash)
local RemoveTextSearchResults = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules.LuaApp.Actions.RemoveTextSearchResults
local DiscoveryTypes = require(CorePackages.Workspace.Packages.DiscoveryTypes)
local UserSearchResultsPageLayerExposure = require(script.Parent.UserSearchResultsPageLayerExposure)
local PlayerSearchPage = require(script.Parent.PlayerSearchPage)
local ApiFetchPlayerSearch = require(script.Parent.Parent.Thunks.ApiFetchPlayerSearch)
local RemoveUsersSearchResults = require(script.Parent.Parent.Actions.RemoveUsersSearchResults)

return RoactRodux.connect(function(p1, p2) -- line: 37
	-- upvalues: Constants (copy), DiscoveryTypes (copy), RetrievalStatus (copy), ApiFetchPlayerSearch (copy), getAutoFetchingStatus (copy), FormFactor (copy)
	local v21 = p2.searchParameters.searchKeyword or ""
	local v22 = not (utf8.len(v21) >= Constants.PLAYER_SEARCH_MIN_KEYWORD_UTF8_LEN)
	local text = nil
	local v24 = p1.TextSearchResults[p2.searchUuid] and p1.TextSearchResults[p2.searchUuid][DiscoveryTypes.SearchTextTopicIds.HotlineSearchText]

	if v24 then
		text = v24.text
	end

	return {
		screenSize = p1.ScreenSize,
		usersSearchResult = p1.UsersSearchResults[v21],
		searchWordLengthNotSupported = v22,
		playerSearchStatus = v22 and RetrievalStatus.Done or ApiFetchPlayerSearch.GetFetchingStatus(p1, v21),
		autoTabSearchStatus = v22 and RetrievalStatus.Done or getAutoFetchingStatus(p1, v21),
		wideMode = p1.FormFactor == FormFactor.WIDE,
		hotlineSearchText = text
	}
end, function(p3) -- line: 59
	-- upvalues: FetchDataWithErrorToasts (copy), ApiFetchPlayerSearch (copy), RemoveUsersSearchResults (copy), RemoveTextSearchResults (copy)
	return {
		fetchPlayerSearch = function(p4, ...) -- line: 61
			-- upvalues: p3 (copy), FetchDataWithErrorToasts (copy), ApiFetchPlayerSearch (copy)
			return p3(FetchDataWithErrorToasts(ApiFetchPlayerSearch.Fetch(p4, ...)))
		end,
		removeUserSearchResults = function(p5) -- line: 64
			-- upvalues: p3 (copy), RemoveUsersSearchResults (copy)
			return p3(RemoveUsersSearchResults(p5))
		end,
		removeTextSearchResults = function(p6) -- line: 67
			-- upvalues: p3 (copy), RemoveTextSearchResults (copy)
			return p3(RemoveTextSearchResults(p6))
		end
	}
end)(function(p7) -- line: 29
	-- upvalues: Roact (copy), UserSearchResultsPageLayerExposure (copy), PlayerSearchPage (copy), Dash (copy)
	return Roact.createElement(UserSearchResultsPageLayerExposure, {
		renderChild = function(p8) -- line: 31
			-- upvalues: Roact (copy), PlayerSearchPage (copy), Dash (copy), p7 (copy)
			return Roact.createElement(PlayerSearchPage, Dash.join(p8 or {}, p7 or {}))
		end
	})
end)
