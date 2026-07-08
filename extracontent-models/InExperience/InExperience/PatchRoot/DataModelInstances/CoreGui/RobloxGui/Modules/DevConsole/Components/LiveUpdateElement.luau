local CorePackages = game:GetService("CorePackages")
local TextService = game:GetService("TextService")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local DataConsumer = require(script.Parent.Parent.Components.DataConsumer)
local Actions = script.Parent.Parent.Actions
local SetActiveTab = require(Actions.SetActiveTab)
local Constants = require(script.Parent.Parent.Constants)
local MsgTypeNamesOrdered = Constants.MsgTypeNamesOrdered
local TopBar = Constants.DefaultFontSize.TopBar
local ColorText = Constants.Color.Text
local TopBar2 = Constants.Font.TopBar
local uDim2 = UDim2.new(0, TopBar, 0, TopBar)
local TextSize = TextService:GetTextSize("Client Mem:", TopBar, TopBar2, Vector2.new(0, 0))
local TextSize2 = TextService:GetTextSize("Client Memory Usage:", TopBar, TopBar2, Vector2.new(0, 0))
local TextSize3 = TextService:GetTextSize("Avg. Data Ping:", TopBar, TopBar2, Vector2.new(0, 0))
local v17 = Roact.PureComponent:extend("LiveUpdateElement")

function v17.didMount(p1) -- line: 35
	p1.totalMemConnector = p1.props.ClientMemoryData:totalMemSignal():Connect(function(p2) -- line: 37
		-- upvalues: p1 (copy)
		p1:setState({
			totalClientMemory = p2
		})
	end)
	p1.avgPingConnector = p1.props.ServerStatsData:avgPing():Connect(function(p3) -- line: 41
		-- upvalues: p1 (copy)
		p1:setState({
			averagePing = p3
		})
	end)
	p1.logWarningErrorConnector = p1.props.ClientLogData:errorWarningSignal():Connect(function(p4, p5) -- line: 45
		-- upvalues: p1 (copy)
		p1:setState({
			numErrors = p4,
			numWarnings = p5
		})
	end)
	p1:doSizeCheck()
end
function v17.didUpdate(p6) -- line: 55
	p6:doSizeCheck()
end
function v17.doSizeCheck(p7) -- line: 59
	if p7.ref.current then
		local v22 = p7.state.formFactorThreshold > p7.ref.current.AbsoluteSize.X

		if v22 ~= p7.state.isSmallerThanFormFactorThreshold then
			p7:setState({
				isSmallerThanFormFactorThreshold = v22
			})
		end
	end
end
function v17.willUnmount(p8) -- line: 72
	p8.totalMemConnector:Disconnect()
	p8.totalMemConnector = nil
	p8.avgPingConnector:Disconnect()
	p8.avgPingConnector = nil
	p8.logWarningErrorConnector:Disconnect()
	p8.logWarningErrorConnector = nil
end
function v17.init(p9) -- line: 83
	-- upvalues: MsgTypeNamesOrdered (copy), Roact (copy)
	local v25, v26 = p9.props.ClientLogData:getErrorWarningCount()

	function p9.onLogWarningButton() -- line: 85
		-- upvalues: MsgTypeNamesOrdered (copy), p9 (copy)
		local t1 = {}

		for _, v in pairs(MsgTypeNamesOrdered) do
			t1[v] = false
		end

		t1.Warning = true
		p9.props.ClientLogData:setFilters(t1)
		p9.props.dispatchChangeTabClientLog()
	end
	function p9.onLogErrorButton() -- line: 96
		-- upvalues: MsgTypeNamesOrdered (copy), p9 (copy)
		local t2 = {}

		for _, v in pairs(MsgTypeNamesOrdered) do
			t2[v] = false
		end

		t2.Error = true
		p9.props.ClientLogData:setFilters(t2)
		p9.props.dispatchChangeTabClientLog()
	end

	p9.ref = Roact.createRef()
	p9.state = {
		totalClientMemory = 0,
		averagePing = 0,
		formFactorThreshold = 380,
		isSmallerThanFormFactorThreshold = false,
		numErrors = v25,
		numWarnings = v26
	}
end
function v17.render(p10) -- line: 119
	-- upvalues: TextSize2 (copy), Constants (copy), TextSize (copy), TextService (copy), TopBar (copy), TopBar2 (copy), TextSize3 (copy), Roact (copy), uDim2 (copy), ColorText (copy)
	local size = p10.props.size
	local position = p10.props.position
	local formFactor = p10.props.formFactor
	local numErrors = p10.state.numErrors
	local numWarnings = p10.state.numWarnings
	local totalClientMemory = p10.state.totalClientMemory
	local averagePing = p10.state.averagePing
	local isSmallerThanFormFactorThreshold = p10.state.isSmallerThanFormFactorThreshold
	local v36 = false
	local TextSize2X = TextSize2.X
	local Center = Enum.HorizontalAlignment.Center

	if formFactor == Constants.FormFactor.Small or isSmallerThanFormFactorThreshold then
		position += UDim2.new(0, 12, 0, 0)
		TextSize2X = TextSize.X
		v36 = true
		Center = Enum.HorizontalAlignment.Left
	end

	local v39 = string.format("%d", numErrors)
	local TextSize4 = TextService:GetTextSize(v39, TopBar, TopBar2, Vector2.new(0, 0))
	local v41 = string.format("%d", numWarnings)
	local TextSize5 = TextService:GetTextSize(v41, TopBar, TopBar2, Vector2.new(0, 0))
	local v43 = string.format("%d MB", totalClientMemory)
	local TextSize6 = TextService:GetTextSize(v43, TopBar, TopBar2, Vector2.new(0, 0))
	local v45 = string.format("%d ms", averagePing)
	local TextSize7 = TextService:GetTextSize(v45, TopBar, TopBar2, Vector2.new(0, 0))

	if formFactor == Constants.FormFactor.Small or isSmallerThanFormFactorThreshold then
		position += UDim2.new(0, 12, 0, 0)
		TextSize2X = TextSize.X
		v36 = true
		Center = Enum.HorizontalAlignment.Left
	end

	local v47 = averagePing > 0
	local v48 = TextSize3

	return Roact.createElement("Frame", {
		Position = position,
		Size = size,
		BackgroundTransparency = 1,
		[Roact.Ref] = p10.ref
	}, {
		UIListLayout = Roact.createElement("UIListLayout", {
			Padding = UDim.new(0, 6),
			HorizontalAlignment = Center,
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		LogErrorIcon = Roact.createElement("ImageButton", {
			Image = Constants.Image.Error,
			Size = uDim2,
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			[Roact.Event.Activated] = p10.onLogErrorButton
		}),
		LogErrorCount = Roact.createElement("TextButton", {
			Text = v39,
			TextSize = TopBar,
			TextColor3 = ColorText,
			TextXAlignment = Enum.TextXAlignment.Left,
			Font = TopBar2,
			Size = UDim2.new(0, TextSize4.X, 1, 0),
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			[Roact.Event.Activated] = p10.onLogErrorButton
		}),
		ErrorWarningPad = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 3
		}),
		LogWarningIcon = Roact.createElement("ImageButton", {
			Image = Constants.Image.Warning,
			Size = uDim2,
			BackgroundTransparency = 1,
			LayoutOrder = 4,
			[Roact.Event.Activated] = p10.onLogWarningButton
		}),
		LogWarningCount = Roact.createElement("TextButton", {
			Text = v41,
			TextSize = TopBar,
			TextColor3 = ColorText,
			TextXAlignment = Enum.TextXAlignment.Left,
			Font = TopBar2,
			Size = UDim2.new(0, TextSize5.X, 1, 0),
			BackgroundTransparency = 9,
			LayoutOrder = 5,
			[Roact.Event.Activated] = p10.onLogWarningButton
		}),
		WarningMemoryPad = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 6
		}),
		MemoryUsage = Roact.createElement("TextButton", {
			Text = not v36 and "Client Memory Usage:" or "Client Mem:",
			TextSize = TopBar,
			TextColor3 = Constants.Color.WarningYellow,
			TextXAlignment = Enum.TextXAlignment.Right,
			Font = TopBar2,
			Size = UDim2.new(0, TextSize2X, 1, 0),
			BackgroundTransparency = 1,
			LayoutOrder = 7,
			[Roact.Event.Activated] = p10.props.dispatchChangeTabClientMemory
		}),
		MemoryUsage_MB = Roact.createElement("TextButton", {
			Text = v43,
			TextSize = TopBar,
			TextColor3 = ColorText,
			TextXAlignment = Enum.TextXAlignment.Left,
			Font = TopBar2,
			Size = UDim2.new(0, TextSize6.X, 1, 0),
			BackgroundTransparency = 1,
			LayoutOrder = 8,
			[Roact.Event.Activated] = p10.props.dispatchChangeTabClientMemory
		}),
		MemoryPingPad = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 9
		}),
		AvgPing = not v36 and (v47 and Roact.createElement("TextButton", {
			Text = "Avg. Data Ping:",
			TextSize = TopBar,
			TextColor3 = Constants.Color.WarningYellow,
			TextXAlignment = Enum.TextXAlignment.Right,
			Font = TopBar2,
			Size = UDim2.new(0, v48.X, 1, 0),
			BackgroundTransparency = 1,
			LayoutOrder = 10,
			[Roact.Event.Activated] = p10.props.dispatchChangeTabNetworkPing
		})),
		AvgPing_ms = not v36 and (v47 and Roact.createElement("TextButton", {
			Text = v45,
			TextSize = TopBar,
			TextColor3 = ColorText,
			TextXAlignment = Enum.TextXAlignment.Left,
			Font = TopBar2,
			Size = UDim2.new(0, TextSize7.X, 1, 0),
			BackgroundTransparency = 1,
			LayoutOrder = 11,
			[Roact.Event.Activated] = p10.props.dispatchChangeTabNetworkPing
		}))
	})
end

local function mapDispatchToProps(p11) -- line: 286
	-- upvalues: SetActiveTab (copy)
	return {
		dispatchChangeTabClientLog = function() -- line: 288
			-- upvalues: p11 (copy), SetActiveTab (copy)
			p11(SetActiveTab("Log", true))
		end,
		dispatchChangeTabClientMemory = function() -- line: 291
			-- upvalues: p11 (copy), SetActiveTab (copy)
			p11(SetActiveTab("Memory", true))
		end,
		dispatchChangeTabNetworkPing = function() -- line: 294
			-- upvalues: p11 (copy), SetActiveTab (copy)
			p11(SetActiveTab("ServerStats", true))
		end
	}
end

return RoactRodux.UNSTABLE_connect2(nil, mapDispatchToProps)(DataConsumer(v17, "ServerStatsData", "ClientMemoryData", "ClientLogData"))
