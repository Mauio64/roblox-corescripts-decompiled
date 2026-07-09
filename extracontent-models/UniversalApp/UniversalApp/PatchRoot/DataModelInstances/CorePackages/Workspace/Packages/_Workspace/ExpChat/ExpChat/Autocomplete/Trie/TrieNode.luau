local t1 = {}

t1.__index = t1

function t1.new(s1: string) -- line: 4
	-- upvalues: t1 (copy)
	local t2 = {}

	setmetatable(t2, t1)
	t2.children = {}
	t2.isEndOfWord = false
	t2.data = s1

	return t2
end

return t1
