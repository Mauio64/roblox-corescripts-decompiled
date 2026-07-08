local __DEV__ = _G.__DEV__
local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent
local isArray = require(scriptParent.isArray)

require(ParentParent.ES7Types)

local function flat(p1, n1: number?) -- line: 21
	-- upvalues: __DEV__ (copy), isArray (copy), flat (copy)
	if __DEV__ then
		if typeof(p1) ~= "table" then
			error(string.format("Array.flat called on %s", (typeof(p1))))
		end

		if n1 ~= nil and typeof(n1) ~= "number" then
			error("depth is not a number or nil")
		end
	end

	local v8 = n1 or 1
	local t1 = {}

	for _, v11 in p1 do
		if isArray(v11) then
			for _, v13 in if not (v8 > 1) then v11 else flat(v11, v8 - 1) do
				table.insert(t1, v13)
			end
		else
			table.insert(t1, v11)
		end
	end

	return t1
end

return flat
