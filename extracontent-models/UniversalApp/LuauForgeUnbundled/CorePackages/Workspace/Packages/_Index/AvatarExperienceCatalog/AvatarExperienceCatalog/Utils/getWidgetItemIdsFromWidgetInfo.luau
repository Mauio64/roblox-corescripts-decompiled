require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/ResultsList/WidgetListInfoViewModel")

local function getWidgetItemIdsFromWidgetInfo(p2, p3)
	local ids = {}

	if not (p2 and p2.content) then
		return ids
	end

	local content = p2.content

	for i = 1, math.min(#content, p3) do
		local v5 = content[i]

		if v5 ~= nil and v5.id ~= nil then
			table.insert(ids, (tostring(v5.id)))
		end
	end

	return ids
end

return getWidgetItemIdsFromWidgetInfo
