local t1 = {}
local ParentParent = script.Parent.Parent.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Object = LuauPolyfill.Object
local Set = LuauPolyfill.Set
local Array = LuauPolyfill.Array

require(script.Parent.Parent.globals)

local isNonNullObject = require(script.Parent.objects).isNonNullObject

local function deepFreeze(p1) -- line: 22
	-- upvalues: Set (copy), isNonNullObject (copy), Object (copy), Array (copy)
	local v10 = Set.new({ p1 })

	for _, v12 in v10 do
		if isNonNullObject(v12) then
			if not table.isfrozen(v12) then
				Object.freeze(v12)
			end

			Array.forEach(Object.keys(v12), function(p2) -- line: 30
				-- upvalues: isNonNullObject (copy), v12 (copy), v10 (copy)
				if isNonNullObject(v12[p2]) then
					v10:add(v12[p2])
				end
			end)
		end
	end

	return p1
end

function t1.maybeDeepFreeze(p3) -- line: 41
	-- upvalues: deepFreeze (copy)
	if _G.__DEV__ then
		deepFreeze(p3)
	end

	return p3
end

return t1
