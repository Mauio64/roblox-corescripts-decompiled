local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local SearchInput = Foundation.SearchInput
local View = Foundation.View
local GetSearchQueryStore = require(BuildExperience.Stores.GetSearchQueryStore)

require(BuildExperience.Stores.GetSearchQueryStore.createSearchQueryStore)

local function BuildSearchBar(t1: {[any]: any}) -- line: 21
	-- upvalues: GetSearchQueryStore (copy), React (copy), View (copy), SearchInput (copy), LocalizationStrings (copy)
	local v11 = t1.store or GetSearchQueryStore()
	local v12 = v11.useDraftQuery()
	local v13 = React.useCallback(function(s1: string) -- line: 29
		-- upvalues: v11 (copy)
		if s1 == "" then
			v11.clear()

			return
		end

		v11.setQuery(s1)
	end, { v11 })

	return React.createElement(View, {
		tag = "size-full-0 auto-y",
		testId = "build-search-bar",
		LayoutOrder = t1.LayoutOrder
	}, {
		Input = React.createElement(SearchInput, {
			testId = "build-search-bar-input",
			text = v12,
			placeholder = LocalizationStrings.BUILD_SEARCH_PLACEHOLDER,
			onChanged = v13,
			width = UDim.new(1, 0)
		})
	})
end

return BuildSearchBar
