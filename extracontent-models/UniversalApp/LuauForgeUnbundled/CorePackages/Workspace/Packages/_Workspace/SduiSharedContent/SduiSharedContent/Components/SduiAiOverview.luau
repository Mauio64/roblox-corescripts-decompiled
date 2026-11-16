local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Foundation")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/AppCommonLib")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Localization").Hooks.useLocalization

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Cryo")

local view = Foundation.View
local chip = Foundation.Chip
local divider = Foundation.Divider
local usePreferences = Foundation.Hooks.usePreferences
local useTokens = Foundation.Hooks.useTokens
local chipSize = Foundation.Enums.ChipSize
local chipVariant = Foundation.Enums.ChipVariant
local iconName = Foundation.Enums.IconName

local useAiOverviewExpansion = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/useAiOverviewExpansion")

local function SduiAiOverview(props)
	local v5 = useTokens()
	local v6 = usePreferences()
	local v7 = useLocalization({
		expandButtonText = "CommonUI.Controls.Action.ShowMore"
	})

	local v8 = React.useMemo(function()
		return {
			index = props.index,
			scrollViewPositionChangedSignal = props.scrollViewPositionChangedSignal,
			verticalScrollingFrameRef = props.verticalScrollingFrameRef,
			startRow = props.startRow or props.index
		}
	end, {
		props.index,
		props.scrollViewPositionChangedSignal,
		props.verticalScrollingFrameRef,
		props.startRow
	})

	local v9 = React.useCallback(function(items)
		if not items or typeof(items) ~= "table" then
			return items
		end

		local result = {}

		for k, item in items do
			local extraLocalProps = item.props and item.props.extraLocalProps or {}
			result[k] = React.cloneElement(item, {
				extraLocalProps = Cryo.Dictionary.join(extraLocalProps, v8)
			})
		end

		return result
	end, { v8 })

	local v10 = React.useMemo(function()
		return v9(props.content)
	end, { props.content, v9 })

	local v11 = React.useMemo(function()
		return v9(props.footer)
	end, { props.footer, v9 })

	local headerGap = props.headerGap or v5.Gap.Small
	local sectionGap = props.sectionGap or v5.Gap.Large
	local v12 = props.titleComponent ~= nil or props.descriptionComponent ~= nil
	local v13 = props.content ~= nil or props.footer ~= nil
	local expandButtonText = props.expandButtonText or v7.expandButtonText
	local backgroundStyle = props.backgroundStyle or v5.Color.Surface.Surface_0
	local v14 = useAiOverviewExpansion({
		buttonHeight = v5.Size.Size_1000,
		compactHeight = props.compactHeight,
		hasHeader = v12,
		hasExpandableBody = v13,
		sectionGap = sectionGap,
		reducedMotion = v6.reducedMotion
	})

	local createElement = React.createElement
	local v16 = {
		tag = "size-full-0 auto-y",
		layout = {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, sectionGap)
		},
		backgroundStyle = props.backgroundStyle,
		LayoutOrder = props.layoutOrder,
		sizeConstraint = v14.shouldReserveCompactHeight and {
			MinSize = Vector2.new(0, props.compactHeight)
		} or nil,
		testId = props.testId or "--sdui-ai-overview"
	}
	local v18

	if v12 then
		local createElement2 = React.createElement
		local v20 = {
			tag = "size-full-0 auto-y",
			layout = {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, headerGap)
			},
			LayoutOrder = 1,
			onAbsoluteSizeChanged = v14.onHeaderAbsoluteSizeChanged
		}

		local v22 = if props.titleComponent then React.createElement(
			view,
			{
				tag = "size-full-0 auto-y",
				LayoutOrder = 1,
				testId = "--sdui-ai-overview-title"
			},
			{ Slot = props.titleComponent }
		) else nil

		local v23 = if props.descriptionComponent then React.createElement(
			view,
			{
				tag = "size-full-0 auto-y",
				LayoutOrder = 2,
				testId = "--sdui-ai-overview-description"
			},
			{ Slot = props.descriptionComponent }
		) else nil
		v18 = createElement2(view, v20, { Title = v22, Description = v23 })
	end

	local v19

	if v13 then
		local createElement2 = React.createElement

		local createElement3 = React.createElement
		local v24 = {
			tag = {
				clip = v14.useCompactViewport,
				["no-clip"] = not v14.useCompactViewport,
				["auto-none"] = v14.useCompactViewport,
				["auto-y"] = not v14.useCompactViewport
			},
			Size = 0
		}
		local v25

		if v14.useCompactViewport then
			v25 = v14.animatedViewportHeight:map(function(p2)
				return UDim2.new(1, 0, 0, (math.ceil(p2)))
			end)
		else
			v25 = UDim2.fromScale(1, 0)
		end

		v24.Size = v25

		local createElement4 = React.createElement
		local v28 = {
			tag = "size-full-0 auto-y",
			layout = {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, sectionGap)
			},
			onAbsoluteSizeChanged = v14.onContentAbsoluteSizeChanged
		}

		local v30 = if v10 then React.createElement(view, {
			tag = "size-full-0 auto-y",
			layout = {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, sectionGap)
			},
			LayoutOrder = 3,
			testId = "--sdui-ai-overview-content"
		}, v10) else nil

		local v31 = if v11 then React.createElement(view, {
			tag = "size-full-0 auto-y",
			layout = {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, sectionGap)
			},
			LayoutOrder = 4,
			testId = "--sdui-ai-overview-footer"
		}, v11) else nil
		local v26 = {
			Content = createElement4(view, v28, { Content = v30, Footer = v31 }),
			FadeOverlay = 0
		}
		local v32

		if v14.isCompact then
			v32 = React.createElement(view, {
				tag = "position-bottom-left anchor-bottom-left",
				backgroundStyle = backgroundStyle,
				Size = v14.animatedViewportHeight:map(function(p2)
					return UDim2.new(1, 0, 0, (math.ceil(p2 * 0.25)))
				end),
				ZIndex = 2
			}, {
				Gradient = React.createElement("UIGradient", {
					Rotation = 90,
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 1),
						NumberSequenceKeypoint.new(1, 0)
					})
				})
			})
		end

		v26.FadeOverlay = v32
		v19 = createElement2(view, { tag = "col size-full-0 auto-y", LayoutOrder = 2 }, {
			Inner = createElement3(view, v24, v26)
		})
	end

	local v20 = if v14.isCompact then React.createElement(
		view,
		{ tag = "row align-y-center gap-xsmall size-full-0 auto-y", LayoutOrder = 3 },
		{
			LeadingLine = React.createElement(view, { tag = "grow", LayoutOrder = 1 }, {
				Divider = React.createElement(divider)
			}),
			ChipOutline = React.createElement(
				view,
				{ tag = "auto-xy stroke-default radius-circle", LayoutOrder = 2 },
				{
					Chip = React.createElement(chip, {
						text = expandButtonText,
						trailing = iconName.ChevronLargeDown,
						size = chipSize.Large,
						variant = chipVariant.Utility,
						onActivated = v14.onExpand,
						testId = "--sdui-ai-overview-toggle"
					})
				}
			),
			TrailingLine = React.createElement(view, { tag = "grow", LayoutOrder = 3 }, {
				Divider = React.createElement(divider)
			})
		}
	) else nil
	return createElement(view, v16, { Header = v18, Body = v19, ToggleButton = v20 })
end

return React.memo(SduiAiOverview)
