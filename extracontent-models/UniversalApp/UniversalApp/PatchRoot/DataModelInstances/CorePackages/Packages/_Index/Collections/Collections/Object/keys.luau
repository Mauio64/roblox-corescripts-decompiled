local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local ParentParent = scriptParent.Parent.Parent
local Set = require(scriptParentParent.Set)

require(ParentParent.ES7Types)

local InstanceOf = require(ParentParent.InstanceOf)

return function(p1) -- line: 26
	-- upvalues: InstanceOf (copy), Set (copy)
	if p1 == nil then
		error("cannot extract keys from a nil value")
	end

	local v7 = typeof(p1)
	local t2 = nil

	if v7 == "table" then
		local t1 = {}

		if InstanceOf(p1, Set) then
			return t1
		end

		for k in pairs(p1) do
			table.insert(t1, k)
		end

		return t1
	end

	if v7 == "string" then
		local v11 = p1:len()

		t2 = table.create(v11)

		for i = 1, v11 do
			t2[i] = tostring(i)
		end
	end

	return t2
end
