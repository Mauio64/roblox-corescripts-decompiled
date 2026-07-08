local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local LinkingProtocol = require(CorePackages.Workspace.Packages.LinkingProtocol).LinkingProtocol
local Components = script.Parent.Parent.Parent.Components
local BannerButton = require(Components.BannerButton)
local BoxButton = require(Components.BoxButton)
local CellCheckbox = require(Components.CellCheckbox)
local CellLabel = require(Components.CellLabel)
local DataConsumer = require(Components.DataConsumer)
local DropDown = require(Components.DropDown)
local HeaderButton = require(Components.HeaderButton)
local Constants = require(script.Parent.Parent.Parent.Constants)
local GeneralFormatting = Constants.GeneralFormatting
local LineWidth = GeneralFormatting.LineWidth
local LineColor = GeneralFormatting.LineColor
local DebugVisualizationsFormatting = Constants.DebugVisualizationsFormatting
local ChartHeaderNames = DebugVisualizationsFormatting.ChartHeaderNames
local ChartCellWidths = DebugVisualizationsFormatting.ChartCellWidths
local HeaderFrameHeight = DebugVisualizationsFormatting.HeaderFrameHeight
local EntryFrameHeight = DebugVisualizationsFormatting.EntryFrameHeight
local CellPadding = DebugVisualizationsFormatting.CellPadding
local MinFrameWidth = DebugVisualizationsFormatting.MinFrameWidth
local LearnMoreWidth = DebugVisualizationsFormatting.LearnMoreWidth
local MainWindow = Constants.DefaultFontSize.MainWindow
local MainWindow2 = Constants.Font.MainWindow
local v26 = game:DefineFastFlag("SlimDevConsole2", false)
local v27 = v26 and game:GetService("TextService") or nil

local function getDescriptionWidth(p1, p2) -- line: 37
	-- upvalues: LearnMoreWidth (copy), CellPadding (copy)
	if p2 ~= nil then
		return p1 - LearnMoreWidth - CellPadding * 2
	end

	return p1 - CellPadding * 2
end
local function getDescriptionHeight(p3, p4) -- line: 43
	-- upvalues: v27 (copy), MainWindow (copy), MainWindow2 (copy), EntryFrameHeight (copy)
	return (math.max(v27:GetTextSize(p3, MainWindow, MainWindow2, Vector2.new(p4, 1e999)).Y, EntryFrameHeight))
end

local n1 = 0

for _, v in ipairs(ChartCellWidths) do
	n1 += v
end

local t1 = {}
local t2 = {}
local t3 = {}
local v36 = -n1 / 2

table.insert(t1, UDim2.fromOffset(CellPadding, 0))
table.insert(t2, UDim2.new(0.5, v36 - CellPadding, 0, HeaderFrameHeight))
table.insert(t3, UDim2.new(0.5, v36 - CellPadding, 0, EntryFrameHeight))

for _, v in ipairs(ChartCellWidths) do
	table.insert(t1, UDim2.new(0.5, v36 + CellPadding, 0, 0))
	table.insert(t2, UDim2.fromOffset(v - CellPadding, HeaderFrameHeight))
	table.insert(t3, UDim2.fromOffset(v - CellPadding, EntryFrameHeight))
	v36 += v
end

table.insert(t1, UDim2.new(0.5, v36 + CellPadding, 0, 0))
table.insert(t2, UDim2.new(0.5, -n1 / 2 - CellPadding, 0, HeaderFrameHeight))
table.insert(t3, UDim2.new(0.5, -n1 / 2 - CellPadding, 0, EntryFrameHeight))
assert(#ChartCellWidths == 2, "DebugVisualizationsChart expected DebugVisualizationsFormatting CELL_WIDTHS to have a length of 2")
assert(#t1 == 4, "DebugVisualizationsChart expected cellOffset to have length " .. 4)
assert(#t2 == 4, "DebugVisualizationsChart expected headerCellSize to have length " .. 4)
assert(#t3 == 4, "DebugVisualizationsChart expected entryCellSize to have length " .. 4)

local t4 = {}

for i, v in ipairs(t1) do
	t4[i] = UDim2.new(v.X.Scale, v.X.Offset - CellPadding, v.Y.Scale, v.Y.Offset)
end

local v42 = Roact.Component:extend("DebugVisualizationsChart")

local function constructHeader(p5, p6) -- line: 106
	-- upvalues: ChartHeaderNames (copy), Roact (copy), HeaderButton (copy), t2 (copy), t1 (copy), LineWidth (copy), LineColor (copy), t4 (copy), HeaderFrameHeight (copy)
	local t5 = {}

	for i, v in ipairs(ChartHeaderNames) do
		t5[v] = Roact.createElement(HeaderButton, {
			text = v,
			size = t2[i],
			pos = t1[i],
			sortfunction = p5
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
		Size = UDim2.new(0, p6, 0, HeaderFrameHeight)
	}, t5)
end
local function constructEntry(p7, p8, p9, p10, p11, p12, p13, p14) -- line: 148
	-- upvalues: t4 (copy), Roact (copy), LineWidth (copy), LineColor (copy), CellLabel (copy), t3 (copy), t1 (copy), v26 (copy), DropDown (copy), CellPadding (copy), EntryFrameHeight (copy), CellCheckbox (copy), LearnMoreWidth (copy), BannerButton (copy), BoxButton (copy)
	local name = p7.name
	local settingInfo = p7.settingInfo
	local str = tostring(settingInfo.Name)
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

	if v26 and settingInfo.Kind == "Dropdown" then
		local EnumItems = settingInfo.EnumItems
		local n2 = 1

		for i, v in ipairs(EnumItems) do
			if v == settingInfo.Value then
				n2 = i

				break
			end
		end

		t6.checkbox = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = t3[2],
			Position = t1[2]
		}, {
			DropDown = Roact.createElement(DropDown, {
				buttonSize = UDim2.new(1, -CellPadding, 0, EntryFrameHeight - 8),
				position = UDim2.new(0, 0, 0, 4),
				dropDownList = settingInfo.DropDownList,
				selectedIndex = n2,
				onSelection = function(p15) -- line: 193
					-- upvalues: p7 (copy), str (copy), EnumItems (copy)
					p7.valueChangeCallback(str, EnumItems[p15])
				end
			})
		})
	else
		t6.checkbox = Roact.createElement(CellCheckbox, {
			name = str,
			isSelected = settingInfo.Value,
			size = t3[2],
			pos = t1[2],
			OnCheckboxClicked = p7.valueChangeCallback
		})
	end

	t6.visualType = Roact.createElement(CellLabel, {
		text = settingInfo.Type,
		size = t3[3],
		pos = t1[3]
	})
	t6.tags = Roact.createElement(CellLabel, {
		text = tostring(settingInfo.Tagstring),
		size = t3[4],
		pos = t1[4]
	})
	t6.lowerHorizontalLine = Roact.createElement("Frame", {
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, LineWidth),
		Position = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = LineColor
	})

	local LearnMoreUrl = nil
	local v73, uDim2

	if v26 then
		LearnMoreUrl = settingInfo.LearnMoreUrl
		v73 = LearnMoreUrl ~= nil

		local v74 = if LearnMoreUrl == nil then p8 - CellPadding * 2 else p8 - LearnMoreWidth - CellPadding * 2

		uDim2 = UDim2.new(0, v74, 0, p10)
	else
		v73 = true
		uDim2 = UDim2.new(0, p8 - LearnMoreWidth - CellPadding * 2, 0, EntryFrameHeight)
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, p8, 0, p9),
		LayoutOrder = p11
	}, {
		Button = Roact.createElement(BannerButton, {
			size = UDim2.new(1, 0, 0, EntryFrameHeight),
			pos = UDim2.new(),
			isExpanded = p12,
			onButtonPress = p13(name)
		}, t6),
		DescriptionText = p12 and Roact.createElement(CellLabel, {
			pos = UDim2.new(0, CellPadding, 0, EntryFrameHeight + CellPadding),
			size = uDim2,
			text = tostring(settingInfo.Description)
		}),
		LearnMoreButton = p12 and (v73 and Roact.createElement(BoxButton, {
			text = "Learn More",
			size = UDim2.new(0, LearnMoreWidth, 0, EntryFrameHeight),
			pos = UDim2.new(0, p8 - LearnMoreWidth - CellPadding, 0, EntryFrameHeight + CellPadding),
			onClicked = if not v26 then p14(name) else p14(name, LearnMoreUrl)
		}))
	})
end

function populateEntries(p16, p17, p18, p19, p20, p21, p22, p23, p24, p25) -- line: 269
	-- upvalues: Roact (copy), EntryFrameHeight (copy), v26 (copy), LearnMoreWidth (copy), CellPadding (copy), v27 (copy), MainWindow (copy), MainWindow2 (copy), constructEntry (copy), LineColor (copy)
	local t7 = {
		UIListLayout = Roact.createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			SortOrder = Enum.SortOrder.LayoutOrder
		})
	}
	local t8 = {}

	for k, v in pairs(p17) do
		if v then
			table.insert(t8, k)
		end
	end

	local v90 = #p18
	local n3 = 0

	if p21 and p20 then
		local n4 = -1
		local n5 = 0
		local n6 = 0

		for i, v in ipairs(p18) do
			local v97 = false

			if p16 then
				local str = tostring(v.settingInfo.Name)

				v97 = string.find(str:lower(), p16:lower()) ~= nil or string.find(v.name:lower(), p16:lower()) ~= nil
			end

			if #t8 > 0 then
				local v99 = false

				for _, v2 in pairs(t8) do
					if table.find(v.settingInfo.Tags, v2) ~= nil then
						v99 = true

						break
					end
				end

				if not p16 then
					p16 = true
					v97 = v99
				else
					v97 = v97 and v99
				end
			end

			if not p16 or v97 then
				local v102 = p23 == v.name
				local v103 = EntryFrameHeight
				local v106

				if v26 then
					if v102 then
						local v104 = if v.settingInfo.LearnMoreUrl == nil then p22 - CellPadding * 2 else p22 - LearnMoreWidth - CellPadding * 2
						local str = tostring(v.settingInfo.Description)

						v103 = math.max(v27:GetTextSize(str, MainWindow, MainWindow2, Vector2.new(v104, 1e999)).Y, EntryFrameHeight)
						v106 = EntryFrameHeight + v103 + CellPadding * 2
					else
						v106 = EntryFrameHeight
					end
				else
					v106 = v102 and EntryFrameHeight * 2 + CellPadding * 2 or EntryFrameHeight
				end

				if n3 + EntryFrameHeight >= p20.Y then
					if n5 < p21.Y then
						local v107 = p19 and v90 - i or i

						t7[i] = constructEntry(v, p22, v106, v103, v107 + 1, v102, p24, p25)
					end

					if n4 < 0 then
						n4 = n3
					else
						n5 += EntryFrameHeight
					end

					n6 += 1
				end

				n3 += v106
			end
		end

		if n6 == 0 then
			t7.NoneFound = Roact.createElement("TextLabel", {
				Text = "No DebugVisualizations Found",
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Size = UDim2.fromScale(1, 1),
				TextColor3 = LineColor
			})
		else
			t7.WindowingPadding = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, n4)
			})
		end
	end

	return t7, n3
end
function v42.init(p26, p27) -- line: 393
	-- upvalues: LinkingProtocol (copy), v26 (copy), Roact (copy)
	local v110 = p27.DebugVisualizationsData:getCurrentData()

	function p26.getOnButtonPress(p28) -- line: 396
		-- upvalues: p26 (copy)
		return function(_, _) -- line: 397
			-- upvalues: p26 (copy), p28 (copy)
			p26:setState({
				expandedEntry = p26.state.expandedEntry ~= p28 and p28
			})
		end
	end
	function p26.getLearnMorePress(p31, p32) -- line: 404
		-- upvalues: LinkingProtocol (copy), v26 (copy)
		return function(_, _) -- line: 405
			-- upvalues: LinkingProtocol (copy), v26 (copy), p32 (copy), p31 (copy)
			LinkingProtocol.default:openURL(if not v26 then "https://create.roblox.com/docs/reference/engine/classes/PhysicsSettings#" .. p31 else p32)
		end
	end
	function p26.onSortChanged(p35) -- line: 413
		-- upvalues: p27 (copy), p26 (copy)
		if p35 == p27.DebugVisualizationsData:getSortType() then
			p26:setState(function(p36) -- line: 416
				return {
					reverseSort = not p36.reverseSort
				}
			end)

			return
		end

		p27.DebugVisualizationsData:setSortType(p35)
		p26:setState({
			reverseSort = false
		})
	end
	function p26.onCanvasPosChanged() -- line: 430
		-- upvalues: p26 (copy)
		local CanvasPosition = p26.scrollingRef.current.CanvasPosition

		p26:setState({
			canvasPos = CanvasPosition
		})
	end

	p26.scrollingRef = Roact.createRef()
	p26.state = {
		reverseSort = false,
		expandedEntry = nil,
		visualizationEntries = v110
	}
end
function v42.didUpdate(p37) -- line: 446
	if p37.scrollingRef.current then
		local AbsoluteSize = p37.scrollingRef.current.AbsoluteSize

		if AbsoluteSize ~= p37.state.absScrollSize then
			p37:setState({
				absScrollSize = AbsoluteSize
			})
		end
	end
end
function v42.didMount(p38) -- line: 458
	p38.visualizationsUpdated = p38.props.DebugVisualizationsData:Signal():Connect(function(p39) -- line: 459
		-- upvalues: p38 (copy)
		p38:setState({
			visualizationEntries = p39
		})
	end)

	if p38.scrollingRef.current then
		p38.canvasPosConnector = p38.scrollingRef.current:GetPropertyChangedSignal("CanvasPosition"):Connect(p38.onCanvasPosChanged)
		p38:setState({
			absScrollSize = p38.scrollingRef.current.AbsoluteSize,
			canvasPos = p38.scrollingRef.current.CanvasPosition
		})
	end
end
function v42.willUnmount(p40) -- line: 476
	p40.visualizationsUpdated:Disconnect()
	p40.visualizationsUpdated = nil
	p40.canvasPosConnector:Disconnect()
	p40.canvasPosConnector = nil
end
function v42.render(p41) -- line: 483
	-- upvalues: MinFrameWidth (copy), Roact (copy), constructHeader (copy), HeaderFrameHeight (copy), Constants (copy)
	local absScrollSize = p41.state.absScrollSize
	local v117 = absScrollSize and math.max(absScrollSize.X, MinFrameWidth) or MinFrameWidth
	local v118, v119 = populateEntries(p41.props.searchTerm, p41.props.typeFilters, p41.state.visualizationEntries, p41.state.reverseSort, p41.state.canvasPos, absScrollSize, v117, p41.state.expandedEntry, p41.getOnButtonPress, p41.getLearnMorePress)
	local size = p41.props.size
	local layoutOrder = p41.props.layoutOrder

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Size = size,
		LayoutOrder = layoutOrder
	}, {
		Header = constructHeader(p41.onSortChanged, v117),
		MainChart = Roact.createElement("ScrollingFrame", {
			Position = UDim2.fromOffset(0, HeaderFrameHeight),
			Size = UDim2.new(1, 0, 1, -HeaderFrameHeight),
			CanvasSize = UDim2.fromOffset(v117, v119),
			ScrollBarThickness = 6,
			BackgroundColor3 = Constants.Color.BaseGray,
			BackgroundTransparency = 1,
			[Roact.Ref] = p41.scrollingRef
		}, v118)
	})
end

return DataConsumer(v42, "DebugVisualizationsData")
