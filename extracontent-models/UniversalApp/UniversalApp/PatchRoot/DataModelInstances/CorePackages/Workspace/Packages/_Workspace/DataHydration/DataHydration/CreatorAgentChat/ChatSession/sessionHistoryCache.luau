require(script.Parent.Parent.types)

local historyPageUtils = require(script.Parent.historyPageUtils)
local constants = require(script.Parent.constants)

return {
	createSessionHistoryCache = function(n1: number?) -- line: 25
		-- upvalues: constants (copy), historyPageUtils (copy)
		local v4 = n1 or constants.getMaxCachedSessionHistories()
		local t1 = {}
		local t2 = {}

		local function removeFromOrder(s1: string) -- line: 30
			-- upvalues: t2 (copy)
			for v11, v12 in t2 do
				if v12 == s1 then
					table.remove(t2, v11)

					return
				end
			end
		end
		local function touch(s2: string) -- line: 39
			-- upvalues: removeFromOrder (copy), t2 (copy)
			removeFromOrder(s2)
			table.insert(t2, s2)
		end
		local function evictOldest() -- line: 44
			-- upvalues: t2 (copy), t1 (copy)
			local v14 = t2[1]

			if v14 == nil then
				return
			end

			table.remove(t2, 1)
			t1[v14] = nil
		end

		return {
			save = function(s3: string, t3: {[any]: any}) -- line: 53
				-- upvalues: t1 (copy), historyPageUtils (copy), removeFromOrder (copy), t2 (copy), v4 (copy)
				t1[s3] = {
					loadedBySequenceId = historyPageUtils.cloneHistoryBySequenceId(t3.loadedBySequenceId),
					overlayBySequenceId = historyPageUtils.cloneHistoryBySequenceId(t3.overlayBySequenceId),
					hasLoadedHistory = t3.hasLoadedHistory,
					nextHistoryPageToken = t3.nextHistoryPageToken,
					latestObservedHistorySequenceId = t3.latestObservedHistorySequenceId,
					pendingUserMessage = t3.pendingUserMessage
				}
				removeFromOrder(s3)
				table.insert(t2, s3)

				while #t2 > v4 do
					local v17 = t2[1]

					if v17 ~= nil then
						table.remove(t2, 1)
						t1[v17] = nil
					end
				end
			end,
			restore = function(s4: string) -- line: 68
				-- upvalues: t1 (copy), removeFromOrder (copy), t2 (copy), historyPageUtils (copy)
				local v19 = t1[s4]

				if v19 == nil then
					return nil
				end

				removeFromOrder(s4)
				table.insert(t2, s4)

				return {
					loadedBySequenceId = historyPageUtils.cloneHistoryBySequenceId(v19.loadedBySequenceId),
					overlayBySequenceId = historyPageUtils.cloneHistoryBySequenceId(v19.overlayBySequenceId),
					hasLoadedHistory = v19.hasLoadedHistory,
					nextHistoryPageToken = v19.nextHistoryPageToken,
					latestObservedHistorySequenceId = v19.latestObservedHistorySequenceId,
					pendingUserMessage = v19.pendingUserMessage
				}
			end
		}
	end
}
