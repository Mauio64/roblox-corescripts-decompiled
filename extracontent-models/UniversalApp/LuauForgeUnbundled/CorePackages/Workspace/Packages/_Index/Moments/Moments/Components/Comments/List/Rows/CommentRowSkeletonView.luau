local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local FFlagMomentsCommentRowRedesign = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsCommentRowRedesign")
local getLineHeights = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/List/Rows/getLineHeights")

local skeleton = Foundation.Skeleton
local view = Foundation.View

local radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens

local function CommentRowSkeletonView(props)
	local v5 = useTokens()
	local size_300 = v5.Size.Size_300

	local v7 = if FFlagMomentsCommentRowRedesign then v5.Typography.TitleMedium else v5.Typography.TitleSmall
	local v8 = getLineHeights(v7)

	local v9 = if FFlagMomentsCommentRowRedesign then v5.Size.Size_800 else v5.Size.Size_700
	local v10, v11 = getLineHeights(v5.Typography.BodyMedium)

	local children = {}

	for k, bodyLineWidth in props.bodyLineWidths do
		local formatted = `Line{k}`
		local createElement = React.createElement

		local newUDim2 = UDim2.new
		local v17 = if k == 1 then v10 else v11
		children[formatted] = createElement(
			view,
			{
				LayoutOrder = k,
				Size = newUDim2(1, 0, 0, v17),
				tag = "row align-y-center"
			},
			{
				Bar = React.createElement(skeleton, {
					Size = UDim2.new(bodyLineWidth, 0, 0, size_300),
					radius = radius.Medium,
					testId = `{props.testId}--body-line-{k}`
				})
			}
		)
	end

	local createElement = React.createElement
	local v13 = {
		LayoutOrder = props.LayoutOrder,
		tag = {
			["row gap-medium size-full-0 auto-y padding-top-small"] = true,
			["padding-bottom-small"] = FFlagMomentsCommentRowRedesign
		},
		testId = props.testId
	}
	local v14 = {
		Avatar = React.createElement(skeleton, {
			LayoutOrder = 1,
			Size = UDim2.fromOffset(v9, v9),
			radius = radius.Circle,
			testId = `{props.testId}--avatar`
		}),
		TextColumn = 0
	}

	local createElement2 = React.createElement

	local createElement3 = React.createElement

	local createElement4 = React.createElement
	local v21 = {
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, v8),
		tag = "row align-y-center gap-medium"
	}

	local v22 = {
		Author = React.createElement(skeleton, {
			LayoutOrder = 1,
			Size = UDim2.fromOffset(props.authorWidth, size_300),
			radius = radius.Medium,
			testId = `{props.testId}--author`
		}),
		Timestamp = 0
	}

	local v23 = if not FFlagMomentsCommentRowRedesign then React.createElement(skeleton, {
		LayoutOrder = 2,
		Size = UDim2.fromOffset(props.timestampWidth, size_300),
		radius = radius.Medium,
		testId = `{props.testId}--timestamp`
	}) else nil
	v22.Timestamp = v23
	local v17 = {
		MainContent = createElement3(view, {
			LayoutOrder = 1,
			tag = {
				["col size-full-0 auto-y"] = true,
				["gap-xxsmall"] = FFlagMomentsCommentRowRedesign,
				["gap-xsmall"] = not FFlagMomentsCommentRowRedesign
			}
		}, {
			Header = createElement4(view, v21, v22),
			Body = React.createElement(
				view,
				{ LayoutOrder = 2, tag = "col size-full-0 auto-y" },
				children
			)
		}),
		Reaction = 0,
		Footer = 0
	}

	local v24 = if not FFlagMomentsCommentRowRedesign then React.createElement(
		view,
		{
			LayoutOrder = 2,
			tag = "row align-y-center gap-xsmall auto-xy padding-bottom-small",
			testId = `{props.testId}--reaction`
		},
		{
			Icon = React.createElement(skeleton, {
				LayoutOrder = 1,
				Size = UDim2.fromOffset(v5.Size.Size_500, v5.Size.Size_500),
				radius = radius.Circle
			}),
			Count = React.createElement(skeleton, {
				LayoutOrder = 2,
				Size = UDim2.fromOffset(v5.Size.Size_400, size_300),
				radius = radius.Medium
			})
		}
	) else nil
	v17.Reaction = v24

	local v25 = if FFlagMomentsCommentRowRedesign then React.createElement(
		view,
		{
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, v5.Size.Size_600),
			tag = "row align-y-center gap-small",
			testId = `{props.testId}--footer`
		},
		{
			Timestamp = React.createElement(
				view,
				{ LayoutOrder = 1, tag = "row align-y-center fill auto-y" },
				{
					Bar = React.createElement(skeleton, {
						Size = UDim2.fromOffset(props.timestampWidth, size_300),
						radius = radius.Medium,
						testId = `{props.testId}--timestamp`
					})
				}
			),
			Reaction = React.createElement(
				view,
				{
					LayoutOrder = 2,
					tag = "row align-y-center gap-xsmall auto-xy padding-right-small",
					testId = `{props.testId}--reaction`
				},
				{
					Icon = React.createElement(skeleton, {
						LayoutOrder = 1,
						Size = UDim2.fromOffset(v5.Size.Size_400, v5.Size.Size_400),
						radius = radius.Circle
					}),
					Count = React.createElement(skeleton, {
						LayoutOrder = 2,
						Size = UDim2.fromOffset(v5.Size.Size_400, size_300),
						radius = radius.Medium,
						testId = `{props.testId}--reaction-count`
					})
				}
			)
		}
	) else nil
	v17.Footer = v25
	v14.TextColumn = createElement2(view, {
		LayoutOrder = 2,
		tag = {
			["col fill auto-y"] = true,
			["gap-xsmall"] = FFlagMomentsCommentRowRedesign,
			["gap-small"] = not FFlagMomentsCommentRowRedesign
		}
	}, v17)
	return createElement(view, v13, v14)
end

return CommentRowSkeletonView
