local __DEV__ = _G.__DEV__
local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local inspect = require(scriptParent.inspect)
local isArray = require(scriptParent.Array.isArray)
local forEach = require(scriptParent.Array.forEach)
local fromString = require(scriptParent.Array.from.fromString)

require(scriptParentParent.ES7Types)

local t1 = {
	__iter = function(p1) -- line: 39
		return next, p1._array
	end,
	__tostring = function(p2) -- line: 42
		-- upvalues: inspect (copy)
		local s1 = "Set "

		if #p2._array > 0 then
			s1 ..= "(" .. tostring(#p2._array) .. ") "
		end

		return s1 .. inspect(p2._array)
	end
}

t1.__index = t1

function t1.new(p3) -- line: 54
	-- upvalues: isArray (copy), __DEV__ (copy), fromString (copy), t1 (copy)
	local t2 = {}
	local t3

	if p3 ~= nil then
		local v14 = nil

		if typeof(p3) == "table" then
			if isArray(p3) then
				v14 = table.clone(p3)
			else
				local mt = getmetatable(p3)

				if mt and rawget(mt, "__iter") then
					v14 = p3
				elseif __DEV__ then
					error("cannot create array from an object-like table")
				end
			end
		elseif typeof(p3) == "string" then
			v14 = fromString(p3)
		else
			error(("cannot create array from value of type `%s`"):format((typeof(p3))))
		end

		if v14 then
			t3 = table.create(#v14)

			for _, v18 in v14 do
				if not t2[v18] then
					t2[v18] = true
					table.insert(t3, v18)
				end
			end
		else
			t3 = {}
		end
	else
		t3 = {}
	end

	return (setmetatable({
		size = #t3,
		_map = t2,
		_array = t3
	}, t1))
end
function t1.add(p4, p5) -- line: 100
	if not p4._map[p5] then
		p4.size = p4.size + 1
		p4._map[p5] = true
		table.insert(p4._array, p5)
	end

	return p4
end
function t1.clear(p6) -- line: 110
	p6.size = 0
	table.clear(p6._map)
	table.clear(p6._array)
end
function t1.delete(p7, p8) -- line: 116
	if not p7._map[p8] then
		return false
	end

	p7.size = p7.size - 1
	p7._map[p8] = nil

	local v24 = table.find(p7._array, p8)

	if v24 then
		table.remove(p7._array, v24)
	end

	return true
end
function t1.forEach(p9, p10, p11) -- line: 132
	-- upvalues: forEach (copy)
	if typeof(p10) ~= "function" then
		error("callback is not a function")
	end

	forEach(p9._array, function(p12) -- line: 138
		-- upvalues: p11 (copy), p10 (copy), p9 (copy)
		if p11 ~= nil then
			p10(p11, p12, p12, p9)

			return
		end

		p10(p12, p12, p9)
	end)
end
function t1.has(p13, p14) -- line: 147
	return p13._map[p14] ~= nil
end
function t1.ipairs(p15) -- line: 151
	-- upvalues: __DEV__ (copy)
	if __DEV__ then
		warn(debug.traceback("`for _,_ in mySet:ipairs() do` is deprecated and will be removed in a future release, please use `for _,_ in mySet do` instead\n", 2))
	end

	return ipairs(p15._array)
end

return t1
