local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local React = require(parent.React)
local AppCommonLib = require(parent.AppCommonLib)
local Signal = AppCommonLib.Signal

local CategorySection = require(InExperienceShop.Components.CategorySection)
local FFlagEnableInExperienceShopUnifiedLogging = require(InExperienceShop.Flags.FFlagEnableInExperienceShopUnifiedLogging)
local FFlagEnableCategoryLoggingInShop = require(InExperienceShop.Flags.FFlagEnableCategoryLoggingInShop)
local FFlagEnableShopRobuxBuyTelemetry = require(InExperienceShop.Flags.FFlagEnableShopRobuxBuyTelemetry)
require(InExperienceShop.Types)

require(script.Parent.ShopHomePageView)

local function useShopHomePageViewModel(data)
	local itemsPerRow = data.itemsPerRow
	local v = React.useMemo(function()
		if FFlagEnableInExperienceShopUnifiedLogging then
			return Signal.new()
		end

		return nil
	end, {})

	local onScroll = React.useCallback(function(_)
		if FFlagEnableInExperienceShopUnifiedLogging and v then
			v:fire()
		end
	end, { v })

	local renderItem = React.useCallback(function(p)
		local item = p.item
		local createElement = React.createElement
		local v2 = {
			sectionId = item.id,
			categoryType = 0,
			stableCategoryId = 0,
			categoryGroup = 0,
			categoryName = 0,
			title = 0,
			items = 0,
			robuxPackages = 0,
			featuredRobuxPackage = 0,
			paymentSessionId = 0,
			bonusJwt = 0,
			itemsPerRow = 0,
			onCategoryActivated = 0,
			onItemActivated = 0,
			isPageVisible = 0,
			scrollImpressionsSignal = 0,
			LayoutOrder = 0
		}
		local categoryType

		if FFlagEnableCategoryLoggingInShop or FFlagEnableShopRobuxBuyTelemetry then
			categoryType = item.categoryType
		end

		v2.categoryType = categoryType
		local stableCategoryId

		if FFlagEnableCategoryLoggingInShop then
			stableCategoryId = item.stableCategoryId
		end

		v2.stableCategoryId = stableCategoryId
		local categoryGroup

		if FFlagEnableCategoryLoggingInShop then
			categoryGroup = item.categoryGroup
		end

		v2.categoryGroup = categoryGroup
		local categoryName

		if FFlagEnableCategoryLoggingInShop then
			categoryName = item.name
		end

		v2.categoryName = categoryName
		v2.title = item.name
		v2.items = item.items
		v2.robuxPackages = item.robuxPackages
		v2.featuredRobuxPackage = item.featuredRobuxPackage
		v2.paymentSessionId = item.paymentSessionId
		v2.bonusJwt = item.bonusJwt
		v2.itemsPerRow = itemsPerRow
		v2.onCategoryActivated = data.onCategoryActivated
		v2.onItemActivated = data.onItemActivated
		v2.isPageVisible = data.Visible ~= false
		local scrollImpressionsSignal

		if FFlagEnableInExperienceShopUnifiedLogging then
			scrollImpressionsSignal = v
		end

		v2.scrollImpressionsSignal = scrollImpressionsSignal

		v2.LayoutOrder = p.index
		return createElement(CategorySection, v2)
	end, { itemsPerRow, data.onCategoryActivated, data.onItemActivated, data.Visible, v })

	local keyExtractor = React.useCallback(function(p)
		return p.id
	end, {})

	local v2 = {
		data = data.sections,
		renderItem = renderItem,
		keyExtractor = keyExtractor,
		LayoutOrder = data.LayoutOrder,
		Visible = data.Visible,
		onScroll = 0
	}

	if not FFlagEnableInExperienceShopUnifiedLogging then
		onScroll = nil
	end

	v2.onScroll = onScroll
	return v2
end

return useShopHomePageViewModel
