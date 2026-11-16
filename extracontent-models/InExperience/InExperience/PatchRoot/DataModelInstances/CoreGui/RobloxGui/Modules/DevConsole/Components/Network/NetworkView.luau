local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)

local Constants = require(script.Parent.Parent.Parent.Constants)
local HeaderFrameHeight = Constants.NetworkFormatting.HeaderFrameHeight
local EntryFrameHeight = Constants.NetworkFormatting.EntryFrameHeight
local SummaryButtonHeight = Constants.NetworkFormatting.SummaryButtonHeight
local MinFrameWidth = Constants.NetworkFormatting.MinFrameWidth

local MainWindow = Constants.DefaultFontSize.MainWindow
local MainWindowHeader = Constants.Font.MainWindowHeader

local Components = script.Parent.Parent.Parent.Components
local BannerButton = require(Components.BannerButton)
local NetworkSummary = require(Components.Network.NetworkSummary)
local NetworkChart = require(Components.Network.NetworkChart)

local extended = Roact.Component:extend("NetworkView")

function extended:init(p)
	assert(p.targetNetworkData, "Make sure the NetworkData is assigned for this NetworkView")

	local currentData = p.targetNetworkData:getCurrentData()

	function self.onSortChanged(p2)
		if p2 == p.targetNetworkData:getSortType() then
			self:setState({
				reverseSort = not self.state.reverseSort
			})
			return
		end

		p.targetNetworkData:setSortType(p2)
		self:setState({ reverseSort = false })
	end

	function self.onSummaryButton(_, _)
		self:setState({
			summaryExpanded = not self.state.summaryExpanded
		})
	end

	function self.onDetailButton(_, _)
		self:setState({
			entriesExpanded = not self.state.entriesExpanded
		})
	end

	self.ref = Roact.createRef()

	self.state = {
		httpSummaryTable = currentData.summaryTable,
		httpSummaryCount = currentData.summaryCount,
		httpEntryList = currentData.entryList,
		summaryExpanded = true,
		entriesExpanded = true,
		indexOfEntryExpanded = 0,
		reverseSort = false,
		absWidth = 0
	}
end

function extended.didUpdate(object)
	if object.ref.current and object.state.absWidth ~= object.ref.current.AbsoluteSize.X then
		object:setState({ absWidth = object.ref.current.AbsoluteSize.X })
	end
end

function extended:didMount()
	self.httpEntryAddedConnector = self.props.targetNetworkData:Signal():Connect(function(httpSummaryTable, httpSummaryCount, httpEntryList)
		self:setState({
			httpSummaryTable = httpSummaryTable,
			httpSummaryCount = httpSummaryCount,
			httpEntryList = httpEntryList
		})
	end)

	if self.ref.current then
		self:setState({ absWidth = self.ref.current.AbsoluteSize.X })
	end
end

function extended:willUnmount()
	self.httpEntryAddedConnector:Disconnect()
	self.httpEntryAddedConnector = nil
end

function extended.render(props)
	local layoutOrder = props.props.layoutOrder
	local searchTerm = props.props.searchTerm
	local size = props.props.size

	local summaryExpanded = props.state.summaryExpanded
	local entriesExpanded = props.state.entriesExpanded
	local reverseSort = props.state.reverseSort
	local httpSummaryTable = props.state.httpSummaryTable
	local httpEntryList = props.state.httpEntryList
	local httpSummaryCount = props.state.httpSummaryCount

	local width = math.max(MinFrameWidth, props.state.absWidth)

	local v = SummaryButtonHeight * 2

	if summaryExpanded then
		v = v + httpSummaryCount * EntryFrameHeight + HeaderFrameHeight
	end

	local v2

	if props.ref.current then
		v2 = props.ref.current.AbsoluteSize.Y - v
	else
		v2 = size.Y.Offset - v
	end

	local chartHeight = math.max(0, v2)

	return Roact.createElement("Frame", {
		Size = size,
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		LayoutOrder = layoutOrder,
		[Roact.Ref] = props.ref
	}, {
		UIListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		SummaryButton = Roact.createElement(BannerButton, {
			size = UDim2.new(1, 0, 0, SummaryButtonHeight),
			pos = UDim2.new(),
			isExpanded = summaryExpanded,
			onButtonPress = props.onSummaryButton,
			layoutOrder = 1
		}, {
			Text = Roact.createElement("TextLabel", {
				Text = "Summary",
				TextColor3 = Constants.Color.Text,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextSize = MainWindow,
				Font = MainWindowHeader,
				Size = UDim2.new(1, -30, 0, SummaryButtonHeight),
				Position = UDim2.new(0, 30, 0, 0),
				BackgroundTransparency = 1
			})
		}),
		Summary = summaryExpanded and Roact.createElement(NetworkSummary, {
			width = width,
			httpSummaryTable = httpSummaryTable,
			layoutOrder = 2
		}),
		DetailsButton = Roact.createElement(BannerButton, {
			size = UDim2.new(1, 0, 0, SummaryButtonHeight),
			pos = UDim2.new(),
			isExpanded = entriesExpanded,
			onButtonPress = props.onDetailButton,
			layoutOrder = 3
		}, {
			Text = Roact.createElement("TextLabel", {
				Text = "Details",
				TextColor3 = Constants.Color.Text,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextSize = MainWindow,
				Font = MainWindowHeader,
				Size = UDim2.new(1, -30, 0, SummaryButtonHeight),
				Position = UDim2.new(0, 30, 0, 0),
				BackgroundTransparency = 1
			})
		}),
		Entries = entriesExpanded and Roact.createElement(NetworkChart, {
			httpEntryList = httpEntryList,
			chartHeight = chartHeight,
			width = width,
			searchTerm = searchTerm,
			reverseSort = reverseSort,
			layoutOrder = 4,
			onSortChanged = props.onSortChanged
		})
	})
end

return extended
