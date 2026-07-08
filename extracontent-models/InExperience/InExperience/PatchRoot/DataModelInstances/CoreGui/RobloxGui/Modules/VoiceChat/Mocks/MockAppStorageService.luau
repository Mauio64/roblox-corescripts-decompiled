local t1 = {}

t1.__index = t1

function t1.new(p1) -- line: 4
	-- upvalues: t1 (copy)
	return (setmetatable({
		_privateValues = table.clone(p1)
	}, t1))
end
function t1.GetItem(p2, p3) -- line: 12
	return p2._privateValues[p3]
end
function t1.SetItem(p4, p5, p6) -- line: 16
	p4._privateValues[p5] = p6
end
function t1.Flush(_) -- line: 20
end
function t1._DeepEquals(p8, p9) -- line: 23
	for v11, v12 in p9 do
		if v12 ~= p8._privateValues[v11] then
			return false
		end
	end

	return true
end

return t1
