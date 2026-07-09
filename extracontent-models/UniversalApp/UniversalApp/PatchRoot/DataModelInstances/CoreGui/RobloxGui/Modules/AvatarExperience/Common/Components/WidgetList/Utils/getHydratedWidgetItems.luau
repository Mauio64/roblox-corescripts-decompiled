local CorePackages = game:GetService("CorePackages")

require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)

local Cryo = require(CorePackages.Packages.Cryo)

local function sortWidgetIndexes(t1: {[any]: any}) -- line: 30
	-- upvalues: Cryo (copy)
	local v10 = Cryo.List.filter(Cryo.Dictionary.keys(t1), function(p1) -- line: 31
		return tonumber(p1) ~= nil
	end)
	local v11 = Cryo.List.map(v10, function(p2) -- line: 35
		return (tonumber(p2))
	end)

	table.sort(v11)

	return v11
end
local function flattenHydratedContent(t2: {[any]: any}) -- line: 44
	local t3 = {}

	for _, v15 in t2 do
		for v16, v17 in v15 do
			t3[tostring(v16)] = v17
		end
	end

	return t3
end
local function getItemsForWidget(p3, t4: {[any]: any}) -- line: 55
	-- upvalues: Cryo (copy)
	if not p3 then
		return nil
	end

	local v20 = Cryo.List.map(p3.content, function(p4) -- line: 60
		-- upvalues: t4 (copy)
		return t4[tostring(p4.id)]
	end)

	return (Cryo.List.filter(v20, function(p5) -- line: 64
		return p5 ~= nil
	end))
end
local function buildHydratedItemsForAllWidgets(t5: {[any]: any}, t6: {[any]: any}, t7: {[any]: any}) -- line: 74
	-- upvalues: getItemsForWidget (copy)
	local t8 = {}

	for _, v26 in t6 do
		local v27 = t5[tostring(v26)]
		local v28 = getItemsForWidget(v27, t7)

		if v28 and #v28 > 0 then
			table.insert(t8, {
				id = tostring(v27.id),
				items = v28
			})
		end
	end

	return t8
end
local function getSelectedWidgetItems(t9: {[any]: any}, n1: number) -- line: 97
	local v31 = t9[n1]

	if v31 then
		return {
			[v31.id] = v31.items
		}
	end

	return nil
end
local function getHydratedWidgetItems(t10: {[any]: any}) -- line: 118
	-- upvalues: flattenHydratedContent (copy), sortWidgetIndexes (copy), buildHydratedItemsForAllWidgets (copy)
	local hydratedWidgetData = t10.hydratedWidgetData
	local widgetInfoDetails = t10.widgetInfoDetails
	local selectedWidgetIndex = t10.selectedWidgetIndex

	if not widgetInfoDetails or (not hydratedWidgetData or not next(hydratedWidgetData)) then
		return nil
	end

	local v36 = flattenHydratedContent(hydratedWidgetData)
	local v37 = sortWidgetIndexes(widgetInfoDetails)

	if not v37 or #v37 == 0 then
		return nil
	end

	if selectedWidgetIndex and selectedWidgetIndex > #v37 then
		return nil
	end

	local v38 = buildHydratedItemsForAllWidgets(widgetInfoDetails, v37, v36)

	if selectedWidgetIndex then
		local v39 = v38[selectedWidgetIndex]

		if v39 then
			return {
				[v39.id] = v39.items
			}
		end

		return nil
	end

	local t11 = {}

	for _, v42 in v38 do
		t11[v42.id] = v42.items
	end

	return t11
end

return getHydratedWidgetItems
