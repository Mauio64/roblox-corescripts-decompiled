local t1 = {}

t1.__index = t1

function t1.createNode(p1) -- line: 4
	-- upvalues: t1 (copy)
	local t2 = {
		previous = nil,
		next = nil,
		value = p1
	}

	setmetatable(t2, t1)

	return t2
end
function t1.CreateNext(p2, p3) -- line: 17
	-- upvalues: t1 (copy)
	local t3 = {
		previous = p2,
		next = p2.next,
		value = p3 or {}
	}

	if p2.next then
		p2.next.previous = t3
	end

	setmetatable(t3, t1)
	p2.next = t3

	return t3
end
function t1.CreatePrevious(p4, p5) -- line: 34
	-- upvalues: t1 (copy)
	local t4 = {
		previous = p4.previous,
		next = p4,
		value = p5 or {}
	}

	if p4.previous then
		p4.previous.next = t4
	end

	setmetatable(t4, t1)
	p4.previous = t4

	return t4
end

return t1
