local ParentParent = script.Parent.Parent
local Set = require(ParentParent.Set)
local instanceof = require(ParentParent.instanceof)

require(ParentParent.types)

return function(p1) -- line: 9
	-- upvalues: instanceof (copy), Set (copy)
	if p1 == nil then
		error("cannot extract keys from a nil value")
	end

	local v5 = typeof(p1)
	local t2 = nil

	if v5 == "table" then
		local t1 = {}

		if instanceof(p1, Set) then
			return t1
		end

		for k in pairs(p1) do
			table.insert(t1, k)
		end

		return t1
	end

	if v5 == "string" then
		local v9 = p1:len()

		t2 = table.create(v9)

		for i = 1, v9 do
			t2[i] = tostring(i)
		end
	end

	return t2
end
