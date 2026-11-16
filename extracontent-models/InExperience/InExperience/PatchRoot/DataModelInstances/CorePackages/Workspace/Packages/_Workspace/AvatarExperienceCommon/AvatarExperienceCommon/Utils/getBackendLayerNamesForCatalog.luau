local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FStringAXBackendDrivenCatalogLayersNames = AvatarExperienceFlags.FStringAXBackendDrivenCatalogLayersNames

return function()
	local fStringAXBackendDrivenCatalogLayersNames = FStringAXBackendDrivenCatalogLayersNames()

	if not fStringAXBackendDrivenCatalogLayersNames or fStringAXBackendDrivenCatalogLayersNames == "" then
		return nil
	end

	local v = string.split(fStringAXBackendDrivenCatalogLayersNames, ",")
	local v2 = {}

	for _, v3 in v do
		local v4 = string.gsub(v3, "^%s*(.-)%s*$", "%1")

		if v4 ~= "" and string.len(v4) <= 200 then
			table.insert(v2, v4)
		end
	end

	return #v2 > 0 and v2 or nil
end
