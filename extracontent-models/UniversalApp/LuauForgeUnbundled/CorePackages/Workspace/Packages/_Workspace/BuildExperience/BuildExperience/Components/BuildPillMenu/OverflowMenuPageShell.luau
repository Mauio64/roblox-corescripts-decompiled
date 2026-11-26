local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local FFlagBuildAdsUiPolish = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAdsUiPolish")
local useScrollPerformanceTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/useScrollPerformanceTracker")

local iconButton = Foundation.IconButton
local divider = Foundation.Divider
local scrollView = Foundation.ScrollView
local text = Foundation.Text
local view = Foundation.View

local buttonVariant = Foundation.Enums.ButtonVariant
local iconName = Foundation.Enums.IconName
local inputSize = Foundation.Enums.InputSize

local function OverflowMenuPageShell(props)
	local testId = props.testId or "overflow-menu-page"
	local ref = React.useRef(nil)
	useScrollPerformanceTracker(props.scrollPerformanceIntervalName or "BuildOverflowMenuPageShell", ref)
	local element = React.createElement(view, {
		tag = {
			["composition-content-body"] = true,
			["col size-full"] = props.disableScrolling == true,
			["col size-full-0 auto-y"] = props.disableScrolling ~= true
		},
		testId = `{testId}-content-body`
	}, { Content = props.content })

	local createElement = React.createElement
	local v6 = {
		LayoutOrder = props.layoutOrder,
		tag = {
			["composition-layout-detail"] = true,
			["col align-x-center size-full bg-surface-0"] = true
		},
		testId = testId
	}

	local createElement2 = React.createElement
	local v9 = {
		LayoutOrder = 1,
		tag = {
			["composition-content-header"] = true,
			["row align-y-center gap-small size-full-0 auto-y padding-y-small"] = true
		},
		testId = `{testId}-header`
	}
	local v10 = {
		Close = React.createElement(iconButton, {
			LayoutOrder = 1,
			icon = props.closeIcon or iconName.ChevronLargeLeft,
			isCircular = true,
			onActivated = props.onClose,
			size = inputSize.Large,
			testId = `{testId}-close`,
			variant = buttonVariant.Utility
		}),
		Title = 0,
		Trailing = 0
	}

	local v11 = if props.headerContent == nil then React.createElement(text, {
		LayoutOrder = 2,
		Text = props.title,
		tag = "fill text-heading-medium text-align-x-left text-truncate-end content-emphasis"
	}) else React.createElement(
		view,
		{ LayoutOrder = 2, tag = "grow auto-y", testId = `{testId}-header-content` },
		{ Content = props.headerContent }
	)
	v10.Title = v11

	local v12 = if props.headerTrailing ~= nil then React.createElement(
		view,
		{ LayoutOrder = 3, tag = "auto-xy", testId = `{testId}-header-trailing` },
		{ Content = props.headerTrailing }
	) else nil
	v10.Trailing = v12
	local v7 = {
		Header = createElement2(view, v9, v10),
		Body = 0,
		FooterDivider = 0,
		Footer = 0
	}

	local v13 = if props.disableScrolling then React.createElement(
		view,
		{
			LayoutOrder = 2,
			tag = "fill size-full-0 bg-surface-0",
			testId = `{testId}-body`
		},
		{ ContentBody = element }
	) else React.createElement(scrollView, {
		LayoutOrder = 2,
		scrollingFrameRef = ref,
		tag = "fill size-full-0 bg-surface-0",
		testId = `{testId}-scroll-view`,
		scroll = {
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.new(1, 0, 0, 0),
			ScrollingDirection = Enum.ScrollingDirection.Y
		}
	}, { ContentBody = element })
	v7.Body = v13

	local v14 = if props.footer ~= nil and props.footerDivider ~= false then React.createElement(divider, {
		LayoutOrder = 3,
		testId = `{testId}-footer-divider`
	}) else nil
	v7.FooterDivider = v14

	local v15 = if props.footer ~= nil then React.createElement(view, {
		LayoutOrder = 4,
		ZIndex = FFlagBuildAdsUiPolish and 2 or nil,
		tag = { ["composition-content-body"] = true, ["size-full-0 auto-y"] = true },
		testId = `{testId}-footer-body`
	}, { Footer = props.footer }) else nil
	v7.Footer = v15
	return createElement(view, v6, v7)
end

return OverflowMenuPageShell
