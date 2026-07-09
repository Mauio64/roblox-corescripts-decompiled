local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local FStringAXBackendDrivenCatalogLayersNames = require(Parent.AvatarExperienceFlags).FStringAXBackendDrivenCatalogLayersNames

return function() -- line: 6
	-- upvalues: FStringAXBackendDrivenCatalogLayersNames (copy)
	local v3 = FStringAXBackendDrivenCatalogLayersNames()

	if not v3 or v3 == "" then
		return nil
	end

	local t1 = {}

	for _, v6 in (string.split(v3, ",")) do
		local v7 = string.gsub(v6, "^%s*(.-)%s*$", "%1")

		if v7 ~= "" and string.len(v7) <= 200 then
			table.insert(t1, v7)
		end
	end

	return #t1 > 0 and t1 or nil
end
