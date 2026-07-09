local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent

require(SduiCoreSystemParent.Signals)

local buildDataBindingSourcesForTemplate = require(SduiCoreSystem.ClientBinding.buildDataBindingSourcesForTemplate)

require(SduiCoreSystem.SduiBuilderTypes)

local SduiClientBindingTypes = require(SduiCoreSystem.ClientBinding.SduiClientBindingTypes)
local SduiClientBindingBuilder = require(SduiCoreSystem.ClientBinding.SduiClientBindingBuilder)

require(SduiCoreSystem.ClientBinding.PropBuilder.SduiListEntryNormalizer)

local PropResultCategory = SduiClientBindingTypes.PropResultCategory
local t1 = {}

local function resolvePropToValue(p1, p2, p3, p4, p5, p6) -- line: 39
	-- upvalues: SduiClientBindingBuilder (copy), PropResultCategory (copy)
	if p1 == nil or p1.kind == nil then
		return nil
	end

	local v18, v19 = SduiClientBindingBuilder.buildProp(p1, p2, p3, p4, p5)

	if v19 == PropResultCategory.PropSignal and v18 ~= nil then
		local v20 = v18(p6)

		return v20 and v20.data
	end

	return v18
end
local function resolveOrderedIdentifiers(p7, p8, p9, p10, p11, p12) -- line: 67
	-- upvalues: SduiClientBindingBuilder (copy), PropResultCategory (copy)
	if p7 == nil or p7.kind == nil then
		return nil
	end

	local v27, v28 = SduiClientBindingBuilder.buildProp(p7, p9, p10, p11, p12)

	if v28 == PropResultCategory.PropSignal and v27 ~= nil then
		v27 = v27(p8)

		if v27 then
			return v27.data
		end
	end

	return v27
end
local function resolveItemSortRank(p13, p14, p15, p16, p17, p18) -- line: 99
	-- upvalues: t1 (copy), buildDataBindingSourcesForTemplate (copy), resolvePropToValue (copy)
	if p13 == nil or p13.kind == nil then
		return nil
	end

	local v35 = p15 and p15.kind
	local v36 = v35 and v35.value
	local v37 = v36 and (v36.shared and v36.shared.data)
	local v38 = if typeof(p14) ~= "table" then t1 else p14
	local v39 = buildDataBindingSourcesForTemplate(v38, v37 or t1)

	local function sourcesGetter() -- line: 131
		-- upvalues: v39 (copy)
		return v39
	end
	local function itemInputGetter() -- line: 134
		-- upvalues: v38 (copy)
		return v38
	end

	local ok, result = pcall(resolvePropToValue, p13, sourcesGetter, itemInputGetter, p16, p17, p18)

	if not ok then
		return nil
	end

	return (tonumber(result))
end
local function compareEntryRank(p19, p20) -- line: 152
	if p19.rank == p20.rank then
		return p19.originalIndex < p20.originalIndex
	end

	if p19.rank == nil then
		return false
	end

	if p20.rank == nil then
		return true
	end

	return p19.rank < p20.rank
end

return {
	applyOrder = function(t2: {[any]: any}, p21, p22, p23, p24, p25, p26) -- line: 182
		-- upvalues: SduiClientBindingBuilder (copy), PropResultCategory (copy), resolveItemSortRank (copy), compareEntryRank (copy)
		local v53

		if p21 == nil or p21.kind == nil then
			v53 = nil
		else
			local v54

			v53, v54 = SduiClientBindingBuilder.buildProp(p21, p23, p24, p25, p26)

			if v54 == PropResultCategory.PropSignal and v53 ~= nil then
				local v55 = v53(p22)

				v53 = v55 and v55.data
			end
		end

		if v53 then
			local t3 = {}

			for _, v58 in t2 do
				if v58.identifier then
					t3[v58.identifier] = v58
				end
			end

			t2 = {}

			for _, v60 in v53 do
				if t3[v60] then
					table.insert(t2, t3[v60])
				end
			end
		end

		local v61 = false

		for _, v63 in t2 do
			if v63.sortRankProp ~= nil then
				v61 = true

				break
			end
		end

		if not v61 then
			return t2
		end

		local t4 = {}

		for v65, v66 in t2 do
			if v66.template then
				t4[v65] = resolveItemSortRank(v66.sortRankProp, v66.item, v66.template, p25, p26, p22)
			end
		end

		local t5 = {}

		for v68, v69 in t2 do
			table.insert(t5, {
				entry = v69,
				rank = t4[v68],
				originalIndex = v68
			})
		end

		table.sort(t5, compareEntryRank)

		local t6 = {}

		for _, v72 in t5 do
			table.insert(t6, v72.entry)
		end

		return t6
	end
}
