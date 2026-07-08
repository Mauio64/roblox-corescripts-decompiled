local ParentParent = script.Parent.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Set = LuauPolyfill.Set
local Array = LuauPolyfill.Array
local t1 = {}

require(script.Parent.anyEntryTypes)
require(script.Parent.initTypes)

local parentEntrySlot = require(script.Parent.context).parentEntrySlot
local helpers = require(script.Parent.helpers)
local hasOwnProperty = helpers.hasOwnProperty
local maybeUnsubscribe = helpers.maybeUnsubscribe
local toArray = helpers.toArray
local t2 = {
	setDirty = true,
	dispose = true,
	forget = true
}

require(script.Parent.depTypes)

function t1.dep(t3: {[any]: any}?) -- line: 66
	-- upvalues: parentEntrySlot (copy), Set (copy), maybeUnsubscribe (copy), hasOwnProperty (copy), t2 (copy), Array (copy), toArray (copy)
	local t4 = {}
	local v14 = if t3 == nil then t3 else t3.subscribe
	local self = setmetatable({}, {
		__call = function(_, p2) -- line: 74
			-- upvalues: parentEntrySlot (copy), t4 (copy), Set (copy), v14 (copy), maybeUnsubscribe (copy)
			local v18 = parentEntrySlot:getValue()

			if v18 ~= nil then
				local v19 = t4[p2]

				if not v19 then
					v19 = Set.new()
					t4[p2] = v19
				end

				v18:dependOn(v19)

				if type(v14) == "function" then
					maybeUnsubscribe(v19)
					v19.unsubscribe = v14(p2)
				end
			end
		end
	})

	function self.dirty(_, p4, s1: string?) -- line: 101
		-- upvalues: t4 (copy), hasOwnProperty (copy), t2 (copy), Array (copy), toArray (copy), maybeUnsubscribe (copy)
		local v23 = t4[p4]

		if v23 then
			local v24 = (not s1 or not hasOwnProperty(t2, s1)) and "setDirty" or s1

			Array.forEach(toArray(v23), function(p5) -- line: 112
				-- upvalues: v24 (copy)
				p5[v24](p5)
			end)
			t4[p4] = nil
			maybeUnsubscribe(v23)
		end
	end

	return self
end

return t1
