local scriptParent = script.Parent
local isArray = require(scriptParent.isArray)
local scriptParentParent = scriptParent.Parent

require(scriptParentParent.types)

local function concat(p1, ...) -- line: 14
	-- upvalues: isArray (copy)
	local v6, v7

	if isArray(p1) then
		v6 = table.clone(p1)
		v7 = #p1
	else
		v7 = 0 + 1
		v6 = {
			[v7] = p1
		}
	end

	for i = 1, select("#", ...) do
		local v9 = select(i, ...)
		local v10 = typeof(v9)

		if v9 ~= nil then
			if v10 == "table" then
				if _G.__DEV__ and not isArray(v9) then
					error("Array.concat(...) only works with array-like tables but it received an object-like table.\nYou can avoid this error by wrapping the object-like table into an array. Example: `concat({1, 2}, {a = true})` should be `concat({1, 2}, { {a = true} }`")
				end

				for j = 1, #v9 do
					v7 += 1
					v6[v7] = v9[j]
				end
			else
				v7 += 1
				v6[v7] = v9
			end
		end
	end

	return v6
end

return concat
