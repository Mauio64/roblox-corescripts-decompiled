local parent = script.Parent
local parent2 = parent.Parent.Parent.Parent.Parent

local Roact = require(parent2.Roact)
local t = require(parent2.t)
local LuauPolyfill = require(parent2.LuauPolyfill)
local Object = LuauPolyfill.Object

local ResponsiveLayoutContext = require(parent.ResponsiveLayoutContext)
local ResponsiveLayoutConfigReader = require(parent.ResponsiveLayoutConfigReader)

local extended = Roact.PureComponent:extend("ResponsiveCell")

extended.validateProps = t.interface({
	layoutOrder = t.optional(t.integer),
	zIndex = t.optional(t.integer),
	colspan = t.optional(t.union(t.integer, t.table)),
	rowspan = t.optional(t.union(t.integer, t.table)),
	order = t.optional(t.union(t.integer, t.table)),
	[Roact.Children] = t.optional(t.table),
	gridCellRef = t.optional(t.union(t.table, t.callback))
})

local function findProp(props, p, p2)
	local v = p2 == nil and "default" or p2

	if props[p .. "_" .. v] ~= nil then
		return props[p .. "_" .. v]
	end

	if props[p] == nil then
		return nil
	end

	if type(props[p]) ~= "table" then
		return props[p]
	end

	if props[p][v] == nil then
		return props[p].default
	end

	return props[p][v]
end

function extended:getColspan(p)
	local prop = findProp(self.props, "colspan", p)
	return if prop == nil then 1 else prop
end

function extended:getRowspan(p)
	local prop = findProp(self.props, "rowspan", p)
	return if prop == nil then 1 else prop
end

function extended:getOrder(p)
	if self.props.layoutOrder then
		return self.props.layoutOrder
	end

	return findProp(self.props, "order", p)
end

local function round(p, data) -- 1 equivalent call inferred from this helper
	local v = math.floor(p)
	data.subPixelOffset += p - v
	local v2 = math.floor(data.subPixelOffset + 0.5)
	data.subPixelOffset -= v2
	return v + v2
end

function extended:getSize(p, p2, data)
	local v = ResponsiveLayoutConfigReader.getValue(data, "gutter") or 0

	if data.multiLine then
		local v2 = ResponsiveLayoutConfigReader.getValue(data, "verticalGutter") or v

		return UDim2.new(p, (p - 1) * v, p2, (p2 - 1) * v2)
	end

	local v2 = ResponsiveLayoutConfigReader.getValue(data, "columns") or 1

	if data.scrollable then
		v2 *= math.max(data.pages, 1)
	end

	return UDim2.new(p / v2, round((p / v2 - 1) * v, data), 1, 0) -- inferred equivalent call
end

function extended:render()
	return Roact.createElement(ResponsiveLayoutContext.Consumer, {
		render = function(props)
			local colspan = self:getColspan(props.breakpoint)
			local v = not props.multiLine and 1 or self:getRowspan(props.breakpoint)

			if not (colspan > 0 and v > 0) then
				return nil
			end

			local order = self:getOrder(props.breakpoint)
			local name = not order and "ResponsiveCell" or string.format("ResponsiveCell%02d", order)
			local v2 = props.multiLine and (colspan > 1 or v > 1)
			local createElement = Roact.createElement
			local name2

			if not v2 then
				name2 = name
			end

			local gridCellRefsByRef = {}
			gridCellRefsByRef.Name = name2
			gridCellRefsByRef.Size = self:getSize(colspan, v, props)
			local automaticSize

			if props.relativeHeight then
				automaticSize = Enum.AutomaticSize.None
			else
				automaticSize = Enum.AutomaticSize.Y
			end

			gridCellRefsByRef.AutomaticSize = automaticSize
			gridCellRefsByRef.BackgroundTransparency = 1
			gridCellRefsByRef.LayoutOrder = order
			gridCellRefsByRef.ZIndex = self.props.zIndex
			gridCellRefsByRef[Roact.Ref] = self.props.gridCellRef
			local element = createElement("Frame", gridCellRefsByRef, self.props[Roact.Children])

			if v2 then
				return Roact.createElement("Frame", {
					Name = name,
					BackgroundTransparency = 1,
					LayoutOrder = order
				}, {
					ResponsiveCellInner = element
				})
			end

			return element
		end
	})
end

return Roact.forwardRef(function(p, gridCellRef)
	return Roact.createElement(extended, Object.assign({}, p, { gridCellRef = gridCellRef }))
end)
