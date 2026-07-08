local t1 = {}

t1.__index = t1

function t1.new(p1) -- line: 5
	-- upvalues: t1 (copy)
	assert(p1, "Cannot initialize CircularBuffer with nil")
	assert(p1 > 0, "Cannot initialize CircularBuffer to size < 1")

	local t2 = {}

	setmetatable(t2, t1)
	t2._data = {}
	t2._backIndex = 0
	t2._maxSize = p1

	return t2
end
function t1.reset(p2) -- line: 19
	p2._data = {}
	p2._backIndex = 0
end
function t1.getSize(p3) -- line: 24
	return #p3._data
end
function t1.getMaxSize(p4) -- line: 28
	return p4._maxSize
end
function t1.setSize(p5, p6) -- line: 32
	assert(p6, "Cannot set CircularBuffer with nil")
	assert(p6 > 0, "Cannot set CircularBuffer to size < 1")

	if p6 == p5._maxSize then
		return
	end

	local v9 = p5:iterator()
	local v10 = v9:next()
	local t3 = {}
	local n1 = 0

	while v10 and n1 < p6 do
		local v13 = n1 + 1

		t3[v13] = {
			entry = v10
		}

		if t3[n1] then
			t3[n1]._next = t3[v13]
		end

		n1 = v13
		v10 = v9:next()
	end

	p5._data = t3
	p5._backIndex = n1
	p5._maxSize = p6
end
function t1.getFrontIndex(p7) -- line: 63
	local v15 = p7._backIndex + 1

	if not p7._data[v15] then
		return 1
	end

	return v15
end
function t1.front(p8) -- line: 71
	local v17 = p8:getFrontIndex()

	if p8._data[v17] then
		return p8._data[v17].entry
	end

	return nil
end
function t1.back(p9) -- line: 79
	if p9._data[p9._backIndex] then
		return p9._data[p9._backIndex].entry
	end

	return nil
end
function t1.iterator(p10) -- line: 86
	return {
		data = p10._data[p10:getFrontIndex()],
		next = function(p11) -- line: 91
			local data = p11.data

			if data then
				p11.data = p11.data._next
			end

			return data and data.entry
		end
	}
end
function t1.getData(p12) -- line: 103
	return p12._data
end
function t1.at(p13, p14) -- line: 107
	assert(p14, "Cannot index CircularBuffer with nil")

	local v23 = (p13:getFrontIndex() + p14 - 2) % p13._maxSize + 1

	if p13._data[v23] then
		return p13._data[v23].entry
	end

	return nil
end
function t1.reverseAt(p15, p16) -- line: 118
	local v26 = (p15._backIndex - p16) % p15._maxSize + 1

	if p15._data[v26] then
		return p15._data[v26].entry
	end

	return nil
end
function t1.push_back(p17, p18) -- line: 129
	local _backIndex = p17._backIndex
	local v30 = p17._backIndex + 1

	if v30 > p17._maxSize then
		v30 = 1
	end

	local v31 = p17._data[v30]

	p17._data[v30] = {
		entry = p18
	}

	if _backIndex > 0 then
		p17._data[_backIndex]._next = p17._data[v30]

		if v31 then
			v31._next = nil
		end
	end

	p17._backIndex = v30

	return v31 and v31.entry
end

return t1
