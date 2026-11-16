local Markdown = script:FindFirstAncestor("Markdown")

local parent = Markdown.Parent
local Dash = require(parent.Dash)
local InlineLayout = require(parent.InlineLayout)

local getRowContext = require(script.Parent.getRowContext)
local mergeContexts = require(Markdown.Utils.mergeContexts)
require(Markdown.Types)

local HardBreakElement = InlineLayout.Components.InlineLayoutElements.HardBreakElement
local isInlineElement = InlineLayout.Utils.isInlineElement

local function measureUnwrappedWidth(filtered)
	local total = 0
	local maxValue = 0

	for _, item in filtered do
		if item == HardBreakElement then
			total = 0
		else
			total += item:getWidth()
			maxValue = math.max(maxValue, total)
		end
	end

	return (math.ceil(maxValue))
end

local function getStyleKey(data)
	return Dash.pretty(
		{
			textStyles = data.textStyles,
			codeStyles = data.codeStyles,
			linkStyles = data.linkStyles,
			imageStyles = data.imageStyles
		},
		{ depth = 4 }
	)
end

local function getContentKey(child)
	local text = child.text or ""
	local contentKey = `{child.name}:{#text}:{text}`

	if child.attributes then
		contentKey ..= Dash.pretty(child.attributes)
	end

	for _, child2 in child.children do
		contentKey ..= `({getContentKey(child2)})`
	end

	return contentKey
end

local ColumnWidths = {}
ColumnWidths.MIN_COLUMN_CONTENT_WIDTH = 80

function ColumnWidths.createWidthCache()
	return { styleKey = "", cellWidths = {} }
end

function ColumnWidths.measureColumnContentWidths(p, p2, state)
	local styleKey = getStyleKey(p2)
	local v = state.styleKey ~= styleKey and {} or state.cellWidths
	local cellWidths = {}
	local columnContentWidths = {}

	for _, child in p.children do
		local v2 = mergeContexts(getRowContext(child, p2), { isInline = true })

		for k, child2 in child.children do
			local v3 = child.name .. getContentKey(child2)
			local v4 = cellWidths[v3]
				or v[v3]
				or measureUnwrappedWidth(Dash.filter(v2.processChildren(child2, v2), isInlineElement))

			cellWidths[v3] = v4
			columnContentWidths[k] = math.max(columnContentWidths[k] or 0, v4)
		end
	end

	state.styleKey = styleKey
	state.cellWidths = cellWidths

	return columnContentWidths
end

function ColumnWidths.computeColumnWidths(items, p: number, p2: number)
	local result = {}
	local result2 = {}
	local total = 0
	local total2 = 0

	for k, item in items do
		result[k] = item + p2
		result2[k] = math.min(item, 80) + p2
		total += result[k]
		total2 += result2[k]
	end

	if total <= p then
		return result
	end

	if p <= total2 then
		return result2
	end

	local v = (p - total2) / (total - total2)

	return Dash.map(result2, function(p3, p4)
		return (math.floor(p3 + (result[p4] - p3) * v))
	end)
end

function ColumnWidths.fillUnmeasuredColumns(list, p: number)
	if p <= #list then
		return list
	end

	local clone = table.clone(list)

	for i = #list + 1, p do
		clone[i] = 80
	end

	return clone
end

return ColumnWidths
