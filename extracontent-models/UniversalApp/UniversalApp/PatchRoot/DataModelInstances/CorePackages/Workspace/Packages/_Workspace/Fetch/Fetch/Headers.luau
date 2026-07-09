local ParentParent = script.Parent.Parent
local Array = require(ParentParent.LuauPolyfill).Array
local t1 = {}

t1.__index = t1

function t1.new(p1) -- line: 36
	-- upvalues: Array (copy), t1 (copy)
	local t2 = {}
	local t3

	if Array.isArray(p1) then
		t3 = {}

		for _, v8 in p1 do
			t3[v8[1]] = v8[2]
		end
	else
		t3 = p1 or {}
	end

	t2.headerList = t3
	t2.guard = "none"
	setmetatable(t2, t1)

	return t2
end
function t1.append(t4: {[any]: any}, s1: string, s2: string) -- line: 56
	if t4.guard == "immutable" then
		error("TypeError: tried to append header to immutable Headers object")
	end

	t4.headerList[s1] = s2
end
function t1.delete(t5: {[any]: any}, s3: string) -- line: 64
	if t5.guard == "immutable" then
		error("TypeError: tried to delete key on immutable Headers object")
	end

	if not t5:has(s3) then
		return
	end

	t5.headerList[s3] = nil
end
function t1.get(t6: {[any]: any}, s4: string) -- line: 76
	return t6.headerList[s4]
end
function t1.has(t7: {[any]: any}, s5: string) -- line: 80
	return t7.headerList[s5] ~= nil
end
function t1.set(t8: {[any]: any}, s6: string, s7: string) -- line: 84
	if t8.guard == "immutable" then
		error("TypeError: tried to set key on immutable Headers object")
	end

	t8.headerList[s6] = s7
end
function t1.__iter(p2) -- line: 91
	return next, p2.headerList
end

return {
	Headers = t1
}
