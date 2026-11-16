local parent = script.Parent.Parent.Parent

local LuauPolyfill = require(parent.LuauPolyfill)
local Map = LuauPolyfill.Map

local function defaultDispose() end

local class = {}
class.__index = class

function class.new(p: number?, dispose)
	local max = p == nil and 1e999 or p

	if dispose == nil then
		dispose = defaultDispose
	end

	local self = setmetatable({}, class)

	self.map = Map.new(nil)
	self.newest = nil
	self.oldest = nil

	self.max = max
	self.dispose = dispose

	return self
end

function class:has(p)
	return self.map:has(p)
end

function class:get(p)
	local node = self:getNode(p)

	return node and node.value
end

function class:getNode(p)
	local node = self.map:get(p)

	if not node or node == self.newest then
		return node
	end

	local older = node.older
	local newer = node.newer

	if newer then
		newer.older = older
	end

	if older then
		older.newer = newer
	end

	node.older = self.newest
	node.older.newer = node

	node.newer = nil
	self.newest = node

	if node == self.oldest then
		self.oldest = newer
	end

	return node
end

function class:set(p, p2)
	local node = self:getNode(p)

	if node then
		node.value = p2
		return node.value
	end

	local v = { key = p, value = p2, newer = nil, older = self.newest }

	if self.newest then
		self.newest.newer = v
	end

	self.newest = v

	self.oldest = self.oldest or v

	self.map:set(p, v)
	return v.value
end

function class:clean()
	while self.oldest and self.map.size > self.max do
		self:delete(self.oldest.key)
	end
end

function class:delete(p): boolean
	local v = self.map:get(p)

	if not v then
		return false
	end

	if v == self.newest then
		self.newest = v.older
	end

	if v == self.oldest then
		self.oldest = v.newer
	end

	if v.newer then
		v.newer.older = v.older
	end

	if v.older then
		v.older.newer = v.newer
	end

	self.map:delete(p)
	self.dispose(v.value, p)

	return true
end

return { Cache = class }
