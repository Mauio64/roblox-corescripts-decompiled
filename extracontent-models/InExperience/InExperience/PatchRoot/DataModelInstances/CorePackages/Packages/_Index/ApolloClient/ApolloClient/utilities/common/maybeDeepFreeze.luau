local MaybeDeepFreeze = {}

local parent = script.Parent.Parent.Parent.Parent

local LuauPolyfill = require(parent.LuauPolyfill)
local Object = LuauPolyfill.Object
local Set = LuauPolyfill.Set
local Array = LuauPolyfill.Array

require(script.Parent.Parent.globals)

local objects = require(script.Parent.objects)
local isNonNullObject = objects.isNonNullObject

local function deepFreeze(p)
	local v = Set.new({ p })

	for _, list in v do
		if not isNonNullObject(list) then
			continue
		end

		if not table.isfrozen(list) then
			Object.freeze(list)
		end

		Array.forEach(Object.keys(list), function(p2)
			if isNonNullObject(list[p2]) then
				v:add(list[p2])
			end
		end)
	end

	return p
end

function MaybeDeepFreeze.maybeDeepFreeze(p)
	if _G.__DEV__ then
		deepFreeze(p)
	end

	return p
end

return MaybeDeepFreeze
