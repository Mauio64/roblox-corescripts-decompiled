local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local React = require(parent.React)

local Constants = require(InExperienceShop.Constants)
require(InExperienceShop.Types)
local FFlagShopUseFuzzySearch = require(InExperienceShop.Flags.FFlagShopUseFuzzySearch)

require(script.Parent.SearchResultsView)
local searchMatchers = require(script.Parent.searchMatchers)

local v = {}

local function compositeKey(item) -- 1 equivalent call inferred from this helper
	return item.id .. "|" .. tostring(item.itemType)
end

local function collectUniqueItems(sections)
	local set = {}
	local uniqueItems = {}

	for _, item in sections do
		for _, item2 in item.items do
			local v2 = compositeKey(item2) -- inferred equivalent call

			if set[v2] then
				continue
			end

			set[v2] = true
			table.insert(uniqueItems, item2)
		end
	end

	return uniqueItems
end

local function computeState(committedQuery: string, p: number): string -- 1 equivalent call inferred from this helper
	if committedQuery == "" then
		return "hint"
	end

	return if p == 0 then "empty" else "results"
end

local function useSearchResultsViewModel(data)
	local committedQuery = data.committedQuery
	local sections = data.sections

	local v2 = React.useMemo(function()
		if committedQuery == "" then
			return {}
		end

		local v2 = collectUniqueItems(sections)
		local v3

		if FFlagShopUseFuzzySearch then
			v3 = searchMatchers.fuzzyMatch
		else
			v3 = searchMatchers.substringMatch
		end

		return v3(v2, committedQuery, Constants.MAX_SEARCH_RESULTS)
	end, { sections, committedQuery })

	local v3 = math.min(data.itemsPerRow, Constants.ITEMS_PER_SECTION)
	local itemsPerRow = data.itemsPerRow

	local rows = React.useMemo(function()
		if #v2 == 0 then
			return v
		end

		local result = {}

		for i = 1, #v2, v3 do
			local v4 = {}
			table.move(v2, i, math.min(i + v3 - 1, #v2), 1, v4)
			table.insert(result, v4)
		end

		return result
	end, { v2, v3 })

	local onItemActivated = data.onItemActivated

	local state = computeState(committedQuery, #rows) -- inferred equivalent call

	return {
		rows = rows,
		columnCount = itemsPerRow,
		onItemActivated = onItemActivated,
		LayoutOrder = data.LayoutOrder,
		state = state
	}
end

return useSearchResultsViewModel
