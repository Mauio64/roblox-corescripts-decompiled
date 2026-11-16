local parent = script:FindFirstAncestor("RoactUtils").Parent

local AppCommonLib = require(parent.AppCommonLib)
local named = AppCommonLib.Symbol.named("NilDependency")

local function dependencyArray(...)
	local result = {}

	for i = 1, select("#", ...) do
		local v = select(i, ...)

		if v == nil then
			v = named
		end

		result[i] = v
	end

	return result
end

return dependencyArray
