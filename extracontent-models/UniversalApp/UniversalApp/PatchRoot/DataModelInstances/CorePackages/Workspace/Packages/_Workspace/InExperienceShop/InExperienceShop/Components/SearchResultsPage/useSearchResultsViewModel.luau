local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local InExperienceShopParent = InExperienceShop.Parent
local React = require(InExperienceShopParent.React)
local Constants = require(InExperienceShop.Constants)

require(InExperienceShop.Types)

local FFlagShopUseFuzzySearch = require(InExperienceShop.Flags.FFlagShopUseFuzzySearch)

require(script.Parent.SearchResultsView)

local searchMatchers = require(script.Parent.searchMatchers)
local t1 = {}

local function compositeKey(p1) -- line: 37
	return p1.id .. "|" .. tostring(p1.itemType)
end
local function collectUniqueItems(t2: {[any]: any}) -- line: 41
	local t3 = {}
	local t4 = {}

	for _, v17 in t2 do
		for _, v19 in v17.items do
			local v20 = v19.id .. "|" .. tostring(v19.itemType)

			if not t3[v20] then
				t3[v20] = true
				table.insert(t4, v19)
			end
		end
	end

	return t4
end
local function computeState(s1: string, n1: number) -- line: 58
	if s1 == "" then
		return "hint"
	end

	if n1 == 0 then
		return "empty"
	end

	return "results"
end
local function useSearchResultsViewModel(t5: {[any]: any}) -- line: 68
	-- upvalues: React (copy), collectUniqueItems (copy), FFlagShopUseFuzzySearch (copy), searchMatchers (copy), Constants (copy), t1 (copy)
	local committedQuery = t5.committedQuery
	local sections = t5.sections
	local v26 = React.useMemo(function() -- line: 72
		-- upvalues: committedQuery (copy), collectUniqueItems (copy), sections (copy), FFlagShopUseFuzzySearch (copy), searchMatchers (copy), Constants (copy)
		if committedQuery == "" then
			return {}
		end

		local v33 = collectUniqueItems(sections)

		return ((if not FFlagShopUseFuzzySearch then searchMatchers.substringMatch else searchMatchers.fuzzyMatch))(v33, committedQuery, Constants.MAX_SEARCH_RESULTS)
	end, {
		sections,
		committedQuery
	})
	local v27 = math.min(t5.itemsPerRow, Constants.ITEMS_PER_SECTION)
	local itemsPerRow = t5.itemsPerRow
	local v29 = React.useMemo(function() -- line: 86
		-- upvalues: v26 (copy), t1 (copy), v27 (copy)
		if #v26 == 0 then
			return t1
		end

		local t6 = {}

		for i = 1, #v26, v27 do
			local t7 = {}

			table.move(v26, i, math.min(i + v27 - 1, #v26), 1, t7)
			table.insert(t6, t7)
		end

		return t6
	end, {
		v26,
		v27
	})
	local onItemActivated = t5.onItemActivated
	local v31 = #v29
	local v32 = if committedQuery ~= "" then v31 ~= 0 and "results" or "empty" else "hint"

	return {
		rows = v29,
		columnCount = itemsPerRow,
		onItemActivated = onItemActivated,
		LayoutOrder = t5.LayoutOrder,
		state = v32
	}
end

return useSearchResultsViewModel
