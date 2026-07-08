local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local uuid = require(ParentParent.utilities.common.makeUniqueId).uuid
local t1 = {}
local t6 = nil
local t2 = {}
local n1 = 1

local function makeSlotClass() -- line: 62
	-- upvalues: Array (copy), n1 (ref), uuid (copy), t6 (ref), t2 (copy)
	local t3 = {}

	t3.__index = t3

	function t3.new() -- line: 66
		-- upvalues: t3 (copy), Array (copy), n1 (ref), uuid (copy)
		local self = setmetatable({}, t3)

		self.id = Array.join({
			"slot",
			n1,
			DateTime.now().UnixTimestampMillis,
			uuid()
		}, ":")
		n1 += 1

		return self
	end
	function t3.hasValue(p1) -- line: 84
		-- upvalues: t6 (ref), t2 (copy)
		local v18 = t6

		while v18 do
			if v18.slots[p1.id] then
				local v19 = v18.slots[p1.id]

				if v19 == t2 then
					break
				end

				if v18 ~= t6 then
					t6.slots[p1.id] = v19
				end

				return true
			end

			v18 = v18.parent
		end

		if t6 then
			t6.slots[p1.id] = t2
		end

		return false
	end
	function t3.getValue(p2) -- line: 120
		-- upvalues: t6 (ref)
		if p2:hasValue() then
			return t6.slots[p2.id]
		end

		return nil
	end
	function t3.withValue(t4: {[any]: any}, p3, p4: ((...any) -> ...any), p5, p6) -- line: 127
		-- upvalues: t6 (ref)
		local t5 = {
			[t4.id] = p3
		}
		local v27 = t6

		t6 = {
			parent = v27,
			slots = t5
		}

		local ok, result, v30 = pcall(function() -- line: 144
			-- upvalues: p4 (copy), p6 (copy), p5 (copy)
			return p4(p6, table.unpack(p5 or {})), true
		end)

		t6 = v27

		if v30 then
			return result
		end

		if not ok then
			error(result)
		end

		return nil
	end
	function t3.bind(p7: ((...any) -> ...any)) -- line: 162
		-- upvalues: t6 (ref)
		local v32 = t6

		return function(p8, ...) -- line: 164
			-- upvalues: t6 (ref), v32 (copy), p7 (copy)
			local v41 = t6

			t6 = v32

			local ok, result = pcall(p7, p8, table.unpack({ ... }))

			t6 = v41

			if not ok then
				error(result)
			end

			return result
		end
	end
	function t3.noContext(p9: ((...any) -> ...any), p10, p11) -- line: 178
		-- upvalues: t6 (ref)
		if t6 then
			local v36 = t6
			local ok, result, v39 = pcall(function() -- line: 189
				-- upvalues: t6 (ref), p9 (copy), p11 (copy), p10 (copy)
				t6 = nil

				return p9(p11, table.unpack(p10 or {})), true
			end)

			t6 = v36

			if v39 then
				return result
			end

			if not ok then
				error(result)
			end

			return nil
		end

		return p9(p11, table.unpack(p10 or {}))
	end

	return t3
end

local g13 = nil
local v12 = nil

if Boolean.toJSBoolean(Array["@wry/context:Slot"]) then
	v12 = Array["@wry/context:Slot"]

	if v12 then
		g13 = true
	end
end

if not g13 then
	local v14 = makeSlotClass()

	pcall(function() -- line: 227
		-- upvalues: Array (copy), v14 (copy)
		Array["@wry/context:Slot"] = v14
	end)
	v12 = v14
end

g13 = false
t1.Slot = v12

return t1
