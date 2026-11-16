local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local LuauPolyfill = require(parent2.LuauPolyfill)

local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean

local makeUniqueId = require(parent.utilities.common.makeUniqueId)
local uuid = makeUniqueId.uuid

local v = nil

local v2 = {}

local v3 = 1

local function makeSlotClass()
	local slotClass = {}
	slotClass.__index = slotClass

	function slotClass.new()
		local self = setmetatable({}, slotClass)

		self.id = Array.join({ "slot", v3, DateTime.now().UnixTimestampMillis, uuid() }, ":")

		v3 += 1

		return self
	end

	function slotClass:hasValue(): boolean
		local v4 = v

		while v4 do
			if v4.slots[self.id] then
				local slot = v4.slots[self.id]

				if slot == v2 then
					break
				end

				if v4 ~= v then
					v.slots[self.id] = slot
				end

				return true
			end

			v4 = v4.parent
		end

		if v then
			v.slots[self.id] = v2
		end

		return false
	end

	function slotClass:getValue()
		if self:hasValue() then
			return v.slots[self.id]
		end

		return nil
	end

	function slotClass.withValue(p, p2, callback, options, p3)
		local slots = { [p.id] = p2 }

		local parent3 = v
		v = { parent = parent3, slots = slots }

		local success, result, v4 = pcall(function()
			return callback(p3, table.unpack(options or {})), true
		end)

		v = parent3

		if v4 then
			return result
		end

		if not success then
			error(result)
		end

		return nil
	end

	function slotClass.bind(callback)
		local v4 = v
		return function(p, ...)
			local v5 = v
			v = v4
			local success, result = pcall(callback, p, table.unpack({ ... }))
			v = v5

			if not success then
				error(result)
			end

			return result
		end
	end

	function slotClass.noContext(callback, options, p)
		if not v then
			return callback(p, table.unpack(options or {}))
		end

		local v4 = v
		local success, result, v5 = pcall(function()
			v = nil

			return callback(p, table.unpack(options or {})), true
		end)

		v = v4

		if v5 then
			return result
		end

		if not success then
			error(result)
		end

		return nil
	end

	return slotClass
end

local v4 = Boolean.toJSBoolean(Array["@wry/context:Slot"]) and Array["@wry/context:Slot"]

if not v4 then
	v4 = makeSlotClass()
	pcall(function()
		Array["@wry/context:Slot"] = v4
	end)
end

return { Slot = v4 }
