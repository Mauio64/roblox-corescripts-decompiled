require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/DataHydration")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")

local v5 = {}

local function createMessageReactionsStore()
	local dataCache = DataHydration.createDataCache()

	return {
		getMessageReactions = function(p2, p3)
			return dataCache.getItem(p2).data(p3)
		end,
		ingestMessageReactions = function(items)
			local v6 = {}

			for k, item in items do
				local id = item.id
				local data = dataCache.getItem(id).data(false)

				local id2 = item.id
				local v7 = {
					reactions = item.reactions or v5,
					pending = 0
				}
				local v8 = if data then data.pending else nil
				v7.pending = v8
				v6[id2] = v7
			end

			dataCache.replaceItems(v6)
		end,
		evictMessageReactions = function(items)
			for k, item in items do
				if dataCache.getItem(item).data(false) == nil then
					continue
				end

				dataCache.replaceItem(item, nil)
			end
		end,
		clear = dataCache.clear,
		dispose = dataCache.dispose
	}
end

return createMessageReactionsStore
