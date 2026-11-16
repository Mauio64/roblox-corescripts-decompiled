local CrossExperience = script:FindFirstAncestor("CrossExperience")
local dependencies = require(CrossExperience.dependencies)

local cryo = dependencies.Cryo

return function(p)
	local result = {}

	if p == nil then
		return result
	end

	local keys = cryo.Dictionary.keys(p)

	for _, key in ipairs(keys) do
		local v = tonumber(key)

		if v then
			result[v] = p[key]
		end
	end

	return result
end
