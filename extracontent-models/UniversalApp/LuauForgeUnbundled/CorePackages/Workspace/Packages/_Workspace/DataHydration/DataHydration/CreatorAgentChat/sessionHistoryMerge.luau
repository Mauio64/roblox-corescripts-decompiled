require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/types")

local function getSequenceId(p2)
	local sequenceId = p2.sequenceId

	if typeof(sequenceId) == "number" and sequenceId >= 0 then
		return sequenceId
	end

	return nil
end

return {
	mergeHistoryIntoMap = function(p2, items, p3)
		for k, item in items do
			local sequenceId = item.sequenceId

			if typeof(sequenceId) ~= "number" or not (sequenceId >= 0) then
				sequenceId = nil
			end

			if sequenceId ~= nil and p3[sequenceId] == nil then
				p2[sequenceId] = item
			end
		end
	end,
	orderMergedHistoryItems = function(p2, items)
		local clone = table.clone(p2)

		for k, item in items do
			clone[k] = item
		end

		local result = {}

		for k, v5 in clone do
			table.insert(result, v5)
		end

		table.sort(result, function(a, b): boolean
			local sequenceId = a.sequenceId

			if typeof(sequenceId) ~= "number" or not (sequenceId >= 0) then
				sequenceId = nil
			end

			local sequenceId2 = b.sequenceId

			if typeof(sequenceId2) ~= "number" or not (sequenceId2 >= 0) then
				sequenceId2 = nil
			end

			return (sequenceId or -1) < (sequenceId2 or -1)
		end)

		return result
	end,
	ingestOverlayUpdate = function(clonesBySequenceId, p2, p3, sequenceId): boolean
		if typeof(sequenceId) ~= "number" or sequenceId < 0 then
			return false
		end

		local clone = table.clone(p3)
		clone.sequenceId = sequenceId
		clonesBySequenceId[sequenceId] = clone
		return true
	end
}
