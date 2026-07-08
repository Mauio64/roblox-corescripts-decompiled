local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local t1 = {}
local dep = require(ParentParent.optimism).dep
local Slot = require(ParentParent.wry.context).Slot

require(script.Parent.Parent.core.cache)

local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Set = LuauPolyfill.Set
local WeakMap = LuauPolyfill.WeakMap
local broadcast = nil
local v11 = Slot.new()

t1.cacheSlot = v11

local v12 = WeakMap.new()

local function getCacheInfo(p1) -- line: 57
	-- upvalues: v12 (copy), Set (copy), dep (copy)
	local v15 = v12:get(p1)

	if not v15 then
		v15 = {
			vars = Set.new(),
			dep = dep()
		}
		v12:set(p1, v15)
	end

	return v15
end

function t1.forgetCache(p2) -- line: 73
	-- upvalues: getCacheInfo (copy)
	getCacheInfo(p2).vars:forEach(function(p3) -- line: 74
		-- upvalues: p2 (copy)
		return p3:forgetCache(p2)
	end)
end
function t1.recallCache(p4) -- line: 88
	-- upvalues: getCacheInfo (copy)
	getCacheInfo(p4).vars:forEach(function(p5) -- line: 89
		-- upvalues: p4 (copy)
		return p5:attachCache(p4)
	end)
end
function t1.makeVar(p6) -- line: 95
	-- upvalues: Set (copy), getCacheInfo (copy), broadcast (ref), Array (copy), v11 (copy)
	local v20 = Set.new()
	local v21 = Set.new()
	local self = nil
	local u23 = nil

	self = setmetatable({}, {
		__call = function(_, ...) -- line: 104
			-- upvalues: p6 (ref), v20 (copy), getCacheInfo (copy), self (ref), broadcast (ref), Array (copy), v21 (copy), v11 (copy), u23 (ref)
			if select("#", ...) >= 1 then
				local v28 = ({ ... })[1]

				if v28 ~= p6 then
					p6 = v28
					v20:forEach(function(p8) -- line: 110
						-- upvalues: getCacheInfo (copy), self (ref), broadcast (ref)
						getCacheInfo(p8).dep:dirty(self)
						broadcast(p8)
					end)

					local v29 = Array.from(v21)

					v21:clear()
					Array.forEach(v29, function(p9) -- line: 122
						-- upvalues: p6 (ref)
						p9(p6)
					end)
				end
			else
				local v30 = v11:getValue()

				if v30 then
					u23(v30)
					getCacheInfo(v30).dep(self)
				end
			end

			return p6
		end
	})

	function self.onNextChange(_, p11) -- line: 142
		-- upvalues: v21 (copy)
		v21:add(p11)

		return function() -- line: 144
			-- upvalues: v21 (copy), p11 (copy)
			v21:delete(p11)
		end
	end
	function u23(p12) -- line: 150
		-- upvalues: v20 (copy), getCacheInfo (copy), self (ref)
		v20:add(p12)
		getCacheInfo(p12).vars:add(self)

		return self
	end
	function self.attachCache(_, p14) -- line: 155
		-- upvalues: u23 (ref)
		return u23(p14)
	end
	function self.forgetCache(_, p16) -- line: 160
		-- upvalues: v20 (copy)
		return v20:delete(p16)
	end

	return self
end
function broadcast(p17) -- line: 174
	if p17.broadcastWatches ~= nil then
		p17:broadcastWatches()
	end
end

return t1
