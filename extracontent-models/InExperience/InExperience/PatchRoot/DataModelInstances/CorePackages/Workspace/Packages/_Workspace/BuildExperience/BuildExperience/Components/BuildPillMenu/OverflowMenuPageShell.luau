local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local FFlagBuildAdsUiPolish = require(BuildExperience.Flags.FFlagBuildAdsUiPolish)
local useScrollPerformanceTracker = require(BuildExperience.Telemetry.useScrollPerformanceTracker)

local IconButton = Foundation.IconButton
local Divider = Foundation.Divider
local ScrollView = Foundation.ScrollView
local Text = Foundation.Text
local View = Foundation.View

local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize

local function OverflowMenuPageShell(props)
	local testId = props.testId or "overflow-menu-page"
	local ref = React.useRef(nil)
	useScrollPerformanceTracker(props.scrollPerformanceIntervalName or "BuildOverflowMenuPageShell", ref)
	local element = React.createElement(View, {
		tag = {
			["composition-content-body"] = true,
			["col size-full"] = props.disableScrolling == true,
			["col size-full-0 auto-y"] = props.disableScrolling ~= true
		},
		testId = `{testId}-content-body`
	}, { Content = props.content })

	local createElement = React.createElement
	local v = {
		LayoutOrder = props.layoutOrder,
		tag = {
			["composition-layout-detail"] = true,
			["col align-x-center size-full bg-surface-0"] = true
		},
		testId = testId
	}

	local createElement2 = React.createElement
	local v3 = {
		LayoutOrder = 1,
		tag = {
			["composition-content-header"] = true,
			["row align-y-center gap-small size-full-0 auto-y padding-y-small"] = true
		},
		testId = `{testId}-header`
	}
	local v4 = {
		Close = React.createElement(IconButton, {
			LayoutOrder = 1,
			icon = props.closeIcon or IconName.ChevronLargeLeft,
			isCircular = true,
			onActivated = props.onClose,
			size = InputSize.Large,
			testId = `{testId}-close`,
			variant = ButtonVariant.Utility
		}),
		Title = 0,
		Trailing = 0
	}
	local title

	if props.headerContent == nil then
		title = React.createElement(Text, {
			LayoutOrder = 2,
			Text = props.title,
			tag = "fill text-heading-medium text-align-x-left text-truncate-end content-emphasis"
		})
	else
		title = React.createElement(
			View,
			{ LayoutOrder = 2, tag = "grow auto-y", testId = `{testId}-header-content` },
			{ Content = props.headerContent }
		)
	end

	v4.Title = title
	local trailing

	if props.headerTrailing ~= nil then
		trailing = React.createElement(
			View,
			{ LayoutOrder = 3, tag = "auto-xy", testId = `{testId}-header-trailing` },
			{ Content = props.headerTrailing }
		)
	end

	v4.Trailing = trailing
	local v2 = { Header = createElement2(View, v3, v4), Body = 0, FooterDivider = 0, Footer = 0 }
	local body

	if props.disableScrolling then
		body = React.createElement(
			View,
			{ LayoutOrder = 2, tag = "fill size-full-0 bg-surface-0", testId = `{testId}-body` },
			{ ContentBody = element }
		)
	else
		body = React.createElement(ScrollView, {
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
	end

	v2.Body = body
	local footerDivider

	if not (props.footer == nil or props.footerDivider == false) then
		footerDivider = React.createElement(Divider, {
			LayoutOrder = 3,
			testId = `{testId}-footer-divider`
		})
	end

	v2.FooterDivider = footerDivider
	local footer

	if props.footer ~= nil then
		footer = React.createElement(View, {
			LayoutOrder = 4,
			ZIndex = FFlagBuildAdsUiPolish and 2 or nil,
			tag = { ["composition-content-body"] = true, ["size-full-0 auto-y"] = true },
			testId = `{testId}-footer-body`
		}, { Footer = props.footer })
	end

	v2.Footer = footer
	return createElement(View, v, v2)
end

return OverflowMenuPageShell
