local __DEV__ = _G.__DEV__
local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent
local flat = require(scriptParent.flat)
local map = require(scriptParent.map)

require(ParentParent.ES7Types)

local function flatMap(p1, p2: ((...any) -> ...any), p3) -- line: 25
	-- upvalues: __DEV__ (copy), flat (copy), map (copy)
	if __DEV__ then
		if typeof(p1) ~= "table" then
			error(string.format("Array.flatMap called on %s", (typeof(p1))))
		end

		if typeof(p2) ~= "function" then
			error("callback is not a function")
		end
	end

	return flat(map(p1, p2, p3))
end

return flatMap
