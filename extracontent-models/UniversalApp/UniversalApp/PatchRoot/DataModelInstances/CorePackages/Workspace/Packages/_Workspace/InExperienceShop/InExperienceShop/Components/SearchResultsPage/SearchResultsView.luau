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
local v11 = if not FFlagEnableInExperienceShopUnifiedLogging then nil else require(InExperienceShop.Analytics)
local v12 = if not v11 then nil else v11.Constants.ShopPageType
local useShopImpressionsDetector = require(InExperienceShop.Hooks.useShopImpressionsDetector)
local Constants = require(InExperienceShop.Constants)

require(InExperienceShop.Types)

local v15 = string.format("Type at least %d characters to search", Constants.SEARCH_MIN_LENGTH)
local t1 = {
	emptyText = "CommonUI.Messages.Response.NoResults"
}

local function SearchResultsView(t2: {[any]: any}) -- line: 45
	-- upvalues: useLocalization (copy), t1 (copy), useShopImpressionsDetector (copy), v12 (copy), React (copy), FFlagEnableInExperienceShopUnifiedLogging (copy), ItemRow (copy), v15 (copy), View (copy), ScrollView (copy), Foundation (copy), FoundationText (copy)
	local v19 = useLocalization(t1)
	local v20 = useShopImpressionsDetector({
		isPageActive = true,
		externalScrollSignal = nil,
		pageType = not v12 and "" or v12.Search
	})
	local v21 = React.useCallback(function(_) -- line: 54
		-- upvalues: FFlagEnableInExperienceShopUnifiedLogging (copy), v20 (copy)
		if FFlagEnableInExperienceShopUnifiedLogging then
			v20.onLayoutChange()
		end
	end, { v20.onLayoutChange })
	local v22 = React.useMemo(function() -- line: 60
		-- upvalues: t2 (copy), React (copy), ItemRow (copy)
		if t2.state ~= "results" then
			return {}
		end

		local t3 = {}

		for v26, v27 in t2.rows do
			t3["Row" .. v26] = React.createElement(ItemRow, {
				items = v27,
				columnCount = t2.columnCount,
				rowIndex = v26,
				onItemActivated = t2.onItemActivated,
				LayoutOrder = v26
			})
		end

		return t3
	end, {
		t2.rows,
		t2.columnCount,
		t2.onItemActivated,
		t2.state
	})
	local v23 = if t2.state ~= "hint" then if t2.state ~= "empty" then nil else v19.emptyText else v15

	return React.createElement(View, {
		tag = "fill size-full-0",
		testId = "SearchResultsView",
		LayoutOrder = t2.LayoutOrder
	}, {
		Scroll = if v23 ~= nil then nil else React.createElement(ScrollView, {
			Size = UDim2.fromScale(1, 1),
			onCanvasPositionChanged = if not FFlagEnableInExperienceShopUnifiedLogging then nil else v21,
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.fromScale(1, 0),
				ScrollingDirection = Enum.ScrollingDirection.Y,
				scrollBarVisibility = Foundation.Enums.Visibility.None
			}
		}, {
			Content = React.createElement(View, {
				tag = "col gap-medium size-full-0 auto-y padding-x-xlarge padding-bottom-xlarge padding-top-medium",
				ref = if not FFlagEnableInExperienceShopUnifiedLogging then nil else v20.gridRef,
				onAbsoluteSizeChanged = if not FFlagEnableInExperienceShopUnifiedLogging then nil else function(_) -- line: 115
					-- upvalues: v20 (copy)
					v20.onLayoutChange()
				end
			}, v22)
		}),
		ImpressionsDetector = if not FFlagEnableInExperienceShopUnifiedLogging then nil else v20.impressionsDetector,
		Message = if v23 == nil then nil else React.createElement(View, {
			tag = "col align-x-center align-y-center size-full padding-x-xlarge padding-y-xlarge",
			testId = "SearchResultsMessage"
		}, {
			Label = React.createElement(FoundationText, {
				tag = "auto-xy text-body-medium text-align-x-center content-default",
				Text = v23
			})
		})
	})
end

return SearchResultsView
