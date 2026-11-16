local parent = script.Parent.Parent.Parent

local LuauPolyfill = require(parent.LuauPolyfill)

local Set = LuauPolyfill.Set
local Array = LuauPolyfill.Array

local Dep = {}

require(script.Parent.anyEntryTypes)

require(script.Parent.initTypes)

local context = require(script.Parent.context)
local parentEntrySlot = context.parentEntrySlot
local helpers = require(script.Parent.helpers)
local hasOwnProperty = helpers.hasOwnProperty

local maybeUnsubscribe = helpers.maybeUnsubscribe
local toArray = helpers.toArray

local v = { setDirty = true, dispose = true, forget = true }

require(script.Parent.depTypes)

function Dep.dep(callback)
	local v2 = {}

	if callback ~= nil then
		callback = callback.subscribe
	end

	local object = setmetatable({}, {
		__call = function(_, p)
			local value = parentEntrySlot:getValue()

			if value ~= nil then
				local v3 = v2[p]

				if not v3 then
					v3 = Set.new()

					v2[p] = v3
				end

				value:dependOn(v3)

				if type(callback) == "function" then
					maybeUnsubscribe(v3)

					v3.unsubscribe = callback(p)
				end
			end
		end
	})

	function object.dirty(_, p, p2: string?)
		local v3 = v2[p]

		if v3 then
			local v4 = not (p2 and hasOwnProperty(v, p2)) and "setDirty" or p2

			Array.forEach(toArray(v3), function(p3)
				p3[v4](p3)
			end)

			v2[p] = nil

			maybeUnsubscribe(v3)
		end
	end

	return object
end

return Dep
