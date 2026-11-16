local parent = script:FindFirstAncestor("InExperienceShop").Parent
local React = require(parent.React)

local CategoryPageView = require(script.Parent.CategoryPageView)
local useCategoryPageViewModel = require(script.Parent.useCategoryPageViewModel)

local function CategoryPageContainer(p)
	local v = useCategoryPageViewModel(p)
	return React.createElement(CategoryPageView, v)
end

return CategoryPageContainer
