local parent = script:FindFirstAncestor("Moments").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local CommentRowSkeletonView = require(script.Parent.Rows.CommentRowSkeletonView)

local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local function getRowShapes(p)
	local size = p.Size
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

local function CommentsListSkeletonView(p)
	local children = {}

	for k, v in getRowShapes(useTokens()) do
		children[`Row{k}`] = React.createElement(CommentRowSkeletonView, {
			LayoutOrder = k,
			authorWidth = v.authorWidth,
			timestampWidth = v.timestampWidth,
			bodyLineWidths = v.bodyLineWidths,
			testId = `{p.testId}--row-{k}`
		})
	end

	return React.createElement(
		View,
		{ LayoutOrder = p.LayoutOrder, tag = "col size-full clip", testId = p.testId },
		children
	)
end

return CommentsListSkeletonView
