local module = require("@luauforge/deferred/ekg")
local module2 = require("@luauforge/deferred/ekh")
local module3 = require("@luauforge/deferred/eko")

local module4 = require("@luauforge/deferred/ekH")

local fFlagFriendsActivityFeedFetchItemNames = require("@luauforge/deferred/ekI").FFlagFriendsActivityFeedFetchItemNames

local useSignalState = module2.useSignalState
local computed = module.createComputed(function(): nil
	return nil
end)

local function useItemName(p2)
	local v5 = if not (p2 == nil or p2 == 0) then tostring(p2) else nil

	if fFlagFriendsActivityFeedFetchItemNames then
		local v6 = useSignalState(function(p3)
			local cache = module3.ItemDetailsStore.getCache(p3)

			if v5 == nil then
				return nil
			end

			return cache[v5]
		end)

		if v6 == nil then
			return nil
		end

		return v6.name
	else
		local v6 = module4(false)
		local v7 = if v5 == nil then computed else v6.getMarketplaceAssetInfo(v5).data

		local v8 = useSignalState(v7)

		if v8 == nil then
			return nil
		end

		return v8.name
	end
end

return useItemName
