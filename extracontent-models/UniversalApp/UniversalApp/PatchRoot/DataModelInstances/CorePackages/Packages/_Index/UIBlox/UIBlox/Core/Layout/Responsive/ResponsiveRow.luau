local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Roact = require(ParentParentParent.Roact)
local t = require(ParentParentParent.t)
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Object = LuauPolyfill.Object
local Array = LuauPolyfill.Array
local UIBloxConfig = require(ParentParent.UIBloxConfig)
local ResponsiveLayoutContext = require(scriptParent.ResponsiveLayoutContext)
local ResponsiveLayoutConfigReader = require(scriptParent.ResponsiveLayoutConfigReader)
local ResponsiveBaseRow = require(scriptParent.ResponsiveBaseRow)
local ResponsiveCell = require(scriptParent.ResponsiveCell)
local v14 = Roact.PureComponent:extend("ResponsiveRow")

v14.validateProps = t.strictInterface({
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
v14.defaultProps = {
	kind = "default",
	multiLine = false,
	data = {},
	getItem = function(p1, p2, _) -- line: 78
		if type(p1) == "table" then
			return p1[p2]
		end

		return nil
	end,
	renderItem = function(p4, _) -- line: 85
		return p4
	end,
	getCellColspan = function(_, _) -- line: 88
		return nil
	end,
	getCellRowspan = function(_, _) -- line: 91
		return nil
	end,
	getCellOrder = function(_, _) -- line: 94
		return nil
	end
}

local function countItems(p12, p13) -- line: 99
	-- upvalues: v14 (copy)
	if p12.getItemCount then
		return p12.getItemCount(p12.data, p13)
	end

	if p12.getItem == v14.defaultProps.getItem then
		return #p12.data
	end

	for i = 1, p13.columns do
		if p12.getItem(p12.data, i, p13) == nil then
			return i - 1
		end
	end

	return p13.columns
end
local function resolveCellProp(p14, p15, p16, p17) -- line: 114
	if p14 then
		local v37 = p14(p15, p16)

		if v37 ~= nil then
			if type(v37) ~= table then
				return v37
			end

			local v38 = p16.breakpoint or "default"

			if v37[v38] ~= nil then
				return v37[v38]
			end

			if v37.default ~= nil then
				return v37.default
			end
		end
	end

	return p17
end
local function addPaddingCells(p18, p19) -- line: 133
	-- upvalues: Array (copy), Object (copy)
	local t1 = {}

	local function shouldSkip(p20) -- line: 135
		-- upvalues: p19 (copy), t1 (copy)
		local v86 = math.floor(p20 / p19.columns)
		local v87 = p20 - v86 * p19.columns

		return t1[string.format("%d,%d", v87, v86)]
	end
	local function setSkip(p21, p22, p23) -- line: 140
		-- upvalues: p19 (copy), t1 (copy)
		local v91 = math.floor(p21 / p19.columns)
		local v92 = p21 - v91 * p19.columns

		for i = v92, v92 + p22 - 1 do
			for j = v91, v91 + p23 - 1 do
				t1[string.format("%d,%d", i, j)] = true
			end
		end
	end

	return Array.reduce(p18, function(p24, p25) -- line: 149
		-- upvalues: p19 (copy), t1 (copy), setSkip (copy), Object (copy)
		while true do
			local v97 = #p24
			local v98 = math.floor(v97 / p19.columns)
			local v99 = v97 - v98 * p19.columns

			if not t1[string.format("%d,%d", v99, v98)] then
				break
			end

			table.insert(p24, {
				order = #p24 + 1
			})
		end

		if p25.colspan > 1 or p25.rowspan > 1 then
			setSkip(#p24, p25.colspan, p25.rowspan)
		end

		table.insert(p24, Object.assign({}, p25, {
			order = #p24 + 1
		}))

		return p24
	end, {})
end
local function formatCellKey(p26, p27) -- line: 169
	local v46 = math.floor(math.log10(p27) + 1)

	return string.format("ResponsiveRowCell%0" .. v46 .. "d", p26)
end

function filterDisplayedCells(p28, p29, p30) -- line: 175
	-- upvalues: Array (copy), Object (copy)
	local v50 = (p30.Min - 1) * p29.columns + 1
	local v51 = p30.Max * p29.columns
	local v52 = Array.filter(p28, function(_, p32) -- line: 179
		-- upvalues: v50 (copy), v51 (copy)
		return p32 >= v50 and p32 <= v51
	end)
	local v53 = (p30.Max - p30.Min + 1) * p29.columns

	return Array.map(v52, function(p33, _) -- line: 184
		-- upvalues: Object (copy), v53 (copy)
		local assign = Object.assign
		local t2 = {}
		local v106 = (p33.order - 1) % v53 + 1
		local v107 = math.floor(math.log10(v53) + 1)

		t2.key = string.format("ResponsiveRowCell%0" .. v107 .. "d", v106)

		return assign({}, p33, t2)
	end)
end
function v14.init(p35) -- line: 193
	p35.itemCache = {}
end
function v14.renderChildren(p36, p37) -- line: 197
	-- upvalues: countItems (copy), Array (copy), addPaddingCells (copy), UIBloxConfig (copy), Roact (copy), ResponsiveCell (copy)
	local t3 = {}
	local t4 = {}
	local n1 = 1
	local n2 = 1
	local g67 = nil
	local g69 = nil
	local n3 = nil
	local g72 = nil
	local g74 = nil
	local n4 = nil
	local g77 = nil
	local g79 = nil
	local v78 = nil

	for i = 1, countItems(p36.props, p37) do
		local v62 = p36.props.getItem(p36.props.data, i, p37)
		local v63 = nil
		local v64 = nil

		if p36.props.keyExtractor then
			v63 = p36.props.keyExtractor(v62, i, p37)
		end

		if v63 and p36.itemCache[v63] then
			v64 = p36.itemCache[v63]
		end

		if not v64 then
			v64 = p36.props.renderItem(v62, p37)
		end

		if v63 then
			t4[v63] = v64
		end

		local t5 = {}
		local getCellColspan = p36.props.getCellColspan

		repeat
			repeat
				if g67 or (g67 or not getCellColspan) then
					g67 = false
					n3 = 1
					g69 = true
				end

				if g69 then
					break
				end

				n3 = getCellColspan(v62, p37)

				if n3 == nil then
					g67 = true
				end
			until not g67

			if g69 then
				break
			end

			if type(n3) ~= table then
				g69 = true
			end

			if g69 then
				break
			end

			local v70 = p37.breakpoint or "default"

			if n3[v70] ~= nil then
				n3 = n3[v70]
				g69 = true
			end

			if g69 then
				break
			end

			if n3.default == nil then
				g67 = true
			end
		until not g67

		if not g69 then
			if not g69 then
				if not g69 then
					n3 = n3.default
				end
			end
		end

		g69 = false
		t5.colspan = n3

		local getCellRowspan = p36.props.getCellRowspan

		repeat
			repeat
				if g72 or (g72 or not getCellRowspan) then
					g72 = false
					n4 = 1
					g74 = true
				end

				if g74 then
					break
				end

				n4 = getCellRowspan(v62, p37)

				if n4 == nil then
					g72 = true
				end
			until not g72

			if g74 then
				break
			end

			if type(n4) ~= table then
				g74 = true
			end

			if g74 then
				break
			end

			local v75 = p37.breakpoint or "default"

			if n4[v75] ~= nil then
				n4 = n4[v75]
				g74 = true
			end

			if g74 then
				break
			end

			if n4.default == nil then
				g72 = true
			end
		until not g72

		if not g74 then
			if not g74 then
				if not g74 then
					n4 = n4.default
				end
			end
		end

		g74 = false
		t5.rowspan = n4

		local getCellOrder = p36.props.getCellOrder

		repeat
			repeat
				if g77 or (g77 or not getCellOrder) then
					g77 = false
					v78 = i
					g79 = true
				end

				if g79 then
					break
				end

				v78 = getCellOrder(v62, p37)

				if v78 == nil then
					g77 = true
				end
			until not g77

			if g79 then
				break
			end

			if type(v78) ~= table then
				g79 = true
			end

			if g79 then
				break
			end

			local v80 = p37.breakpoint or "default"

			if v78[v80] ~= nil then
				v78 = v78[v80]
				g79 = true
			end

			if g79 then
				break
			end

			if v78.default == nil then
				g77 = true
			end
		until not g77

		if not g79 then
			if not g79 then
				if not g79 then
					v78 = v78.default
				end
			end
		end

		g79 = false
		t5.order = v78
		t5.cell = v64
		table.insert(t3, t5)
	end

	p36.itemCache = t4

	if p36.props.multiLine then
		Array.sort(t3, function(p38, p39) -- line: 227
			return p38.order - p39.order
		end)
		t3 = addPaddingCells(t3, p37)
		n1 = math.ceil(#t3 / p37.columns)

		if p36.props.displayLines then
			t3 = filterDisplayedCells(t3, p37, p36.props.displayLines)
		end
	elseif p36.props.scrollable then
		n2 = Array.reduce(t3, function(p40, p41) -- line: 237
			return p40 + p41.colspan
		end, 0) / p37.columns
	end

	if UIBloxConfig.setZIndexOnGridCells then
		for i = 1, #t3 do
			t3[i].zIndex = #t3 + 2 - i
		end
	end

	return Array.map(t3, function(p42, p43) -- line: 250
		-- upvalues: Roact (copy), ResponsiveCell (copy), t3 (ref)
		local createElement = Roact.createElement
		local v115 = ResponsiveCell
		local t6 = {}
		local key = p42.key

		if not key then
			local v118 = math.floor(math.log10(#t3) + 1)

			key = string.format("ResponsiveRowCell%0" .. v118 .. "d", p43)
		end

		t6.key = key
		t6.colspan = p42.colspan
		t6.rowspan = p42.rowspan
		t6.order = p42.order
		t6.zIndex = p42.zIndex

		return createElement(v115, t6, {
			ResponsiveItem = p42.cell
		})
	end), n2, n1
end
function v14.render(p44) -- line: 265
	-- upvalues: Roact (copy), ResponsiveLayoutContext (copy), Object (copy), ResponsiveLayoutConfigReader (copy), ResponsiveBaseRow (copy)
	return Roact.createElement(ResponsiveLayoutContext.Consumer, {
		render = function(p45) -- line: 267
			-- upvalues: Object (copy), p44 (copy), ResponsiveLayoutConfigReader (copy), Roact (copy), ResponsiveBaseRow (copy)
			local v120 = Object.assign({}, p45, {
				kind = p44.props.kind or Object.None
			})
			local v121, v122, v123 = p44:renderChildren({
				breakpoint = v120.breakpoint,
				kind = v120.kind,
				width = ResponsiveLayoutConfigReader.getValue(v120, "width") or 1,
				columns = ResponsiveLayoutConfigReader.getValue(v120, "columns") or 1,
				margin = ResponsiveLayoutConfigReader.getValue(v120, "margin") or 1,
				gutter = ResponsiveLayoutConfigReader.getValue(v120, "gutter") or 1,
				verticalGutter = ResponsiveLayoutConfigReader.getValue(v120, "verticalGutter")
			})

			return Roact.createElement(ResponsiveBaseRow, {
				kind = p44.props.kind,
				layoutOrder = p44.props.layoutOrder,
				zIndex = p44.props.zIndex,
				scrollable = p44.props.scrollable,
				clipsDescendants = p44.props.clipsDescendants,
				selectable = p44.props.selectable,
				pages = v122,
				multiLine = p44.props.multiLine,
				lines = v123,
				paddingTopLines = if not p44.props.multiLine or not p44.props.displayLines then nil else math.max(p44.props.displayLines.Min - 1, 0),
				relativeHeight = p44.props.relativeHeight,
				scrollingFrameRef = p44.props.scrollingFrameRef,
				[Roact.Ref] = p44.props.forwardedRef
			}, v121)
		end
	})
end

return Roact.forwardRef(function(p46, p47) -- line: 302
	-- upvalues: Roact (copy), v14 (copy), Object (copy)
	return Roact.createElement(v14, Object.assign({}, p46, {
		forwardedRef = p47
	}))
end)
