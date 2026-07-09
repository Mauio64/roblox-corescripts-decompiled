local Parent = script:FindFirstAncestor("InExperienceShop").Parent
local React = require(Parent.React)
local SearchInputView = require(script.Parent.SearchInputView)
local useSearchInputViewModel = require(script.Parent.useSearchInputViewModel)

local function SearchInputContainer(p1) -- line: 10
	-- upvalues: useSearchInputViewModel (copy), React (copy), SearchInputView (copy)
	local v7 = useSearchInputViewModel(p1)

	return React.createElement(SearchInputView, v7)
end

return SearchInputContainer
