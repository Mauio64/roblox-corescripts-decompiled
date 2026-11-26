require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")

local function isCatalogFeedForeground(p2, p3): boolean
	local name = p2 and p2.opaque and p2.opaque.name

	if name == nil or p3 == nil then
		return true
	end

	return name == p3
end

return isCatalogFeedForeground
