local parent = script:FindFirstAncestor("InExperienceShop").Parent
local React = require(parent.React)

local SearchResultsView = require(script.Parent.SearchResultsView)
local useSearchResultsViewModel = require(script.Parent.useSearchResultsViewModel)

local function SearchResultsContainer(p)
	local v = useSearchResultsViewModel(p)
	return React.createElement(SearchResultsView, v)
end

return SearchResultsContainer
