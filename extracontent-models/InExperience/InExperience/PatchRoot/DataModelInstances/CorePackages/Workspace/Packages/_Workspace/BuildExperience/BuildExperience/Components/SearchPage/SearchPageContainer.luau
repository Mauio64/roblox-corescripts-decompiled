local parent = script:FindFirstAncestor("BuildExperience").Parent

local React = require(parent.React)

local SearchPageView = require(script.Parent.SearchPageView)
local useSearchPageViewModel = require(script.Parent.useSearchPageViewModel)

local function SearchPageContainer(p, p2)
	local v = useSearchPageViewModel(p, p2)
	return React.createElement(SearchPageView, v)
end

return React.forwardRef(SearchPageContainer)
