require(script.Parent.types)

local function getSequenceId(p) -- 3 equivalent calls inferred from this helper
	local sequenceId = p.sequenceId

	if typeof(sequenceId) == "number" and sequenceId >= 0 then
		return sequenceId
	end

	return nil
end

local SessionHistoryMerge = {}

function SessionHistoryMerge.mergeHistoryIntoMap(p, items, p2)
	for _, item in items do
		local sequenceId = getSequenceId(item) -- inferred equivalent call

		if sequenceId ~= nil and p2[sequenceId] == nil then
			p[sequenceId] = item
		end
	end
end

function SessionHistoryMerge.orderMergedHistoryItems(p, items)
	local clone = table.clone(p)

	for k, item in items do
		clone[k] = item
	end

	local result = {}

	for _, v in clone do
		table.insert(result, v)
	end

	table.sort(result, function(a, b): boolean
		return (getSequenceId(a) or -1) < (getSequenceId(b) or -1) -- inferred equivalent call
	end)

	return result
end

function SessionHistoryMerge.ingestOverlayUpdate(clonesBySequenceId, _, p, sequenceId: number): boolean
	if typeof(sequenceId) ~= "number" or sequenceId < 0 then
		return false
	end

	local clone = table.clone(p)
	clone.sequenceId = sequenceId
	clonesBySequenceId[sequenceId] = clone
	return true
end

return SessionHistoryMerge
