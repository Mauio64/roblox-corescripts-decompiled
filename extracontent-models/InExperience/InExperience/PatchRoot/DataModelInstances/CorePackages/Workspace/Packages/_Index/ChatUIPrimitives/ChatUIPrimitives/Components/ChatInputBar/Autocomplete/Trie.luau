local t1 = {}

t1.__index = t1

function t1.new(s1: string) -- line: 4
	-- upvalues: t1 (copy)
	local self = setmetatable({}, t1)

	self.children = {}
	self.isEndOfWord = false
	self.data = s1

	return self
end

local t2 = {}

t2.__index = t2

function t2.new() -- line: 15
	-- upvalues: t2 (copy), t1 (copy)
	local self = setmetatable({}, t2)

	self.root = t1.new("")

	return self
end
function t2.insert(t3: {[any]: any}, s2: string) -- line: 21
	-- upvalues: t1 (copy)
	local root = t3.root

	for i = 1, #s2 do
		local v10 = string.sub(s2, i, i)

		if not root.children[v10] then
			root.children[v10] = t1.new(v10)
		end

		root = root.children[v10]
	end

	root.isEndOfWord = true
end
function t2.autocomplete(t4: {[any]: any}, s3: string) -- line: 33
	local t5 = {}
	local root = t4.root

	for i = 1, #s3 do
		local v16 = string.sub(s3, i, i)

		if not root.children[v16] then
			return t5
		end

		root = root.children[v16]
	end

	t4:_collect(root, t5, (string.sub(s3, 1, #s3 - 1)))

	return t5
end
function t2._collect(t6: {[any]: any}, p1, t7: {[any]: any}, s4: string) -- line: 48
	if p1.isEndOfWord then
		table.insert(t7, s4 .. p1.data)
	end

	for _, v in pairs(p1.children) do
		t6:_collect(v, t7, s4 .. p1.data)
	end
end

return t2
