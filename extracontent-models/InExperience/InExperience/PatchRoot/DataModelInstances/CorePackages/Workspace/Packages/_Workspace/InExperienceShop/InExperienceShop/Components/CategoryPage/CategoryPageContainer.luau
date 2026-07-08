local Parent = script:FindFirstAncestor("InExperienceShop").Parent
local React = require(Parent.React)
local CategoryPageView = require(script.Parent.CategoryPageView)
local useCategoryPageViewModel = require(script.Parent.useCategoryPageViewModel)

local function CategoryPageContainer(p1) -- line: 10
	-- upvalues: useCategoryPageViewModel (copy), React (copy), CategoryPageView (copy)
	local v7 = useCategoryPageViewModel(p1)

	return React.createElement(CategoryPageView, v7)
end

return CategoryPageContainer
