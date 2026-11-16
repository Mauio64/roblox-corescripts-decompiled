local CorePackages = game:GetService("CorePackages")
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
local Cryo = require(CorePackages.Packages.Cryo)

local function sortWidgetIndexes(widgetInfoDetails)
	local filtered = Cryo.List.filter(Cryo.Dictionary.keys(widgetInfoDetails), function(p2): boolean
		return tonumber(p2) ~= nil
	end)

	local mapped = Cryo.List.map(filtered, function(p2)
		return (tonumber(p2))
	end)

	table.sort(mapped)
	return mapped
end

local function flattenHydratedContent(hydratedWidgetData)
	local result = {}

	for k, item in hydratedWidgetData do
		for k2, v5 in item do
			result[tostring(k2)] = v5
		end
	end

	return result
end

local function getItemsForWidget(p2, p3)
	if not p2 then
		return nil
	end

	local mapped = Cryo.List.map(p2.content, function(p4)
		return p3[tostring(p4.id)]
	end)

	return (Cryo.List.filter(mapped, function(p4): boolean
		return p4 ~= nil
	end))
end

local function buildHydratedItemsForAllWidgets(widgetInfoDetails, items, p2)
	local hydratedItemsForAllWidgets = {}

	for k, item in items do
		local v5 = widgetInfoDetails[tostring(item)]
		local itemsForWidget = getItemsForWidget(v5, p2)

		if itemsForWidget and #itemsForWidget > 0 then
			table.insert(hydratedItemsForAllWidgets, {
				id = tostring(v5.id),
				items = itemsForWidget
			})
		end
	end

	return hydratedItemsForAllWidgets
end

local function getSelectedWidgetItems(p2, p3)
	local v5 = p2[p3]

	if not v5 then
		return nil
	end

	return { [v5.id] = v5.items }
end

local function getHydratedWidgetItems(data)
	local hydratedWidgetData = data.hydratedWidgetData
	local widgetInfoDetails = data.widgetInfoDetails
	local selectedWidgetIndex = data.selectedWidgetIndex

	if not (widgetInfoDetails and hydratedWidgetData and next(hydratedWidgetData)) then
		return nil
	end

	local v5 = flattenHydratedContent(hydratedWidgetData)
	local v6 = sortWidgetIndexes(widgetInfoDetails)

	if not v6 or #v6 == 0 or selectedWidgetIndex and #v6 < selectedWidgetIndex then
		return nil
	end

	local hydratedItemsForAllWidgets = buildHydratedItemsForAllWidgets(widgetInfoDetails, v6, v5)

	if selectedWidgetIndex then
		local hydratedItemsForAllWidget = hydratedItemsForAllWidgets[selectedWidgetIndex]

		if not hydratedItemsForAllWidget then
			return nil
		end

		return { [hydratedItemsForAllWidget.id] = hydratedItemsForAllWidget.items }
	else
		local itemsById = {}

		for k, hydratedItemsForAllWidget in hydratedItemsForAllWidgets do
			itemsById[hydratedItemsForAllWidget.id] = hydratedItemsForAllWidget.items
		end

		return itemsById
	end
end

return getHydratedWidgetItems
