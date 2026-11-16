local parent = script.Parent.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)

local ReactUtils = require(parent2.ReactUtils)
local useProperties = ReactUtils.useProperties
local usePropertiesDeferred = ReactUtils.usePropertiesDeferred

local UIBloxConfig = require(parent.UIBloxConfig)

local ResponsiveRow = require(parent.Core.Layout.Responsive.ResponsiveRow)
local useResponsiveLayout = require(parent.Core.Layout.Responsive.useResponsiveLayout)

local function useCellAbsoluteHeight(relativeHeight: UDim?, kind: string?)
	local v = useResponsiveLayout("columns", kind) or 1
	local v2 = useResponsiveLayout("gutter", kind) or 0
	local v3 = useResponsiveLayout("verticalGutter", kind) or v2
	local v4 = useResponsiveLayout("margin", kind) or 0
	local v5 = useResponsiveLayout("relativeHeight", kind)

	local v6 = relativeHeight or v5

	return React.useCallback(function(p: number)
		if v6 then
			return math.max(((p - 2 * v4 + v2) / v - v2) * v6.Scale + v6.Offset, 0) + v3
		end

		return nil
	end, { v, v2, v3, v4, v6 })
end

local numberRange = NumberRange.new(0, 0)

if not UIBloxConfig.responsiveGridDisplayLinesNonNil then
	numberRange = nil
end

local function ResponsiveGrid(props, p)
	local state, setState = React.useState(numberRange)
	local v = useCellAbsoluteHeight(props.relativeHeight, props.kind)

	local v2 = React.useCallback(function(p2, p3)
		if props.absoluteWindowTop and props.absoluteWindowHeight then
			local v2 = v(p3.X)

			if v2 and v2 > 0 then
				local v3 = math.floor(math.max(props.absoluteWindowTop - p2.Y, 0) / v2) + 1
				local v4 = math.ceil(math.max(props.absoluteWindowHeight, 0) / v2) + 1
				return setState(NumberRange.new(v3, v3 + v4 - 1))
			end
		end

		return setState(numberRange)
	end, { v, props.absoluteWindowTop, props.absoluteWindowHeight, setState })
	local v3

	if props.enableDeferredRefPropEvents then
		v3 = usePropertiesDeferred
	else
		v3 = useProperties
	end

	local ref = v3(p, v2, { "AbsolutePosition", "AbsoluteSize" })

	local createElement = React.createElement
	local v4 = {
		kind = props.kind,
		layoutOrder = props.layoutOrder,
		scrollable = false,
		multiLine = true,
		displayLines = 0,
		relativeHeight = 0,
		data = 0,
		getItem = 0,
		getItemCount = 0,
		renderItem = 0,
		keyExtractor = 0,
		getCellColspan = 0,
		getCellRowspan = 0,
		getCellOrder = 0,
		ref = 0
	}

	if not (props.absoluteWindowTop and props.absoluteWindowHeight) then
		state = nil
	end

	v4.displayLines = state
	v4.relativeHeight = props.relativeHeight
	v4.data = props.data
	v4.getItem = props.getItem
	v4.getItemCount = props.getItemCount
	v4.renderItem = props.renderItem
	v4.keyExtractor = props.keyExtractor
	v4.getCellColspan = props.getCellColspan
	v4.getCellRowspan = props.getCellRowspan
	v4.getCellOrder = props.getCellOrder
	v4.ref = ref
	return createElement(ResponsiveRow, v4)
end

return React.forwardRef(ResponsiveGrid)
