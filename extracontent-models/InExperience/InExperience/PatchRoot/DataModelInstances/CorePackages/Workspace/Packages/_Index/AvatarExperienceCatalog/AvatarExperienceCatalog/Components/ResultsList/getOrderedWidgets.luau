local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")

require(AvatarExperienceCatalog.Components.ResultsList.WidgetListInfoViewModel)

local function getOrderedWidgets(items)
	local v = {}

	for k in items do
		local v2 = tonumber(k)

		if v2 then
			table.insert(v, v2)
		end
	end

	table.sort(v)

	local orderedWidgets = {}

	for _, position in v do
		local item = items[tostring(position)]

		if item.content and #item.content > 0 then
			table.insert(orderedWidgets, { position = position, widget = item })
		end
	end

	return orderedWidgets
end

return getOrderedWidgets
