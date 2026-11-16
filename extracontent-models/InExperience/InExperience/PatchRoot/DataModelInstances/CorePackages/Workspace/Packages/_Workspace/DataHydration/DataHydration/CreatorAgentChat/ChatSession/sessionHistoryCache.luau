require(script.Parent.Parent.types)
local historyPageUtils = require(script.Parent.historyPageUtils)

local constants = require(script.Parent.constants)

return {
	createSessionHistoryCache = function(p: number?)
		local v = p or constants.getMaxCachedSessionHistories()
		local v2 = {}
		local v3 = {}

		local function removeFromOrder(p2: string)
			for k, v4 in v3 do
				if v4 == p2 then
					table.remove(v3, k)
					break
				end
			end
		end

		local function touch(p2: string) -- 2 equivalent calls inferred from this helper
			removeFromOrder(p2)
			table.insert(v3, p2)
		end

		local function evictOldest() -- 1 equivalent call inferred from this helper
			local v4 = v3[1]

			if v4 == nil then
				return
			end

			table.remove(v3, 1)
			v2[v4] = nil
		end

		return {
			save = function(p2: string, data)
				v2[p2] = {
					loadedBySequenceId = historyPageUtils.cloneHistoryBySequenceId(data.loadedBySequenceId),
					overlayBySequenceId = historyPageUtils.cloneHistoryBySequenceId(data.overlayBySequenceId),
					hasLoadedHistory = data.hasLoadedHistory,
					nextHistoryPageToken = data.nextHistoryPageToken,
					latestObservedHistorySequenceId = data.latestObservedHistorySequenceId,
					pendingUserMessage = data.pendingUserMessage
				}
				touch(p2) -- inferred equivalent call

				while v < #v3 do
					evictOldest() -- inferred equivalent call
				end
			end,
			restore = function(p2: string)
				local v4 = v2[p2]

				if v4 == nil then
					return nil
				end

				touch(p2) -- inferred equivalent call
				return {
					loadedBySequenceId = historyPageUtils.cloneHistoryBySequenceId(v4.loadedBySequenceId),
					overlayBySequenceId = historyPageUtils.cloneHistoryBySequenceId(v4.overlayBySequenceId),
					hasLoadedHistory = v4.hasLoadedHistory,
					nextHistoryPageToken = v4.nextHistoryPageToken,
					latestObservedHistorySequenceId = v4.latestObservedHistorySequenceId,
					pendingUserMessage = v4.pendingUserMessage
				}
			end
		}
	end
}
