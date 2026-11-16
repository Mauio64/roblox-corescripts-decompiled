local parent = script:FindFirstAncestor("SocialCommon").Parent
local React = require(parent.React)

local SearchFieldView = require(script.Parent.SearchFieldView)
local useSearchFieldViewModel = require(script.Parent.useSearchFieldViewModel)

local function SearchField(p)
	local v = useSearchFieldViewModel(p)
	return React.createElement(SearchFieldView, v)
end

return SearchField
