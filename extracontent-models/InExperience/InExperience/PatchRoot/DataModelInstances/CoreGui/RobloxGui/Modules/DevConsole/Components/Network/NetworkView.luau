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
local v14 = Roact.Component:extend("NetworkView")

function v14.init(p1, p2) -- line: 22
	-- upvalues: Roact (copy)
	assert(p2.targetNetworkData, "Make sure the NetworkData is assigned for this NetworkView")

	local v17 = p2.targetNetworkData:getCurrentData()

	function p1.onSortChanged(p3) -- line: 27
		-- upvalues: p2 (copy), p1 (copy)
		if p3 == p2.targetNetworkData:getSortType() then
			p1:setState({
				reverseSort = not p1.state.reverseSort
			})

			return
		end

		p2.targetNetworkData:setSortType(p3)
		p1:setState({
			reverseSort = false
		})
	end
	function p1.onSummaryButton(_, _) -- line: 41
		-- upvalues: p1 (copy)
		p1:setState({
			summaryExpanded = not p1.state.summaryExpanded
		})
	end
	function p1.onDetailButton(_, _) -- line: 47
		-- upvalues: p1 (copy)
		p1:setState({
			entriesExpanded = not p1.state.entriesExpanded
		})
	end

	p1.ref = Roact.createRef()
	p1.state = {
		summaryExpanded = true,
		entriesExpanded = true,
		indexOfEntryExpanded = 0,
		reverseSort = false,
		absWidth = 0,
		httpSummaryTable = v17.summaryTable,
		httpSummaryCount = v17.summaryCount,
		httpEntryList = v17.entryList
	}
end
function v14.didUpdate(p8) -- line: 67
	if p8.ref.current and p8.state.absWidth ~= p8.ref.current.AbsoluteSize.X then
		p8:setState({
			absWidth = p8.ref.current.AbsoluteSize.X
		})
	end
end
function v14.didMount(p9) -- line: 77
	p9.httpEntryAddedConnector = p9.props.targetNetworkData:Signal():Connect(function(p10, p11, p12) -- line: 79
		-- upvalues: p9 (copy)
		p9:setState({
			httpSummaryTable = p10,
			httpSummaryCount = p11,
			httpEntryList = p12
		})
	end)

	if p9.ref.current then
		p9:setState({
			absWidth = p9.ref.current.AbsoluteSize.X
		})
	end
end
function v14.willUnmount(p13) -- line: 94
	p13.httpEntryAddedConnector:Disconnect()
	p13.httpEntryAddedConnector = nil
end
function v14.render(p14) -- line: 99
	-- upvalues: MinFrameWidth (copy), SummaryButtonHeight (copy), EntryFrameHeight (copy), HeaderFrameHeight (copy), Roact (copy), BannerButton (copy), Constants (copy), MainWindow (copy), MainWindowHeader (copy), NetworkSummary (copy), NetworkChart (copy)
	local layoutOrder = p14.props.layoutOrder
	local searchTerm = p14.props.searchTerm
	local size = p14.props.size
	local summaryExpanded = p14.state.summaryExpanded
	local entriesExpanded = p14.state.entriesExpanded
	local reverseSort = p14.state.reverseSort
	local httpSummaryTable = p14.state.httpSummaryTable
	local httpEntryList = p14.state.httpEntryList
	local httpSummaryCount = p14.state.httpSummaryCount
	local v31 = math.max(MinFrameWidth, p14.state.absWidth)
	local v32 = SummaryButtonHeight * 2

	if summaryExpanded then
		v32 = v32 + httpSummaryCount * EntryFrameHeight + HeaderFrameHeight
	end

	local v33 = math.max(0, if not p14.ref.current then size.Y.Offset - v32 else p14.ref.current.AbsoluteSize.Y - v32)

	return Roact.createElement("Frame", {
		Size = size,
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		LayoutOrder = layoutOrder,
		[Roact.Ref] = p14.ref
	}, {
		UIListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		SummaryButton = Roact.createElement(BannerButton, {
			layoutOrder = 1,
			size = UDim2.new(1, 0, 0, SummaryButtonHeight),
			pos = UDim2.new(),
			isExpanded = summaryExpanded,
			onButtonPress = p14.onSummaryButton
		}, {
			Text = Roact.createElement("TextLabel", {
				Text = "Summary",
				BackgroundTransparency = 1,
				TextColor3 = Constants.Color.Text,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextSize = MainWindow,
				Font = MainWindowHeader,
				Size = UDim2.new(1, -30, 0, SummaryButtonHeight),
				Position = UDim2.new(0, 30, 0, 0)
			})
		}),
		Summary = summaryExpanded and Roact.createElement(NetworkSummary, {
			layoutOrder = 2,
			width = v31,
			httpSummaryTable = httpSummaryTable
		}),
		DetailsButton = Roact.createElement(BannerButton, {
			layoutOrder = 3,
			size = UDim2.new(1, 0, 0, SummaryButtonHeight),
			pos = UDim2.new(),
			isExpanded = entriesExpanded,
			onButtonPress = p14.onDetailButton
		}, {
			Text = Roact.createElement("TextLabel", {
				Text = "Details",
				BackgroundTransparency = 1,
				TextColor3 = Constants.Color.Text,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextSize = MainWindow,
				Font = MainWindowHeader,
				Size = UDim2.new(1, -30, 0, SummaryButtonHeight),
				Position = UDim2.new(0, 30, 0, 0)
			})
		}),
		Entries = entriesExpanded and Roact.createElement(NetworkChart, {
			layoutOrder = 4,
			httpEntryList = httpEntryList,
			chartHeight = v33,
			width = v31,
			searchTerm = searchTerm,
			reverseSort = reverseSort,
			onSortChanged = p14.onSortChanged
		})
	})
end

return v14
