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
local Text = Constants.Color.Text
local topBar = Constants.Font.TopBar

local udim = UDim2.new(0, TopBar, 0, TopBar)

local textSize = TextService:GetTextSize("Client Mem:", TopBar, topBar, Vector2.new(0, 0))

local textSize2 = TextService:GetTextSize("Client Memory Usage:", TopBar, topBar, Vector2.new(0, 0))

local textSize3 = TextService:GetTextSize("Avg. Data Ping:", TopBar, topBar, Vector2.new(0, 0))

local extended = Roact.PureComponent:extend("LiveUpdateElement")

function extended:didMount()
	self.totalMemConnector = self.props.ClientMemoryData:totalMemSignal():Connect(function(totalClientMemory)
		self:setState({ totalClientMemory = totalClientMemory })
	end)

	self.avgPingConnector = self.props.ServerStatsData:avgPing():Connect(function(averagePing)
		self:setState({ averagePing = averagePing })
	end)

	self.logWarningErrorConnector = self.props.ClientLogData:errorWarningSignal():Connect(function(numErrors, numWarnings)
		self:setState({ numErrors = numErrors, numWarnings = numWarnings })
	end)

	self:doSizeCheck()
end

function extended:didUpdate()
	self:doSizeCheck()
end

function extended:doSizeCheck()
	if self.ref.current then
		local isSmallerThanFormFactorThreshold = self.state.formFactorThreshold > self.ref.current.AbsoluteSize.X

		if isSmallerThanFormFactorThreshold ~= self.state.isSmallerThanFormFactorThreshold then
			self:setState({ isSmallerThanFormFactorThreshold = isSmallerThanFormFactorThreshold })
		end
	end
end

function extended:willUnmount()
	self.totalMemConnector:Disconnect()
	self.totalMemConnector = nil

	self.avgPingConnector:Disconnect()
	self.avgPingConnector = nil

	self.logWarningErrorConnector:Disconnect()
	self.logWarningErrorConnector = nil
end

function extended:init()
	local errorWarningCount, numWarnings = self.props.ClientLogData:getErrorWarningCount()
	function self.onLogWarningButton()
		local v = {}

		for _, v2 in pairs(MsgTypeNamesOrdered) do
			v[v2] = false
		end

		v.Warning = true
		self.props.ClientLogData:setFilters(v)
		self.props.dispatchChangeTabClientLog()
	end

	function self.onLogErrorButton()
		local v = {}

		for _, v2 in pairs(MsgTypeNamesOrdered) do
			v[v2] = false
		end

		v.Error = true
		self.props.ClientLogData:setFilters(v)
		self.props.dispatchChangeTabClientLog()
	end

	self.ref = Roact.createRef()

	self.state = {
		numErrors = errorWarningCount,
		numWarnings = numWarnings,
		totalClientMemory = 0,
		averagePing = 0,
		formFactorThreshold = 380,
		isSmallerThanFormFactorThreshold = false
	}
end

function extended.render(props)
	local size = props.props.size
	local position = props.props.position
	local formFactor = props.props.formFactor

	local numErrors = props.state.numErrors
	local numWarnings = props.state.numWarnings
	local totalClientMemory = props.state.totalClientMemory
	local averagePing = props.state.averagePing
	local isSmallerThanFormFactorThreshold = props.state.isSmallerThanFormFactorThreshold

	local x = textSize2.X
	local horizontalAlignment = Enum.HorizontalAlignment.Center
	local v

	if formFactor == Constants.FormFactor.Small or isSmallerThanFormFactorThreshold then
		position += UDim2.new(0, 12, 0, 0)
		x = textSize.X

		horizontalAlignment = Enum.HorizontalAlignment.Left
		v = true
	else
		v = false
	end

	local text = string.format("%d", numErrors)
	local textSize4 = TextService:GetTextSize(text, TopBar, topBar, Vector2.new(0, 0))

	local text2 = string.format("%d", numWarnings)
	local textSize5 = TextService:GetTextSize(text2, TopBar, topBar, Vector2.new(0, 0))

	local text3 = string.format("%d MB", totalClientMemory)
	local textSize6 = TextService:GetTextSize(text3, TopBar, topBar, Vector2.new(0, 0))

	local text4 = string.format("%d ms", averagePing)
	local textSize7 = TextService:GetTextSize(text4, TopBar, topBar, Vector2.new(0, 0))

	if formFactor == Constants.FormFactor.Small or isSmallerThanFormFactorThreshold then
		position += UDim2.new(0, 12, 0, 0)
		x = textSize.X

		horizontalAlignment = Enum.HorizontalAlignment.Left
		v = true
	end

	local v2 = averagePing > 0
	local createElement = Roact.createElement
	local refsByRef = {
		Position = position,
		Size = size,
		BackgroundTransparency = 1,
		[Roact.Ref] = props.ref
	}
	local children = {
		UIListLayout = Roact.createElement("UIListLayout", {
			Padding = UDim.new(0, 6),
			HorizontalAlignment = horizontalAlignment,
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		LogErrorIcon = Roact.createElement("ImageButton", {
			Image = Constants.Image.Error,
			Size = udim,
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			[Roact.Event.Activated] = props.onLogErrorButton
		}),
		LogErrorCount = Roact.createElement("TextButton", {
			Text = text,
			TextSize = TopBar,
			TextColor3 = Text,
			TextXAlignment = Enum.TextXAlignment.Left,
			Font = topBar,
			Size = UDim2.new(0, textSize4.X, 1, 0),
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			[Roact.Event.Activated] = props.onLogErrorButton
		}),
		ErrorWarningPad = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 3
		}),
		LogWarningIcon = Roact.createElement("ImageButton", {
			Image = Constants.Image.Warning,
			Size = udim,
			BackgroundTransparency = 1,
			LayoutOrder = 4,
			[Roact.Event.Activated] = props.onLogWarningButton
		}),
		LogWarningCount = Roact.createElement("TextButton", {
			Text = text2,
			TextSize = TopBar,
			TextColor3 = Text,
			TextXAlignment = Enum.TextXAlignment.Left,
			Font = topBar,
			Size = UDim2.new(0, textSize5.X, 1, 0),
			BackgroundTransparency = 9,
			LayoutOrder = 5,
			[Roact.Event.Activated] = props.onLogWarningButton
		}),
		WarningMemoryPad = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 6
		}),
		MemoryUsage = Roact.createElement("TextButton", {
			Text = v and "Client Mem:" or "Client Memory Usage:",
			TextSize = TopBar,
			TextColor3 = Constants.Color.WarningYellow,
			TextXAlignment = Enum.TextXAlignment.Right,
			Font = topBar,
			Size = UDim2.new(0, x, 1, 0),
			BackgroundTransparency = 1,
			LayoutOrder = 7,
			[Roact.Event.Activated] = props.props.dispatchChangeTabClientMemory
		}),
		MemoryUsage_MB = Roact.createElement("TextButton", {
			Text = text3,
			TextSize = TopBar,
			TextColor3 = Text,
			TextXAlignment = Enum.TextXAlignment.Left,
			Font = topBar,
			Size = UDim2.new(0, textSize6.X, 1, 0),
			BackgroundTransparency = 1,
			LayoutOrder = 8,
			[Roact.Event.Activated] = props.props.dispatchChangeTabClientMemory
		}),
		MemoryPingPad = Roact.createElement("Frame", { BackgroundTransparency = 1, LayoutOrder = 9 }),
		AvgPing = 0,
		AvgPing_ms = 0
	}

	local avgPing = not v

	if avgPing then
		if v2 then
			avgPing = Roact.createElement("TextButton", {
				Text = "Avg. Data Ping:",
				TextSize = TopBar,
				TextColor3 = Constants.Color.WarningYellow,
				TextXAlignment = Enum.TextXAlignment.Right,
				Font = topBar,
				Size = UDim2.new(0, textSize3.X, 1, 0),
				BackgroundTransparency = 1,
				LayoutOrder = 10,
				[Roact.Event.Activated] = props.props.dispatchChangeTabNetworkPing
			})
		else
			avgPing = v2
		end
	end

	children.AvgPing = avgPing

	local avgPing_ms = not v

	if avgPing_ms then
		if v2 then
			avgPing_ms = Roact.createElement("TextButton", {
				Text = text4,
				TextSize = TopBar,
				TextColor3 = Text,
				TextXAlignment = Enum.TextXAlignment.Left,
				Font = topBar,
				Size = UDim2.new(0, textSize7.X, 1, 0),
				BackgroundTransparency = 1,
				LayoutOrder = 11,
				[Roact.Event.Activated] = props.props.dispatchChangeTabNetworkPing
			})
		else
			avgPing_ms = v2
		end
	end

	children.AvgPing_ms = avgPing_ms
	return createElement("Frame", refsByRef, children)
end

local function mapDispatchToProps(callback)
	return {
		dispatchChangeTabClientLog = function()
			callback(SetActiveTab("Log", true))
		end,
		dispatchChangeTabClientMemory = function()
			callback(SetActiveTab("Memory", true))
		end,
		dispatchChangeTabNetworkPing = function()
			callback(SetActiveTab("ServerStats", true))
		end
	}
end

return RoactRodux.UNSTABLE_connect2(nil, mapDispatchToProps)(DataConsumer(
	extended,
	"ServerStatsData",
	"ClientMemoryData",
	"ClientLogData"
))
