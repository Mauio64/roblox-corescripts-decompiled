require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/types")

return {
	awaitRequestState = function(callback, p2, callback2)
		while callback(false).status == "pending" do
			if p2 <= os.clock() or callback2 ~= nil and callback2() then
				return callback(false)
			end

			task.wait()
		end

		return callback(false)
	end,
	awaitRequestStateCancelled = function(callback, callback2)
		while callback(false).status == "pending" and not callback2() do
			task.wait()
		end

		return callback(false)
	end,
	getMaxHistorySequenceId = function(items)
		local maxHistorySequenceId = nil

		for k, item in items do
			local sequenceId = item.sequenceId

			if
				typeof(sequenceId) == "number"
				and (maxHistorySequenceId == nil or maxHistorySequenceId < sequenceId)
			then
				maxHistorySequenceId = sequenceId
			end
		end

		return maxHistorySequenceId
	end,
	getSessionLoadHistory = function(p2)
		local history = if p2 ~= nil then p2.history else nil

		if typeof(history) == "table" then
			return history
		end

		return {}
	end,
	getNextHistoryPageToken = function(p2)
		local nextHistoryPageToken = if p2 ~= nil then p2.nextHistoryPageToken else nil

		if typeof(nextHistoryPageToken) == "string" and nextHistoryPageToken ~= "" then
			return nextHistoryPageToken
		end

		return nil
	end,
	collectSequenceIds = function(items)
		local sequenceIdSet = {}

		for k, item in items do
			local sequenceId = item.sequenceId

			if typeof(sequenceId) == "number" then
				sequenceIdSet[sequenceId] = true
			end
		end

		return sequenceIdSet
	end,
	historyOverlapsSequenceIds = function(items, p2): boolean
		for k, item in items do
			local sequenceId = item.sequenceId

			if typeof(sequenceId) == "number" and p2[sequenceId] then
				return true
			end
		end

		return false
	end,
	appendUniqueHistoryBySequenceId = function(list, items, p2)
		local count = 0

		for k, item in items do
			local sequenceId = item.sequenceId

			if not (typeof(sequenceId) ~= "number" or not p2[sequenceId]) then
				continue
			end

			if typeof(sequenceId) == "number" then
				p2[sequenceId] = true
			end

			table.insert(list, item)
			count += 1
		end

		return count
	end,
	cloneHistoryBySequenceId = function(p2)
		return table.clone(p2)
	end,
	resolveNonNegativeNumber = function(value, p2)
		if typeof(value) == "number" and value >= 0 then
			return value
		end

		return p2
	end,
	resolvePositiveNumber = function(value, p2)
		if typeof(value) == "number" and value > 0 then
			return value
		end

		return p2
	end
}
