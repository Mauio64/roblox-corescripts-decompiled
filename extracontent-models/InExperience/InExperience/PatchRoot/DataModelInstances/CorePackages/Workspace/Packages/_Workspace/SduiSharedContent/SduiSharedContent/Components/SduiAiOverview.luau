local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
require(parent.AppCommonLib)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local Cryo = require(parent.Cryo)

local View = Foundation.View
local Chip = Foundation.Chip
local Divider = Foundation.Divider
local usePreferences = Foundation.Hooks.usePreferences
local useTokens = Foundation.Hooks.useTokens
local ChipSize = Foundation.Enums.ChipSize
local ChipVariant = Foundation.Enums.ChipVariant
local IconName = Foundation.Enums.IconName

local useAiOverviewExpansion = require(script.Parent.useAiOverviewExpansion)

local function SduiAiOverview(props)
	local v = useTokens()
	local v2 = usePreferences()
	local v3 = useLocalization({ expandButtonText = "CommonUI.Controls.Action.ShowMore" })

	local v4 = React.useMemo(function()
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

	local v5 = React.useCallback(function(items)
		if not items or typeof(items) ~= "table" then
			return items
		end

		local result = {}

		for k, item in items do
			local extraLocalProps = item.props and item.props.extraLocalProps or {}
			result[k] = React.cloneElement(item, {
				extraLocalProps = Cryo.Dictionary.join(extraLocalProps, v4)
			})
		end

		return result
	end, { v4 })

	local v6 = React.useMemo(function()
		return v5(props.content)
	end, { props.content, v5 })

	local v7 = React.useMemo(function()
		return v5(props.footer)
	end, { props.footer, v5 })

	local headerGap = props.headerGap or v.Gap.Small
	local sectionGap = props.sectionGap or v.Gap.Large
	local hasHeader = props.titleComponent ~= nil or props.descriptionComponent ~= nil
	local hasExpandableBody = props.content ~= nil or props.footer ~= nil
	local expandButtonText = props.expandButtonText or v3.expandButtonText
	local backgroundStyle = props.backgroundStyle or v.Color.Surface.Surface_0
	local v8 = useAiOverviewExpansion({
		buttonHeight = v.Size.Size_1000,
		compactHeight = props.compactHeight,
		hasHeader = hasHeader,
		hasExpandableBody = hasExpandableBody,
		sectionGap = sectionGap,
		reducedMotion = v2.reducedMotion
	})

	local createElement = React.createElement
	local v9 = {
		tag = "size-full-0 auto-y",
		layout = {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, sectionGap)
		},
		backgroundStyle = props.backgroundStyle,
		LayoutOrder = props.layoutOrder,
		sizeConstraint = v8.shouldReserveCompactHeight and {
			MinSize = Vector2.new(0, props.compactHeight)
		} or nil,
		testId = props.testId or "--sdui-ai-overview"
	}
	local header

	if hasHeader then
		local createElement2 = React.createElement
		local v10 = {
			tag = "size-full-0 auto-y",
			layout = {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, headerGap)
			},
			LayoutOrder = 1,
			onAbsoluteSizeChanged = v8.onHeaderAbsoluteSizeChanged
		}
		local title

		if props.titleComponent then
			title = React.createElement(
				View,
				{ tag = "size-full-0 auto-y", LayoutOrder = 1, testId = "--sdui-ai-overview-title" },
				{ Slot = props.titleComponent }
			)
		end

		local description

		if props.descriptionComponent then
			description = React.createElement(
				View,
				{
					tag = "size-full-0 auto-y",
					LayoutOrder = 2,
					testId = "--sdui-ai-overview-description"
				},
				{ Slot = props.descriptionComponent }
			)
		end

		header = createElement2(View, v10, { Title = title, Description = description })
	end

	local body

	if hasExpandableBody then
		local createElement2 = React.createElement

		local createElement3 = React.createElement
		local v10 = {
			tag = {
				clip = v8.useCompactViewport,
				["no-clip"] = not v8.useCompactViewport,
				["auto-none"] = v8.useCompactViewport,
				["auto-y"] = not v8.useCompactViewport
			},
			Size = 0
		}
		local size

		if v8.useCompactViewport then
			size = v8.animatedViewportHeight:map(function(p: number)
				return UDim2.new(1, 0, 0, (math.ceil(p)))
			end)
		else
			size = UDim2.fromScale(1, 0)
		end

		v10.Size = size

		local createElement4 = React.createElement
		local v11 = {
			tag = "size-full-0 auto-y",
			layout = {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, sectionGap)
			},
			onAbsoluteSizeChanged = v8.onContentAbsoluteSizeChanged
		}
		local content

		if v6 then
			content = React.createElement(View, {
				tag = "size-full-0 auto-y",
				layout = {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, sectionGap)
				},
				LayoutOrder = 3,
				testId = "--sdui-ai-overview-content"
			}, v6)
		end

		local footer

		if v7 then
			footer = React.createElement(View, {
				tag = "size-full-0 auto-y",
				layout = {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, sectionGap)
				},
				LayoutOrder = 4,
				testId = "--sdui-ai-overview-footer"
			}, v7)
		end

		local v12 = {
			Content = createElement4(View, v11, { Content = content, Footer = footer }),
			FadeOverlay = 0
		}
		local fadeOverlay

		if v8.isCompact then
			fadeOverlay = React.createElement(View, {
				tag = "position-bottom-left anchor-bottom-left",
				backgroundStyle = backgroundStyle,
				Size = v8.animatedViewportHeight:map(function(p: number)
					return UDim2.new(1, 0, 0, (math.ceil(p * 0.25)))
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

		v12.FadeOverlay = fadeOverlay
		body = createElement2(View, { tag = "col size-full-0 auto-y", LayoutOrder = 2 }, {
			Inner = createElement3(View, v10, v12)
		})
	end

	local toggleButton

	if v8.isCompact then
		toggleButton = React.createElement(
			View,
			{ tag = "row align-y-center gap-xsmall size-full-0 auto-y", LayoutOrder = 3 },
			{
				LeadingLine = React.createElement(View, { tag = "grow", LayoutOrder = 1 }, {
					Divider = React.createElement(Divider)
				}),
				ChipOutline = React.createElement(
					View,
					{ tag = "auto-xy stroke-default radius-circle", LayoutOrder = 2 },
					{
						Chip = React.createElement(Chip, {
							text = expandButtonText,
							trailing = IconName.ChevronLargeDown,
							size = ChipSize.Large,
							variant = ChipVariant.Utility,
							onActivated = v8.onExpand,
							testId = "--sdui-ai-overview-toggle"
						})
					}
				),
				TrailingLine = React.createElement(View, { tag = "grow", LayoutOrder = 3 }, {
					Divider = React.createElement(Divider)
				})
			}
		)
	end

	return createElement(View, v9, { Header = header, Body = body, ToggleButton = toggleButton })
end

return React.memo(SduiAiOverview)
