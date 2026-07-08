local ParentParent = script.Parent.Parent.Parent.Parent

require(ParentParent.LuauPolyfill)

local t1 = {}

local function defaultMakeData() -- line: 24
	return {}
end

local t2 = {}

t2.__index = t2

function t2.new(b1: boolean?, p1: ((...any) -> ...any)?) -- line: 67
	-- upvalues: defaultMakeData (copy), t2 (copy)
	if b1 == nil then
		b1 = true
	end

	if p1 == nil then
		p1 = defaultMakeData
	end

	local self = setmetatable({}, t2)

	self.weakness = b1
	self.makeData = p1

	return self
end
function t2.lookup(p2, ...) -- line: 88
	return p2:lookupArray({ ... })
end
function t2.lookupArray(p3, p4) -- line: 97
	local v11 = p3

	for _, v13 in p4 do
		v11 = v11:getChildTrie(v13)
	end

	if not v11.data then
		v11.data = p3.makeData(table.clone(p4))
	end

	return v11.data
end
function t2.getChildTrie(p5, p6) -- line: 114
	-- upvalues: t2 (copy)
	local weak

	if p5.weakness then
		if p5.weak == nil then
			p5.weak = setmetatable({}, {
				__mode = "k"
			})
		end

		weak = p5.weak
	else
		if p5.strong == nil then
			p5.strong = {}
		end

		weak = p5.strong
	end

	local v17 = weak[p6]

	if not v17 then
		v17 = t2.new(p5.weakness, p5.makeData)
		weak[p6] = v17
	end

	return v17
end

t1.Trie = t2

return t1
