local __DEV__ = _G.__DEV__
local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local forEach = require(ParentParent.Array.forEach)
local map = require(ParentParent.Array.map)
local isArray = require(ParentParent.Array.isArray)
local InstanceOf = require(ParentParentParent.InstanceOf)

require(ParentParentParent.ES7Types)

local t1 = {}

function t1.new(p1) -- line: 39
	-- upvalues: isArray (copy), __DEV__ (copy), InstanceOf (copy), t1 (copy)
	local t2 = nil
	local t3 = nil

	if p1 == nil then
		t2 = {}
		t3 = {}
	elseif isArray(p1) then
		if __DEV__ and #p1 > 0 and typeof(p1[1]) ~= "table" then
			error("Value `" .. typeof(p1[1]) .. "` is not an entry object.\n " .. "Cannot create Map from {K, V} form, it must be { {K, V}... }")
		end

		t2 = table.create(#p1)
		t3 = {}

		for _, v13 in p1 do
			local v14 = v13[1]

			if __DEV__ and v14 == nil then
				error("cannot create Map from a table that isn't an array.")
			end

			local v15 = v13[2]

			if t3[v14] == nil then
				table.insert(t2, v14)
			end

			t3[v14] = v15
		end
	elseif InstanceOf(p1, t1) then
		t2 = table.clone(p1._array)
		t3 = table.clone(p1._map)
	else
		error(("`%s` `%s` is not iterable, cannot make Map using it"):format(typeof(p1), (tostring(p1))))
	end

	return (setmetatable({
		size = #t2,
		_map = t3,
		_array = t2
	}, t1))
end
function t1.set(p2, p3, p4) -- line: 88
	if p2._map[p3] == nil then
		p2.size = p2.size + 1
		table.insert(p2._array, p3)
	end

	p2._map[p3] = p4

	return p2
end
function t1.get(p5, p6) -- line: 100
	return p5._map[p6]
end
function t1.clear(p7) -- line: 104
	local _table = table

	p7.size = 0
	_table.clear(p7._map)
	_table.clear(p7._array)
end
function t1.delete(p8, p9) -- line: 111
	if p8._map[p9] == nil then
		return false
	end

	p8.size = p8.size - 1
	p8._map[p9] = nil

	local v25 = table.find(p8._array, p9)

	if v25 then
		table.remove(p8._array, v25)
	end

	return true
end
function t1.forEach(p10, p11, p12) -- line: 127
	-- upvalues: __DEV__ (copy), forEach (copy)
	if __DEV__ and typeof(p11) ~= "function" then
		error("callback is not a function")
	end

	forEach(p10._array, function(p13) -- line: 134
		-- upvalues: p10 (copy), p12 (copy), p11 (copy)
		local v43 = p10._map[p13]

		if p12 ~= nil then
			p11(p12, v43, p13, p10)

			return
		end

		p11(v43, p13, p10)
	end)
end
function t1.has(p14, p15) -- line: 145
	return p14._map[p15] ~= nil
end
function t1.keys(p16) -- line: 149
	return p16._array
end
function t1.values(p17) -- line: 153
	-- upvalues: map (copy)
	return map(p17._array, function(p18) -- line: 154
		-- upvalues: p17 (copy)
		return p17._map[p18]
	end)
end
function t1.entries(p19) -- line: 159
	-- upvalues: map (copy)
	return map(p19._array, function(p20) -- line: 160
		-- upvalues: p19 (copy)
		return {
			p20,
			p19._map[p20]
		}
	end)
end
function t1.ipairs(p21) -- line: 165
	-- upvalues: __DEV__ (copy)
	if __DEV__ then
		warn(debug.traceback("`for _,_ in myMap:ipairs() do` is deprecated and will be removed in a future release, please use `for _,_ in myMap do` instead\n", 2))
	end

	return ipairs(p21:entries())
end
function t1.__iter(p22) -- line: 177
	return next, p22:entries()
end
function t1.__index(p23, p24) -- line: 181
	-- upvalues: t1 (copy), __DEV__ (copy)
	local v38 = rawget(t1, p24)

	if v38 ~= nil then
		return v38
	end

	if __DEV__ then
		assert(rawget(p23, "_map"), "Map has been corrupted, and is missing private state! Did you accidentally call table.clear() instead of map:clear()?")
	end

	return t1.get(p23, p24)
end
function t1.__newindex(p25, p26, p27) -- line: 197
	p25:set(p26, p27)
end

return t1
