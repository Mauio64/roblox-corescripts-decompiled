local ParentParent = script.Parent.Parent.Parent.Parent
local v2 = require(ParentParent.Shared).Symbol.named("Nil")
local t1 = {}

local function tryPropertyName(p1, p2) -- line: 33
	return p1[p2]
end
local function getDefaultInstanceProperty(p3, p4) -- line: 37
	-- upvalues: t1 (copy), v2 (copy), tryPropertyName (copy)
	local v10 = t1[p3]

	if v10 then
		local v11 = v10[p4]

		if v11 == v2 then
			return true, nil
		end

		if v11 ~= nil then
			return true, v11
		end
	else
		v10 = {}
		t1[p3] = v10
	end

	local v12 = Instance.new(p3)
	local ok, result = pcall(tryPropertyName, v12, p4)

	v12:Destroy()

	if ok then
		if result == nil then
			v10[p4] = v2

			return ok, result
		end

		v10[p4] = result
	end

	return ok, result
end

return getDefaultInstanceProperty
