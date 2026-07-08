local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent.Parent.Parent
local Roact = require(ParentParent.Roact)
local t = require(ParentParent.t)
local Object = require(ParentParent.LuauPolyfill).Object
local ResponsiveLayoutContext = require(scriptParent.ResponsiveLayoutContext)
local ResponsiveLayoutConfigReader = require(scriptParent.ResponsiveLayoutConfigReader)
local v8 = Roact.PureComponent:extend("ResponsiveCell")

v8.validateProps = t.interface({
	layoutOrder = t.optional(t.integer),
	zIndex = t.optional(t.integer),
	colspan = t.optional(t.union(t.integer, t.table)),
	rowspan = t.optional(t.union(t.integer, t.table)),
	order = t.optional(t.union(t.integer, t.table)),
	[Roact.Children] = t.optional(t.table),
	gridCellRef = t.optional(t.union(t.table, t.callback))
})

local function findProp(p1, p2, p3) -- line: 35
	if p3 == nil then
		p3 = "default"
	end

	if p1[p2 .. "_" .. p3] ~= nil then
		return p1[p2 .. "_" .. p3]
	end

	if p1[p2] ~= nil then
		if type(p1[p2]) == "table" then
			if p1[p2][p3] ~= nil then
				return p1[p2][p3]
			end

			return p1[p2].default
		end

		return p1[p2]
	end

	return nil
end

function v8.getColspan(p4, p5) -- line: 56
	-- upvalues: findProp (copy)
	local v16 = findProp(p4.props, "colspan", p5)

	if v16 ~= nil then
		return v16
	end

	return 1
end
function v8.getRowspan(p6, p7) -- line: 61
	-- upvalues: findProp (copy)
	local v19 = findProp(p6.props, "rowspan", p7)

	if v19 ~= nil then
		return v19
	end

	return 1
end
function v8.getOrder(p8, p9) -- line: 66
	-- upvalues: findProp (copy)
	if p8.props.layoutOrder then
		return p8.props.layoutOrder
	end

	return (findProp(p8.props, "order", p9))
end

local function round(p10, p11) -- line: 75
	local v24 = math.floor(p10)

	p11.subPixelOffset = p11.subPixelOffset + (p10 - v24)

	local v25 = math.floor(p11.subPixelOffset + 0.5)

	p11.subPixelOffset = p11.subPixelOffset - v25

	return v24 + v25
end

function v8.getSize(_, p13, p14, p15) -- line: 84
	-- upvalues: ResponsiveLayoutConfigReader (copy)
	local v30 = ResponsiveLayoutConfigReader.getValue(p15, "gutter") or 0

	if p15.multiLine then
		local v31 = ResponsiveLayoutConfigReader.getValue(p15, "verticalGutter") or v30

		return UDim2.new(p13, (p13 - 1) * v30, p14, (p14 - 1) * v31)
	end

	local v32 = ResponsiveLayoutConfigReader.getValue(p15, "columns") or 1

	if p15.scrollable then
		v32 *= math.max(p15.pages, 1)
	end

	local new = UDim2.new
	local v34 = p13 / v32
	local v35 = (p13 / v32 - 1) * v30
	local v36 = math.floor(v35)

	p15.subPixelOffset = p15.subPixelOffset + (v35 - v36)

	local v37 = math.floor(p15.subPixelOffset + 0.5)

	p15.subPixelOffset = p15.subPixelOffset - v37

	return new(v34, v36 + v37, 1, 0)
end
function v8.render(p16) -- line: 103
	-- upvalues: Roact (copy), ResponsiveLayoutContext (copy)
	return Roact.createElement(ResponsiveLayoutContext.Consumer, {
		render = function(p17) -- line: 105
			-- upvalues: p16 (copy), Roact (copy)
			local v42 = p16:getColspan(p17.breakpoint)
			local v43 = not p17.multiLine and 1 or p16:getRowspan(p17.breakpoint)

			if v42 > 0 and v43 > 0 then
				local v44 = p16:getOrder(p17.breakpoint)
				local v45 = not v44 and "ResponsiveCell" or string.format("ResponsiveCell%02d", v44)
				local v46 = p17.multiLine and (v42 > 1 or v43 > 1)
				local v47 = Roact.createElement("Frame", {
					Name = if not v46 then v45 else nil,
					Size = p16:getSize(v42, v43, p17),
					AutomaticSize = if not p17.relativeHeight then Enum.AutomaticSize.Y else Enum.AutomaticSize.None,
					BackgroundTransparency = 1,
					LayoutOrder = v44,
					ZIndex = p16.props.zIndex,
					[Roact.Ref] = p16.props.gridCellRef
				}, p16.props[Roact.Children])

				if v46 then
					return Roact.createElement("Frame", {
						BackgroundTransparency = 1,
						Name = v45,
						LayoutOrder = v44
					}, {
						ResponsiveCellInner = v47
					})
				end

				return v47
			end

			return nil
		end
	})
end

return Roact.forwardRef(function(p18, p19) -- line: 141
	-- upvalues: Roact (copy), v8 (copy), Object (copy)
	return Roact.createElement(v8, Object.assign({}, p18, {
		gridCellRef = p19
	}))
end)
