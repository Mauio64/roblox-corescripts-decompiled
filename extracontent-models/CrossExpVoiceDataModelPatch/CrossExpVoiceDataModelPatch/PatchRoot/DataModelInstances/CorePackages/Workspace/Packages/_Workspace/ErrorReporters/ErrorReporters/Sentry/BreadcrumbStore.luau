local ParentParent = script.Parent.Parent.Parent
local t = require(ParentParent.t)
local Breadcrumb = require(script.Parent.Breadcrumb)
local t1 = {}

t1.__index = t1

local v5 = t.tuple(t.optional(t.strictInterface({
	limit = t.optional(t.numberPositive)
})))

function t1.new(t2: {[any]: any}?) -- line: 48
	-- upvalues: v5 (copy), t1 (copy)
	assert(v5(t2))

	local v7 = (t2 or {}).limit or 200

	return (setmetatable({
		_writeIndex = 1,
		_count = 0,
		_breadcrumbs = table.create(v7),
		_limit = v7
	}, t1))
end
function t1.addBreadcrumb(t3: {[any]: any}, p1) -- line: 75
	-- upvalues: Breadcrumb (copy)
	local v10 = Breadcrumb.new(p1)

	t3._breadcrumbs[t3._writeIndex] = v10

	if t3._count < t3._limit then
		t3._count = t3._count + 1
	end

	t3._writeIndex = t3._writeIndex % t3._limit + 1
end
function t1.getBreadcrumbs(t4: {[any]: any}) -- line: 100
	local t5 = {}

	if t4._count == 0 then
		return t5
	end

	if t4._count < t4._limit then
		for i = 1, t4._count do
			table.insert(t5, t4._breadcrumbs[i])
		end

		return t5
	end

	for i = t4._writeIndex, t4._limit do
		table.insert(t5, t4._breadcrumbs[i])
	end

	for i = 1, t4._writeIndex - 1 do
		table.insert(t5, t4._breadcrumbs[i])
	end

	return t5
end
function t1.getCount(t6: {[any]: any}) -- line: 130
	return t6._count
end
function t1.clear(t7: {[any]: any}) -- line: 137
	t7._breadcrumbs = table.create(t7._limit)
	t7._writeIndex = 1
	t7._count = 0
end
function t1.isFull(t8: {[any]: any}) -- line: 148
	return t8._count >= t8._limit
end

return t1
