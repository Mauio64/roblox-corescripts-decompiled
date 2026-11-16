local parent = script.Parent
local parent2 = parent.Parent.Parent.Parent
local parent3 = parent2.Parent

local Roact = require(parent3.Roact)
local t = require(parent3.t)
local LuauPolyfill = require(parent3.LuauPolyfill)
local Object = LuauPolyfill.Object
local Array = LuauPolyfill.Array
local UIBloxConfig = require(parent2.UIBloxConfig)

local ResponsiveLayoutContext = require(parent.ResponsiveLayoutContext)
local ResponsiveLayoutConfigReader = require(parent.ResponsiveLayoutConfigReader)
local ResponsiveBaseRow = require(parent.ResponsiveBaseRow)
local ResponsiveCell = require(parent.ResponsiveCell)

local extended = Roact.PureComponent:extend("ResponsiveRow")

extended.validateProps = t.strictInterface({
	kind = t.optional(t.string),
	layoutOrder = t.optional(t.integer),
	zIndex = t.optional(t.number),
	scrollable = t.optional(t.boolean),
	clipsDescendants = t.optional(t.boolean),
	selectable = t.optional(t.boolean),
	multiLine = t.optional(t.boolean),
	displayLines = t.optional(t.NumberRange),
	relativeHeight = t.optional(t.UDim),
	data = t.optional(t.any),
	getItem = t.optional(t.callback),
	getItemCount = t.optional(t.callback),
	renderItem = t.optional(t.callback),
	keyExtractor = t.optional(t.callback),
	getCellColspan = t.optional(t.callback),
	getCellRowspan = t.optional(t.callback),
	getCellOrder = t.optional(t.callback),
	scrollingFrameRef = t.optional(t.table),
	forwardedRef = t.optional(t.union(t.table, t.callback))
})

extended.defaultProps = {
	kind = "default",
	multiLine = false,
	data = {},
	getItem = function(p, p2, _)
		if type(p) == "table" then
			return p[p2]
		end

		return nil
	end,
	renderItem = function(p, _)
		return p
	end,
	getCellColspan = function(_, _): nil
		return nil
	end,
	getCellRowspan = function(_, _): nil
		return nil
	end,
	getCellOrder = function(_, _): nil
		return nil
	end
}

local function countItems(props, p)
	if props.getItemCount then
		return props.getItemCount(props.data, p)
	end

	if props.getItem == extended.defaultProps.getItem then
		return #props.data
	end

	for i = 1, p.columns do
		if props.getItem(props.data, i, p) == nil then
			return i - 1
		end
	end

	return p.columns
end

local function resolveCellProp(callback, item, p, i) -- 3 equivalent calls inferred from this helper
	if not callback then
		return i
	end

	local v = callback(item, p)

	if v == nil then
		return i
	end

	if type(v) ~= table then
		return v
	end

	local breakpoint = p.breakpoint or "default"

	if v[breakpoint] ~= nil then
		return v[breakpoint]
	end

	return if v.default ~= nil then v.default else i
end

local function addPaddingCells(p, p2)
	local set = {}
	local function shouldSkip(p3) -- 1 equivalent call inferred from this helper
		local v = math.floor(p3 / p2.columns)
		local v2 = p3 - v * p2.columns
		return set[string.format("%d,%d", v2, v)]
	end

	local function setSkip(p3, colspan, rowspan)
		local v = math.floor(p3 / p2.columns)
		local v2 = p3 - v * p2.columns

		for i = v2, v2 + colspan - 1 do
			for j = v, v + rowspan - 1 do
				set[string.format("%d,%d", i, j)] = true
			end
		end
	end
	return Array.reduce(p, function(list, p3)
		while shouldSkip(#list) do -- inferred equivalent call
			table.insert(list, {
				order = #list + 1
			})
		end

		if p3.colspan > 1 or p3.rowspan > 1 then
			setSkip(#list, p3.colspan, p3.rowspan)
		end

		table.insert(list, Object.assign({}, p3, {
			order = #list + 1
		}))

		return list
	end, {})
end

local function formatCellKey(p, p2) -- 2 equivalent calls inferred from this helper
	local v = math.floor(math.log10(p2) + 1)
	return string.format("ResponsiveRowCell%0" .. v .. "d", p)
end

function filterDisplayedCells(p, p2, p3)
	local v = (p3.Min - 1) * p2.columns + 1
	local v2 = p3.Max * p2.columns

	local filtered = Array.filter(p, function(_, p4): boolean
		return v <= p4 and p4 <= v2
	end)

	local v3 = (p3.Max - p3.Min + 1) * p2.columns

	return Array.map(filtered, function(p4, _)
		return Object.assign({}, p4, {
			key = formatCellKey((p4.order - 1) % v3 + 1, v3) -- inferred equivalent call
		})
	end)
end

function extended:init()
	self.itemCache = {}
end

function extended:renderChildren(p)
	local itemCache = {}
	local v = {}
	local v2 = 1
	local v3 = 1

	for i = 1, countItems(self.props, p) do
		local item = self.props.getItem(self.props.data, i, p)

		local v4 = nil
		local v5

		if self.props.keyExtractor then
			v5 = self.props.keyExtractor(item, i, p)
		end

		if v5 and self.itemCache[v5] then
			v4 = self.itemCache[v5]
		end

		local cell = v4 or self.props.renderItem(item, p)

		if v5 then
			itemCache[v5] = cell
		end

		local v6 = {
			colspan = resolveCellProp(self.props.getCellColspan, item, p, 1), -- inferred equivalent call
			rowspan = resolveCellProp(self.props.getCellRowspan, item, p, 1), -- inferred equivalent call
			order = resolveCellProp(self.props.getCellOrder, item, p, i), -- inferred equivalent call
			cell = cell
		}
		table.insert(v, v6)
	end

	self.itemCache = itemCache

	if self.props.multiLine then
		Array.sort(v, function(p2, p3)
			return p2.order - p3.order
		end)

		v = addPaddingCells(v, p)
		v3 = math.ceil(#v / p.columns)

		if self.props.displayLines then
			v = filterDisplayedCells(v, p, self.props.displayLines)
		end
	elseif self.props.scrollable then
		v2 = Array.reduce(v, function(p2, p3)
			return p2 + p3.colspan
		end, 0) / p.columns
	end

	if UIBloxConfig.setZIndexOnGridCells then
		for i = 1, #v do
			v[i].zIndex = #v + 2 - i
		end
	end

	return Array.map(v, function(props, p2)
		return Roact.createElement(ResponsiveCell, {
			key = props.key or formatCellKey(p2, #v), -- inferred equivalent call
			colspan = props.colspan,
			rowspan = props.rowspan,
			order = props.order,
			zIndex = props.zIndex
		}, { ResponsiveItem = props.cell })
	end), v2, v3
end

function extended:render()
	return Roact.createElement(ResponsiveLayoutContext.Consumer, {
		render = function(p)
			local v = Object.assign({}, p, {
				kind = self.props.kind or Object.None
			})

			local children, pages, lines = self:renderChildren({
				breakpoint = v.breakpoint,
				kind = v.kind,
				width = ResponsiveLayoutConfigReader.getValue(v, "width") or 1,
				columns = ResponsiveLayoutConfigReader.getValue(v, "columns") or 1,
				margin = ResponsiveLayoutConfigReader.getValue(v, "margin") or 1,
				gutter = ResponsiveLayoutConfigReader.getValue(v, "gutter") or 1,
				verticalGutter = ResponsiveLayoutConfigReader.getValue(v, "verticalGutter")
			})

			local createElement = Roact.createElement
			local forwardedRefsByRef = {
				["kind"] = self.props.kind,
				layoutOrder = self.props.layoutOrder,
				zIndex = self.props.zIndex,
				scrollable = self.props.scrollable,
				clipsDescendants = self.props.clipsDescendants,
				selectable = self.props.selectable,
				pages = pages,
				multiLine = self.props.multiLine,
				lines = lines
			}
			local paddingTopLines

			if self.props.multiLine and self.props.displayLines then
				paddingTopLines = math.max(self.props.displayLines.Min - 1, 0)
			end

			forwardedRefsByRef.paddingTopLines = paddingTopLines

			forwardedRefsByRef.relativeHeight = self.props.relativeHeight
			forwardedRefsByRef.scrollingFrameRef = self.props.scrollingFrameRef
			forwardedRefsByRef[Roact.Ref] = self.props.forwardedRef
			return createElement(ResponsiveBaseRow, forwardedRefsByRef, children)
		end
	})
end

return Roact.forwardRef(function(p, forwardedRef)
	return Roact.createElement(extended, Object.assign({}, p, { forwardedRef = forwardedRef }))
end)
