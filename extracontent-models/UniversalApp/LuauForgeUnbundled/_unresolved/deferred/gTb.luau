local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useCallback = React.useCallback
local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)
local fitFrameHorizontal = AvatarExperienceDeps.RoactFitComponents.FitFrameHorizontal
require("@luauforge/bundled/fuM")
local module = require("@luauforge/deferred/gSI")
local module2 = require("@luauforge/deferred/gSJ")

local module3 = require("@luauforge/deferred/gSZ")

return function(props)
	local categories = props.categories
	local slotCategory = props.slotCategory

	React.useEffect(function()
		if categories[slotCategory].hide and props.onSlotCategorySelected then
			for k, category in categories do
				if not category.hide then
					props.onSlotCategorySelected(k, category)
					return
				end
			end
		end
	end, { slotCategory, categories, props.onSlotCategorySelected })

	local v5 = useCallback(function(props2)
		local getScrollingFrameItemRef = props2.getScrollingFrameItemRef
		local elements = {}

		for k, category in categories do
			if category.hide then
				continue
			end

			local v6 = slotCategory == k
			local element = React.createElement(module2, {
				categoryIndex = category.index,
				categoryTitle = category.nameTranslationKey,
				layoutOrder = category.index,
				isSelected = v6,
				frameRef = getScrollingFrameItemRef(k),
				onActivate = function()
					if props.onSlotCategorySelected then
						props.onSlotCategorySelected(k, category)
					end
				end,
				ref = getScrollingFrameItemRef(k)
			})

			elements[`Category{k}`] = element
		end

		return React.createElement(React.Fragment, {}, {
			SlotNavFrame = React.createElement(
				fitFrameHorizontal,
				{
					height = UDim.new(1, 0),
					FillDirection = Enum.FillDirection.Horizontal,
					BackgroundTransparency = 1,
					[React.Change.AbsoluteSize] = props2.onNavFrameSizeChanged
				},
				elements
			),
			Highlight = React.createElement(module, {
				scrollingFrameRef = props2.getScrollingFrameRef(),
				selectedCategoryButtonInstance = props2.selectedItemInstance
			})
		})
	end, { categories, slotCategory, props.onSlotCategorySelected })

	return React.createElement(module3, {
		LayoutOrder = props.LayoutOrder,
		ZIndex = props.ZIndex,
		navHeight = props.navHeight,
		selectedItemKey = slotCategory,
		enableSnapToSelectedItem = props.enableSnapToSelectedItem,
		renderScrollingListContent = v5
	})
end
