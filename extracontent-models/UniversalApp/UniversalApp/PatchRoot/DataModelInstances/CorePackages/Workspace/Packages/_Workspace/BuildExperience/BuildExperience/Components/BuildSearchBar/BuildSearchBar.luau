local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local SearchInput = Foundation.SearchInput
local View = Foundation.View
local GetSearchQueryStore = require(BuildExperience.Stores.GetSearchQueryStore)

require(BuildExperience.Stores.GetSearchQueryStore.createSearchQueryStore)

local function BuildSearchBar(t1: {[any]: any}) -- line: 20
	-- upvalues: GetSearchQueryStore (copy), React (copy), View (copy), SearchInput (copy)
	local v10 = t1.store or GetSearchQueryStore()
	local v11 = v10.useDraftQuery()
	local v12 = React.useCallback(function(s1: string) -- line: 28
		-- upvalues: v10 (copy)
		if s1 == "" then
			v10.clear()

			return
		end

		v10.setQuery(s1)
	end, { v10 })

	return React.createElement(View, {
		tag = "size-full-0 auto-y",
		testId = "build-search-bar",
		LayoutOrder = t1.LayoutOrder
	}, {
		Input = React.createElement(SearchInput, {
			placeholder = "Search games",
			testId = "build-search-bar-input",
			text = v11,
			onChanged = v12,
			width = UDim.new(1, 0)
		})
	})
end

return BuildSearchBar
