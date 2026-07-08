local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local InExperienceShopParent = InExperienceShop.Parent
local React = require(InExperienceShopParent.React)
local Signal = require(InExperienceShopParent.AppCommonLib).Signal
local CategorySection = require(InExperienceShop.Components.CategorySection)
local FFlagEnableInExperienceShopUnifiedLogging = require(InExperienceShop.Flags.FFlagEnableInExperienceShopUnifiedLogging)

require(InExperienceShop.Types)
require(script.Parent.ShopHomePageView)

local function useShopHomePageViewModel(t1: {[any]: any}) -- line: 32
	-- upvalues: React (copy), FFlagEnableInExperienceShopUnifiedLogging (copy), Signal (copy), CategorySection (copy)
	local itemsPerRow = t1.itemsPerRow
	local v10 = React.useMemo(function() -- line: 34
		-- upvalues: FFlagEnableInExperienceShopUnifiedLogging (copy), Signal (copy)
		if not FFlagEnableInExperienceShopUnifiedLogging then
			return nil
		end

		return Signal.new()
	end, {})
	local v11 = React.useCallback(function(_) -- line: 41
		-- upvalues: FFlagEnableInExperienceShopUnifiedLogging (copy), v10 (copy)
		if FFlagEnableInExperienceShopUnifiedLogging and v10 then
			v10:fire()
		end
	end, { v10 })
	local v12 = React.useCallback(function(p2) -- line: 48
		-- upvalues: React (copy), CategorySection (copy), itemsPerRow (copy), t1 (copy), FFlagEnableInExperienceShopUnifiedLogging (copy), v10 (copy)
		local item = p2.item

		return React.createElement(CategorySection, {
			sectionId = item.id,
			title = item.name,
			items = item.items,
			robuxPackages = item.robuxPackages,
			featuredRobuxPackage = item.featuredRobuxPackage,
			paymentSessionId = item.paymentSessionId,
			itemsPerRow = itemsPerRow,
			onCategoryActivated = t1.onCategoryActivated,
			onItemActivated = t1.onItemActivated,
			isPageVisible = t1.Visible ~= false,
			scrollImpressionsSignal = if not FFlagEnableInExperienceShopUnifiedLogging then nil else v10,
			LayoutOrder = p2.index
		})
	end, {
		itemsPerRow,
		t1.onCategoryActivated,
		t1.onItemActivated,
		t1.Visible,
		v10
	})
	local v13 = React.useCallback(function(p3) -- line: 76
		return p3.id
	end, {})

	return {
		data = t1.sections,
		renderItem = v12,
		keyExtractor = v13,
		LayoutOrder = t1.LayoutOrder,
		Visible = t1.Visible,
		onScroll = if not FFlagEnableInExperienceShopUnifiedLogging then nil else v11
	}
end

return useShopHomePageViewModel
