local ParentParent = script.Parent.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local ReactUtils = require(ParentParentParent.ReactUtils)
local useProperties = ReactUtils.useProperties
local usePropertiesDeferred = ReactUtils.usePropertiesDeferred
local UIBloxConfig = require(ParentParent.UIBloxConfig)
local ResponsiveRow = require(ParentParent.Core.Layout.Responsive.ResponsiveRow)
local useResponsiveLayout = require(ParentParent.Core.Layout.Responsive.useResponsiveLayout)

local function useCellAbsoluteHeight(uDim: UDim?, s1: string?) -- line: 60
	-- upvalues: useResponsiveLayout (copy), React (copy)
	local v16 = useResponsiveLayout("columns", s1) or 1
	local v17 = useResponsiveLayout("gutter", s1) or 0
	local v18 = useResponsiveLayout("verticalGutter", s1) or v17
	local v19 = useResponsiveLayout("margin", s1) or 0
	local v20 = useResponsiveLayout("relativeHeight", s1)
	local v21 = uDim or v20

	return React.useCallback(function(n1: number) -- line: 69
		-- upvalues: v21 (copy), v19 (copy), v17 (copy), v16 (copy), v18 (copy)
		if v21 then
			return math.max(((n1 - 2 * v19 + v17) / v16 - v17) * v21.Scale + v21.Offset, 0) + v18
		end

		return nil
	end, {
		v16,
		v17,
		v18,
		v19,
		v21
	})
end

local numberRange = NumberRange.new(0, 0)
local v12 = if not UIBloxConfig.responsiveGridDisplayLinesNonNil then nil else numberRange

local function ResponsiveGrid(t1: {[any]: any}, p1) -- line: 83
	-- upvalues: React (copy), v12 (copy), useCellAbsoluteHeight (copy), usePropertiesDeferred (copy), useProperties (copy), ResponsiveRow (copy)
	local v24, v25 = React.useState(v12)
	local v26 = useCellAbsoluteHeight(t1.relativeHeight, t1.kind)
	local v27 = React.useCallback(function(p2, p3) -- line: 87
		-- upvalues: t1 (copy), v26 (copy), v25 (copy), v12 (copy)
		if t1.absoluteWindowTop and t1.absoluteWindowHeight then
			local v32 = v26(p3.X)

			if v32 and v32 > 0 then
				local v33 = math.floor(math.max(t1.absoluteWindowTop - p2.Y, 0) / v32) + 1
				local v34 = math.ceil(math.max(t1.absoluteWindowHeight, 0) / v32) + 1

				return v25(NumberRange.new(v33, v33 + v34 - 1))
			end
		end

		return v25(v12)
	end, {
		v26,
		t1.absoluteWindowTop,
		t1.absoluteWindowHeight,
		v25
	})
	local v28 = ((if not t1.enableDeferredRefPropEvents then useProperties else usePropertiesDeferred))(p1, v27, {
		"AbsolutePosition",
		"AbsoluteSize"
	})

	return React.createElement(ResponsiveRow, {
		scrollable = false,
		multiLine = true,
		kind = t1.kind,
		layoutOrder = t1.layoutOrder,
		displayLines = if not t1.absoluteWindowTop or not t1.absoluteWindowHeight then nil else v24,
		relativeHeight = t1.relativeHeight,
		data = t1.data,
		getItem = t1.getItem,
		getItemCount = t1.getItemCount,
		renderItem = t1.renderItem,
		keyExtractor = t1.keyExtractor,
		getCellColspan = t1.getCellColspan,
		getCellRowspan = t1.getCellRowspan,
		getCellOrder = t1.getCellOrder,
		ref = v28
	})
end

return React.forwardRef(ResponsiveGrid)
