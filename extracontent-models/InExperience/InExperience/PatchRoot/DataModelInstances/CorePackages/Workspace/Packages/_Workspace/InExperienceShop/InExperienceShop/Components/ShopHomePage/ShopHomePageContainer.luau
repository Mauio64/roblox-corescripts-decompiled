local parent = script:FindFirstAncestor("InExperienceShop").Parent
local React = require(parent.React)

local ShopHomePageView = require(script.Parent.ShopHomePageView)
local useShopHomePageViewModel = require(script.Parent.useShopHomePageViewModel)

local function ShopHomePageContainer(p)
	local v = useShopHomePageViewModel(p)
	return React.createElement(ShopHomePageView, v)
end

return React.memo(ShopHomePageContainer)
