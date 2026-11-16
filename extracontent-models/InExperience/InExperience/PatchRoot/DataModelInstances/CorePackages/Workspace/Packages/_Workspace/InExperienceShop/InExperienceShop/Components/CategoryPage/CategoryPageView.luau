local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local View = Foundation.View
local ScrollView = Foundation.ScrollView

local ItemGrid = require(InExperienceShop.Components.ItemGrid)
require(InExperienceShop.Components.ItemRow)
local FFlagEnableInExperienceShopUnifiedLogging = require(InExperienceShop.Flags.FFlagEnableInExperienceShopUnifiedLogging)
local FFlagShopRobuxTermsDisclosure = require(InExperienceShop.Flags.FFlagShopRobuxTermsDisclosure)
local RobuxTermsDisclosure

if FFlagShopRobuxTermsDisclosure then
	RobuxTermsDisclosure = require(InExperienceShop.Components.RobuxTermsDisclosure)
else
	RobuxTermsDisclosure = nil
end

local SharedFlags = require(parent.SharedFlags)
local isSubjectToDesktopPolicies = SharedFlags.isSubjectToDesktopPolicies
local Analytics

if FFlagEnableInExperienceShopUnifiedLogging then
	Analytics = require(InExperienceShop.Analytics)
end

local shopPageType

if Analytics then
	shopPageType = Analytics.Constants.ShopPageType
else
	shopPageType = nil
end

local useShopImpressionsDetector = require(InExperienceShop.Hooks.useShopImpressionsDetector)

require(InExperienceShop.Types)

local function CategoryPageView(props)
	local showRobuxTermsDisclosure = props.showRobuxTermsDisclosure == true
	local isMobile = not isSubjectToDesktopPolicies()

	local v = useShopImpressionsDetector({
		pageType = not shopPageType and "" or shopPageType.Category,
		isPageActive = true,
		externalScrollSignal = nil
	})

	local onCanvasPositionChanged = React.useCallback(function(_)
		if FFlagEnableInExperienceShopUnifiedLogging then
			v.onLayoutChange()
		end
	end, { v.onLayoutChange })

	local createElement = React.createElement
	local v2 = {
		tag = "fill size-full-0",
		testId = "CategoryPageView",
		LayoutOrder = props.LayoutOrder
	}

	local createElement2 = React.createElement
	local v3 = { Size = UDim2.fromScale(1, 1), onCanvasPositionChanged = 0, scroll = 0 }

	if not FFlagEnableInExperienceShopUnifiedLogging then
		onCanvasPositionChanged = nil
	end

	v3.onCanvasPositionChanged = onCanvasPositionChanged

	v3.scroll = {
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.fromScale(1, 0),
		ScrollingDirection = Enum.ScrollingDirection.Y,
		scrollBarVisibility = Foundation.Enums.Visibility.None
	}

	local createElement3 = React.createElement
	local v4 = {
		tag = showRobuxTermsDisclosure and "col gap-medium size-full-0 auto-y padding-x-xlarge padding-bottom-xlarge" or "size-full-0 auto-y padding-x-xlarge padding-bottom-xlarge padding-top-medium",
		ref = 0,
		onAbsoluteSizeChanged = 0
	}
	local ref

	if FFlagEnableInExperienceShopUnifiedLogging then
		ref = v.gridRef
	end

	v4.ref = ref
	v4.onAbsoluteSizeChanged = FFlagEnableInExperienceShopUnifiedLogging and function(_)
		v.onLayoutChange()
	end or nil
	local disclosure

	if showRobuxTermsDisclosure and RobuxTermsDisclosure then
		disclosure = React.createElement(RobuxTermsDisclosure, {
			isMobile = isMobile,
			LayoutOrder = 1
		})
	end

	local createElement4 = React.createElement
	local v6 = {
		LayoutOrder = showRobuxTermsDisclosure and 2 or nil,
		items = props.items,
		itemsPerRow = props.itemsPerRow,
		sectionId = props.sectionId,
		onItemActivated = props.onItemActivated,
		renderTile = props.renderTile,
		isFeaturedDoubleWidthRobux = props.isFeaturedDoubleWidthRobux,
		gap = "gap-large",
		onGridLayoutChange = 0
	}
	local onGridLayoutChange

	if FFlagEnableInExperienceShopUnifiedLogging then
		onGridLayoutChange = v.onLayoutChange
	end

	v6.onGridLayoutChange = onGridLayoutChange
	local v5 = {
		Scroll = createElement2(ScrollView, v3, {
			Content = createElement3(View, v4, {
				Disclosure = disclosure,
				Grid = createElement4(ItemGrid, v6)
			})
		}),
		ImpressionsDetector = 0
	}
	local impressionsDetector

	if FFlagEnableInExperienceShopUnifiedLogging then
		impressionsDetector = v.impressionsDetector
	end

	v5.ImpressionsDetector = impressionsDetector
	return createElement(View, v2, v5)
end

return CategoryPageView
