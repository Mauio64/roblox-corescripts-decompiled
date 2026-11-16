local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local Actions = script.Parent.Parent.Parent.Actions

local Components = script.Parent.Parent.Parent.Components
local DataConsumer = require(Components.DataConsumer)
local LineGraph = require(Components.LineGraph)
local Sparkline = require(Components.Sparkline)
local MainViewConnectivityPanel = require(script.Parent.MainViewConnectivityPanel)
local MainViewSubscriptionsPanel = require(script.Parent.MainViewSubscriptionsPanel)
local MainViewRemoteOperationsPanel = require(script.Parent.MainViewRemoteOperationsPanel)
local MainViewClientOperationQueuePanel = require(script.Parent.MainViewClientOperationQueuePanel)
local CollapsibleSection = require(script.Parent.CollapsibleSection)

local Constants = require(script.Parent.Parent.Parent.Constants)
local MainRowPadding = Constants.GeneralFormatting.MainRowPadding
local LineGraphHeight = Constants.GeneralFormatting.LineGraphHeight

local UtilAndTab = require(Components.UtilAndTab)

local convertTimeStamp = require(script.Parent.Parent.Parent.Util.convertTimeStamp)

local VoiceDebugFieldMeta = require(script.Parent.VoiceDebugFieldMeta)
local VoiceDebugFieldDisplayOrder = require(script.Parent.VoiceDebugFieldDisplayOrder)

local GetFFlagVoiceDebugConsoleV2 = require(script.Parent.GetFFlagVoiceDebugConsoleV2)

local FreezeToggle = require(script.Parent.FreezeToggle)
local VoiceSourceToggle = require(script.Parent.VoiceSourceToggle)

local clone = table.clone(VoiceDebugFieldDisplayOrder)
local v = {
	rttMs = true,
	incomingBitrateKbps = true,
	outgoingBitrateKbps = true,
	incomingJitterMs = true,
	outgoingJitterMs = true,
	jitterBufferDelayMs = true,
	incomingLossPercent = true
}

local v2 = { "Connection", "Incoming", "Outgoing" }

local v3 = {
	totalConcealmentEvents = true,
	lastPublisherAudioLevelDbov = true,
	lastSubscriberAudioLevelDbov = true
}

for _, v4 in {
	"incomingBitrateKbps",
	"outgoingBitrateKbps",
	"outgoingCodec",
	"incomingLossPercent",
	"totalConcealmentEvents",
	"lastPublisherAudioLevelDbov",
	"lastSubscriberAudioLevelDbov"
} do
	table.insert(clone, v4)
end

local function getX(p)
	return p.time
end

local function getY(p)
	return p.value
end

local function makeStringFormatY(p: string) -- 2 equivalent calls inferred from this helper
	local unit = VoiceDebugFieldMeta[p] and VoiceDebugFieldMeta[p].unit
	return function(p2)
		if unit then
			return string.format("%.1f %s", p2, unit)
		end

		return string.format("%.1f", p2)
	end
end

local function getFieldSeverity(p: string, p2) -- 4 equivalent calls inferred from this helper
	return VoiceDebugFieldMeta.getFieldSeverity(p, p2)
end

local function severityColor(p, color: Color3) -- 3 equivalent calls inferred from this helper
	if p == "error" then
		return Constants.Color.ErrorRed
	elseif p == "warn" then
		return Constants.Color.WarningYellow
	elseif p == "ok" then
		return Constants.Color.HoverGreen
	end

	return color
end

local function formatNumber(p: string, p2: number) -- 2 equivalent calls inferred from this helper
	if v[p] then
		return string.format("%.2f", p2)
	end

	return (tostring(p2))
end

local function formatValue(p: string, p2)
	if p2 == nil then
		return "—"
	end

	local v4 = VoiceDebugFieldMeta[p]
	local unit = v4 and v4.unit
	local selected = formatNumber(p, p2) -- inferred equivalent call

	if unit then
		return string.format("%s %s", selected, unit)
	end

	return selected
end

local function formatCardSubCaption(p, p2: string?)
	local v4 = p and string.format("%.1f", p.max) or "—"

	if p2 then
		return string.format("%s · peak %s%s", p2, v4, p2)
	end

	return string.format("peak %s", v4)
end

local function formatCardValue(value, value2: number?)
	if type(value) == "number" then
		return string.format("%." .. tostring(value2 or 0) .. "f", value)
	end

	return "—"
end

local function HealthCard(props)
	local textColor = severityColor(props.severity, Constants.Color.Text) -- inferred equivalent call

	return Roact.createElement(
		"Frame",
		{
			LayoutOrder = props.layoutOrder,
			Size = UDim2.new(0, 110, 0, 56),
			BackgroundColor3 = Constants.Color.TextBoxGray,
			BorderSizePixel = 0
		},
		{
			Stroke = Roact.createElement("UIStroke", {
				Color = Constants.Color.BorderGray,
				Thickness = 1,
				Transparency = 0.5
			}),
			Padding = Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 8),
				PaddingRight = UDim.new(0, 8),
				PaddingTop = UDim.new(0, 6),
				PaddingBottom = UDim.new(0, 6)
			}),
			Layout = Roact.createElement("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }),
			Caption = Roact.createElement("TextLabel", {
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, 14),
				Text = props.caption,
				Font = Constants.Font.MainWindowHeader,
				TextSize = Constants.DefaultFontSize.MainWindowHeader,
				TextColor3 = Constants.Color.Text,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1
			}),
			Value = Roact.createElement("TextLabel", {
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, 20),
				Text = props.value,
				Font = Constants.Font.MainWindowBold,
				TextSize = 18,
				TextColor3 = textColor,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1
			}),
			SubCaption = Roact.createElement("TextLabel", {
				LayoutOrder = 3,
				Size = UDim2.new(1, 0, 0, 12),
				Text = props.subCaption or "",
				Font = Constants.Font.MainWindow,
				TextSize = 11,
				TextColor3 = Constants.Color.BorderGray,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1
			})
		}
	)
end

local extended = Roact.PureComponent:extend("MainViewVoiceDebug")

function extended:init()
	function self.onUtilTabHeightChanged(utilTabHeight)
		self:setState({ utilTabHeight = utilTabHeight })
	end

	function self.onStatsUpdated(stats)
		if self.state.frozen then
			return
		end

		self:setState({
			stats = stats,
			series = self.props.VoiceDebugData:getSeries(),
			connectivity = self.props.VoiceDebugData:getConnectivity(),
			subscriptions = self.props.VoiceDebugData:getSubscriptions(),
			remoteOperations = self.props.VoiceDebugData:getRemoteOperations(),
			source = self.props.VoiceDebugData:getSource()
		})
	end

	function self.onSourceChanged(source)
		self.props.VoiceDebugData:setSource(source)
		self:setState({
			source = source,
			stats = self.props.VoiceDebugData:getCurrentData(),
			series = self.state.frozen and self.props.VoiceDebugData:getSeriesSnapshot() or self.props.VoiceDebugData:getSeries(),
			connectivity = self.props.VoiceDebugData:getConnectivity(),
			subscriptions = self.props.VoiceDebugData:getSubscriptions(),
			remoteOperations = self.props.VoiceDebugData:getRemoteOperations()
		})
	end

	function self.onFreezeToggled()
		if self.state.frozen then
			self:setState({
				frozen = false,
				stats = self.props.VoiceDebugData:getCurrentData(),
				series = self.props.VoiceDebugData:getSeries(),
				connectivity = self.props.VoiceDebugData:getConnectivity(),
				subscriptions = self.props.VoiceDebugData:getSubscriptions(),
				remoteOperations = self.props.VoiceDebugData:getRemoteOperations()
			})
		else
			self:setState({
				frozen = true,
				series = self.props.VoiceDebugData:getSeriesSnapshot()
			})
		end
	end

	self._statsUpdatedConnection = self.props.VoiceDebugData:Signal():Connect(self.onStatsUpdated)

	self.utilRef = Roact.createRef()

	self.state = {
		utilTabHeight = 0,
		stats = {},
		series = {},
		connectivity = {},
		subscriptions = {},
		remoteOperations = {},
		source = self.props.VoiceDebugData:getSource(),
		selectedGraphKeyByGroup = {},
		frozen = false
	}
end

function extended.didMount(object)
	object:setState({ utilTabHeight = object.utilRef.current.Size.Y.Offset })
end

function extended.didUpdate(object)
	local size = object.utilRef.current.Size

	if size.Y.Offset ~= object.state.utilTabHeight then
		object:setState({ utilTabHeight = size.Y.Offset })
	end
end

function extended:willUnmount()
	if self._statsUpdatedConnection then
		self._statsUpdatedConnection:Disconnect()
		self._statsUpdatedConnection = nil
	end
end

function extended:onGraphRowClicked(p: string)
	local v4 = VoiceDebugFieldMeta[p]
	local v5

	if v4 then
		v5 = v4.group or p
	else
		v5 = p
	end

	local clone2 = table.clone(self.state.selectedGraphKeyByGroup)

	if clone2[v5] == p then
		clone2[v5] = nil
	else
		clone2[v5] = p
	end

	self:setState({ selectedGraphKeyByGroup = clone2 })
end

function extended:renderHealthStrip()
	local stats = self.state.stats
	local series = self.state.series

	local createElement = Roact.createElement
	local v4 = { LayoutOrder = 0, Size = UDim2.new(1, 0, 0, 56), BackgroundTransparency = 1 }

	local children = {
		Layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, MainRowPadding)
		}),
		RoundTrip = 0,
		LossIn = 0,
		JitterIn = 0,
		Streams = 0
	}

	local createElement2 = Roact.createElement

	local rttMs = stats.rttMs
	local v5 = {
		layoutOrder = 1,
		caption = "Round-trip",
		value = type(rttMs) ~= "number" and "—" or string.format("%." .. tostring(2) .. "f", rttMs),
		severity = getFieldSeverity("rttMs", stats.rttMs), -- inferred equivalent call
		subCaption = 0
	}
	local rttMs2 = series.rttMs
	local v6 = rttMs2 and string.format("%.1f", rttMs2.max) or "—"

	v5.subCaption = string.format("%s · peak %s%s", "ms", v6, "ms")
	children.RoundTrip = createElement2(HealthCard, v5)

	local createElement3 = Roact.createElement

	local incomingLossPercent = stats.incomingLossPercent
	local v7 = {
		layoutOrder = 2,
		caption = "Loss in",
		value = type(incomingLossPercent) ~= "number" and "—" or string.format(
			"%." .. tostring(1) .. "f",
			incomingLossPercent
		),
		severity = getFieldSeverity("incomingLossPercent", stats.incomingLossPercent), -- inferred equivalent call
		subCaption = 0
	}
	local incomingLossPercent2 = series.incomingLossPercent
	local v8 = incomingLossPercent2 and string.format("%.1f", incomingLossPercent2.max) or "—"

	v7.subCaption = string.format("%s · peak %s%s", "%", v8, "%")
	children.LossIn = createElement3(HealthCard, v7)

	local createElement4 = Roact.createElement

	local incomingJitterMs = stats.incomingJitterMs
	local v9 = {
		layoutOrder = 3,
		caption = "Jitter in",
		value = type(incomingJitterMs) ~= "number" and "—" or string.format("%." .. tostring(2) .. "f", incomingJitterMs),
		severity = getFieldSeverity("incomingJitterMs", stats.incomingJitterMs), -- inferred equivalent call
		subCaption = 0
	}
	local incomingJitterMs2 = series.incomingJitterMs
	local v10 = incomingJitterMs2 and string.format("%.1f", incomingJitterMs2.max) or "—"

	v9.subCaption = string.format("%s · peak %s%s", "ms", v10, "ms")
	children.JitterIn = createElement4(HealthCard, v9)

	children.Streams = Roact.createElement(HealthCard, {
		layoutOrder = 4,
		caption = "Streams",
		value = string.format(
			"%s / %s",
			tostring(stats.incomingStreams or "—"),
			(tostring(stats.outgoingStreams or "—"))
		),
		severity = nil,
		subCaption = "in / out"
	})
	return createElement("Frame", v4, children)
end

local function buildStatRow(object, p: string, p2, count: number)
	local v4 = VoiceDebugFieldMeta[p]
	local text

	if v4 then
		text = v4.label or p
	else
		text = p
	end

	if not GetFFlagVoiceDebugConsoleV2() then
		local text2 = string.format("%s: %s", text, formatValue(p, p2))
		return Roact.createElement("TextLabel", {
			LayoutOrder = count,
			Size = UDim2.new(1, 0, 0, 20),
			Text = text2,
			TextColor3 = Constants.Color.Text,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundTransparency = 1
		})
	end

	local unit = v4 and v4.unit or ""
	local v5 = object.state.series[p]
	local v6

	if v4 == nil or v4.plottable ~= true then
		v6 = false
	else
		v6 = v5 ~= nil
	end

	local fieldSeverity = getFieldSeverity(p, p2) -- inferred equivalent call
	local textColor = severityColor(fieldSeverity, Constants.Color.Text) -- inferred equivalent call
	local v7 = fieldSeverity == "warn" or fieldSeverity == "error"

	local children = {
		Accent = Roact.createElement("Frame", {
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(0, 3, 1, 0),
			BackgroundColor3 = severityColor(fieldSeverity, Constants.Color.WarningYellow), -- inferred equivalent call
			BackgroundTransparency = v7 and 0 or 1,
			BorderSizePixel = 0
		}),
		Label = Roact.createElement("TextLabel", {
			Position = UDim2.new(0, 11, 0, 0),
			Size = UDim2.new(1, -251, 1, 0),
			Text = text,
			Font = Constants.Font.MainWindow,
			TextSize = Constants.DefaultFontSize.MainWindow,
			TextColor3 = Constants.Color.Text,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
			BackgroundTransparency = 1
		}),
		Value = 0,
		Unit = 0,
		Delta = 0
	}

	local createElement = Roact.createElement
	local v8 = {
		Position = UDim2.new(1, -180, 0, 0),
		Size = UDim2.new(0, 56, 1, 0),
		Text = 0,
		Font = 0,
		TextSize = 0,
		TextColor3 = 0,
		TextXAlignment = 0,
		BackgroundTransparency = 1
	}
	local text2

	if p2 == nil then
		text2 = "—"
	else
		text2 = formatNumber(p, p2) or "—" -- inferred equivalent call
	end

	v8.Text = text2
	v8.Font = Constants.Font.MainWindowBold
	v8.TextSize = Constants.DefaultFontSize.MainWindow
	v8.TextColor3 = textColor
	v8.TextXAlignment = Enum.TextXAlignment.Right
	children.Value = createElement("TextLabel", v8)

	children.Unit = Roact.createElement("TextLabel", {
		Position = UDim2.new(1, -116, 0, 0),
		Size = UDim2.new(0, 36, 1, 0),
		Text = unit,
		Font = Constants.Font.MainWindow,
		TextSize = Constants.DefaultFontSize.MainWindow,
		TextColor3 = Constants.Color.BorderGray,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1
	})

	children.Delta = Roact.createElement("TextLabel", {
		Position = UDim2.new(1, -72, 0, 0),
		Size = UDim2.new(0, 72, 1, 0),
		Text = v6 and string.format("peak %.1f", v5.max) or "—",
		Font = Constants.Font.MainWindow,
		TextSize = Constants.DefaultFontSize.MainWindow,
		TextColor3 = Constants.Color.BorderGray,
		TextXAlignment = Enum.TextXAlignment.Right,
		BackgroundTransparency = 1
	})

	if v6 then
		children.SparklineButton = Roact.createElement("TextButton", {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(1, -240, 0.5, 0),
			Size = UDim2.new(0, 52, 0, 13),
			Text = "",
			AutoButtonColor = false,
			BackgroundTransparency = 1,
			[Roact.Event.Activated] = function()
				object:onGraphRowClicked(p)
			end
		}, {
			Sparkline = Roact.createElement(Sparkline, {
				dataSet = v5.dataSet,
				getY = getY,
				minY = v5.min,
				maxY = v5.max,
				color = v7 and Constants.Color.WarningYellow or Constants.Color.HighlightBlue,
				size = UDim2.new(1, 0, 1, 0)
			})
		})
	end

	return Roact.createElement(
		"Frame",
		{ LayoutOrder = count, Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1 },
		children
	)
end

local function buildGraphElement(props, p, p2: string, count: number)
	return Roact.createElement(LineGraph, {
		pos = UDim2.new(0, 0, 0, MainRowPadding),
		size = UDim2.new(1, -32, 0, LineGraphHeight),
		layoutOrder = count,
		graphData = props.dataSet,
		minY = props.min,
		maxY = props.max,
		getX = getX,
		getY = getY,
		axisLabelX = "Time",
		axisLabelY = p.label,
		stringFormatX = convertTimeStamp,
		stringFormatY = makeStringFormatY(p2) -- inferred equivalent call
	})
end

function extended:renderStatLabels(items)
	local children = {}
	local count = 0
	local total = 0

	local function addRow(p: string) -- 4 equivalent calls inferred from this helper
		count += 1
		total += 20
		children[p] = buildStatRow(self, p, self.state.stats[p], count)
	end

	local function insertGraph(p: string, p2) -- 2 equivalent calls inferred from this helper
		local v4 = self.state.series[p]

		if not v4 then
			return
		end

		count += 1
		total += LineGraphHeight + MainRowPadding
		children["__graph_" .. p] = buildGraphElement(v4, p2, p, count)
	end

	if GetFFlagVoiceDebugConsoleV2() then
		local v4 = {}

		for _, v5 in v2 do
			v4[v5] = {}
		end

		local v5 = {}

		for _, item in items do
			local v6 = VoiceDebugFieldMeta[item]
			local group = v6 and v6.group

			if group and v4[group] then
				table.insert(v4[group], item)
			else
				table.insert(v5, item)
			end
		end

		for _, text in v2 do
			local v6 = v4[text]

			if not (#v6 > 0) then
				continue
			end

			count += 1
			total += 18
			children["__group_header_" .. text] = Roact.createElement("TextLabel", {
				LayoutOrder = count,
				Size = UDim2.new(1, 0, 0, 18),
				Text = text,
				Font = Constants.Font.MainWindowHeader,
				TextSize = Constants.DefaultFontSize.MainWindowHeader,
				TextColor3 = Constants.Color.BorderGray,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1
			})

			for _, v7 in v6 do
				addRow(v7) -- inferred equivalent call
			end

			local v7 = self.state.selectedGraphKeyByGroup[text]
			local v8 = v7 and VoiceDebugFieldMeta[v7]

			if v8 and v8.plottable then
				insertGraph(v7, v8) -- inferred equivalent call
			end
		end

		for _, v6 in v5 do
			addRow(v6) -- inferred equivalent call
			local v7 = VoiceDebugFieldMeta[v6]

			if v7 and v7.plottable and self.state.selectedGraphKeyByGroup[v6] == v6 then
				insertGraph(v6, v7) -- inferred equivalent call
			end
		end
	else
		for _, item in items do
			addRow(item) -- inferred equivalent call
		end
	end

	local fFlagVoiceDebugConsoleV2 = GetFFlagVoiceDebugConsoleV2()

	for k in self.state.stats do
		if children[k] or not (fFlagVoiceDebugConsoleV2 or not v3[k]) then
			continue
		end

		addRow(k) -- inferred equivalent call
	end

	return children, total
end

function extended:renderGraphs(items)
	local children = {}
	local count = 0

	if GetFFlagVoiceDebugConsoleV2() then
		return children, count
	end

	for _, item in items do
		local v4 = VoiceDebugFieldMeta[item]
		local v5 = self.state.series[item]

		if not (v4 and v4.plottable and v5) then
			continue
		end

		count += 1
		children[item] = Roact.createElement(LineGraph, {
			pos = UDim2.new(),
			size = UDim2.new(1, -32, 0, LineGraphHeight),
			layoutOrder = count,
			graphData = v5.dataSet,
			minY = v5.min,
			maxY = v5.max,
			getX = getX,
			getY = getY,
			axisLabelX = "Time",
			axisLabelY = v4.label,
			stringFormatX = convertTimeStamp,
			stringFormatY = makeStringFormatY(item) -- inferred equivalent call
		})
	end

	return children, count
end

function extended:render()
	local size = self.props.size
	local formFactor = self.props.formFactor
	local tabList = self.props.tabList

	local v4 = GetFFlagVoiceDebugConsoleV2() and clone or VoiceDebugFieldDisplayOrder

	local statLabels, v5 = self:renderStatLabels(v4)
	local graphs, v6 = self:renderGraphs(v4)

	local v7 = v6 * LineGraphHeight + math.max(0, v6 - 1) * MainRowPadding
	local utilTabHeight = self.state.utilTabHeight

	local createElement = Roact.createElement

	local children = {
		UIListLayout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Padding = UDim.new(0, MainRowPadding)
		}),
		FramePadding = Roact.createElement("UIPadding", { PaddingLeft = UDim.new(0, 16) }),
		UtilAndTab = 0,
		Content = 0
	}

	local createElement2 = Roact.createElement
	local v8 = {
		windowWidth = size.X.Offset,
		formFactor = formFactor,
		tabList = tabList,
		layoutOrder = 1,
		refForParent = self.utilRef,
		onHeightChanged = self.onUtilTabHeightChanged,
		extraContent = 0
	}
	local extraContent

	if GetFFlagVoiceDebugConsoleV2() then
		local createElement3 = Roact.createElement
		local v9 = {
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.new(0, 0, 1, 0),
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, formFactor == Constants.FormFactor.Small and -24 or -20, 0.5, 0)
		}

		local v10 = {
			Layout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 8)
			}),
			VoiceSourceToggle = 0,
			FreezeToggle = 0
		}
		local voiceSourceToggle

		if GetFFlagVoiceDebugConsoleV2() then
			voiceSourceToggle = Roact.createElement(VoiceSourceToggle, {
					source = self.state.source,
					onSourceChanged = self.onSourceChanged,
					layoutOrder = 1
				})
				or nil
		end

		v10.VoiceSourceToggle = voiceSourceToggle

		v10.FreezeToggle = Roact.createElement(FreezeToggle, {
			frozen = self.state.frozen,
			onToggle = self.onFreezeToggled,
			layoutOrder = 2
		})
		extraContent = createElement3("Frame", v9, v10) or nil
	end

	v8.extraContent = extraContent
	children.UtilAndTab = createElement2(UtilAndTab, v8)

	children.Content = Roact.createElement("ScrollingFrame", {
		LayoutOrder = 2,
		Size = UDim2.new(1, 0, 1, -utilTabHeight),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 5
	}, GetFFlagVoiceDebugConsoleV2() and {
		UIListLayout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, MainRowPadding)
		}),
		ContentPadding = Roact.createElement("UIPadding", { PaddingRight = UDim.new(0, 24) }),
		MetricsSection = Roact.createElement(CollapsibleSection, {
			title = "Metrics",
			layoutOrder = 1
		}, {
			HealthStrip = self:renderHealthStrip(),
			StatsContainer = Roact.createElement(
				"Frame",
				{ LayoutOrder = 2, Size = UDim2.new(1, 0, 0, v5), BackgroundTransparency = 1 },
				{
					UIListLayout = Roact.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder
					}),
					Labels = Roact.createFragment(statLabels)
				}
			)
		}),
		ConnectivityContainer = Roact.createElement(MainViewConnectivityPanel, {
			connectivity = self.state.connectivity,
			layoutOrder = 2
		}),
		SubscriptionsContainer = Roact.createElement(MainViewSubscriptionsPanel, {
			subscriptions = self.state.subscriptions,
			layoutOrder = 3
		}),
		RemoteOperationsContainer = Roact.createElement(MainViewRemoteOperationsPanel, {
			remoteOperations = self.state.remoteOperations,
			layoutOrder = 4
		}),
		ClientOperationQueueContainer = Roact.createElement(MainViewClientOperationQueuePanel, {
			remoteOperations = self.state.remoteOperations,
			layoutOrder = 5
		}),
		BottomSpacer = Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, 16),
			LayoutOrder = 6,
			BackgroundTransparency = 1
		})
	} or {
		UIListLayout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, MainRowPadding)
		}),
		ContentPadding = Roact.createElement("UIPadding", { PaddingRight = UDim.new(0, 24) }),
		StatsContainer = Roact.createElement(
			"Frame",
			{ LayoutOrder = 1, Size = UDim2.new(1, 0, 0, v5), BackgroundTransparency = 1 },
			{
				UIListLayout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				Labels = Roact.createFragment(statLabels)
			}
		),
		GraphsContainer = Roact.createElement(
			"Frame",
			{ LayoutOrder = 2, Size = UDim2.new(1, 0, 0, v7), BackgroundTransparency = 1 },
			{
				UIListLayout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, MainRowPadding)
				}),
				Graphs = Roact.createFragment(graphs)
			}
		),
		ConnectivityContainer = Roact.createElement(MainViewConnectivityPanel, {
			connectivity = self.state.connectivity,
			layoutOrder = 3
		})
	})
	return createElement("Frame", { Size = size, BackgroundTransparency = 1, LayoutOrder = 3 }, children)
end

return DataConsumer(extended, "VoiceDebugData")
