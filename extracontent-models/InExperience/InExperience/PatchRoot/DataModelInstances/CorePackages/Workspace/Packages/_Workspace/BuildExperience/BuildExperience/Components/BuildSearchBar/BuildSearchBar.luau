local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

local SearchInput = Foundation.SearchInput
local View = Foundation.View

local GetSearchQueryStore = require(BuildExperience.Stores.GetSearchQueryStore)
require(BuildExperience.Stores.GetSearchQueryStore.createSearchQueryStore)

local function BuildSearchBar(p)
	local v = useLocalization({ placeholder = LocalizationStrings.BUILD_SEARCH_PLACEHOLDER })

	local store = p.store or GetSearchQueryStore()
	local text = store.useDraftQuery()

	local onChanged = React.useCallback(function(p2: string)
		if p2 == "" then
			store.clear()
		else
			store.setQuery(p2)
		end
	end, { store })

	return React.createElement(
		View,
		{ LayoutOrder = p.LayoutOrder, tag = "size-full-0 auto-y", testId = "build-search-bar" },
		{
			Input = React.createElement(SearchInput, {
				text = text,
				placeholder = v.placeholder,
				onChanged = onChanged,
				width = UDim.new(1, 0),
				testId = "build-search-bar-input"
			})
		}
	)
end

return BuildSearchBar
