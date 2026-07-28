local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local Components = script.Parent.Parent.Parent.Components
local DataConsumer = require(Components.DataConsumer)
local HeaderButton = require(Components.HeaderButton)
local CellLabel = require(Components.CellLabel)
local Constants = require(script.Parent.Parent.Parent.Constants)
local GeneralFormatting = Constants.GeneralFormatting
local LineWidth = GeneralFormatting.LineWidth
local LineColor = GeneralFormatting.LineColor
local ActionBindingsFormatting = Constants.ActionBindingsFormatting
local ChartHeaderNames = ActionBindingsFormatting.ChartHeaderNames
local ChartCellWidths = ActionBindingsFormatting.ChartCellWidths
local HeaderFrameHeight = ActionBindingsFormatting.HeaderFrameHeight
local EntryFrameHeight = ActionBindingsFormatting.EntryFrameHeight
local CellPadding = ActionBindingsFormatting.CellPadding
local MinFrameWidth = ActionBindingsFormatting.MinFrameWidth
local n1 = 0

for _, v in ipairs(ChartCellWidths) do
	n1 += v
end

local t1 = {}
local t2 = {}
local t3 = {}
local v24 = -n1 / 2

table.insert(t1, UDim2.new(0, CellPadding, 0, 0))
table.insert(t2, UDim2.new(0.5, v24 - CellPadding, 0, HeaderFrameHeight))
table.insert(t3, UDim2.new(0.5, v24 - CellPadding, 0, EntryFrameHeight))

for _, v in ipairs(ChartCellWidths) do
	table.insert(t1, UDim2.new(0.5, v24 + CellPadding, 0, 0))
	table.insert(t2, UDim2.new(0, v - CellPadding, 0, HeaderFrameHeight))
	table.insert(t3, UDim2.new(0, v - CellPadding, 0, EntryFrameHeight))
	v24 += v
end

table.insert(t1, UDim2.new(0.5, v24 + CellPadding, 0, 0))
table.insert(t2, UDim2.new(0.5, -n1 / 2 - CellPadding, 0, HeaderFrameHeight))
table.insert(t3, UDim2.new(0.5, -n1 / 2 - CellPadding, 0, EntryFrameHeight))

local t4 = {}

for i, v in ipairs(t1) do
	t4[i] = UDim2.new(v.X.Scale, v.X.Offset - CellPadding, v.Y.Scale, v.Y.Offset)
end

local v30 = Roact.Component:extend("ActionBindingsChart")

local function constructHeader(p1, p2) -- line: 61
	-- upvalues: ChartHeaderNames (copy), Roact (copy), HeaderButton (copy), t2 (copy), t1 (copy), LineWidth (copy), LineColor (copy), t4 (copy), HeaderFrameHeight (copy)
	local t5 = {}

	for i, v in ipairs(ChartHeaderNames) do
		t5[v] = Roact.createElement(HeaderButton, {
			text = v,
			size = t2[i],
			pos = t1[i],
			sortfunction = p1
		})
	end

	t5.upperHorizontalLine = Roact.createElement("Frame", {
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, LineWidth),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundColor3 = LineColor
	})
	t5.lowerHorizontalLine = Roact.createElement("Frame", {
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, LineWidth),
		Position = UDim2.new(0, 0, 1, -LineWidth),
		BackgroundColor3 = LineColor
	})

	for i = 2, #t4 do
		t5[string.format("VerticalLine_%d", i)] = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(0, LineWidth, 1, 0),
			Position = t4[i],
			BackgroundColor3 = LineColor
		})
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, p2, 0, HeaderFrameHeight)
	}, t5)
end
local function constructEntry(p3, p4, p5) -- line: 103
	-- upvalues: t4 (copy), Roact (copy), LineWidth (copy), LineColor (copy), CellLabel (copy), t3 (copy), t1 (copy), EntryFrameHeight (copy)
	local name = p3.name
	local actionInfo = p3.actionInfo
	local str = tostring(actionInfo.inputTypes[1])
	local s1 = "Developer"

	if actionInfo.isCore then
		s1 = "Core"
	end

	local t6 = {}

	for i = 2, #t4 do
		t6[string.format("line_%d", i)] = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(0, LineWidth, 1, 0),
			Position = t4[i],
			BackgroundColor3 = LineColor
		})
	end

	t6[name] = Roact.createElement(CellLabel, {
		text = str,
		size = t3[1],
		pos = t1[1]
	})
	t6.priorityLevel = Roact.createElement(CellLabel, {
		text = actionInfo.priorityLevel,
		size = t3[2],
		pos = t1[2]
	})
	t6.isCore = Roact.createElement(CellLabel, {
		text = s1,
		size = t3[3],
		pos = t1[3]
	})
	t6.actionName = Roact.createElement(CellLabel, {
		text = name,
		size = t3[4],
		pos = t1[4]
	})
	t6.inputTypes = Roact.createElement(CellLabel, {
		text = str,
		size = t3[5],
		pos = t1[5]
	})
	t6.lowerHorizontalLine = Roact.createElement("Frame", {
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, LineWidth),
		Position = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = LineColor
	})

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, p4, 0, EntryFrameHeight),
		LayoutOrder = p5
	}, t6)
end

function v30.init(p6, p7) -- line: 172
	-- upvalues: Roact (copy)
	local v50 = p7.ActionBindingsData:getCurrentData()

	function p6.onSortChanged(p8) -- line: 175
		-- upvalues: p7 (copy), p6 (copy)
		if p8 == p7.ActionBindingsData:getSortType() then
			p6:setState({
				reverseSort = not p6.state.reverseSort
			})

			return
		end

		p7.ActionBindingsData:setSortType(p8)
		p6:setState({
			reverseSort = false
		})
	end
	function p6.onCanvasPosChanged() -- line: 189
		-- upvalues: p6 (copy)
		local CanvasPosition = p6.scrollingRef.current.CanvasPosition

		if CanvasPosition ~= p6.state.canvasPos then
			p6:setState({
				canvasPos = CanvasPosition
			})
		end
	end

	p6.scrollingRef = Roact.createRef()
	p6.state = {
		reverseSort = false,
		actionBindingEntries = v50
	}
end
function v30.willUpdate(p9) -- line: 206
	if p9.canvasPosConnector then
		p9.canvasPosConnector:Disconnect()
	end
end
function v30.didUpdate(p10) -- line: 212
	if p10.scrollingRef.current then
		p10.canvasPosConnector = p10.scrollingRef.current:GetPropertyChangedSignal("CanvasPosition"):Connect(p10.onCanvasPosChanged)

		local AbsoluteSize = p10.scrollingRef.current.AbsoluteSize
		local absScrollSize = p10.state.absScrollSize

		if AbsoluteSize.X ~= absScrollSize.X or AbsoluteSize.Y ~= absScrollSize.Y then
			p10:setState({
				absScrollSize = AbsoluteSize
			})
		end
	end
end
function v30.didMount(p11) -- line: 227
	p11.bindingsUpdated = p11.props.ActionBindingsData:Signal():Connect(function(p12) -- line: 228
		-- upvalues: p11 (copy)
		p11:setState({
			actionBindingEntries = p12
		})
	end)

	if p11.scrollingRef.current then
		p11.canvasPosConnector = p11.scrollingRef.current:GetPropertyChangedSignal("CanvasPosition"):Connect(p11.onCanvasPosChanged)
		p11:setState({
			absScrollSize = p11.scrollingRef.current.AbsoluteSize,
			canvasPos = p11.scrollingRef.current.CanvasPosition
		})
	end
end
function v30.willUnmount(p13) -- line: 245
	p13.bindingsUpdated:Disconnect()
	p13.bindingsUpdated = nil
	p13.canvasPosConnector:Disconnect()
	p13.canvasPosConnector = nil
end
function v30.render(p14) -- line: 252
	-- upvalues: MinFrameWidth (copy), Roact (copy), EntryFrameHeight (copy), constructEntry (copy), LineColor (copy), constructHeader (copy), HeaderFrameHeight (copy), Constants (copy)
	local t7 = {}
	local searchTerm = p14.props.searchTerm
	local size = p14.props.size
	local layoutOrder = p14.props.layoutOrder
	local actionBindingEntries = p14.state.actionBindingEntries
	local reverseSort = p14.state.reverseSort
	local canvasPos = p14.state.canvasPos
	local absScrollSize = p14.state.absScrollSize
	local v66 = absScrollSize and math.max(absScrollSize.X, MinFrameWidth) or MinFrameWidth

	t7.UIListLayout = Roact.createElement("UIListLayout", {
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		SortOrder = Enum.SortOrder.LayoutOrder
	})

	local v67 = #actionBindingEntries
	local n2 = 0

	if absScrollSize and canvasPos then
		local n3 = -1
		local n4 = 0
		local n5 = 0

		for i, v in ipairs(actionBindingEntries) do
			local v74 = false

			if searchTerm then
				local str = tostring(v.actionInfo.inputTypes[1])

				v74 = string.find(str:lower(), searchTerm:lower()) ~= nil or string.find(v.name:lower(), searchTerm:lower()) ~= nil
			end

			if not searchTerm or v74 then
				if n2 + EntryFrameHeight >= canvasPos.Y then
					if n4 < absScrollSize.Y then
						local v76 = reverseSort and v67 - i or i

						t7[i] = constructEntry(v, v66, v76 + 1)
					end

					if n3 < 0 then
						n3 = n2
					else
						n4 += EntryFrameHeight
					end

					n5 += 1
				end

				n2 += EntryFrameHeight
			end
		end

		if n5 == 0 then
			t7.NoneFound = Roact.createElement("TextLabel", {
				Text = "No ActionBindings Found",
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 1, 0),
				TextColor3 = LineColor
			})
		else
			t7.WindowingPadding = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, n3)
			})
		end
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Size = size,
		LayoutOrder = layoutOrder
	}, {
		Header = constructHeader(p14.onSortChanged, v66),
		MainChart = Roact.createElement("ScrollingFrame", {
			Position = UDim2.new(0, 0, 0, HeaderFrameHeight),
			Size = UDim2.new(1, 0, 1, -HeaderFrameHeight),
			CanvasSize = UDim2.new(0, v66, 0, n2),
			ScrollBarThickness = 6,
			BackgroundColor3 = Constants.Color.BaseGray,
			BackgroundTransparency = 1,
			[Roact.Ref] = p14.scrollingRef
		}, t7)
	})
end

return DataConsumer(v30, "ActionBindingsData")
