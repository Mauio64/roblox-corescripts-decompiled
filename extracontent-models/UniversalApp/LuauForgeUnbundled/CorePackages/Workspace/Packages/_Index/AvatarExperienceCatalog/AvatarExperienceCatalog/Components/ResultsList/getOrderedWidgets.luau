require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/ResultsList/WidgetListInfoViewModel")

local function getOrderedWidgets(items)
	local v5 = {}

	for k in items do
		local v6 = tonumber(k)

		if v6 then
			table.insert(v5, v6)
		end
	end

	table.sort(v5)

	local orderedWidgets = {}

	for k, v6 in v5 do
		local item = items[tostring(v6)]

		if item.content and #item.content > 0 then
			table.insert(orderedWidgets, { position = v6, widget = item })
		end
	end

	return orderedWidgets
end

return getOrderedWidgets
