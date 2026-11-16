local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local FFlagMomentsCommentRowRedesign = require(Moments.Flags.FFlagMomentsCommentRowRedesign)
local getLineHeights = require(script.Parent.getLineHeights)

local Skeleton = Foundation.Skeleton
local View = Foundation.View

local Radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens

local function CommentRowSkeletonView(props)
	local v = useTokens()
	local size_300 = v.Size.Size_300
	local v2

	if FFlagMomentsCommentRowRedesign then
		v2 = v.Typography.TitleMedium
	else
		v2 = v.Typography.TitleSmall
	end

	local lineHeights = getLineHeights(v2)
	local v3

	if FFlagMomentsCommentRowRedesign then
		v3 = v.Size.Size_800
	else
		v3 = v.Size.Size_700
	end

	local lineHeights2, v4 = getLineHeights(v.Typography.BodyMedium)

	local children = {}

	for k, bodyLineWidth in props.bodyLineWidths do
		local formatted = `Line{k}`
		local createElement = React.createElement

		local v5 = if k == 1 then lineHeights2 else v4
		children[formatted] = createElement(
			View,
			{ LayoutOrder = k, Size = UDim2.new(1, 0, 0, v5), tag = "row align-y-center" },
			{
				Bar = React.createElement(Skeleton, {
					Size = UDim2.new(bodyLineWidth, 0, 0, size_300),
					radius = Radius.Medium,
					testId = `{props.testId}--body-line-{k}`
				})
			}
		)
	end

	local createElement = React.createElement
	local v5 = {
		LayoutOrder = props.LayoutOrder,
		tag = {
			["row gap-medium size-full-0 auto-y padding-top-small"] = true,
			["padding-bottom-small"] = FFlagMomentsCommentRowRedesign
		},
		testId = props.testId
	}
	local v6 = {
		Avatar = React.createElement(Skeleton, {
			LayoutOrder = 1,
			Size = UDim2.fromOffset(v3, v3),
			radius = Radius.Circle,
			testId = `{props.testId}--avatar`
		}),
		TextColumn = 0
	}

	local createElement2 = React.createElement

	local createElement3 = React.createElement

	local createElement4 = React.createElement
	local v7 = {
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, lineHeights),
		tag = "row align-y-center gap-medium"
	}

	local v9 = {
		Author = React.createElement(Skeleton, {
			LayoutOrder = 1,
			Size = UDim2.fromOffset(props.authorWidth, size_300),
			radius = Radius.Medium,
			testId = `{props.testId}--author`
		}),
		Timestamp = 0
	}
	local timestamp

	if not FFlagMomentsCommentRowRedesign then
		timestamp = React.createElement(Skeleton, {
			LayoutOrder = 2,
			Size = UDim2.fromOffset(props.timestampWidth, size_300),
			radius = Radius.Medium,
			testId = `{props.testId}--timestamp`
		})
	end

	v9.Timestamp = timestamp
	local v8 = {
		MainContent = createElement3(View, {
			LayoutOrder = 1,
			tag = {
				["col size-full-0 auto-y"] = true,
				["gap-xxsmall"] = FFlagMomentsCommentRowRedesign,
				["gap-xsmall"] = not FFlagMomentsCommentRowRedesign
			}
		}, {
			Header = createElement4(View, v7, v9),
			Body = React.createElement(View, { LayoutOrder = 2, tag = "col size-full-0 auto-y" }, children)
		}),
		Reaction = 0,
		Footer = 0
	}
	local reaction

	if not FFlagMomentsCommentRowRedesign then
		reaction = React.createElement(
			View,
			{
				LayoutOrder = 2,
				tag = "row align-y-center gap-xsmall auto-xy padding-bottom-small",
				testId = `{props.testId}--reaction`
			},
			{
				Icon = React.createElement(Skeleton, {
					LayoutOrder = 1,
					Size = UDim2.fromOffset(v.Size.Size_500, v.Size.Size_500),
					radius = Radius.Circle
				}),
				Count = React.createElement(Skeleton, {
					LayoutOrder = 2,
					Size = UDim2.fromOffset(v.Size.Size_400, size_300),
					radius = Radius.Medium
				})
			}
		)
	end

	v8.Reaction = reaction
	local footer

	if FFlagMomentsCommentRowRedesign then
		footer = React.createElement(
			View,
			{
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, v.Size.Size_600),
				tag = "row align-y-center gap-small",
				testId = `{props.testId}--footer`
			},
			{
				Timestamp = React.createElement(View, {
					LayoutOrder = 1,
					tag = "row align-y-center fill auto-y"
				}, {
					Bar = React.createElement(Skeleton, {
						Size = UDim2.fromOffset(props.timestampWidth, size_300),
						radius = Radius.Medium,
						testId = `{props.testId}--timestamp`
					})
				}),
				Reaction = React.createElement(
					View,
					{
						LayoutOrder = 2,
						tag = "row align-y-center gap-xsmall auto-xy padding-right-small",
						testId = `{props.testId}--reaction`
					},
					{
						Icon = React.createElement(Skeleton, {
							LayoutOrder = 1,
							Size = UDim2.fromOffset(v.Size.Size_400, v.Size.Size_400),
							radius = Radius.Circle
						}),
						Count = React.createElement(Skeleton, {
							LayoutOrder = 2,
							Size = UDim2.fromOffset(v.Size.Size_400, size_300),
							radius = Radius.Medium,
							testId = `{props.testId}--reaction-count`
						})
					}
				)
			}
		)
	end

	v8.Footer = footer
	v6.TextColumn = createElement2(View, {
		LayoutOrder = 2,
		tag = {
			["col fill auto-y"] = true,
			["gap-xsmall"] = FFlagMomentsCommentRowRedesign,
			["gap-small"] = not FFlagMomentsCommentRowRedesign
		}
	}, v8)
	return createElement(View, v5, v6)
end

return CommentRowSkeletonView
