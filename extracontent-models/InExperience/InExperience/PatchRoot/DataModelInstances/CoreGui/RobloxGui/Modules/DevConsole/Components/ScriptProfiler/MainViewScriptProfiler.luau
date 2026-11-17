local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local ScriptProfilerService = game:GetService("ScriptProfilerService")
local Players = game:GetService("Players")

local Immutable = require(script.Parent.Parent.Parent.Immutable)

local Components = script.Parent.Parent.Parent.Components
local UtilAndTab = require(Components.UtilAndTab)
local BoxButton = require(Components.BoxButton)
local DropDown = require(Components.DropDown)
local ProfilerView = require(script.Parent.ProfilerView)
local ProfilerFunctionsView = require(script.Parent.ProfilerFunctionsView)
require(script.Parent.ProfilerDataFormatV2)
local ProfilerExportView = require(script.Parent.ProfilerExportView)
local MobileSettingsView = require(script.Parent.MobileSettingsView)

local ProfilerUtil = require(script.Parent.ProfilerUtil)
local getPluginFlag = ProfilerUtil.getPluginFlag
local getDurations = ProfilerUtil.getDurations
local formatFrequency = ProfilerUtil.formatFrequency

local Actions = script.Parent.Parent.Parent.Actions
local SetScriptProfilerState = require(Actions.SetScriptProfilerState)
local SetIsProfiling = require(script.Parent.Actions.SetIsProfiling)
local SetData = require(script.Parent.Actions.SetData)
local SetThreads = require(script.Parent.Actions.SetThreads)
local SetTimerState = require(script.Parent.Actions.SetTimerState)
local ClearStateForNewProfilingSession = require(script.Parent.Actions.ClearStateForNewProfilingSession)
local SetAverage = require(script.Parent.Actions.SetAverage)
local SetFrequency = require(script.Parent.Actions.SetFrequency)
local SetDataView = require(script.Parent.Actions.SetDataView)
local SetLiveUpdate = require(script.Parent.Actions.SetLiveUpdate)
local SetShowPlugins = require(script.Parent.Actions.SetShowPlugins)
local SetShowGC = require(script.Parent.Actions.SetShowGC)
local SetSearchData = require(script.Parent.Actions.SetSearchData)

local Constants = require(script.Parent.Parent.Parent.Constants)
local MainRowPadding = Constants.GeneralFormatting.MainRowPadding
local SmallFrameHeight = Constants.UtilityBarFormatting.SmallFrameHeight

local MainWindowHeader = Constants.Font.MainWindowHeader
local mainWindowHeader = Constants.DefaultFontSize.MainWindowHeader
local Text = Constants.Color.Text
local UnselectedGray = Constants.Color.UnselectedGray

local extended = Roact.PureComponent:extend("MainViewScriptProfiler")

local defineFastFlag = game:DefineFastFlag("ScriptProfilerShowPlugins2", false)

local defineFastInt = game:DefineFastInt("ScriptProfilerLiveUpdateIntervalMS", 1000)

local dropDownList = { "Callgraph", "Functions" }
local function annotateSearchFilterNodes(data, result, result2, k: number, child: number, flag: boolean)
	local node = data.Nodes[child]

	if node.Children then
		local children = node.Children

		local v = false

		if k > 0 and result[k] then
			result2[child] = true

			for k2, child2 in pairs(children) do
				result2[child2] = true

				annotateSearchFilterNodes(data, result, result2, k2, child2, true)
			end

			return true
		end

		for k2, child2 in pairs(children) do
			local v2 = annotateSearchFilterNodes(data, result, result2, k2, child2, flag)
			v = v or v2
		end

		if v or flag then
			result2[child] = true
		end

		return v
	end

	flag = k > 0 and result[k] or flag
	result2[child] = flag
	return k > 0 and result[k]
end

local function generateSearchFilters(p, p2: string)
	if p2 == "" then
		return nil, nil
	end

	local data = p.data

	if not data then
		return nil, nil
	end

	local result = table.create(#data.Functions, false)

	for k, v in data.Functions do
		local name = ProfilerUtil.getName(data, v)

		if name and string.find(name, p2, 1, true) then
			result[k] = true
		end
	end

	local result2 = table.create(#data.Nodes, false)

	for _, category in data.Categories do
		local nodeId = category.NodeId
		local node = data.Nodes[nodeId]

		if node.Children then
			local children = node.Children
			local v = false

			for k, child in pairs(children) do
				local v2 = annotateSearchFilterNodes(data, result, result2, k, child, false)
				v = v or v2
			end

			if v then
				result2[nodeId] = true
			end
		else
			result2[nodeId] = false
		end
	end

	for k, v in data.Functions do
		if result[k] == true or ProfilerUtil.getName(data, v) then
			continue
		end

		local sourceName = ProfilerUtil.getSourceName(data, v)

		if sourceName and string.find(sourceName, p2, 1, true) then
			result[k] = true
		end
	end

	return result, result2
end

local function generatePluginDurationOffsets(gcNodeOffsets, data)
	if not data then
		return {}, {}
	end

	assert(data.Version == 2)

	local result = table.create(#data.Categories, 0)
	local result2 = table.create(#data.Categories, 0)
	local total = 0
	local total2 = 0

	for k, category in data.Categories do
		local total3 = 0
		local total4 = 0
		local children = data.Nodes[category.NodeId].Children

		if children then
			for k2, child in pairs(children) do
				local _ = data.Functions[k2]

				if not getPluginFlag(data, data.Functions[k2]) then
					continue
				end

				total3 += getDurations(data, child)

				if #gcNodeOffsets > 0 then
					total4 += gcNodeOffsets[child]
				end
			end
		end

		result[k] = total3
		result2[k] = total4
		total += total3
		total2 += total4
	end

	result.Total = total
	result2.Total = total
	return result, result2
end

local function getGCOverhead(p, gcOverheadsByNodeId, data, nodeId, gcFuncId)
	local node = data.Nodes[nodeId]
	local gcOverhead = 0

	if not node.Children then
		return gcOverhead
	end

	for k, child in pairs(node.Children) do
		local v

		if k == gcFuncId then
			v = data.Nodes[child].TotalDuration
		else
			v = getGCOverhead(p, gcOverheadsByNodeId, data, child, gcFuncId)
		end

		p[k] += v
		gcOverheadsByNodeId[child] = v
		gcOverhead += v
	end

	return gcOverhead
end

local function generateGCOverheadOffsets(data)
	if not (data and data.GCFuncId) then
		return {}, {}
	end

	local gcFuncId = data.GCFuncId

	local v = table.create(#data.Functions, 0)
	local gcOverheadsByNodeId = table.create(#data.Nodes, 0)
	local total = 0

	for _, category in data.Categories do
		local nodeId = category.NodeId

		local gcOverhead = getGCOverhead(v, gcOverheadsByNodeId, data, nodeId, gcFuncId)
		total += gcOverhead

		gcOverheadsByNodeId[nodeId] = gcOverhead
	end

	gcOverheadsByNodeId.Total = total

	return v, gcOverheadsByNodeId
end

function extended:getActiveState()
	local isClientView = self.props.isClientView

	if self.props.isClientView then
		return isClientView, self.props.client
	end

	return isClientView, self.props.server
end

function extended:getState(p)
	return if p then self.props.client else self.props.server
end

function extended.UpdateState(p, p2, p3)
	if p2 then
		p.props.dispatchSetScriptProfilerState(nil, nil, p3, nil)
	else
		p.props.dispatchSetScriptProfilerState(nil, nil, nil, p3)
	end
end

local function OnNewProfilingData(state, state2, serializedData: string?)
	state.serializedData = serializedData
	state.data = ScriptProfilerService:DeserializeJSON(serializedData)

	local gcFunctionOffsets, gcNodeOffsets = generateGCOverheadOffsets(state.data)
	state.gcFunctionOffsets = gcFunctionOffsets
	state.gcNodeOffsets = gcNodeOffsets

	if defineFastFlag then
		local pluginOffsets, pluginGCOffsets = generatePluginDurationOffsets(state.gcNodeOffsets, state.data)
		state.pluginOffsets = pluginOffsets
		state.pluginGCOffsets = pluginGCOffsets
	end

	local v = state.data and #state.data.Nodes or 0
	local v2 = state2.data and #state2.data.Nodes or 0
	local expandedNodes2 = table.create(v, false)
	local expandedNodes = state2.expandedNodes
	table.move(expandedNodes, 1, v2, 1, expandedNodes2)
	state.expandedNodes = expandedNodes2
end

function extended:init()
	local function StartScriptProfiling(p, p2) -- 1 equivalent call inferred from this helper
		if p then
			ScriptProfilerService:ClientStart(Players.LocalPlayer, p2.frequency)
		else
			ScriptProfilerService:ServerStart(p2.frequency)
		end
	end

	local function StopScriptProfiling(p): nil -- 2 equivalent calls inferred from this helper
		if p then
			ScriptProfilerService:ClientStop(Players.LocalPlayer)
		else
			ScriptProfilerService:ServerStop()
		end

		return nil
	end

	local function RequestNewData(p) -- 3 equivalent calls inferred from this helper
		if p then
			ScriptProfilerService:ClientRequestData(Players.LocalPlayer)
		else
			ScriptProfilerService:ServerRequestData()
		end
	end

	local function StopTimedProfiling(activeState) -- 1 equivalent call inferred from this helper
		if self:getState(activeState).isProfiling then
			StopScriptProfiling(activeState) -- inferred equivalent call
			self.props.dispatchSetIsProfiling(activeState, false)

			if activeState then
				RequestNewData(true) -- inferred equivalent call
			else
				ScriptProfilerService:ServerRequestData()
			end
		end
	end

	function self.onUtilTabHeightChanged(utilTabHeight)
		self:setState({ utilTabHeight = utilTabHeight })
	end

	local function UpdateTimedProfilingTimer(activeState)
		while task.wait(0.5) do
			local timedProfilingCountdown = self:getState(activeState).timedProfilingCountdown

			if timedProfilingCountdown <= 0 then
				break
			end

			self.props.dispatchSetTimer(activeState, {
				timedProfilingCountdown = timedProfilingCountdown - 0.5
			})
		end
	end

	local function LiveUpdate(p)
		while task.wait(defineFastInt / 1000) do
			if self:getState(p).liveUpdate then
				RequestNewData(p) -- inferred equivalent call
			end
		end
	end

	function self.onBeginProfile()
		local activeState, v = self:getActiveState()

		if activeState then
			ScriptProfilerService:ClientStart(Players.LocalPlayer, v.frequency)
		else
			StartScriptProfiling(false, v) -- inferred equivalent call
		end

		self.props.dispatchSetIsProfiling(activeState, true)
		self.props.dispatchClearStateForNewSession(activeState)

		local v2 = {}

		if v.timedProfilingDuration > 0 then
			self.props.dispatchSetTimer(activeState, {
				timedProfilingCountdown = v.timedProfilingDuration
			})

			v2.timedProfilingThread = task.delay(v.timedProfilingDuration, function()
				StopTimedProfiling(activeState) -- inferred equivalent call
			end)

			v2.timedProfilingTimerThread = task.spawn(function()
				UpdateTimedProfilingTimer(activeState)
			end)
		end

		v2.liveUpdateThread = task.spawn(LiveUpdate, activeState)

		self.props.dispatchSetThreads(activeState, v2)
	end

	function self.onEndProfile()
		local activeState, v = self:getActiveState()
		StopScriptProfiling(activeState) -- inferred equivalent call
		local v2 = {}

		if v.timedProfilingThread then
			task.cancel(v.timedProfilingThread)
			v2.timedProfilingThread = nil
		end

		if v.timedProfilingTimerThread then
			task.cancel(v.timedProfilingTimerThread)
			v2.timedProfilingTimerThread = nil
		end

		if v.liveUpdateThread then
			task.cancel(v.liveUpdateThread)
			v2.liveUpdateThread = nil
		end

		self.props.dispatchSetThreads(activeState, {})
		self.props.dispatchSetIsProfiling(activeState, false)
		RequestNewData(activeState) -- inferred equivalent call
	end

	function self.toggleTimedProfiling()
		local activeState, v = self:getActiveState()

		local timedProfilingDuration = v.timedProfilingDuration
		local timedProfilingDuration2

		if timedProfilingDuration == 0 then
			timedProfilingDuration2 = 60
		elseif timedProfilingDuration == 60 then
			timedProfilingDuration2 = 300
		elseif timedProfilingDuration == 300 then
			timedProfilingDuration2 = 600
		else
			timedProfilingDuration2 = 0
		end

		self.props.dispatchSetTimer(activeState, {
			timedProfilingDuration = timedProfilingDuration2
		})
	end

	function self.toggleAverage()
		local activeState, v = self:getActiveState()

		local average = v.average
		local v2

		if average == 0 then
			v2 = 1
		elseif average == 1 then
			v2 = 60
		elseif average == 60 then
			v2 = 300
		else
			v2 = if average == 300 then 600 else 0
		end

		self.props.dispatchSetAverage(activeState, v2)
	end

	function self.toggleUnits()
		self.props.dispatchSetScriptProfilerState(nil, not self.props.usePercentages, nil, nil)
	end

	function self.toggleFrequency()
		local activeState, v = self:getActiveState()

		local v2 = v.frequency == 1000 and 10000 or 1000

		self.props.dispatchSetFrequency(activeState, v2)
	end

	function self.onClientButton()
		self.props.dispatchSetScriptProfilerState(true)
	end

	function self.onServerButton()
		self.props.dispatchSetScriptProfilerState(false)
	end

	function self.dataViewDropDownCallback(p)
		local activeState, v = self:getActiveState()

		local isFunctionsView = v.isFunctionsView

		local v2 = p ~= 1 and (p == 2 or isFunctionsView)

		self.props.dispatchSetDataView(activeState, v2)
	end

	function self.onCheckboxChanged(p, p2)
		local isClientView = self.props.isClientView

		if p == "Live" then
			self.props.dispatchSetLiveUpdate(isClientView, p2)
		elseif p == "Plugins" then
			self.props.dispatchSetShowPlugins(isClientView, p2)
		elseif p == "GC" then
			self.props.dispatchSetShowGC(isClientView, p2)
		end
	end

	function self.onSearchTermChanged(searchTerm)
		local activeState, v = self:getActiveState()

		local v2, v3 = generateSearchFilters(v, searchTerm)

		self.props.dispatchSetSearchData(activeState, {
			searchTerm = searchTerm,
			searchFilterFlat = v2 or {},
			searchFilterGraph = v3 or {}
		})
	end

	self.utilRef = Roact.createRef()

	self.state = { utilTabHeight = 0 }
end

function extended:didMount()
	self:setState({ utilTabHeight = self.utilRef.current.Size.Y.Offset })

	self.scriptProfilerConnection = ScriptProfilerService.OnNewData:Connect(function(p, serializedData)
		local v = p ~= nil
		local v2 = {}
		OnNewProfilingData(v2, self:getState(v), serializedData)

		self.props.dispatchSetData(v, v2)
	end)
end

function extended:willUnmount()
	self.scriptProfilerConnection:Disconnect()
	self.scriptProfilerConnection = nil
end

function extended.didUpdate(object)
	local size = object.utilRef.current.Size

	if size.Y.Offset ~= object.state.utilTabHeight then
		object:setState({ utilTabHeight = size.Y.Offset })
	end
end

local function formatTimer(p: number?) -- 2 equivalent calls inferred from this helper
	local formatTimer2 = ProfilerUtil.formatTimer(p)

	if formatTimer2 == "" then
		return ""
	end

	return ": " .. formatTimer2
end

function extended:renderUtilButtons(props, p, p2)
	local isProfiling = props.isProfiling

	local utilButtons = {}

	table.insert(utilButtons, Roact.createElement(BoxButton, {
		text = isProfiling and "Stop" or "Start",
		onClicked = isProfiling and self.onEndProfile or self.onBeginProfile
	}))

	if not p2 then
		table.insert(utilButtons, Roact.createElement(BoxButton, {
			text = self.props.usePercentages and "Unit: %" or "Unit: ms",
			onClicked = self.toggleUnits
		}))
	end

	if not p2 then
		local createElement = Roact.createElement
		local v = {
			["Text"] = "Freq: " .. formatFrequency(props.frequency),
			TextSize = mainWindowHeader,
			TextColor3 = Text,
			Font = MainWindowHeader,
			AutoButtonColor = true
		}
		local backgroundColor

		if isProfiling then
			backgroundColor = Constants.Color.InactiveBox
		else
			backgroundColor = UnselectedGray
		end

		v.BackgroundColor3 = backgroundColor
		v.BackgroundTransparency = 0

		v[Roact.Event.Activated] = function()
			if not isProfiling then
				self.toggleFrequency()
			end
		end

		table.insert(utilButtons, createElement("TextButton", v))
	end

	if not p2 then
		local createElement = Roact.createElement
		local v

		if isProfiling then
			v = props.timedProfilingCountdown
		else
			v = props.timedProfilingDuration
		end

		local v2 = {
			["Text"] = "Time" .. formatTimer(v), -- inferred equivalent call
			TextSize = mainWindowHeader,
			TextColor3 = Text,
			Font = MainWindowHeader,
			AutoButtonColor = true
		}
		local backgroundColor

		if isProfiling then
			backgroundColor = Constants.Color.InactiveBox
		else
			backgroundColor = UnselectedGray
		end

		v2.BackgroundColor3 = backgroundColor
		v2.BackgroundTransparency = 0

		v2[Roact.Event.Activated] = function()
			if not isProfiling then
				self.toggleTimedProfiling()
			end
		end

		table.insert(utilButtons, createElement("TextButton", v2))
	end

	if not p2 then
		local createElement = Roact.createElement
		local v = {
			["Text"] = "Average" .. formatTimer(props.average), -- inferred equivalent call
			TextSize = mainWindowHeader,
			TextColor3 = Text,
			Font = MainWindowHeader,
			AutoButtonColor = true
		}
		local backgroundColor

		if isProfiling then
			backgroundColor = Constants.Color.InactiveBox
		else
			backgroundColor = UnselectedGray
		end

		v.BackgroundColor3 = backgroundColor
		v.BackgroundTransparency = 0

		v[Roact.Event.Activated] = function()
			if not isProfiling then
				self.toggleAverage()
			end
		end

		table.insert(utilButtons, createElement("TextButton", v))
	end

	if not p2 then
		table.insert(
			utilButtons,
			Roact.createElement(BoxButton, {
				text = "Export",
				onClicked = self.props.dispatchStartExport
			})
		)
	end

	if not p2 then
		table.insert(utilButtons, Roact.createElement(DropDown, {
			buttonSize = UDim2.new(0, 100, 0, SmallFrameHeight),
			dropDownList = dropDownList,
			selectedIndex = props.isFunctionsView and 2 or 1,
			onSelection = self.dataViewDropDownCallback
		}))
	end

	if p then
		table.insert(utilButtons, Roact.createElement(BoxButton, {
			text = "More...",
			onClicked = function()
				self.props.dispatchShowMobileSettings()
			end
		}))
	end

	return utilButtons
end

function extended:renderUtilAndTab(p, p2)
	local size = self.props.size
	local formFactor = self.props.formFactor
	local tabList = self.props.tabList

	return Roact.createElement(UtilAndTab, Immutable.JoinDictionaries({
		windowWidth = size.X.Offset,
		formFactor = formFactor,
		tabList = tabList,
		layoutOrder = 1,
		refForParent = self.utilRef,
		onHeightChanged = self.onUtilTabHeightChanged
	}, p), p2)
end

function extended:renderExportView()
	local size = self.props.size
	local utilTabHeight = self.state.utilTabHeight

	return Roact.createElement(
		"Frame",
		{
			Size = size,
			BackgroundColor3 = Constants.Color.BaseGray,
			BackgroundTransparency = 1,
			LayoutOrder = 3
		},
		{
			UIListLayout = Roact.createElement("UIListLayout", {
				Padding = UDim.new(0, MainRowPadding),
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			UtilAndTab = self:renderUtilAndTab({}, {
				Roact.createElement(BoxButton, {
					text = "Exit",
					onClicked = self.props.dispatchFinishedExporting
				})
			}),
			ExportView = Roact.createElement(ProfilerExportView, {
				size = UDim2.new(1, 0, 1, -utilTabHeight)
			})
		}
	)
end

function extended:renderMobileSettingsUI()
	local size = self.props.size
	local utilTabHeight = self.state.utilTabHeight

	return Roact.createElement(
		"Frame",
		{
			Size = size,
			BackgroundColor3 = Constants.Color.BaseGray,
			BackgroundTransparency = 1,
			LayoutOrder = 3
		},
		{
			UIListLayout = Roact.createElement("UIListLayout", {
				Padding = UDim.new(0, MainRowPadding),
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			UtilAndTab = self:renderUtilAndTab({}, {
				Roact.createElement(BoxButton, {
					text = "Export",
					onClicked = self.props.dispatchStartExport
				}),
				Roact.createElement(BoxButton, {
					text = "Exit",
					onClicked = self.props.dispatchHideMobileSettings
				})
			}),
			MobileSettingsView = Roact.createElement(MobileSettingsView, {
				size = UDim2.new(1, 0, 1, -utilTabHeight)
			})
		}
	)
end

function extended:renderProfilerView(isClientView, props, p, orderedCheckboxState)
	local isProfiling = props.isProfiling
	local data = props.data
	local usePercentages = self.props.usePercentages
	local isFunctionsView = props.isFunctionsView
	local rootNode = props.rootNode
	local rootNodeName = props.rootNodeName
	local rootFunc = props.rootFunc

	local size = self.props.size
	local utilTabHeight = self.state.utilTabHeight
	local sessionLength

	if data and data.SessionStartTime and data.SessionEndTime then
		sessionLength = data.SessionEndTime - data.SessionStartTime
	end

	local createElement = Roact.createElement
	local v = {
		Size = size,
		BackgroundColor3 = Constants.Color.BaseGray,
		BackgroundTransparency = 1,
		LayoutOrder = 3
	}

	local v2 = {
		UIListLayout = Roact.createElement("UIListLayout", {
			Padding = UDim.new(0, MainRowPadding),
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		UtilAndTab = self:renderUtilAndTab({
			isClientView = isClientView,
			onClientButton = self.onClientButton,
			onServerButton = self.onServerButton,
			orderedCheckboxState = orderedCheckboxState,
			onCheckboxChanged = self.onCheckboxChanged,
			onSearchTermChanged = self.onSearchTermChanged,
			searchTerm = props.searchTerm
		}, p),
		ProfilerView = 0
	}

	local createElement2 = Roact.createElement
	local v3

	if isFunctionsView then
		v3 = ProfilerFunctionsView
	else
		v3 = ProfilerView
	end

	local v4 = {
		size = UDim2.new(1, 0, 1, -utilTabHeight),
		searchFilter = 0,
		layoutOrder = 2,
		data = 0,
		profiling = 0,
		showAsPercentages = 0,
		sessionLength = 0,
		rootNode = 0,
		rootFunc = 0,
		rootNodeName = 0,
		average = 0,
		showPlugins = 0,
		pluginOffsets = 0,
		showGC = 0,
		gcFunctionOffsets = 0,
		gcNodeOffsets = 0,
		pluginGCOffsets = 0,
		expandedNodes = 0
	}
	local searchFilter

	if isFunctionsView then
		searchFilter = props.searchFilterFlat
	else
		searchFilter = props.searchFilterGraph
	end

	v4.searchFilter = searchFilter

	v4.data = data
	v4.profiling = isProfiling
	v4.showAsPercentages = usePercentages
	v4.sessionLength = sessionLength
	v4.rootNode = rootNode
	v4.rootFunc = rootFunc
	v4.rootNodeName = rootNodeName
	v4.average = props.average
	v4.showPlugins = props.showPlugins or not defineFastFlag
	v4.pluginOffsets = props.pluginOffsets
	v4.showGC = props.showGC
	v4.gcFunctionOffsets = props.gcFunctionOffsets
	v4.gcNodeOffsets = props.gcNodeOffsets
	v4.pluginGCOffsets = props.pluginGCOffsets
	local expandedNodes

	if not isFunctionsView then
		expandedNodes = props.expandedNodes
	end

	v4.expandedNodes = expandedNodes
	v2.ProfilerView = createElement2(v3, v4)
	return createElement("Frame", v, v2)
end

function extended:render()
	if self.props.isExporting then
		return self:renderExportView()
	end

	if self.props.isShowingMobileSettings then
		return self:renderMobileSettingsUI()
	end

	local formFactor = self.props.formFactor

	local activeState, v = self:getActiveState()

	local v2 = {}
	local v3 = 1

	local v4 = formFactor == Constants.FormFactor.Small

	if not v4 then
		v2[1] = { name = "Live", state = v.liveUpdate }

		if defineFastFlag then
			v3 += 1
			v2[v3] = { name = "Plugins", state = v.showPlugins }
		end

		v2[v3 + 1] = { name = "GC", state = v.showGC }
	end

	return self:renderProfilerView(activeState, v, self:renderUtilButtons(v, v4, v4), v2)
end

local function mapStateToProps(p, _)
	return {
		isClientView = p.ScriptProfiler.isClientView,
		usePercentages = p.ScriptProfiler.usePercentages,
		isExporting = p.ScriptProfiler.isExporting,
		isShowingMobileSettings = p.ScriptProfiler.isShowingMobileSettings,
		client = p.ScriptProfiler.client,
		server = p.ScriptProfiler.server
	}
end

local function mapDispatchToProps(callback)
	return {
		dispatchSetScriptProfilerState = function(p, p2, p3, p4)
			callback(SetScriptProfilerState(p, p2, p3, p4))
		end,
		dispatchSetIsProfiling = function(p, p2)
			callback(SetIsProfiling(p, p2))
		end,
		dispatchSetData = function(p, p2)
			callback(SetData(p, p2))
		end,
		dispatchSetThreads = function(p, p2)
			callback(SetThreads(p, p2))
		end,
		dispatchSetTimer = function(p, p2)
			callback(SetTimerState(p, p2))
		end,
		dispatchClearStateForNewSession = function(p)
			callback(ClearStateForNewProfilingSession(p))
		end,
		dispatchSetAverage = function(p, p2)
			callback(SetAverage(p, p2))
		end,
		dispatchSetFrequency = function(p, p2)
			callback(SetFrequency(p, p2))
		end,
		dispatchSetDataView = function(p, p2)
			callback(SetDataView(p, p2))
		end,
		dispatchSetLiveUpdate = function(p, p2)
			callback(SetLiveUpdate(p, p2))
		end,
		dispatchSetShowPlugins = function(p, p2)
			callback(SetShowPlugins(p, p2))
		end,
		dispatchSetShowGC = function(p, p2)
			callback(SetShowGC(p, p2))
		end,
		dispatchSetSearchData = function(p, p2)
			callback(SetSearchData(p, p2))
		end,
		dispatchStartExport = function()
			callback(SetScriptProfilerState(nil, nil, nil, nil, true))
		end,
		dispatchFinishedExporting = function()
			callback(SetScriptProfilerState(nil, nil, nil, nil, false))
		end,
		dispatchShowMobileSettings = function()
			callback(SetScriptProfilerState(nil, nil, nil, nil, nil, true))
		end,
		dispatchHideMobileSettings = function()
			callback(SetScriptProfilerState(nil, nil, nil, nil, nil, false))
		end
	}
end

return RoactRodux.UNSTABLE_connect2(mapStateToProps, mapDispatchToProps)(extended)
