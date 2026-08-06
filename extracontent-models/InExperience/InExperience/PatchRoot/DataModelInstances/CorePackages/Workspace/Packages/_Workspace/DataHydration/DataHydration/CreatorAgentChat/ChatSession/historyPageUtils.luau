require(script.Parent.Parent.types)

return {
	awaitRequestState = function(p1, n1: number) -- line: 10
		while p1(false).status == "pending" do
			if n1 <= os.clock() then
				return p1(false)
			end

			task.wait()
		end

		return p1(false)
	end,
	awaitRequestStateCancelled = function(p2, p3: ((...any) -> ...any)) -- line: 20
		while p2(false).status == "pending" and not p3() do
			task.wait()
		end

		return p2(false)
	end,
	getMaxHistorySequenceId = function(t1: {[any]: any}) -- line: 30
		local v6 = nil

		for _, v8 in t1 do
			local sequenceId = v8.sequenceId

			if typeof(sequenceId) == "number" and (v6 == nil or v6 < sequenceId) then
				v6 = sequenceId
			end
		end

		return v6
	end,
	getSessionLoadHistory = function(p4) -- line: 41
		local v11 = if p4 == nil then nil else p4.history

		if typeof(v11) == "table" then
			return v11
		end

		return {}
	end,
	getNextHistoryPageToken = function(p5) -- line: 46
		local v13 = if p5 == nil then nil else p5.nextHistoryPageToken

		if typeof(v13) == "string" and v13 ~= "" then
			return v13
		end

		return nil
	end,
	collectSequenceIds = function(t2: {[any]: any}) -- line: 51
		local t3 = {}

		for _, v17 in t2 do
			local sequenceId = v17.sequenceId

			if typeof(sequenceId) == "number" then
				t3[sequenceId] = true
			end
		end

		return t3
	end,
	historyOverlapsSequenceIds = function(t4: {[any]: any}, t5: {[any]: any}) -- line: 62
		for _, v22 in t4 do
			local sequenceId = v22.sequenceId

			if typeof(sequenceId) == "number" and t5[sequenceId] then
				return true
			end
		end

		return false
	end,
	appendUniqueHistoryBySequenceId = function(t6: {[any]: any}, t7: {[any]: any}, t8: {[any]: any}) -- line: 72
		local n2 = 0

		for _, v29 in t7 do
			local sequenceId = v29.sequenceId

			if typeof(sequenceId) ~= "number" or not t8[sequenceId] then
				if typeof(sequenceId) == "number" then
					t8[sequenceId] = true
				end

				table.insert(t6, v29)
				n2 += 1
			end
		end

		return n2
	end,
	cloneHistoryBySequenceId = function(t9: {[any]: any}) -- line: 91
		return table.clone(t9)
	end,
	resolveNonNegativeNumber = function(n3: number?, n4: number) -- line: 95
		if typeof(n3) == "number" and n3 >= 0 then
			return n3
		end

		return n4
	end,
	resolvePositiveNumber = function(n5: number?, n6: number) -- line: 102
		if typeof(n5) == "number" and n5 > 0 then
			return n5
		end

		return n6
	end
}
