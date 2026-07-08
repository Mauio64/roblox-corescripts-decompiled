require(script.Parent.types)

local function getSequenceId(p1) -- line: 8
	local sequenceId = p1.sequenceId

	if typeof(sequenceId) == "number" and sequenceId >= 0 then
		return sequenceId
	end

	return nil
end

return {
	mergeHistoryIntoMap = function(t1: {[any]: any}, t2: {[any]: any}, t3: {[any]: any}) -- line: 13
		for _, v8 in t2 do
			local sequenceId = v8.sequenceId
			local v10 = if typeof(sequenceId) ~= "number" or not (sequenceId >= 0) then nil else sequenceId

			if v10 ~= nil and t3[v10] == nil then
				t1[v10] = v8
			end
		end
	end,
	orderMergedHistoryItems = function(t4: {[any]: any}, t5: {[any]: any}) -- line: 26
		local v13 = table.clone(t4)

		for v14, v15 in t5 do
			v13[v14] = v15
		end

		local t6 = {}

		for _, v18 in v13 do
			table.insert(t6, v18)
		end

		table.sort(t6, function(p2, p3) -- line: 40
			local sequenceId = p2.sequenceId
			local v27 = ((if typeof(sequenceId) ~= "number" or not (sequenceId >= 0) then nil else sequenceId)) or -1
			local sequenceId2 = p3.sequenceId

			return v27 < (((if typeof(sequenceId2) ~= "number" or not (sequenceId2 >= 0) then nil else sequenceId2)) or -1)
		end)

		return t6
	end,
	ingestOverlayUpdate = function(t7: {[any]: any}, _: {[any]: any}, p4, n1: number) -- line: 49
		if typeof(n1) ~= "number" or n1 < 0 then
			return false
		end

		local v23 = table.clone(p4)

		v23.sequenceId = n1
		t7[n1] = v23

		return true
	end
}
