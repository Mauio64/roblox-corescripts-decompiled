local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
local t1 = {}
local invariant = require(ParentParent.jsUtils.invariant)
local t2 = {}

t2.__index = t2

function t2.new(n1: number) -- line: 36
	-- upvalues: t2 (copy), invariant (copy)
	local self = setmetatable({}, t2)

	invariant(n1 >= 0, "CellRenderMask must contain a non-negative number os cells")
	self._numCells = n1

	if n1 == 0 then
		self._regions = {}

		return self
	end

	self._regions = {{
		first = 0,
		isSpacer = true,
		last = n1 - 1
	}}

	return self
end
function t2.enumerateRegions(p1) -- line: 47
	return p1._regions
end
function t2.addCells(t3: {[any]: any}, t4: {[any]: any}) -- line: 50
	-- upvalues: invariant (copy), Object (copy), Array (copy)
	invariant(t4.first >= 0 and (t4.first < t3._numCells and (t4.last >= 0 and (t4.last < t3._numCells and t4.last >= t4.first))), "CellRenderMask.addCells called with invalid cell range")

	local v14, v15 = t3:_findRegion(t4.first)
	local v16, v17 = t3:_findRegion(t4.last)

	if v15 == v17 and not v14.isSpacer then
		return
	end

	local t5 = {}
	local t6 = {}
	local v20 = Object.assign({}, t4, {
		isSpacer = false
	})

	if v14.first < v20.first then
		if v14.isSpacer then
			table.insert(t5, {
				isSpacer = true,
				first = v14.first,
				last = v20.first - 1
			})
		else
			v20.first = v14.first
		end
	end

	if v16.last > v20.last then
		if v16.isSpacer then
			table.insert(t6, {
				isSpacer = true,
				first = v20.last + 1,
				last = v16.last
			})
		else
			v20.last = v16.last
		end
	end

	local v21 = Array.concat(t5, { v20 }, t6)
	local v22 = v17 - v15 + 1

	Array.splice(t3._regions, v15, v22, table.unpack(v21))
end
function t2.equals(t7: {[any]: any}, t8: {[any]: any}) -- line: 95
	-- upvalues: Array (copy)
	return t7._numCells == t8._numCells and (#t7._regions == #t8._regions and Array.every(t7._regions, function(p2, p3) -- line: 98
		-- upvalues: t8 (copy)
		return p2.first == t8._regions[p3].first and (p2.last == t8._regions[p3].last and p2.isSpacer == t8._regions[p3].isSpacer)
	end))
end
function t2._findRegion(t9: {[any]: any}, n2: number) -- line: 105
	-- upvalues: invariant (copy)
	local n3 = 1
	local v28 = #t9._regions

	while n3 <= v28 do
		local v29 = math.floor((n3 + v28) / 2)
		local v30 = t9._regions[v29]

		if n2 >= v30.first and n2 <= v30.last then
			return v30, v29
		end

		if n2 < v30.first then
			v28 = v29 - 1
		elseif n2 > v30.last then
			n3 = v29 + 1
		end
	end

	invariant(false, string.format("A region was not found containing cellIdx %s", (tostring(n2))))

	return nil, nil
end

t1.CellRenderMask = t2

return t1
