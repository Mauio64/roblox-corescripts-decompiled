local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local CommentRowSkeletonView = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/List/Rows/CommentRowSkeletonView")

local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local function getRowShapes(p2)
	local size = p2.Size
	return {
		{
			authorWidth = size.Size_2400,
			timestampWidth = size.Size_500,
			bodyLineWidths = { 1, 0.62 }
		},
		{
			authorWidth = size.Size_1600,
			timestampWidth = size.Size_600,
			bodyLineWidths = { 0.45 }
		},
		{
			authorWidth = size.Size_2800,
			timestampWidth = size.Size_500,
			bodyLineWidths = { 0.96, 1, 0.38 }
		},
		{
			authorWidth = size.Size_2000,
			timestampWidth = size.Size_700,
			bodyLineWidths = { 0.8 }
		},
		{
			authorWidth = size.Size_2600,
			timestampWidth = size.Size_500,
			bodyLineWidths = { 1, 0.5 }
		},
		{
			authorWidth = size.Size_1800,
			timestampWidth = size.Size_600,
			bodyLineWidths = { 0.3 }
		},
		{
			authorWidth = size.Size_2200,
			timestampWidth = size.Size_500,
			bodyLineWidths = { 0.97, 0.72 }
		},
		{
			authorWidth = size.Size_3000,
			timestampWidth = size.Size_600,
			bodyLineWidths = { 0.55 }
		}
	}
end

local function CommentsListSkeletonView(p2)
	local children = {}

	for k, v6 in getRowShapes(useTokens()) do
		children[`Row{k}`] = React.createElement(CommentRowSkeletonView, {
			LayoutOrder = k,
			authorWidth = v6.authorWidth,
			timestampWidth = v6.timestampWidth,
			bodyLineWidths = v6.bodyLineWidths,
			testId = `{p2.testId}--row-{k}`
		})
	end

	return React.createElement(
		view,
		{ LayoutOrder = p2.LayoutOrder, tag = "col size-full clip", testId = p2.testId },
		children
	)
end

return CommentsListSkeletonView
