local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")

require(AvatarExperienceCatalog.Components.ResultsList.WidgetListInfoViewModel)

local function getWidgetItemIdsFromWidgetInfo(p, p2: number)
	local ids = {}

	if not (p and p.content) then
		return ids
	end

	local content = p.content

	for i = 1, math.min(#content, p2) do
		local v = content[i]

		if v ~= nil and v.id ~= nil then
			table.insert(ids, (tostring(v.id)))
		end
	end

	return ids
end

return getWidgetItemIdsFromWidgetInfo
