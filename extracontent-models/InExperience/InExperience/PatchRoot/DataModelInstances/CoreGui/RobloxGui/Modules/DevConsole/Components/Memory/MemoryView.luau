local CorePackages = game:GetService("CorePackages")
local TweenService = game:GetService("TweenService")
local Roact = require(CorePackages.Packages.Roact)
local Components = script.Parent.Parent.Parent.Components
local HeaderButton = require(Components.HeaderButton)
local MemoryViewEntry = require(script.Parent.MemoryViewEntry)
local Constants = require(script.Parent.Parent.Parent.Constants)
local LineWidth = Constants.GeneralFormatting.LineWidth
local LineColor = Constants.GeneralFormatting.LineColor
local ChartHeaderNames = Constants.MemoryFormatting.ChartHeaderNames
local HeaderFrameHeight = Constants.GeneralFormatting.HeaderFrameHeight
local ValueCellWidth = Constants.MemoryFormatting.ValueCellWidth
local CellPadding = Constants.MemoryFormatting.CellPadding
local ValuePadding = Constants.MemoryFormatting.ValuePadding
local EntryFrameHeight = Constants.GeneralFormatting.EntryFrameHeight
local LineGraphHeight = Constants.GeneralFormatting.LineGraphHeight
local NoResultSearchStr = Constants.GeneralFormatting.NoResultSearchStr
local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0)
local v19 = Roact.Component:extend("MemoryView")

local function getX(p1) -- line: 37
	return p1.time
end
local function getY(p2) -- line: 41
	return p2.data
end
local function formatValueStr(p3) -- line: 45
	return string.format("%.3f", p3)
end

function v19.init(p4, p5) -- line: 49
	-- upvalues: EntryFrameHeight (copy), TweenService (copy), tweenInfo (copy), Roact (copy)
	function p4.getOnButtonPress(p6, p7) -- line: 50
		-- upvalues: p4 (copy), EntryFrameHeight (copy), TweenService (copy), tweenInfo (copy)
		return function(_, _) -- line: 51
			-- upvalues: p4 (copy), p6 (copy), p7 (copy), EntryFrameHeight (copy), TweenService (copy), tweenInfo (copy)
			if p4.state.expandIndex ~= p6 and p6 then
				local current = p4.scrollingRef.current

				if current then
					local v80 = (p7 - 2.4) * EntryFrameHeight

					TweenService:Create(current, tweenInfo, {
						CanvasPosition = Vector2.new(0, v80)
					}):Play()
				end
			end

			p4:setState({
				expandIndex = p4.state.expandIndex ~= p6 and p6
			})
		end
	end
	function p4.onSortChanged(p10) -- line: 71
		-- upvalues: p5 (copy), p4 (copy)
		if p10 == p5.targetMemoryData:getSortType() then
			p5.targetMemoryData:setSortType(p10)
			p4:setState({
				reverseSort = not p4.state.reverseSort
			})

			return
		end

		p5.targetMemoryData:setSortType(p10)
		p4:setState({
			reverseSort = false
		})
	end
	function p4.onCanvasPosChanged() -- line: 87
		-- upvalues: p4 (copy)
		local CanvasPosition = p4.scrollingRef.current.CanvasPosition

		if CanvasPosition ~= p4.state.canvasPos then
			p4:setState({
				absScrollSize = p4.scrollingRef.current.AbsoluteSize,
				canvasPos = CanvasPosition
			})
		end
	end

	p4.scrollingRef = Roact.createRef()
	p4.state = {
		reverseSort = false,
		expandIndex = false,
		memoryData = p5.targetMemoryData:getMemoryData()
	}
end
function v19.willUpdate(p11) -- line: 106
	if p11.canvasPosConnector then
		p11.canvasPosConnector:Disconnect()
	end
end
function v19.didUpdate(p12) -- line: 112
	if p12.scrollingRef.current then
		p12.canvasPosConnector = p12.scrollingRef.current:GetPropertyChangedSignal("CanvasPosition"):Connect(p12.onCanvasPosChanged)
	end
end
function v19.didMount(p13) -- line: 119
	p13.treeViewItemConnector = p13.props.targetMemoryData:treeUpdatedSignal():Connect(function(p14) -- line: 121
		-- upvalues: p13 (copy)
		p13:setState({
			memoryData = p14
		})
	end)

	if p13.scrollingRef.current then
		p13.canvasPosConnector = p13.scrollingRef.current:GetPropertyChangedSignal("CanvasPosition"):Connect(p13.onCanvasPosChanged)
		p13:setState({
			absScrollSize = p13.scrollingRef.current.AbsoluteSize,
			canvasPos = p13.scrollingRef.current.CanvasPosition
		})
	end
end
function v19.willUnmount(p15) -- line: 138
	p15.treeViewItemConnector:Disconnect()
end
function v19.appendAdditionTabInformation(p16, p17, p18, p19, p20, p21) -- line: 142
	-- upvalues: EntryFrameHeight (copy), Roact (copy), MemoryViewEntry (copy), formatValueStr (copy)
	local CanvasPosition = p16.scrollingRef.current.CanvasPosition
	local AbsoluteSize = p16.scrollingRef.current.AbsoluteSize

	for _, v in ipairs(p18) do
		local name = v.name
		local value = v.value
		local v44 = p19 .. name

		p21.layoutOrder = p21.layoutOrder + 1

		if p21.scrollingFrameHeight + EntryFrameHeight >= CanvasPosition.Y and p21.usedFrameSpace < AbsoluteSize.Y then
			p17[p19 .. name] = Roact.createElement(MemoryViewEntry, {
				showGraph = false,
				size = UDim2.new(1, 0, 0, EntryFrameHeight),
				depth = p20,
				name = name,
				value = value,
				formatValueStr = formatValueStr,
				layoutOrder = p21.layoutOrder
			})

			if p21.paddingHeight < 0 then
				p21.paddingHeight = p21.scrollingFrameHeight
			else
				p21.usedFrameSpace = p21.usedFrameSpace + EntryFrameHeight
			end
		end

		p21.scrollingFrameHeight = p21.scrollingFrameHeight + EntryFrameHeight

		if v.moreInfo and type(v.moreInfo) == "table" then
			p16:appendAdditionTabInformation(p17, v.moreInfo, v44, p20 + 1, p21)
		end
	end
end
function v19.recursiveConstructEntries(p22, p23, p24, p25, p26) -- line: 183
	-- upvalues: EntryFrameHeight (copy), LineGraphHeight (copy), Roact (copy), MemoryViewEntry (copy), formatValueStr (copy), getX (copy), getY (copy)
	assert(p22.scrollingRef.current, "ScrollingFrame not initialized yet")

	local expandIndex = p22.state.expandIndex
	local v51 = p22.props.searchTerm or ""
	local reverseSort = p22.state.reverseSort
	local CanvasPosition = p22.scrollingRef.current.CanvasPosition
	local AbsoluteSize = p22.scrollingRef.current.AbsoluteSize
	local name = p24.name

	if string.find(name:lower(), v51:lower()) then
		local v56 = expandIndex == name
		local v57 = v56 and EntryFrameHeight + LineGraphHeight or EntryFrameHeight

		p26.layoutOrder = p26.layoutOrder + 1

		if p26.scrollingFrameHeight + v57 >= CanvasPosition.Y and p26.usedFrameSpace < AbsoluteSize.Y then
			p23[name] = Roact.createElement(MemoryViewEntry, {
				size = UDim2.new(1, 0, 0, v57),
				depth = p25,
				name = p24.name,
				showGraph = v56,
				dataStats = p24.dataStats,
				onButtonPress = p22.getOnButtonPress(name, p26.layoutOrder),
				formatValueStr = formatValueStr,
				getX = getX,
				getY = getY,
				layoutOrder = p26.layoutOrder
			})

			if p26.paddingHeight < 0 then
				p26.paddingHeight = p26.scrollingFrameHeight
			else
				p26.usedFrameSpace = p26.usedFrameSpace + v57
			end
		end

		p26.scrollingFrameHeight = p26.scrollingFrameHeight + v57

		if v56 and p24.dataStats.additionalInfoFunc then
			p22:appendAdditionTabInformation(p23, p24.dataStats.additionalInfoFunc(), p24.name, p25 + 1, p26)
		end
	end

	local sortedChildren = p24.dataStats.sortedChildren

	if sortedChildren then
		if reverseSort then
			local v59 = #sortedChildren

			for i = 1, v59 do
				p22:recursiveConstructEntries(p23, sortedChildren[v59 - i + 1], p25 + 1, p26)
			end

			return
		end

		for _, v in ipairs(sortedChildren) do
			p22:recursiveConstructEntries(p23, v, p25 + 1, p26)
		end
	end
end
function v19.render(p27) -- line: 251
	-- upvalues: Roact (copy), Constants (copy), NoResultSearchStr (copy), HeaderFrameHeight (copy), HeaderButton (copy), ChartHeaderNames (copy), ValueCellWidth (copy), ValuePadding (copy), CellPadding (copy), LineColor (copy), LineWidth (copy)
	local t1 = {}
	local layoutOrder = p27.props.layoutOrder
	local size = p27.props.size
	local v67 = p27.props.searchTerm or ""
	local t2 = {
		scrollingFrameHeight = 0,
		paddingHeight = -1,
		usedFrameSpace = 0,
		layoutOrder = 1
	}

	if p27.scrollingRef.current then
		for _, v in ipairs(p27.state.memoryData) do
			p27:recursiveConstructEntries(t1, v, 0, t2)
		end

		t1.UIListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			SortOrder = Enum.SortOrder.LayoutOrder
		})
		t1.WindowingPadding = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, t2.paddingHeight)
		})
	end

	if t2.layoutOrder == 1 then
		if v67 == "" then
			t1.noDataMessage = Roact.createElement("TextLabel", {
				Text = "Awaiting Memory Stats",
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(0, 0, 0, 0),
				TextColor3 = Constants.Color.Text,
				LayoutOrder = layoutOrder
			})
		else
			local v71 = string.format(NoResultSearchStr, v67)

			t1.noDataMessage = Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(0, 0, 0, 0),
				Text = v71,
				TextColor3 = Constants.Color.Text,
				LayoutOrder = layoutOrder
			})
		end
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = size,
		LayoutOrder = layoutOrder
	}, {
		Header = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, HeaderFrameHeight)
		}, {
			Name = Roact.createElement(HeaderButton, {
				text = ChartHeaderNames[1],
				size = UDim2.new(1 - ValueCellWidth, -ValuePadding - CellPadding, 0, HeaderFrameHeight),
				pos = UDim2.new(0, CellPadding, 0, 0),
				sortfunction = p27.onSortChanged
			}),
			ValueMB = Roact.createElement(HeaderButton, {
				text = ChartHeaderNames[2],
				size = UDim2.new(ValueCellWidth, -CellPadding, 0, HeaderFrameHeight),
				pos = UDim2.new(1 - ValueCellWidth, ValuePadding, 0, 0),
				sortfunction = p27.onSortChanged
			}),
			TopHorizontal = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 1),
				BackgroundColor3 = LineColor
			}),
			LowerHorizontal = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, LineWidth),
				Position = UDim2.new(0, 0, 1, 0),
				BackgroundColor3 = LineColor
			}),
			vertical = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				Size = UDim2.new(0, LineWidth, 1, 0),
				Position = UDim2.new(1 - ValueCellWidth, 0, 0, 0),
				BackgroundColor3 = LineColor
			})
		}),
		Entries = Roact.createElement("ScrollingFrame", {
			Size = UDim2.new(1, 0, 1, -HeaderFrameHeight),
			Position = UDim2.new(0, 0, 0, HeaderFrameHeight),
			BackgroundTransparency = 1,
			VerticalScrollBarInset = 1,
			ScrollBarThickness = 5,
			CanvasSize = UDim2.new(1, 0, 0, t2.scrollingFrameHeight),
			[Roact.Ref] = p27.scrollingRef
		}, t1)
	})
end

return v19
