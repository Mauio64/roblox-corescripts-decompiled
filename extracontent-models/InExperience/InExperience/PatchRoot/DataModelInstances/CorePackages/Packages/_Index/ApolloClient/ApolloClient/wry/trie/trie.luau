local parent = script.Parent.Parent.Parent.Parent

require(parent.LuauPolyfill)

local function defaultMakeData()
	return {}
end

local class = {}
class.__index = class

function class.new(flag: boolean?, makeData)
	local weakness = flag == nil or flag

	if makeData == nil then
		makeData = defaultMakeData
	end

	local self = setmetatable({}, class)

	self.weakness = weakness
	self.makeData = makeData

	return self
end

function class:lookup(...)
	return self:lookupArray({ ... })
end

function class:lookupArray(items)
	local v = self

	for _, item in items do
		v = v:getChildTrie(item)
	end

	if not v.data then
		v.data = self.makeData(table.clone(items))
	end

	return v.data
end

function class:getChildTrie(p)
	local childTries

	if self.weakness then
		if self.weak == nil then
			self.weak = setmetatable({}, { __mode = "k" })
		end

		childTries = self.weak
	else
		if self.strong == nil then
			self.strong = {}
		end

		childTries = self.strong
	end

	local childTrie = childTries[p]

	if not childTrie then
		childTrie = class.new(self.weakness, self.makeData)
		childTries[p] = childTrie
	end

	return childTrie
end

return { Trie = class }
