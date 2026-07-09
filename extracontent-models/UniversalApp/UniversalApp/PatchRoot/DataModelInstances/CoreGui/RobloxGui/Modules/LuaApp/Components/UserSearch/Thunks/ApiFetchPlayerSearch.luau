local HttpService = game:GetService("HttpService")
local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local SearchGetOmniSearch = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules.LuaApp.Http.Requests.SearchGetOmniSearch
local enumerate = require(CorePackages.Packages.enumerate)
local Promise = require(Modules.LuaApp.Promise)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local HandleUserSearchResults = require(script.Parent.Parent.Thunks.HandleUserSearchResults)
local v9 = enumerate("UsersError", {
	Unknown = 0,
	TooManyIds = 1,
	TooManyUsernames = 2,
	InvalidUserId = 3,
	TooManyRequests = 4,
	KeywordFiltered = 5,
	KeywordTooShort = 6
})

local function getFetchName(p1) -- line: 28
	return "luaapp.users.playersearch." .. p1
end

return {
	Fetch = function(p2, t1: {[any]: any}) -- line: 40
		-- upvalues: PerformFetch (copy), Promise (copy), SearchGetOmniSearch (copy), HandleUserSearchResults (copy), HttpService (copy), v9 (copy)
		local keyword = t1.keyword

		return PerformFetch.Single("luaapp.users.playersearch." .. keyword, function(p3) -- line: 43
			-- upvalues: keyword (copy), Promise (copy), SearchGetOmniSearch (copy), p2 (copy), t1 (copy), HandleUserSearchResults (copy), HttpService (copy), v9 (copy)
			local v18 = p3:getState().UsersSearchResults[keyword]
			local v19 = v18 and v18.nextPageCursor or nil

			if v19 == "EndOfPlayerSearch" then
				return Promise.resolve("Data has been already fetched")
			end

			return SearchGetOmniSearch(p2, {
				verticalType = "user",
				searchQuery = keyword,
				pageToken = v19,
				sessionId = t1.searchUuid,
				globalSessionId = t1.omniSearchUuid
			}):andThen(function(p4) -- line: 59
				-- upvalues: keyword (copy), t1 (copy), v19 (copy), p3 (copy), HandleUserSearchResults (copy), p2 (copy)
				local t2 = {
					searchKeyword = keyword,
					searchUuid = t1.searchUuid,
					curPageCursor = v19
				}

				return p3:dispatch(HandleUserSearchResults(p2, t2, p4))
			end, function(p5) -- line: 66
				-- upvalues: HttpService (copy), v9 (copy), Promise (copy)
				if p5.Body then
					local v23 = HttpService:JSONDecode(p5.Body).errors[1]

					if v9.fromRawValue(v23.code) == v9.KeywordFiltered then
						return Promise.resolve()
					end
				end

				return Promise.reject(p5)
			end)
		end)
	end,
	GetFetchingStatus = function(p6, p7) -- line: 80
		-- upvalues: PerformFetch (copy)
		return PerformFetch.GetStatus(p6, "luaapp.users.playersearch." .. p7)
	end
}
