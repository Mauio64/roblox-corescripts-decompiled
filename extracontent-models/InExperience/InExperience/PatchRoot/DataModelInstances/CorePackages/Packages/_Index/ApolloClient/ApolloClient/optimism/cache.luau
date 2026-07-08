local ParentParent = script.Parent.Parent.Parent
local Map = require(ParentParent.LuauPolyfill).Map
local t1 = {}

local function defaultDispose() -- line: 21
end

local t2 = {}

t2.__index = t2

function t2.new(n1: number?, p1: ((...any) -> ...any)?) -- line: 51
	-- upvalues: defaultDispose (copy), t2 (copy), Map (copy)
	if n1 == nil then
		n1 = 1e999
	end

	if p1 == nil then
		p1 = defaultDispose
	end

	local self = setmetatable({}, t2)

	self.map = Map.new(nil)
	self.newest = nil
	self.oldest = nil
	self.max = n1
	self.dispose = p1

	return self
end
function t2.has(p2, p3) -- line: 73
	return p2.map:has(p3)
end
function t2.get(p4, p5) -- line: 77
	local v13 = p4:getNode(p5)

	if v13 then
		return v13.value
	end

	return v13
end
function t2.getNode(p6, p7) -- line: 87
	local v16 = p6.map:get(p7)

	if v16 and v16 ~= p6.newest then
		local older = v16.older
		local newer = v16.newer

		if newer then
			newer.older = older
		end

		if older then
			older.newer = newer
		end

		v16.older = p6.newest
		v16.older.newer = v16
		v16.newer = nil
		p6.newest = v16

		if v16 == p6.oldest then
			p6.oldest = newer
		end
	end

	return v16
end
function t2.set(p8, p9, p10) -- line: 121
	local v22 = p8:getNode(p9)

	if v22 then
		v22.value = p10

		return v22.value
	end

	local t3 = {
		newer = nil,
		key = p9,
		value = p10,
		older = p8.newest
	}

	if p8.newest then
		p8.newest.newer = t3
	end

	p8.newest = t3
	p8.oldest = p8.oldest or t3
	p8.map:set(p9, t3)

	return t3.value
end
function t2.clean(p11) -- line: 152
	while p11.oldest and p11.map.size > p11.max do
		p11:delete(p11.oldest.key)
	end
end
function t2.delete(p12, p13) -- line: 160
	local v27 = p12.map:get(p13)

	if v27 then
		if v27 == p12.newest then
			p12.newest = v27.older
		end

		if v27 == p12.oldest then
			p12.oldest = v27.newer
		end

		if v27.newer then
			v27.newer.older = v27.older
		end

		if v27.older then
			v27.older.newer = v27.newer
		end

		p12.map:delete(p13)
		p12.dispose(v27.value, p13)

		return true
	end

	return false
end

t1.Cache = t2

return t1
