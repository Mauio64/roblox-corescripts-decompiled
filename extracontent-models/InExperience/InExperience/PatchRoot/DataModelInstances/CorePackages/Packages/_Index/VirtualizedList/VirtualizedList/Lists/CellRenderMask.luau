local parent = script.Parent.Parent
local parent2 = parent.Parent
local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object

local invariant = require(parent.jsUtils.invariant)

local class = {}
class.__index = class

function class.new(numCells: number)
	local self = setmetatable({}, class)
	invariant(numCells >= 0, "CellRenderMask must contain a non-negative number os cells")
	self._numCells = numCells

	if numCells == 0 then
		self._regions = {}
		return self
	end

	self._regions = {
		{
			first = 0,
			last = numCells - 1,
			isSpacer = true
		}
	}

	return self
end

function class:enumerateRegions()
	return self._regions
end

function class:addCells(p)
	invariant(
		p.first >= 0 and p.first < self._numCells and p.last >= 0 and p.last < self._numCells and p.last >= p.first,
		"CellRenderMask.addCells called with invalid cell range"
	)

	local region, v = self:_findRegion(p.first)
	local region2, v2 = self:_findRegion(p.last)

	if v == v2 and not region.isSpacer then
		return
	end

	local v3 = {}
	local v4 = {}
	local v5 = Object.assign({}, p, { isSpacer = false })

	if region.first < v5.first then
		if region.isSpacer then
			table.insert(v3, {
				first = region.first,
				last = v5.first - 1,
				isSpacer = true
			})
		else
			v5.first = region.first
		end
	end

	if region2.last > v5.last then
		if region2.isSpacer then
			table.insert(v4, {
				first = v5.last + 1,
				last = region2.last,
				isSpacer = true
			})
		else
			v5.last = region2.last
		end
	end

	local joined = Array.concat(v3, { v5 }, v4)
	local v6 = v2 - v + 1
	Array.splice(self._regions, v, v6, table.unpack(joined))
end
function class:equals(p)
	if self._numCells == p._numCells and #self._regions == #p._regions then
		return (Array.every(self._regions, function(data, p2): boolean
			return data.first == p._regions[p2].first
				and data.last == p._regions[p2].last
				and data.isSpacer == p._regions[p2].isSpacer
		end))
	end

	return false
end

function class:_findRegion(p: number)
	local v = #self._regions
	local v2 = 1

	while v2 <= v do
		local v3 = math.floor((v2 + v) / 2)
		local region = self._regions[v3]

		if region.first <= p and p <= region.last then
			return region, v3
		end

		if p < region.first then
			v = v3 - 1
		elseif region.last < p then
			v2 = v3 + 1
		end
	end

	invariant(false, string.format("A region was not found containing cellIdx %s", (tostring(p))))
	return nil, nil
end

return { CellRenderMask = class }
