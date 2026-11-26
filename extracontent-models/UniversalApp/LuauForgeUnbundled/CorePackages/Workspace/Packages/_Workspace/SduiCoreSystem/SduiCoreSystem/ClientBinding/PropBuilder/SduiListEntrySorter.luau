require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/Signals")

local buildDataBindingSourcesForTemplate = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/buildDataBindingSourcesForTemplate")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiBuilderTypes")
local SduiClientBindingTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/SduiClientBindingTypes")
local SduiClientBindingBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/SduiClientBindingBuilder")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/PropBuilder/SduiListEntryNormalizer")

local propResultCategory = SduiClientBindingTypes.PropResultCategory

local v5 = {}

local function resolvePropToValue(p2, p3, p4, p5, p6, p7)
	if p2 == nil or p2.kind == nil then
		return nil
	end

	local prop, v6 = SduiClientBindingBuilder.buildProp(p2, p3, p4, p5, p6)

	if v6 ~= propResultCategory.PropSignal or prop == nil then
		return prop
	end

	local v7 = prop(p7)
	return v7 and v7.data
end

local function resolveOrderedIdentifiers(p2, p3, p4, p5, p6, p7)
	if p2 == nil or p2.kind == nil then
		return nil
	end

	local v6, v7 = SduiClientBindingBuilder.buildProp(p2, p4, p5, p6, p7)

	if v7 == propResultCategory.PropSignal and v6 ~= nil then
		v6 = v6(p3)

		if v6 then
			return v6.data
		end
	end

	return v6
end

local function resolveItemSortRank(sortRankProp, item, template, p2, p3, p4)
	if sortRankProp == nil or sortRankProp.kind == nil then
		return nil
	end

	local kind = template and template.kind
	local value = kind and kind.value

	local data = value and value.shared and value.shared.data

	if typeof(item) ~= "table" then
		item = v5
	end

	local v6 = buildDataBindingSourcesForTemplate(item, data or v5)

	local function sourcesGetter()
		return v6
	end

	local function itemInputGetter()
		return item
	end

	local success, result = pcall(
		resolvePropToValue,
		sortRankProp,
		sourcesGetter,
		itemInputGetter,
		p2,
		p3,
		p4
	)

	if success then
		return (tonumber(result))
	end

	return nil
end

local function compareEntryRank(p2, p3): boolean
	if p2.rank == p3.rank then
		return p2.originalIndex < p3.originalIndex
	end

	if p2.rank == nil then
		return false
	end

	if p3.rank == nil then
		return true
	end

	return p2.rank < p3.rank
end

return {
	applyOrder = function(list, p2, p3, p4, p5, p6, p7)
		local v6

		if not (p2 == nil or p2.kind == nil) then
			local v7
			v6, v7 = SduiClientBindingBuilder.buildProp(p2, p4, p5, p6, p7)

			if v7 == propResultCategory.PropSignal and v6 ~= nil then
				local v8 = v6(p3)
				v6 = v8 and v8.data
			end
		end

		if v6 then
			local v7 = {}

			for k, item in list do
				if item.identifier then
					v7[item.identifier] = item
				end
			end

			list = {}

			for k, v8 in v6 do
				if v7[v8] then
					table.insert(list, v7[v8])
				end
			end
		end

		local v7 = false

		for k, item in list do
			if item.sortRankProp ~= nil then
				v7 = true
				break
			end
		end

		if not v7 then
			return list
		end

		local v9 = {}

		for k, item in list do
			if item.template then
				v9[k] = resolveItemSortRank(item.sortRankProp, item.item, item.template, p6, p7, p3)
			end
		end

		local v10 = {}

		for k, item in list do
			table.insert(v10, { entry = item, rank = v9[k], originalIndex = k })
		end

		table.sort(v10, compareEntryRank)

		local entries = {}

		for k, v11 in v10 do
			table.insert(entries, v11.entry)
		end

		return entries
	end
}
