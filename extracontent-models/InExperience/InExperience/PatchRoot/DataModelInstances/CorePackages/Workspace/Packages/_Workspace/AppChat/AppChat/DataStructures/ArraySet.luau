local t1 = {}

function t1.__index(p1, p2) -- line: 55
	-- upvalues: t1 (copy)
	if type(p2) == "number" then
		return p1:at(p2)
	end

	return t1[p2]
end
function t1.__len(p3) -- line: 63
	return p3:size()
end
function t1.__newindex(p4, p5, p6) -- line: 67
	p4._indexToValue[p5] = p6
end
function t1.__iter(p7) -- line: 71
	local n1 = 0

	return function() -- line: 73
		-- upvalues: n1 (ref), p7 (copy)
		n1 += 1

		if n1 <= p7._size then
			return p7._indexToValue[n1]
		end

		return nil
	end
end
function t1.add(p8, p9) -- line: 83
	if p8._valueToIndex[p9] then
		return false
	end

	local v12 = p8._size + 1

	p8._valueToIndex[p9] = v12
	p8._indexToValue[v12] = p9
	p8._size = v12

	return true
end
function t1.prependAll(t2: {[any]: any}, t3: {[any]: any}) -- line: 101
	local t4 = {}
	local t5 = {}

	for _, v18 in t3 do
		if not t2._valueToIndex[v18] and not t5[v18] then
			t5[v18] = true
			table.insert(t4, v18)
		end
	end

	if #t4 == 0 then
		return false
	end

	local v19 = #t4

	for i = t2._size, 1, -1 do
		local v21 = t2._indexToValue[i]

		t2._indexToValue[i + v19] = v21
		t2._valueToIndex[v21] = i + v19
	end

	for v22, v23 in t4 do
		t2._indexToValue[v22] = v23
		t2._valueToIndex[v23] = v22
	end

	t2._size = t2._size + v19

	return true
end
function t1.remove(p10, p11) -- line: 136
	if not p10._valueToIndex[p11] then
		return false
	end

	local v26 = p10._valueToIndex[p11]

	p10._valueToIndex[p11] = nil

	for i = v26 + 1, p10._size do
		local v28 = p10._indexToValue[i]

		p10._indexToValue[i - 1] = v28
		p10._valueToIndex[v28] = i - 1
	end

	p10._indexToValue[p10._size] = nil
	p10._size = p10._size - 1

	return true
end
function t1.has(p12, p13) -- line: 159
	return p12._valueToIndex[p13] ~= nil
end
function t1.clear(p14) -- line: 163
	p14._valueToIndex = {}
	p14._indexToValue = {}
	p14._size = 0
end
function t1.size(p15) -- line: 169
	return p15._size
end
function t1.at(t6: {[any]: any}, n2: number) -- line: 174
	if n2 < 1 or n2 > t6._size then
		return nil
	end

	return t6._indexToValue[n2]
end
function t1.indexOf(p16, p17) -- line: 183
	return p16._valueToIndex[p17]
end
function t1.toArray(p18) -- line: 188
	return table.clone(p18._indexToValue)
end
function t1.values(p19) -- line: 194
	return p19._indexToValue
end
function t1.clone(p20) -- line: 199
	-- upvalues: t1 (copy)
	return t1.new(p20._indexToValue)
end
function t1.new(t7: {[any]: any}?) -- line: 203
	-- upvalues: t1 (copy)
	local v41 = setmetatable({
		_size = 0,
		_valueToIndex = {},
		_indexToValue = {}
	}, t1)

	if t7 then
		for _, v43 in t7 do
			v41:add(v43)
		end
	end

	return v41
end

return t1
