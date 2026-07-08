local CrossExperience = script:FindFirstAncestor("CrossExperience")
local Cryo = require(CrossExperience.dependencies).Cryo

return function(p1) -- line: 6
	-- upvalues: Cryo (copy)
	local t1 = {}

	if p1 ~= nil then
		local v5 = Cryo.Dictionary.keys(p1)

		for _, v in ipairs(v5) do
			local num = tonumber(v)

			if num then
				t1[num] = p1[v]
			end
		end
	end

	return t1
end
