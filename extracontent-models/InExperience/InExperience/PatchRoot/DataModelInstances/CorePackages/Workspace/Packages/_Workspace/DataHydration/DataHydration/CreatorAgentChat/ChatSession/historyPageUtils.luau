require(script.Parent.Parent.types)
local HistoryPageUtils = {}

function HistoryPageUtils.awaitRequestState(callback, p: number, callback2)
	while callback(false).status == "pending" do
		if p <= os.clock() or callback2 ~= nil and callback2() then
			return callback(false)
		end

		task.wait()
	end

	return callback(false)
end

function HistoryPageUtils.awaitRequestStateCancelled(callback, callback2)
	while callback(false).status == "pending" and not callback2() do
		task.wait()
	end

	return callback(false)
end

function HistoryPageUtils.getMaxHistorySequenceId(items)
	local maxHistorySequenceId = nil

	for _, item in items do
		local sequenceId = item.sequenceId

		if typeof(sequenceId) == "number" and (maxHistorySequenceId == nil or maxHistorySequenceId < sequenceId) then
			maxHistorySequenceId = sequenceId
		end
	end

	return maxHistorySequenceId
end

function HistoryPageUtils.getSessionLoadHistory(p)
	local history

	if p ~= nil then
		history = p.history
	end

	if typeof(history) == "table" then
		return history
	end

	return {}
end

function HistoryPageUtils.getNextHistoryPageToken(p)
	local nextHistoryPageToken

	if p ~= nil then
		nextHistoryPageToken = p.nextHistoryPageToken
	end

	if typeof(nextHistoryPageToken) == "string" and nextHistoryPageToken ~= "" then
		return nextHistoryPageToken
	end

	return nil
end

function HistoryPageUtils.collectSequenceIds(items)
	local sequenceIdSet = {}

	for _, item in items do
		local sequenceId = item.sequenceId

		if typeof(sequenceId) == "number" then
			sequenceIdSet[sequenceId] = true
		end
	end

	return sequenceIdSet
end

function HistoryPageUtils.historyOverlapsSequenceIds(items, p): boolean
	for _, item in items do
		local sequenceId = item.sequenceId

		if typeof(sequenceId) == "number" and p[sequenceId] then
			return true
		end
	end

	return false
end

function HistoryPageUtils.appendUniqueHistoryBySequenceId(list, items, p)
	local count = 0

	for _, item in items do
		local sequenceId = item.sequenceId

		if not (typeof(sequenceId) ~= "number" or not p[sequenceId]) then
			continue
		end

		if typeof(sequenceId) == "number" then
			p[sequenceId] = true
		end

		table.insert(list, item)
		count += 1
	end

	return count
end

function HistoryPageUtils.cloneHistoryBySequenceId(p)
	return table.clone(p)
end

function HistoryPageUtils.resolveNonNegativeNumber(value: number?, p: number)
	return if typeof(value) == "number" and value >= 0 then value else p
end

function HistoryPageUtils.resolvePositiveNumber(value: number?, p: number)
	return if typeof(value) == "number" and value > 0 then value else p
end

return HistoryPageUtils
