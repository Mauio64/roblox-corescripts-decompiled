local Parent = script:FindFirstAncestor("InExperienceShop").Parent
local React = require(Parent.React)
local SearchResultsView = require(script.Parent.SearchResultsView)
local useSearchResultsViewModel = require(script.Parent.useSearchResultsViewModel)

local function SearchResultsContainer(p1) -- line: 10
	-- upvalues: useSearchResultsViewModel (copy), React (copy), SearchResultsView (copy)
	local v7 = useSearchResultsViewModel(p1)

	return React.createElement(SearchResultsView, v7)
end

return SearchResultsContainer
