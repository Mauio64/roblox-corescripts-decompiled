local cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperience/CrossExperience/dependencies").Cryo

return function(p2)
	local result = {}

	if p2 == nil then
		return result
	end

	local keys = cryo.Dictionary.keys(p2)

	for i, key in ipairs(keys) do
		local v5 = tonumber(key)

		if v5 then
			result[v5] = p2[key]
		end
	end

	return result
end
