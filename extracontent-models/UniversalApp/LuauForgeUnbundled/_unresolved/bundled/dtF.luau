local module = require("@luauforge/bundled/dqe")
local retrievalStatus = require("@luauforge/bundled/drq").Enum.RetrievalStatus
local module2 = require("@luauforge/bundled/drs")
local fetchStatusReducer = module2.FetchStatusReducer
local fetchStatusNamespace = module2.FetchStatusNamespace
local module3 = require("@luauforge/bundled/dsB")
local nextDataExpirationTimeReducer = module3.NextDataExpirationTimeReducer
local expirationTimeNamespace = module3.ExpirationTimeNamespace

local module4 = require("@luauforge/bundled/dsC")

local fFlagLuaAppFixGamesListSortTokenExpiringTime = require("@luauforge/bundled/dqB").FFlagLuaAppFixGamesListSortTokenExpiringTime
local v5 = not fFlagLuaAppFixGamesListSortTokenExpiringTime and 600 or nil

local function shouldRefreshSortGroup(p2, p3, p4): boolean
	if fFlagLuaAppFixGamesListSortTokenExpiringTime then
		return p2 ~= retrievalStatus.Fetching and p3 <= p4
	end

	return p2 ~= retrievalStatus.Fetching and p3 - v5 <= p4
end

return function(p2, list)
	return function(object)
		local now = tick()
		local state = object:getState()
		local v6 = {}

		for i, item in ipairs(list) do
			local v7 = state.Personalization[fetchStatusReducer.key][fetchStatusNamespace.GameSortToken][item]

			local v8 = state.Personalization[nextDataExpirationTimeReducer.key][expirationTimeNamespace.GameSortGroup]

			local v10 = (if v8 then v8[item] else nil) or 0
			local v11

			if fFlagLuaAppFixGamesListSortTokenExpiringTime then
				v11 = not (v7 == retrievalStatus.Fetching) and v10 <= now
			else
				v11 = not (v7 == retrievalStatus.Fetching) and v10 - v5 <= now
			end

			if v11 then
				table.insert(v6, object:dispatch(module4(p2, item, nil)))
			end
		end

		return module.all(v6)
	end
end
