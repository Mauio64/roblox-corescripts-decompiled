local HttpService = game:GetService("HttpService")
local CorePackages = game:GetService("CorePackages")

local searchGetOmniSearch = require("@luauforge/bundled/dtb").Modules.LuaApp.Http.Requests.SearchGetOmniSearch

local enumerate = require(CorePackages.Packages.enumerate)
local module = require("@luauforge/bundled/egs")
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch

local module2 = require("@luauforge/deferred/ehN")

local v5 = enumerate("UsersError", {
	Unknown = 0,
	TooManyIds = 1,
	TooManyUsernames = 2,
	InvalidUserId = 3,
	TooManyRequests = 4,
	KeywordFiltered = 5,
	KeywordTooShort = 6
})

local function getFetchName(p2)
	return "luaapp.users.playersearch." .. p2
end

return {
	Fetch = function(p2, data)
		local keyword = data.keyword
		return performFetch.Single("luaapp.users.playersearch." .. keyword, function(object)
			local usersSearchResult = object:getState().UsersSearchResults[keyword]
			local nextPageCursor = usersSearchResult and usersSearchResult.nextPageCursor or nil

			if nextPageCursor == "EndOfPlayerSearch" then
				return module.resolve("Data has been already fetched")
			end

			return searchGetOmniSearch(p2, {
				searchQuery = keyword,
				pageToken = nextPageCursor,
				sessionId = data.searchUuid,
				globalSessionId = data.omniSearchUuid,
				verticalType = "user"
			}):andThen(function(p3)
				return object:dispatch(module2(
					p2,
					{
						searchKeyword = keyword,
						searchUuid = data.searchUuid,
						curPageCursor = nextPageCursor
					},
					p3
				))
			end, function(p3)
				if p3.Body then
					local err = HttpService:JSONDecode(p3.Body).errors[1]

					if v5.fromRawValue(err.code) == v5.KeywordFiltered then
						return module.resolve()
					end
				end

				return module.reject(p3)
			end)
		end)
	end,
	GetFetchingStatus = function(p2, p3)
		return performFetch.GetStatus(p2, "luaapp.users.playersearch." .. p3)
	end
}
