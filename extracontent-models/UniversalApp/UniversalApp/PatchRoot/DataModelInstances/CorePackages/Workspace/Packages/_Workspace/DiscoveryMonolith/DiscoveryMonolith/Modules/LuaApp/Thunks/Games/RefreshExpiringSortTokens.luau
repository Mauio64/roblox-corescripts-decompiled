local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local Promise = require(DiscoveryMonolithParent.Promise)
local RetrievalStatus = require(DiscoveryMonolithParent.Http).Enum.RetrievalStatus
local FetchStatusRodux = require(DiscoveryMonolithParent.FetchStatusRodux)
local FetchStatusReducer = FetchStatusRodux.FetchStatusReducer
local FetchStatusNamespace = FetchStatusRodux.FetchStatusNamespace
local NextDataExpirationTimeRodux = require(DiscoveryMonolithParent.NextDataExpirationTimeRodux)
local NextDataExpirationTimeReducer = NextDataExpirationTimeRodux.NextDataExpirationTimeReducer
local ExpirationTimeNamespace = NextDataExpirationTimeRodux.ExpirationTimeNamespace
local Modules = DiscoveryMonolith.Modules
local ApiFetchSortTokens = require(Modules.LuaApp.Thunks.Games.ApiFetchSortTokens)
local FFlagLuaAppFixGamesListSortTokenExpiringTime = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppFixGamesListSortTokenExpiringTime
local v14 = not FFlagLuaAppFixGamesListSortTokenExpiringTime and 600 or nil

local function shouldRefreshSortGroup(p1, p2, p3) -- line: 25
	-- upvalues: FFlagLuaAppFixGamesListSortTokenExpiringTime (copy), RetrievalStatus (copy), v14 (copy)
	if FFlagLuaAppFixGamesListSortTokenExpiringTime then
		return p1 ~= RetrievalStatus.Fetching and p2 <= p3
	end

	return p1 ~= RetrievalStatus.Fetching and p3 >= p2 - v14
end

return function(p4, p5) -- line: 36
	-- upvalues: FetchStatusReducer (copy), FetchStatusNamespace (copy), NextDataExpirationTimeReducer (copy), ExpirationTimeNamespace (copy), FFlagLuaAppFixGamesListSortTokenExpiringTime (copy), RetrievalStatus (copy), v14 (copy), ApiFetchSortTokens (copy), Promise (copy)
	return function(p6) -- line: 37
		-- upvalues: p5 (copy), FetchStatusReducer (copy), FetchStatusNamespace (copy), NextDataExpirationTimeReducer (copy), ExpirationTimeNamespace (copy), FFlagLuaAppFixGamesListSortTokenExpiringTime (copy), RetrievalStatus (copy), v14 (copy), ApiFetchSortTokens (copy), p4 (copy), Promise (copy)
		local t1 = {}
		local timestamp = tick()
		local v24 = p6:getState()

		for _, v in ipairs(p5) do
			local v27 = v24.Personalization[FetchStatusReducer.key][FetchStatusNamespace.GameSortToken][v]
			local v28 = nil
			local v29 = v24.Personalization[NextDataExpirationTimeReducer.key][ExpirationTimeNamespace.GameSortGroup]

			if v29 then
				v28 = v29[v]
			end

			local v30 = v28 or 0

			if if not FFlagLuaAppFixGamesListSortTokenExpiringTime then v27 ~= RetrievalStatus.Fetching and timestamp >= v30 - v14 else v27 ~= RetrievalStatus.Fetching and v30 <= timestamp then
				table.insert(t1, p6:dispatch(ApiFetchSortTokens(p4, v, nil)))
			end
		end

		return Promise.all(t1)
	end
end
