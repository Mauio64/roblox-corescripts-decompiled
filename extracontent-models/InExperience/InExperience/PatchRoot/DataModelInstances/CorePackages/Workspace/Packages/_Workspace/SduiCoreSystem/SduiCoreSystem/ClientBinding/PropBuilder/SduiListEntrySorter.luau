local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local parent = SduiCoreSystem.Parent
require(parent.Signals)

local buildDataBindingSourcesForTemplate = require(SduiCoreSystem.ClientBinding.buildDataBindingSourcesForTemplate)
require(SduiCoreSystem.SduiBuilderTypes)
local SduiClientBindingTypes = require(SduiCoreSystem.ClientBinding.SduiClientBindingTypes)
local SduiClientBindingBuilder = require(SduiCoreSystem.ClientBinding.SduiClientBindingBuilder)
require(SduiCoreSystem.ClientBinding.PropBuilder.SduiListEntryNormalizer)

local PropResultCategory = SduiClientBindingTypes.PropResultCategory

local v = {}

local function resolvePropToValue(p, p2, p3, p4, p5, p6)
	if p == nil or p.kind == nil then
		return nil
	end

	local prop, v2 = SduiClientBindingBuilder.buildProp(p, p2, p3, p4, p5)

	if v2 ~= PropResultCategory.PropSignal or prop == nil then
		return prop
	end

	local v3 = prop(p6)
	return v3 and v3.data
end

local function resolveOrderedIdentifiers(p, p2, p3, p4, p5, p6)
	if p == nil or p.kind == nil then
		return nil
	end

	local v2, v3 = SduiClientBindingBuilder.buildProp(p, p3, p4, p5, p6)

	if v3 == PropResultCategory.PropSignal and v2 ~= nil then
		v2 = v2(p2)

		if v2 then
			return v2.data
		end
	end

	return v2
end

local function resolveItemSortRank(sortRankProp, item, template, p, p2, p3)
	if sortRankProp == nil or sortRankProp.kind == nil then
		return nil
	end

	local kind = template and template.kind
	local value = kind and kind.value

	local data = value and value.shared and value.shared.data

	if typeof(item) ~= "table" then
		item = v
	end

	local dataBindingSourcesForTemplate = buildDataBindingSourcesForTemplate(item, data or v)

	local function sourcesGetter()
		return dataBindingSourcesForTemplate
	end

	local function itemInputGetter()
		return item
	end

	local success, result = pcall(resolvePropToValue, sortRankProp, sourcesGetter, itemInputGetter, p, p2, p3)

	if success then
		return (tonumber(result))
	end

	return nil
end

local function compareEntryRank(p, p2): boolean
	if p.rank == p2.rank then
		return p.originalIndex < p2.originalIndex
	end

	return p.rank ~= nil and (p2.rank == nil or p.rank < p2.rank)
end

return {
	applyOrder = function(list, p, p2, p3, p4, p5, p6)
		local v2

		if not (p == nil or p.kind == nil) then
			local v3
			v2, v3 = SduiClientBindingBuilder.buildProp(p, p3, p4, p5, p6)

			if v3 == PropResultCategory.PropSignal and v2 ~= nil then
				local v4 = v2(p2)
				v2 = v4 and v4.data
			end
		end

		if v2 then
			local v3 = {}

			for _, item in list do
				if item.identifier then
					v3[item.identifier] = item
				end
			end

			list = {}

			for _, v4 in v2 do
				if v3[v4] then
					table.insert(list, v3[v4])
				end
			end
		end

		local v3 = false

		for _, item in list do
			if item.sortRankProp ~= nil then
				v3 = true
				break
			end
		end

		if not v3 then
			return list
		end

		local v4 = {}

		for k, item in list do
			if item.template then
				v4[k] = resolveItemSortRank(item.sortRankProp, item.item, item.template, p5, p6, p2)
			end
		end

		local v5 = {}

		for k, item in list do
			table.insert(v5, { entry = item, rank = v4[k], originalIndex = k })
		end

		table.sort(v5, compareEntryRank)

		local entries = {}

		for _, v6 in v5 do
			table.insert(entries, v6.entry)
		end

		return entries
	end
}
