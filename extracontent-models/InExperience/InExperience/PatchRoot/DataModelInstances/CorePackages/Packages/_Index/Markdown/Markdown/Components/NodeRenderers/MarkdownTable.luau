local Markdown = script:FindFirstAncestor("Markdown")

local parent = Markdown.Parent
local Foundation = require(parent.Foundation)
local React = require(parent.React)

local getRowContext = require(script.getRowContext)
local MarkdownTable = require(script.MarkdownTable)
local renderInline = require(Markdown.Components.NodeRenderers.renderInline)
local shouldUseTopPadding = require(Markdown.Utils.shouldUseTopPadding)
local TableAlignment = require(Markdown.Enums.TableAlignment)
require(Markdown.Types)

local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local v = {
	[TableAlignment.Left] = Enum.HorizontalAlignment.Left,
	[TableAlignment.Center] = Enum.HorizontalAlignment.Center,
	[TableAlignment.Right] = Enum.HorizontalAlignment.Right
}

local function TableDivider(p)
	local v2 = useTokens()
	local standard = v2.Stroke.Standard

	local createElement = React.createElement
	local size

	if p.isVertical then
		size = UDim2.fromOffset(standard, 0)
	else
		size = UDim2.fromOffset(0, standard)
	end

	return createElement(View, {
		tag = "self-stretch",
		Size = size,
		backgroundStyle = v2.Color.Stroke.Default,
		LayoutOrder = p.LayoutOrder
	})
end

local function renderTableRowCells(node, context, ref, onAbsoluteSizeChanged)
	local children = context.processChildren(node, getRowContext(node, context))

	for i = 2, #node.children do
		table.insert(children, React.createElement(TableDivider, {
			key = `Divider{i}`,
			isVertical = true,
			LayoutOrder = i * 2 - 1
		}))
	end

	return React.createElement(
		View,
		{
			tag = "auto-xy row items-start",
			onAbsoluteSizeChanged = onAbsoluteSizeChanged,
			LayoutOrder = 2,
			ref = ref
		},
		children
	)
end

local function TableRow(p)
	local node = p.node

	local v2 = node.name == "TABLE_HEADER"
	local radiusmedium = node.index == p.context.tableRowCount

	local ref = React.useRef(nil)
	local state, setState = React.useState(Vector2.zero)
	local v3 = React.useCallback(function(p2)
		setState(p2.AbsoluteSize)
	end, {})

	React.useLayoutEffect(function()
		if v2 and ref.current then
			setState(ref.current.AbsoluteSize)
		end
	end, { v2 })

	local createElement = React.createElement
	local v4 = { tag = "auto-xy col items-stretch", LayoutOrder = node.index }
	local divider

	if node.index > 1 then
		divider = React.createElement(TableDivider, { LayoutOrder = 1, isVertical = false })
	end

	local createElement2 = React.createElement
	local background

	if v2 then
		background = React.createElement(View, {
			tag = {
				["bg-shift-100"] = true,
				["radius-medium"] = radiusmedium,
				["radius-top-medium"] = not radiusmedium
			},
			Size = UDim2.fromOffset(state.X, state.Y),
			ZIndex = 0
		})
	end

	local context = p.context

	if not v2 then
		v3 = nil
	end

	return createElement(View, v4, {
		Divider = divider,
		Content = createElement2(View, { tag = "auto-xy", LayoutOrder = 2 }, {
			Background = background,
			Cells = renderTableRowCells(node, context, ref, v3)
		})
	})
end

local MarkdownTable_2 = {}

function MarkdownTable_2.renderTable(node, context)
	return React.createElement(
		View,
		{ key = tostring(node.index), tag = "size-full-0 auto-y col", LayoutOrder = node.index },
		{
			UIPadding = shouldUseTopPadding(node) and React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 10)
			}),
			Table = React.createElement(MarkdownTable, { node = node, context = context })
		}
	)
end

function MarkdownTable_2.renderTableRow(node, context)
	return React.createElement(TableRow, {
		key = tostring(node.index),
		node = node,
		context = context
	})
end

function MarkdownTable_2.renderTableCell(p, p2)
	local index = p.index or 1
	local v2

	if p2.tableColumnWidths then
		v2 = p2.tableColumnWidths[index]
	end

	local alignment = p.attributes and p.attributes.alignment
	local tableCellPadding = p2.tableCellPadding or { x = 0, y = 0, text = 0 }

	local createElement = React.createElement
	local v3 = {
		key = tostring(index),
		tag = "auto-y",
		Size = UDim2.fromOffset(v2 or 0, 0),
		LayoutOrder = index * 2
	}
	local v4 = {
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, tableCellPadding.y),
			PaddingBottom = UDim.new(0, tableCellPadding.y),
			PaddingLeft = UDim.new(0, tableCellPadding.x),
			PaddingRight = UDim.new(0, tableCellPadding.x)
		}),
		Text = 0
	}

	local createElement2 = React.createElement

	local v5 = {
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, tableCellPadding.text),
			PaddingBottom = UDim.new(0, tableCellPadding.text)
		}),
		InlineLayout = 0
	}
	local v6

	if alignment then
		v6 = v[alignment]
	end

	v5.InlineLayout = renderInline(p, p2, v6)
	v4.Text = createElement2(View, { tag = "size-full-0 auto-y" }, v5)
	return createElement(View, v3, v4)
end

return MarkdownTable_2
