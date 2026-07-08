local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent.Parent.Parent
local Roact = require(ParentParent.Roact)
local t = require(ParentParent.t)
local Object = require(ParentParent.LuauPolyfill).Object
local ResponsiveLayoutContext = require(scriptParent.ResponsiveLayoutContext)
local ResponsiveLayoutConfigReader = require(scriptParent.ResponsiveLayoutConfigReader)
local v8 = Roact.PureComponent:extend("ResponsiveBaseRow")

local function multilineScrollingValidator(p1) -- line: 16
	if p1.multiLine and p1.scrollable then
		return false, "multiLine can't be scrollable"
	end

	return true
end

v8.validateProps = t.strictInterface({
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
v8.defaultProps = {
	kind = "default",
	scrollable = false,
	selectable = false,
	clipsDescendants = true,
	multiLine = false
}

function v8.renderChildrenWithPadding(p2, p3, p4) -- line: 64
	-- upvalues: Object (copy), Roact (copy)
	local v15 = p2.props.lines or 1
	local v16 = p2.props.paddingTopLines or 0

	return Object.assign({
		_uiblox_grid_padding_ = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, p3),
			PaddingRight = UDim.new(0, p3),
			PaddingTop = if not p2.props.multiLine or (not (v16 > 0) or not (v15 > 0)) then nil else UDim.new(v16 / v15, v16 / v15 * p4)
		})
	}, p2.props[Roact.Children])
end
function v8.renderChildrenMultiline(p5, p6, p7, p8, p9) -- line: 80
	-- upvalues: Object (copy), Roact (copy)
	local v22 = p5.props.lines or 1

	if p5.props.paddingTopLines then
		v22 -= p5.props.paddingTopLines
	end

	local v23 = math.max(v22, 1)

	return Object.assign({
		_uiblox_grid_layout_ = Roact.createElement("UIGridLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirectionMaxCells = p6,
			CellSize = UDim2.new(1 / p6, math.floor((1 - p6) / p6 * p8), 1 / v23, (math.floor((1 - v23) / v23 * p9))),
			CellPadding = UDim2.fromOffset(p8, p9)
		})
	}, p5:renderChildrenWithPadding(p7, p9))
end
function v8.renderChildren(p10, p11, p12, p13, p14) -- line: 102
	-- upvalues: Object (copy), Roact (copy)
	local v29 = Object.assign({
		_uiblox_grid_layout_ = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, p13)
		})
	}, p10:renderChildrenWithPadding(p12, p14))

	if p11 then
		local v30 = p10.props.pages or 1

		return {
			ResponsiveRowScroller = Roact.createElement("ScrollingFrame", {
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				ScrollingDirection = Enum.ScrollingDirection.X,
				ScrollBarThickness = 0,
				CanvasSize = UDim2.new(v30, (v30 - 1) * (p13 - 2 * p12), 1, 0),
				AutomaticCanvasSize = p10.props.pages and Enum.AutomaticSize.None or Enum.AutomaticSize.X,
				Selectable = p10.props.selectable,
				ClipsDescendants = p10.props.clipsDescendants,
				[Roact.Ref] = p10.props.scrollingFrameRef
			}, v29)
		}
	end

	return v29
end

local function applyUDim(p15, p16) -- line: 136
	return p15.Scale * p16 + p15.Offset
end

function v8.getSize(p17, p18, p19, p20, p21, p22) -- line: 141
	if p18 == nil then
		return UDim2.fromScale(1, 0)
	end

	local v39 = p18.Scale / p22
	local v40 = (p19 - 2 * p21) / p22 - p19
	local v41 = p18.Scale * v40 + p18.Offset

	if p17.props.multiLine and p17.props.lines then
		if p17.props.lines == 0 then
			return UDim2.fromScale(1, 0)
		end

		v39 *= p17.props.lines
		v41 = v41 * p17.props.lines + (p17.props.lines - 1) * p20
	end

	return UDim2.new(1, 0, v39, v41)
end
function v8.render(p23) -- line: 165
	-- upvalues: multilineScrollingValidator (copy), Roact (copy), ResponsiveLayoutContext (copy), Object (copy), ResponsiveLayoutConfigReader (copy)
	assert(multilineScrollingValidator(p23.props))

	local relativeHeight = p23.props.relativeHeight
	local scrollable = p23.props.scrollable
	local multiLine = p23.props.multiLine
	local v46 = not p23.props.layoutOrder and "ResponsiveRow" or string.format("ResponsiveRow%02d", p23.props.layoutOrder)

	return Roact.createElement(ResponsiveLayoutContext.Consumer, {
		render = function(p24) -- line: 174
			-- upvalues: Object (copy), p23 (copy), scrollable (copy), multiLine (copy), relativeHeight (ref), ResponsiveLayoutConfigReader (copy), Roact (copy), ResponsiveLayoutContext (copy), v46 (copy)
			local v50 = Object.assign({}, p24, {
				subPixelOffset = 0,
				kind = p23.props.kind or Object.None,
				scrollable = scrollable,
				pages = p23.props.pages or 1,
				multiLine = multiLine,
				relativeHeight = relativeHeight
			})

			if not relativeHeight then
				relativeHeight = ResponsiveLayoutConfigReader.getValue(v50, "relativeHeight")
				v50.relativeHeight = relativeHeight
			end

			local v51 = ResponsiveLayoutConfigReader.getValue(v50, "width")
			local v52 = ResponsiveLayoutConfigReader.getValue(v50, "gutter") or 0
			local v53 = ResponsiveLayoutConfigReader.getValue(v50, "verticalGutter") or v52
			local v54 = ResponsiveLayoutConfigReader.getValue(v50, "margin") or 0
			local v55 = ResponsiveLayoutConfigReader.getValue(v50, "columns") or 1
			local v56 = relativeHeight and (not multiLine or p23.props.lines)
			local v57 = p23:getSize(relativeHeight, v52, v53, v54, v55)
			local createElement = Roact.createElement
			local Provider = ResponsiveLayoutContext.Provider
			local t1 = {
				value = v50
			}
			local t2 = {}
			local v62 = v46
			local createElement2 = Roact.createElement
			local t3 = {
				Size = v57,
				SizeConstraint = Enum.SizeConstraint.RelativeXX,
				AutomaticSize = if not v56 then Enum.AutomaticSize.Y else Enum.AutomaticSize.None,
				BackgroundTransparency = 1,
				LayoutOrder = p23.props.layoutOrder,
				ZIndex = p23.props.zIndex,
				[Roact.Ref] = p23.props.gridBasicRowRef
			}
			local assign = Object.assign
			local t4 = {}
			local v72

			if v51 then
				local createElement3 = Roact.createElement
				local t5 = {}
				local new = Vector2.new
				local v71

				if relativeHeight then
					local Y = v57.Y

					v71 = Y.Scale * v51 + Y.Offset
				else
					v71 = 1e999
				end

				t5.MaxSize = new(v51, v71)
				v72 = createElement3("UISizeConstraint", t5)
			else
				v72 = nil
			end

			t4._uiblox_grid_maxwidth_ = v72
			t2[v62] = createElement2("Frame", t3, assign(t4, if not multiLine then p23:renderChildren(scrollable, v54, v52, v53) else p23:renderChildrenMultiline(v55, v54, v52, v53)))

			return createElement(Provider, t1, t2)
		end
	})
end

return Roact.forwardRef(function(p25, p26) -- line: 230
	-- upvalues: Roact (copy), v8 (copy), Object (copy)
	return Roact.createElement(v8, Object.assign({}, p25, {
		gridBasicRowRef = p26
	}))
end)
