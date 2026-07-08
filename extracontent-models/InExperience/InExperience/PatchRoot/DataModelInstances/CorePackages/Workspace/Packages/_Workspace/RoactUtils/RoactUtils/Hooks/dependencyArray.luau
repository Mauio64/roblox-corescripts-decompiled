local Parent = script:FindFirstAncestor("RoactUtils").Parent
local v2 = require(Parent.AppCommonLib).Symbol.named("NilDependency")

local function dependencyArray(...) -- line: 22
	-- upvalues: v2 (copy)
	local t1 = {}

	for i = 1, select("#", ...) do
		local v6 = select(i, ...)

		if v6 == nil then
			v6 = v2
		end

		t1[i] = v6
	end

	return t1
end

return dependencyArray
