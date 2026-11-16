require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/types")
local historyPageUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/ChatSession/historyPageUtils")

local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/ChatSession/constants")

return {
	createSessionHistoryCache = function(p2)
		local v5 = p2 or constants.getMaxCachedSessionHistories()
		local v6 = {}
		local v7 = {}

		local function removeFromOrder(p3)
			for k, v8 in v7 do
				if v8 == p3 then
					table.remove(v7, k)
					break
				end
			end
		end

		local function touch(p3)
			removeFromOrder(p3)
			table.insert(v7, p3)
		end

		local function evictOldest()
			local v8 = v7[1]

			if v8 == nil then
				return
			end

			table.remove(v7, 1)
			v6[v8] = nil
		end

		return {
			save = function(p3, data)
				v6[p3] = {
					loadedBySequenceId = historyPageUtils.cloneHistoryBySequenceId(data.loadedBySequenceId),
					overlayBySequenceId = historyPageUtils.cloneHistoryBySequenceId(data.overlayBySequenceId),
					hasLoadedHistory = data.hasLoadedHistory,
					nextHistoryPageToken = data.nextHistoryPageToken,
					latestObservedHistorySequenceId = data.latestObservedHistorySequenceId,
					pendingUserMessage = data.pendingUserMessage
				}
				removeFromOrder(p3)
				table.insert(v7, p3)

				while v5 < #v7 do
					local v9 = v7[1]

					if v9 == nil then
						continue
					end

					table.remove(v7, 1)
					v6[v9] = nil
				end
			end,
			restore = function(p3)
				local v8 = v6[p3]

				if v8 == nil then
					return nil
				end

				removeFromOrder(p3)
				table.insert(v7, p3)

				return {
					loadedBySequenceId = historyPageUtils.cloneHistoryBySequenceId(v8.loadedBySequenceId),
					overlayBySequenceId = historyPageUtils.cloneHistoryBySequenceId(v8.overlayBySequenceId),
					hasLoadedHistory = v8.hasLoadedHistory,
					nextHistoryPageToken = v8.nextHistoryPageToken,
					latestObservedHistorySequenceId = v8.latestObservedHistorySequenceId,
					pendingUserMessage = v8.pendingUserMessage
				}
			end
		}
	end
}
