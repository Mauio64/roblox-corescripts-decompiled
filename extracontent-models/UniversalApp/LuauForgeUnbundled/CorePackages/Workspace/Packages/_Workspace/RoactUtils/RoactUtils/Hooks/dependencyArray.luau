local named = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/AppCommonLib").Symbol.named("NilDependency")

local function dependencyArray(...)
	local result = {}

	for i = 1, select("#", ...) do
		local v5 = select(i, ...)

		if v5 == nil then
			v5 = named
		end

		result[i] = v5
	end

	return result
end

return dependencyArray
