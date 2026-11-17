local parent = script:FindFirstAncestor("AppChat").Parent

require(parent.AppChatNetworking)
local DataHydration = require(parent.DataHydration)
require(parent.Signals)

local v = {}

local function createMessageReactionsStore()
	local dataCache = DataHydration.createDataCache()

	local function getMessageReactions(p: string, p2) -- 2 equivalent calls inferred from this helper
		return dataCache.getItem(p).data(p2)
	end

	return {
		getMessageReactions = getMessageReactions,
		ingestMessageReactions = function(items)
			local v2 = {}

			for _, item in items do
				local messageReactions = getMessageReactions(item.id, false) -- inferred equivalent call
				local id = item.id
				local v3 = {
					reactions = item.reactions or v,
					pending = 0
				}
				local pending

				if messageReactions then
					pending = messageReactions.pending
				end

				v3.pending = pending
				v2[id] = v3
			end

			dataCache.replaceItems(v2)
		end,
		evictMessageReactions = function(items)
			for _, item in items do
				if getMessageReactions(item, false) ~= nil then -- inferred equivalent call
					dataCache.replaceItem(item, nil)
				end
			end
		end,
		clear = dataCache.clear,
		dispose = dataCache.dispose
	}
end

return createMessageReactionsStore
