local __DEV__ = _G.__DEV__
local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent
local isArray = require(scriptParent.isArray)

require(ParentParent.ES7Types)

local function concat(p1, ...) -- line: 29
	-- upvalues: isArray (copy), __DEV__ (copy)
	local v7, v8

	if isArray(p1) then
		v7 = table.clone(p1)
		v8 = #p1
	else
		v8 = 0 + 1
		v7 = {
			[v8] = p1
		}
	end

	for i = 1, select("#", ...) do
		local v10 = select(i, ...)
		local v11 = typeof(v10)

		if v10 ~= nil then
			if v11 == "table" then
				if __DEV__ and not isArray(v10) then
					error("Array.concat(...) only works with array-like tables but it received an object-like table.\nYou can avoid this error by wrapping the object-like table into an array. Example: `concat({1, 2}, {a = true})` should be `concat({1, 2}, { {a = true} }`")
				end

				for j = 1, #v10 do
					v8 += 1
					v7[v8] = v10[j]
				end
			else
				v8 += 1
				v7[v8] = v10
			end
		end
	end

	return v7
end

return concat
