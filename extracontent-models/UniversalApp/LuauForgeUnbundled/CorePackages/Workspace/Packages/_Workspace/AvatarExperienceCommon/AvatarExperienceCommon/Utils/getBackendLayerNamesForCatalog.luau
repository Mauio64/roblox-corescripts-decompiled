local fStringAXBackendDrivenCatalogLayersNames = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceFlags").FStringAXBackendDrivenCatalogLayersNames

return function()
	local v5 = fStringAXBackendDrivenCatalogLayersNames()

	if not v5 or v5 == "" then
		return nil
	end

	local v6 = string.split(v5, ",")
	local v7 = {}

	for k, v8 in v6 do
		local v9 = string.gsub(v8, "^%s*(.-)%s*$", "%1")

		if v9 ~= "" and string.len(v9) <= 200 then
			table.insert(v7, v9)
		end
	end

	return #v7 > 0 and v7 or nil
end
