local Parent = script:FindFirstAncestor("InExperienceShop").Parent
local React = require(Parent.React)
local ShopHomePageView = require(script.Parent.ShopHomePageView)
local useShopHomePageViewModel = require(script.Parent.useShopHomePageViewModel)

local function ShopHomePageContainer(p1) -- line: 10
	-- upvalues: useShopHomePageViewModel (copy), React (copy), ShopHomePageView (copy)
	local v7 = useShopHomePageViewModel(p1)

	return React.createElement(ShopHomePageView, v7)
end

return React.memo(ShopHomePageContainer)
