require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")

local function getWidgetItemIdsFromWidgetInfo(p2, p3)
	local ids = {}

	if p2 and p2.content then
		for k, v5 in p2.content do
			if v5.id then
				table.insert(ids, v5.id)
			end
		end
	end

	if p3 < #ids then
		ids = table.move(ids, 1, p3, 1, {})
	end

	return ids
end

return getWidgetItemIdsFromWidgetInfo
