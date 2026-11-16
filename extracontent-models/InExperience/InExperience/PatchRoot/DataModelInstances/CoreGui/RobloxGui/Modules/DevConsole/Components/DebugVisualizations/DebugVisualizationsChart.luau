local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)

local LinkingProtocol = require(CorePackages.Workspace.Packages.LinkingProtocol)
local linkingProtocol = LinkingProtocol.LinkingProtocol

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
local mainWindow = Constants.Font.MainWindow

local defineFastFlag = game:DefineFastFlag("SlimDevConsole2", false)
local TextService = defineFastFlag and game:GetService("TextService") or nil

local function getDescriptionWidth(p, learnMoreUrl) -- 2 equivalent calls inferred from this helper
	if learnMoreUrl == nil then
		return p - CellPadding * 2
	end

	return p - LearnMoreWidth - CellPadding * 2
end

local function getDescriptionHeight(description, descriptionWidth) -- 1 equivalent call inferred from this helper
	return (math.max(
		TextService:GetTextSize(description, MainWindow, mainWindow, Vector2.new(descriptionWidth, 1e999)).Y,
		EntryFrameHeight
	))
end

local total = 0

for _, chartCellWidth in ipairs(ChartCellWidths) do
	total += chartCellWidth
end

local udims = {}
local udims2 = {}
local udims3 = {}
local v = -total / 2
table.insert(udims, UDim2.fromOffset(CellPadding, 0))
table.insert(udims2, UDim2.new(0.5, v - CellPadding, 0, HeaderFrameHeight))
table.insert(udims3, UDim2.new(0.5, v - CellPadding, 0, EntryFrameHeight))

for _, chartCellWidth in ipairs(ChartCellWidths) do
	table.insert(udims, UDim2.new(0.5, v + CellPadding, 0, 0))
	table.insert(udims2, UDim2.fromOffset(chartCellWidth - CellPadding, HeaderFrameHeight))
	table.insert(udims3, UDim2.fromOffset(chartCellWidth - CellPadding, EntryFrameHeight))
	v += chartCellWidth
end

table.insert(udims, UDim2.new(0.5, v + CellPadding, 0, 0))
table.insert(udims2, UDim2.new(0.5, -total / 2 - CellPadding, 0, HeaderFrameHeight))
table.insert(udims3, UDim2.new(0.5, -total / 2 - CellPadding, 0, EntryFrameHeight))

assert(
	#ChartCellWidths == 2,
	"DebugVisualizationsChart expected DebugVisualizationsFormatting CELL_WIDTHS to have a length of 2"
)

assert(#udims == 4, "DebugVisualizationsChart expected cellOffset to have length " .. 4)

assert(#udims2 == 4, "DebugVisualizationsChart expected headerCellSize to have length " .. 4)

assert(#udims3 == 4, "DebugVisualizationsChart expected entryCellSize to have length " .. 4)

local udims4 = {}

for i, v2 in ipairs(udims) do
	udims4[i] = UDim2.new(v2.X.Scale, v2.X.Offset - CellPadding, v2.Y.Scale, v2.Y.Offset)
end

local extended = Roact.Component:extend("DebugVisualizationsChart")

local function constructHeader(onSortChanged, p)
	local children = {}

	for i, chartHeaderName in ipairs(ChartHeaderNames) do
		children[chartHeaderName] = Roact.createElement(HeaderButton, {
			text = chartHeaderName,
			size = udims2[i],
			pos = udims[i],
			sortfunction = onSortChanged
		})
	end

	children.upperHorizontalLine = Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, LineWidth),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundColor3 = LineColor,
		BorderSizePixel = 0
	})

	children.lowerHorizontalLine = Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, LineWidth),
		Position = UDim2.new(0, 0, 1, -LineWidth),
		BackgroundColor3 = LineColor,
		BorderSizePixel = 0
	})

	for i = 2, #udims4 do
		children[string.format("VerticalLine_%d", i)] = Roact.createElement("Frame", {
			Size = UDim2.new(0, LineWidth, 1, 0),
			Position = udims4[i],
			BackgroundColor3 = LineColor,
			BorderSizePixel = 0
		})
	end

	return Roact.createElement(
		"Frame",
		{
			Size = UDim2.new(0, p, 0, HeaderFrameHeight),
			BackgroundTransparency = 1
		},
		children
	)
end

local function constructEntry(props, p, p2, p3, layoutOrder, isExpanded, callback, callback2)
	local name = props.name
	local settingInfo = props.settingInfo

	local name2 = tostring(settingInfo.Name)

	local children = {}

	for i = 2, #udims4 do
		children[string.format("line_%d", i)] = Roact.createElement("Frame", {
			Size = UDim2.new(0, LineWidth, 1, 0),
			Position = udims4[i],
			BackgroundColor3 = LineColor,
			BorderSizePixel = 0
		})
	end

	children[name] = Roact.createElement(CellLabel, {
		text = name2,
		size = udims3[1],
		pos = udims[1]
	})

	if defineFastFlag and settingInfo.Kind == "Dropdown" then
		local enumItems = settingInfo.EnumItems
		local selectedIndex = 1

		for i, enumItem in ipairs(enumItems) do
			if enumItem == settingInfo.Value then
				selectedIndex = i
				break
			end
		end

		children.checkbox = Roact.createElement(
			"Frame",
			{ Size = udims3[2], Position = udims[2], BackgroundTransparency = 1 },
			{
				DropDown = Roact.createElement(DropDown, {
					buttonSize = UDim2.new(1, -CellPadding, 0, EntryFrameHeight - 8),
					position = UDim2.new(0, 0, 0, 4),
					dropDownList = settingInfo.DropDownList,
					selectedIndex = selectedIndex,
					onSelection = function(p4)
						props.valueChangeCallback(name2, enumItems[p4])
					end
				})
			}
		)
	else
		children.checkbox = Roact.createElement(CellCheckbox, {
			name = name2,
			isSelected = settingInfo.Value,
			size = udims3[2],
			pos = udims[2],
			OnCheckboxClicked = props.valueChangeCallback
		})
	end

	children.visualType = Roact.createElement(CellLabel, {
		text = settingInfo.Type,
		size = udims3[3],
		pos = udims[3]
	})

	children.tags = Roact.createElement(CellLabel, {
		text = tostring(settingInfo.Tagstring),
		size = udims3[4],
		pos = udims[4]
	})

	children.lowerHorizontalLine = Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, LineWidth),
		Position = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = LineColor,
		BorderSizePixel = 0
	})

	local learnMoreUrl = nil
	local learnMoreButton, udim

	if defineFastFlag then
		learnMoreUrl = settingInfo.LearnMoreUrl
		learnMoreButton = learnMoreUrl ~= nil
		udim = UDim2.new(0, getDescriptionWidth(p, learnMoreUrl), 0, p3) -- inferred equivalent call
	else
		udim = UDim2.new(0, p - LearnMoreWidth - CellPadding * 2, 0, EntryFrameHeight)
		learnMoreButton = true
	end

	local createElement = Roact.createElement
	local v2 = {
		Size = UDim2.new(0, p, 0, p2),
		BackgroundTransparency = 1,
		LayoutOrder = layoutOrder
	}

	local v3 = {
		Button = Roact.createElement(
			BannerButton,
			{
				size = UDim2.new(1, 0, 0, EntryFrameHeight),
				pos = UDim2.new(),
				isExpanded = isExpanded,
				onButtonPress = callback(name)
			},
			children
		),
		DescriptionText = isExpanded and Roact.createElement(CellLabel, {
			pos = UDim2.new(0, CellPadding, 0, EntryFrameHeight + CellPadding),
			size = udim,
			text = tostring(settingInfo.Description)
		}),
		LearnMoreButton = 0
	}

	if isExpanded then
		if learnMoreButton then
			local createElement2 = Roact.createElement
			local v4 = {
				text = "Learn More",
				size = UDim2.new(0, LearnMoreWidth, 0, EntryFrameHeight),
				pos = UDim2.new(0, p - LearnMoreWidth - CellPadding, 0, EntryFrameHeight + CellPadding),
				onClicked = 0
			}
			local onClicked

			if defineFastFlag then
				onClicked = callback2(name, learnMoreUrl)
			else
				onClicked = callback2(name)
			end

			v4.onClicked = onClicked
			learnMoreButton = createElement2(BoxButton, v4)
		end
	else
		learnMoreButton = isExpanded
	end

	v3.LearnMoreButton = learnMoreButton
	return createElement("Frame", v2, v3)
end

function populateEntries(value, items, list, p, p2, p3, p4, p5, p6, p7)
	local children = {}

	children.UIListLayout = Roact.createElement("UIListLayout", {
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		SortOrder = Enum.SortOrder.LayoutOrder
	})

	local v2 = {}

	for k, item in pairs(items) do
		if item then
			table.insert(v2, k)
		end
	end

	local v3 = #list
	local total2 = 0

	if not (p3 and p2) then
		return children, total2
	end

	local total3 = 0
	local v4 = -1
	local count = 0

	for i, item in ipairs(list) do
		local v5

		if value then
			local name = tostring(item.settingInfo.Name)
			v5 = string.find(name:lower(), value:lower()) ~= nil or string.find(item.name:lower(), value:lower()) ~= nil
		else
			v5 = false
		end

		if #v2 > 0 then
			local v6 = false

			for _, v7 in pairs(v2) do
				if table.find(item.settingInfo.Tags, v7) ~= nil then
					v6 = true
					break
				end
			end

			if value then
				v5 = v5 and v6
			else
				v5 = v6
				value = true
			end
		end

		if not (not value or v5) then
			continue
		end

		local isExpanded = p5 == item.name

		local v6 = EntryFrameHeight
		local v7

		if defineFastFlag then
			if isExpanded then
				local descriptionWidth = getDescriptionWidth(p4, item.settingInfo.LearnMoreUrl) -- inferred equivalent call

				v6 = getDescriptionHeight(tostring(item.settingInfo.Description), descriptionWidth) -- inferred equivalent call

				v7 = EntryFrameHeight + v6 + CellPadding * 2
			else
				v7 = EntryFrameHeight
			end
		else
			v7 = isExpanded and EntryFrameHeight * 2 + CellPadding * 2 or EntryFrameHeight
		end

		if total2 + EntryFrameHeight >= p2.Y then
			if total3 < p3.Y then
				local v8

				if p then
					v8 = v3 - i or i
				else
					v8 = i
				end

				children[i] = constructEntry(item, p4, v7, v6, v8 + 1, isExpanded, p6, p7)
			end

			if v4 < 0 then
				v4 = total2
			else
				total3 += EntryFrameHeight
			end

			count += 1
		end

		total2 += v7
	end

	if count == 0 then
		children.NoneFound = Roact.createElement("TextLabel", {
			Size = UDim2.fromScale(1, 1),
			Text = "No DebugVisualizations Found",
			TextColor3 = LineColor,
			BackgroundTransparency = 1,
			LayoutOrder = 1
		})
	else
		children.WindowingPadding = Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, v4),
			BackgroundTransparency = 1,
			LayoutOrder = 1
		})
	end

	return children, total2
end

function extended:init(p)
	local currentData = p.DebugVisualizationsData:getCurrentData()

	function self.getOnButtonPress(p2)
		return function(_, _)
			self:setState({
				expandedEntry = self.state.expandedEntry ~= p2 and p2
			})
		end
	end

	function self.getLearnMorePress(p2, p3)
		return function(_, _)
			local default = linkingProtocol.default
			local v2

			if defineFastFlag then
				v2 = p3
			else
				v2 = "https://create.roblox.com/docs/reference/engine/classes/PhysicsSettings#" .. p2
			end

			default:openURL(v2)
		end
	end

	function self.onSortChanged(p2)
		if p2 == p.DebugVisualizationsData:getSortType() then
			self:setState(function(p3)
				return {
					reverseSort = not p3.reverseSort
				}
			end)
			return
		end

		p.DebugVisualizationsData:setSortType(p2)
		self:setState({ reverseSort = false })
	end

	function self.onCanvasPosChanged()
		self:setState({ canvasPos = self.scrollingRef.current.CanvasPosition })
	end

	self.scrollingRef = Roact.createRef()

	self.state = { visualizationEntries = currentData, reverseSort = false, expandedEntry = nil }
end

function extended.didUpdate(object)
	if object.scrollingRef.current then
		local absoluteSize = object.scrollingRef.current.AbsoluteSize

		if absoluteSize ~= object.state.absScrollSize then
			object:setState({ absScrollSize = absoluteSize })
		end
	end
end

function extended:didMount()
	self.visualizationsUpdated = self.props.DebugVisualizationsData:Signal():Connect(function(visualizationEntries)
		self:setState({ visualizationEntries = visualizationEntries })
	end)

	if self.scrollingRef.current then
		self.canvasPosConnector = self.scrollingRef.current:GetPropertyChangedSignal("CanvasPosition"):Connect(self.onCanvasPosChanged)

		self:setState({
			absScrollSize = self.scrollingRef.current.AbsoluteSize,
			canvasPos = self.scrollingRef.current.CanvasPosition
		})
	end
end

function extended:willUnmount()
	self.visualizationsUpdated:Disconnect()
	self.visualizationsUpdated = nil
	self.canvasPosConnector:Disconnect()
	self.canvasPosConnector = nil
end

function extended.render(props)
	local absScrollSize = props.state.absScrollSize
	local v2 = absScrollSize and math.max(absScrollSize.X, MinFrameWidth) or MinFrameWidth

	local v3, v4 = populateEntries(
		props.props.searchTerm,
		props.props.typeFilters,
		props.state.visualizationEntries,
		props.state.reverseSort,
		props.state.canvasPos,
		absScrollSize,
		v2,
		props.state.expandedEntry,
		props.getOnButtonPress,
		props.getLearnMorePress
	)

	local size = props.props.size
	local layoutOrder = props.props.layoutOrder

	return Roact.createElement(
		"Frame",
		{
			Size = size,
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			LayoutOrder = layoutOrder
		},
		{
			Header = constructHeader(props.onSortChanged, v2),
			MainChart = Roact.createElement("ScrollingFrame", {
				Position = UDim2.fromOffset(0, HeaderFrameHeight),
				Size = UDim2.new(1, 0, 1, -HeaderFrameHeight),
				CanvasSize = UDim2.fromOffset(v2, v4),
				ScrollBarThickness = 6,
				BackgroundColor3 = Constants.Color.BaseGray,
				BackgroundTransparency = 1,
				[Roact.Ref] = props.scrollingRef
			}, v3)
		}
	)
end

return DataConsumer(extended, "DebugVisualizationsData")
