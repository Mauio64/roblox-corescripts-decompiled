local Markdown = script:FindFirstAncestor("Markdown")

local parent = Markdown.Parent
local Dash = require(parent.Dash)
local Foundation = require(parent.Foundation)
local React = require(parent.React)

local columnWidths = require(script.Parent.columnWidths)
local mergeContexts = require(Markdown.Utils.mergeContexts)
require(Markdown.Types)

local ScrollView = Foundation.ScrollView
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local function getTableContext(context)
	return mergeContexts(context, {
		textStyles = { textTags = "text-body-medium content-default" }
	})
end

local function getColumnCount(node) -- 1 equivalent call inferred from this helper
	local child = node.children[1]

	if child then
		return #child.children
	end

	return 0
end

local function getCellPadding(p, p2)
	local v = (p.textStyles.textSize or p2.Typography.BodyMedium.FontSize) / p2.Typography.BodyMedium.FontSize
	return {
		x = math.round(p2.Padding.XLarge * v),
		y = math.round(p2.Padding.Medium * v),
		text = math.round(p2.Padding.XXSmall * v)
	}
end

local function MarkdownTable(p)
	local v = useTokens()

	local state, setState = React.useState(0)
	local state2, setState2 = React.useState(nil)
	local ref = React.useRef(nil)

	local v2 = React.useMemo(function()
		return getTableContext(p.context)
	end, { p.context })

	React.useEffect(function()
		local current = ref.current or columnWidths.createWidthCache()
		ref.current = current
		local columnContentWidths = columnWidths.measureColumnContentWidths(p.node, v2, current)
		setState2(function(p2)
			if p2 and Dash.shallowEqual(p2, columnContentWidths) then
				return p2
			end

			return columnContentWidths
		end)
	end, { p.node, v2 })

	local onAbsoluteSizeChanged = React.useCallback(function(p2)
		setState(p2.AbsoluteSize.X)
	end, {})

	local cellPadding = getCellPadding(v2, v)
	local columnCount = getColumnCount(p.node) -- inferred equivalent call
	local standard = math.ceil(v.Stroke.Standard)
	local v3 = math.max(columnCount - 1, 0) * v.Stroke.Standard
	local tableColumnWidths

	if state2 and state > 0 then
		tableColumnWidths = columnWidths.computeColumnWidths(
			columnWidths.fillUnmeasuredColumns(state2, columnCount),
			state - standard * 2 - v3,
			cellPadding.x * 2
		)
	end

	local v4 = not tableColumnWidths and 0 or Dash.sum(tableColumnWidths) + v3 + standard * 2
	local v5 = not (state < v4) and 0 or v.Size.Size_150 + v.Gap.XSmall

	local scroll = React.useMemo(function()
		return {
			AutomaticSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.fromOffset(v4, 0),
			ScrollingDirection = Enum.ScrollingDirection.X,
			scrollBarVisibility = Foundation.Enums.Visibility.Always
		}
	end, { v4 })

	return React.createElement(View, {
		tag = "size-full-0 auto-y",
		onAbsoluteSizeChanged = onAbsoluteSizeChanged
	}, {
		ScrollView = React.createElement(ScrollView, { tag = "size-full-0 auto-y", scroll = scroll }, {
			BorderInset = React.createElement(View, { tag = "auto-xy" }, {
				UIPadding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, standard),
					PaddingBottom = UDim.new(0, standard + v5),
					PaddingLeft = UDim.new(0, standard),
					PaddingRight = UDim.new(0, standard)
				}),
				Table = tableColumnWidths and React.createElement(
					View,
					{ tag = "auto-xy col gap-none radius-medium stroke-standard stroke-default" },
					v2.processChildren(p.node, mergeContexts(v2, {
						tableColumnWidths = tableColumnWidths,
						tableCellPadding = cellPadding,
						tableRowCount = #p.node.children
					}))
				)
			})
		})
	})
end

return MarkdownTable
