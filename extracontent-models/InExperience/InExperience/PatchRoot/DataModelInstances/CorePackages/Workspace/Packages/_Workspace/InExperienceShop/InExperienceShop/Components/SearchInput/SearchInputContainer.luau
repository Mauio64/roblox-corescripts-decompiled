local parent = script:FindFirstAncestor("InExperienceShop").Parent
local React = require(parent.React)

local SearchInputView = require(script.Parent.SearchInputView)
local useSearchInputViewModel = require(script.Parent.useSearchInputViewModel)

local function SearchInputContainer(p)
	local v = useSearchInputViewModel(p)
	return React.createElement(SearchInputView, v)
end

return SearchInputContainer
