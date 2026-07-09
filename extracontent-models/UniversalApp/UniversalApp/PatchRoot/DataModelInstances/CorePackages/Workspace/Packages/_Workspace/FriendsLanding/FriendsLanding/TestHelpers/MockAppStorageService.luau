local t1 = {}

t1.__index = t1

function t1.new(p1) -- line: 4
	-- upvalues: t1 (copy)
	local v3 = p1 or {}

	setmetatable(v3, {
		__index = t1
	})

	return v3
end
function t1.GetItem(p2, p3) -- line: 13
	return p2[p3]
end
function t1.SetItem(p4, p5, p6) -- line: 17
	p4[p5] = tostring(p6)
end
function t1.flush(_) -- line: 21
end

return t1
