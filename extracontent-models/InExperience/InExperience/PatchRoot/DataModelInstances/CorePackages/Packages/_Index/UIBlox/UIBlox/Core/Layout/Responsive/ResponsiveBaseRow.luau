local parent = script.Parent
local parent2 = parent.Parent.Parent.Parent.Parent

local Roact = require(parent2.Roact)
local t = require(parent2.t)
local LuauPolyfill = require(parent2.LuauPolyfill)
local Object = LuauPolyfill.Object

local ResponsiveLayoutContext = require(parent.ResponsiveLayoutContext)
local ResponsiveLayoutConfigReader = require(parent.ResponsiveLayoutConfigReader)

local extended = Roact.PureComponent:extend("ResponsiveBaseRow")

local function multilineScrollingValidator(props)
	if props.multiLine and props.scrollable then
		return false, "multiLine can't be scrollable"
	end

	return true
end

extended.validateProps = t.strictInterface({
	kind = t.optional(t.string),
	layoutOrder = t.optional(t.integer),
	zIndex = t.optional(t.number),
	scrollable = t.optional(t.boolean),
	clipsDescendants = t.optional(t.boolean),
	selectable = t.optional(t.boolean),
	pages = t.optional(t.numberPositive),
	multiLine = t.optional(t.boolean),
	lines = t.optional(t.intersection(t.integer, t.numberMin(0))),
	paddingTopLines = t.optional(t.intersection(t.integer, t.numberMin(0))),
	relativeHeight = t.optional(t.UDim),
	scrollingFrameRef = t.optional(t.table),
	[Roact.Children] = t.optional(t.table),
	gridBasicRowRef = t.optional(t.union(t.table, t.callback))
})

extended.defaultProps = {
	kind = "default",
	scrollable = false,
	selectable = false,
	clipsDescendants = true,
	multiLine = false
}

function extended:renderChildrenWithPadding(p, p2)
	local lines = self.props.lines or 1
	local paddingTopLines = self.props.paddingTopLines or 0
	local assign = Object.assign
	local createElement = Roact.createElement
	local v = { PaddingLeft = UDim.new(0, p), PaddingRight = UDim.new(0, p), PaddingTop = 0 }
	local paddingTop

	if self.props.multiLine and paddingTopLines > 0 and lines > 0 then
		paddingTop = UDim.new(paddingTopLines / lines, paddingTopLines / lines * p2)
	end

	v.PaddingTop = paddingTop
	return assign({ _uiblox_grid_padding_ = createElement("UIPadding", v) }, self.props[Roact.Children])
end

function extended:renderChildrenMultiline(fillDirectionMaxCells, p, p2, p3)
	local lines = self.props.lines or 1

	if self.props.paddingTopLines then
		lines -= self.props.paddingTopLines
	end

	local v = math.max(lines, 1)
	return Object.assign({
		_uiblox_grid_layout_ = Roact.createElement("UIGridLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirectionMaxCells = fillDirectionMaxCells,
			CellSize = UDim2.new(
				1 / fillDirectionMaxCells,
				math.floor((1 - fillDirectionMaxCells) / fillDirectionMaxCells * p2),
				1 / v,
				(math.floor((1 - v) / v * p3))
			),
			CellPadding = UDim2.fromOffset(p2, p3)
		})
	}, self:renderChildrenWithPadding(p, p3))
end

function extended:renderChildren(p, p2, p3, p4)
	local v = Object.assign({
		_uiblox_grid_layout_ = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, p3)
		})
	}, self:renderChildrenWithPadding(p2, p4))

	if not p then
		return v
	end

	local pages = self.props.pages or 1
	return {
		ResponsiveRowScroller = Roact.createElement("ScrollingFrame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			ScrollingDirection = Enum.ScrollingDirection.X,
			ScrollBarThickness = 0,
			CanvasSize = UDim2.new(pages, (pages - 1) * (p3 - 2 * p2), 1, 0),
			AutomaticCanvasSize = self.props.pages and Enum.AutomaticSize.None or Enum.AutomaticSize.X,
			Selectable = self.props.selectable,
			ClipsDescendants = self.props.clipsDescendants,
			[Roact.Ref] = self.props.scrollingFrameRef
		}, v)
	}
end

local function applyUDim(p, p2) -- 2 equivalent calls inferred from this helper
	return p.Scale * p2 + p.Offset
end

function extended:getSize(p, p2, p3, p4, p5)
	if p == nil then
		return UDim2.fromScale(1, 0)
	end

	local v = p.Scale / p5

	local v2 = applyUDim(p, (p2 - 2 * p4) / p5 - p2) -- inferred equivalent call

	if not (self.props.multiLine and self.props.lines) then
		return UDim2.new(1, 0, v, v2)
	end

	if self.props.lines == 0 then
		return UDim2.fromScale(1, 0)
	end

	v *= self.props.lines
	v2 = v2 * self.props.lines + (self.props.lines - 1) * p3

	return UDim2.new(1, 0, v, v2)
end

function extended:render()
	assert(multilineScrollingValidator(self.props))
	local relativeHeight = self.props.relativeHeight
	local scrollable = self.props.scrollable
	local multiLine = self.props.multiLine
	local v = not self.props.layoutOrder and "ResponsiveRow"
		or string.format("ResponsiveRow%02d", self.props.layoutOrder)

	return Roact.createElement(ResponsiveLayoutContext.Consumer, {
		render = function(p)
			local v2 = Object.assign({}, p, {
				kind = self.props.kind or Object.None,
				scrollable = scrollable,
				pages = self.props.pages or 1,
				multiLine = multiLine,
				relativeHeight = relativeHeight,
				subPixelOffset = 0
			})

			if not relativeHeight then
				relativeHeight = ResponsiveLayoutConfigReader.getValue(v2, "relativeHeight")
				v2.relativeHeight = relativeHeight
			end

			local value = ResponsiveLayoutConfigReader.getValue(v2, "width")
			local v3 = ResponsiveLayoutConfigReader.getValue(v2, "gutter") or 0
			local v4 = ResponsiveLayoutConfigReader.getValue(v2, "verticalGutter") or v3
			local v5 = ResponsiveLayoutConfigReader.getValue(v2, "margin") or 0
			local v6 = ResponsiveLayoutConfigReader.getValue(v2, "columns") or 1
			local v7 = relativeHeight and (not multiLine or self.props.lines)
			local size = self:getSize(relativeHeight, v3, v4, v5, v6)
			local createElement = Roact.createElement
			local provider = ResponsiveLayoutContext.Provider

			local createElement2 = Roact.createElement

			local gridBasicRowRefsByRef = {}
			gridBasicRowRefsByRef.Size = size
			gridBasicRowRefsByRef.SizeConstraint = Enum.SizeConstraint.RelativeXX
			local automaticSize

			if v7 then
				automaticSize = Enum.AutomaticSize.None
			else
				automaticSize = Enum.AutomaticSize.Y
			end

			gridBasicRowRefsByRef.AutomaticSize = automaticSize
			gridBasicRowRefsByRef.BackgroundTransparency = 1
			gridBasicRowRefsByRef.LayoutOrder = self.props.layoutOrder
			gridBasicRowRefsByRef.ZIndex = self.props.zIndex
			gridBasicRowRefsByRef[Roact.Ref] = self.props.gridBasicRowRef

			local assign = Object.assign
			local uiblox_grid_maxwidth_

			if value then
				local createElement3 = Roact.createElement
				local v8

				if relativeHeight then
					v8 = applyUDim(size.Y, value) -- inferred equivalent call
				else
					v8 = 1e999
				end

				uiblox_grid_maxwidth_ = createElement3("UISizeConstraint", {
					MaxSize = Vector2.new(value, v8)
				})
			end

			local v8

			if multiLine then
				v8 = self:renderChildrenMultiline(v6, v5, v3, v4)
			else
				v8 = self:renderChildren(scrollable, v5, v3, v4)
			end

			return createElement(provider, { value = v2 }, {
				[v] = createElement2(
					"Frame",
					gridBasicRowRefsByRef,
					assign({ _uiblox_grid_maxwidth_ = uiblox_grid_maxwidth_ }, v8)
				)
			})
		end
	})
end

return Roact.forwardRef(function(p, gridBasicRowRef)
	return Roact.createElement(extended, Object.assign({}, p, { gridBasicRowRef = gridBasicRowRef }))
end)
