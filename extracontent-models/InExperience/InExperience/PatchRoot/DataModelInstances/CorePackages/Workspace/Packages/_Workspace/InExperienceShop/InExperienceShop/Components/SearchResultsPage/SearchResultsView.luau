local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local InExperienceShopParent = InExperienceShop.Parent
local React = require(InExperienceShopParent.React)
local Foundation = require(InExperienceShopParent.Foundation)
local useLocalization = require(InExperienceShopParent.Localization).Hooks.useLocalization
local View = Foundation.View
local FoundationText = Foundation.Text
local ScrollView = Foundation.ScrollView
local ItemRow = require(InExperienceShop.Components.ItemRow)
local FFlagEnableInExperienceShopUnifiedLogging = require(InExperienceShop.Flags.FFlagEnableInExperienceShopUnifiedLogging)
local FFlagPassShopPurchaseSurfaceToBuyModal = require(InExperienceShopParent.SharedFlags).FFlagPassShopPurchaseSurfaceToBuyModal
local v12 = if not FFlagEnableInExperienceShopUnifiedLogging then nil else require(InExperienceShop.Analytics)
local v13 = if not v12 then nil else v12.Constants.ShopPageType
local v14 = if not FFlagPassShopPurchaseSurfaceToBuyModal then nil else require(InExperienceShop.Analytics.Constants).ShopPageType
local useShopImpressionsDetector = require(InExperienceShop.Hooks.useShopImpressionsDetector)
local Constants = require(InExperienceShop.Constants)

require(InExperienceShop.Types)

local v17 = string.format("Type at least %d characters to search", Constants.SEARCH_MIN_LENGTH)
local t1 = {
	emptyText = "CommonUI.Messages.Response.NoResults"
}

local function SearchResultsView(t2: {[any]: any}) -- line: 51
	-- upvalues: useLocalization (copy), t1 (copy), useShopImpressionsDetector (copy), v13 (copy), React (copy), FFlagEnableInExperienceShopUnifiedLogging (copy), ItemRow (copy), v14 (copy), v17 (copy), View (copy), ScrollView (copy), Foundation (copy), FoundationText (copy)
	local v21 = useLocalization(t1)
	local v22 = useShopImpressionsDetector({
		isPageActive = true,
		externalScrollSignal = nil,
		pageType = not v13 and "" or v13.Search
	})
	local v23 = React.useCallback(function(_) -- line: 60
		-- upvalues: FFlagEnableInExperienceShopUnifiedLogging (copy), v22 (copy)
		if FFlagEnableInExperienceShopUnifiedLogging then
			v22.onLayoutChange()
		end
	end, { v22.onLayoutChange })
	local v24 = React.useMemo(function() -- line: 66
		-- upvalues: t2 (copy), React (copy), ItemRow (copy), v14 (copy)
		if t2.state ~= "results" then
			return {}
		end

		local t3 = {}

		for v28, v29 in t2.rows do
			t3["Row" .. v28] = React.createElement(ItemRow, {
				items = v29,
				columnCount = t2.columnCount,
				rowIndex = v28,
				onItemActivated = t2.onItemActivated,
				shopPageType = if not v14 then nil else v14.Search,
				LayoutOrder = v28
			})
		end

		return t3
	end, {
		t2.rows,
		t2.columnCount,
		t2.onItemActivated,
		t2.state
	})
	local v25 = if t2.state ~= "hint" then if t2.state ~= "empty" then nil else v21.emptyText else v17

	return React.createElement(View, {
		tag = "fill size-full-0",
		testId = "SearchResultsView",
		LayoutOrder = t2.LayoutOrder
	}, {
		Scroll = if v25 ~= nil then nil else React.createElement(ScrollView, {
			Size = UDim2.fromScale(1, 1),
			onCanvasPositionChanged = if not FFlagEnableInExperienceShopUnifiedLogging then nil else v23,
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.fromScale(1, 0),
				ScrollingDirection = Enum.ScrollingDirection.Y,
				scrollBarVisibility = Foundation.Enums.Visibility.None
			}
		}, {
			Content = React.createElement(View, {
				tag = "col gap-medium size-full-0 auto-y padding-x-xlarge padding-bottom-xlarge padding-top-medium",
				ref = if not FFlagEnableInExperienceShopUnifiedLogging then nil else v22.gridRef,
				onAbsoluteSizeChanged = if not FFlagEnableInExperienceShopUnifiedLogging then nil else function(_) -- line: 122
					-- upvalues: v22 (copy)
					v22.onLayoutChange()
				end
			}, v24)
		}),
		ImpressionsDetector = if not FFlagEnableInExperienceShopUnifiedLogging then nil else v22.impressionsDetector,
		Message = if v25 == nil then nil else React.createElement(View, {
			tag = "col align-x-center align-y-center size-full padding-x-xlarge padding-y-xlarge",
			testId = "SearchResultsMessage"
		}, {
			Label = React.createElement(FoundationText, {
				tag = "auto-xy text-body-medium text-align-x-center content-default",
				Text = v25
			})
		})
	})
end

return SearchResultsView
