local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local InExperienceShopParent = InExperienceShop.Parent
local React = require(InExperienceShopParent.React)
local Foundation = require(InExperienceShopParent.Foundation)
local View = Foundation.View
local ScrollView = Foundation.ScrollView
local ItemGrid = require(InExperienceShop.Components.ItemGrid)

require(InExperienceShop.Components.ItemRow)

local FFlagEnableInExperienceShopUnifiedLogging = require(InExperienceShop.Flags.FFlagEnableInExperienceShopUnifiedLogging)
local v9 = if not FFlagEnableInExperienceShopUnifiedLogging then nil else require(InExperienceShop.Analytics)
local v10 = if not v9 then nil else v9.Constants.ShopPageType
local useShopImpressionsDetector = require(InExperienceShop.Hooks.useShopImpressionsDetector)

require(InExperienceShop.Types)

local function CategoryPageView(t1: {[any]: any}) -- line: 34
	-- upvalues: useShopImpressionsDetector (copy), v10 (copy), React (copy), FFlagEnableInExperienceShopUnifiedLogging (copy), View (copy), ScrollView (copy), Foundation (copy), ItemGrid (copy)
	local v14 = useShopImpressionsDetector({
		isPageActive = true,
		externalScrollSignal = nil,
		pageType = not v10 and "" or v10.Category
	})
	local v15 = React.useCallback(function(_) -- line: 41
		-- upvalues: FFlagEnableInExperienceShopUnifiedLogging (copy), v14 (copy)
		if FFlagEnableInExperienceShopUnifiedLogging then
			v14.onLayoutChange()
		end
	end, { v14.onLayoutChange })

	return React.createElement(View, {
		tag = "fill size-full-0",
		testId = "CategoryPageView",
		LayoutOrder = t1.LayoutOrder
	}, {
		Scroll = React.createElement(ScrollView, {
			Size = UDim2.fromScale(1, 1),
			onCanvasPositionChanged = if not FFlagEnableInExperienceShopUnifiedLogging then nil else v15,
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.fromScale(1, 0),
				ScrollingDirection = Enum.ScrollingDirection.Y,
				scrollBarVisibility = Foundation.Enums.Visibility.None
			}
		}, {
			Content = React.createElement(View, {
				tag = "size-full-0 auto-y padding-x-xlarge padding-bottom-xlarge padding-top-medium",
				ref = if not FFlagEnableInExperienceShopUnifiedLogging then nil else v14.gridRef,
				onAbsoluteSizeChanged = if not FFlagEnableInExperienceShopUnifiedLogging then nil else function(_) -- line: 72
					-- upvalues: v14 (copy)
					v14.onLayoutChange()
				end
			}, {
				Grid = React.createElement(ItemGrid, {
					gap = "gap-large",
					items = t1.items,
					itemsPerRow = t1.itemsPerRow,
					sectionId = t1.sectionId,
					onItemActivated = t1.onItemActivated,
					renderTile = t1.renderTile,
					isFeaturedDoubleWidthRobux = t1.isFeaturedDoubleWidthRobux,
					onGridLayoutChange = if not FFlagEnableInExperienceShopUnifiedLogging then nil else v14.onLayoutChange
				})
			})
		}),
		ImpressionsDetector = if not FFlagEnableInExperienceShopUnifiedLogging then nil else v14.impressionsDetector
	})
end

return CategoryPageView
