local parent = script:FindFirstAncestor("BuildExperience").Parent

local React = require(parent.React)

local SearchBarView = require(script.Parent.SearchBarView)
local useSearchBarViewModel = require(script.Parent.useSearchBarViewModel)

local function SearchBarContainer(p)
	local v = useSearchBarViewModel(p)
	return React.createElement(SearchBarView, v)
end

return SearchBarContainer
