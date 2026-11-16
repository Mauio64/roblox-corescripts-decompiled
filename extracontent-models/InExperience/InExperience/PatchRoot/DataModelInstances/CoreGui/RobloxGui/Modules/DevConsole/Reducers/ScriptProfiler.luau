local Immutable = require(script.Parent.Parent.Immutable)

local SetScriptProfilerState = require(script.Parent.Parent.Actions.SetScriptProfilerState)
local SetScriptProfilerRoot = require(script.Parent.Parent.Actions.SetScriptProfilerRoot)
local SetIsProfiling = require(script.Parent.Parent.Components.ScriptProfiler.Actions.SetIsProfiling)
local SetData = require(script.Parent.Parent.Components.ScriptProfiler.Actions.SetData)
local SetThreads = require(script.Parent.Parent.Components.ScriptProfiler.Actions.SetThreads)
local SetTimerState = require(script.Parent.Parent.Components.ScriptProfiler.Actions.SetTimerState)

local ClearStateForNewProfilingSession = require(script.Parent.Parent.Components.ScriptProfiler.Actions.ClearStateForNewProfilingSession)
local SetAverage = require(script.Parent.Parent.Components.ScriptProfiler.Actions.SetAverage)
local SetFrequency = require(script.Parent.Parent.Components.ScriptProfiler.Actions.SetFrequency)
local SetDataView = require(script.Parent.Parent.Components.ScriptProfiler.Actions.SetDataView)
local SetLiveUpdate = require(script.Parent.Parent.Components.ScriptProfiler.Actions.SetLiveUpdate)
local SetShowPlugins = require(script.Parent.Parent.Components.ScriptProfiler.Actions.SetShowPlugins)
local SetShowGC = require(script.Parent.Parent.Components.ScriptProfiler.Actions.SetShowGC)
local SetSearchData = require(script.Parent.Parent.Components.ScriptProfiler.Actions.SetSearchData)
require(script.Parent.Parent.Components.ScriptProfiler.ProfilerDataFormatV2)

local function GetSessionState(p, p2) -- 4 equivalent calls inferred from this helper
	return if p then p2.client else p2.server
end

local function Update(isClient, p, p2)
	local sessionState = GetSessionState(isClient, p) -- inferred equivalent call
	local joinDictionaries = Immutable.JoinDictionaries(sessionState, p2)
	local client

	if isClient then
		client = joinDictionaries
	end

	if isClient then
		joinDictionaries = nil
	end

	return Immutable.JoinDictionaries(p, { client = client, server = joinDictionaries })
end

return function(p, data)
	local v = p or {
		isClientView = true,
		usePercentages = false,
		isExporting = false,
		isShowingMobileSettings = false,
		client = {
			isProfiling = false,
			data = nil,
			serializedData = nil,
			frequency = 1000,
			timedProfilingThread = nil,
			timedProfilingTimerThread = nil,
			timedProfilingDuration = 0,
			timedProfilingCountdown = 0,
			isFunctionsView = false,
			average = 0,
			searchTerm = "",
			searchFilterGraph = {},
			searchFilterFlat = {},
			rootNode = 0,
			rootFunc = 0,
			rootNodeName = nil,
			liveUpdate = false,
			liveUpdateThread = nil,
			showPlugins = false,
			pluginOffsets = {},
			showGC = false,
			gcFunctionOffsets = {},
			gcNodeOffsets = {},
			pluginGCOffsets = {},
			expandedNodes = {}
		},
		server = {
			isProfiling = false,
			data = nil,
			serializedData = nil,
			frequency = 1000,
			timedProfilingThread = nil,
			timedProfilingTimerThread = nil,
			timedProfilingDuration = 0,
			timedProfilingCountdown = 0,
			isFunctionsView = false,
			average = 0,
			searchTerm = "",
			searchFilterGraph = {},
			searchFilterFlat = {},
			rootNode = 0,
			rootFunc = 0,
			rootNodeName = nil,
			liveUpdate = false,
			liveUpdateThread = nil,
			showPlugins = false,
			pluginOffsets = {},
			showGC = false,
			gcFunctionOffsets = {},
			gcNodeOffsets = {},
			pluginGCOffsets = {},
			expandedNodes = {}
		}
	}

	if data.type == SetScriptProfilerState.name then
		local v2 = {
			isClientView = data.isClientView,
			usePercentages = data.usePercentages,
			isExporting = data.isExporting,
			isShowingMobileSettings = data.isShowingMobileSettings,
			client = data.clientSessionState,
			server = data.serverSessionState
		}

		return (Immutable.JoinDictionaries(v, v2))
	end

	if data.type == SetIsProfiling.name then
		return Update(data.isClient, v, { isProfiling = data.isProfiling })
	end

	if data.type == SetAverage.name then
		return Update(data.isClient, v, { average = data.average })
	end

	if data.type == SetFrequency.name then
		return Update(data.isClient, v, { frequency = data.frequency })
	end

	if data.type == SetDataView.name then
		return Update(data.isClient, v, { isFunctionsView = data.isFunctionsView })
	end

	if data.type == SetLiveUpdate.name then
		return Update(data.isClient, v, { liveUpdate = data.liveUpdate })
	end

	if data.type == SetShowPlugins.name then
		return Update(data.isClient, v, { showPlugins = data.showPlugins })
	end

	if data.type == SetShowGC.name then
		return Update(data.isClient, v, { showGC = data.showGC })
	end

	if data.type == SetSearchData.name then
		return Update(data.isClient, v, {
			searchTerm = data.state.searchTerm,
			searchFilterFlat = data.state.searchFilterFlat,
			searchFilterGraph = data.state.searchFilterGraph
		})
	end

	if data.type == SetTimerState.name then
		local v2 = {
			timedProfilingDuration = data.state.timedProfilingDuration,
			timedProfilingCountdown = data.state.timedProfilingCountdown
		}

		return Update(data.isClient, v, v2)
	end

	if data.type == SetData.name then
		local clone = table.clone(GetSessionState(data.isClient, v)) -- inferred equivalent call

		clone.data = data.state.data
		clone.serializedData = data.state.serializedData
		clone.pluginOffsets = data.state.pluginOffsets or {}
		clone.pluginGCOffsets = data.state.pluginGCOffsets or {}
		clone.gcFunctionOffsets = data.state.gcFunctionOffsets or {}
		clone.gcNodeOffsets = data.state.gcNodeOffsets or {}
		clone.expandedNodes = data.state.expandedNodes or {}

		local clone2 = table.clone(v)

		if data.isClient then
			clone2.client = clone
		else
			clone2.server = clone
		end

		return Immutable.JoinDictionaries(v, clone2)
	elseif data.type == SetThreads.name then
		local clone = table.clone(GetSessionState(data.isClient, v)) -- inferred equivalent call

		clone.timedProfilingThread = data.state.timedProfilingThread
		clone.timedProfilingTimerThread = data.state.timedProfilingTimerThread
		clone.liveUpdateThread = data.state.liveUpdateThread

		local clone2 = table.clone(v)

		if data.isClient then
			clone2.client = clone
		else
			clone2.server = clone
		end

		return Immutable.JoinDictionaries(v, clone2)
	elseif data.type == ClearStateForNewProfilingSession.name then
		local clone = table.clone(GetSessionState(data.isClient, v)) -- inferred equivalent call

		clone.rootNode = 0
		clone.rootFunc = 0
		clone.rootNodeName = nil
		clone.searchFilterFlat = {}
		clone.searchFilterGraph = {}
		clone.expandedNodes = {}

		local clone2 = table.clone(v)

		if data.isClient then
			clone2.client = clone
		else
			clone2.server = clone
		end

		return Immutable.JoinDictionaries(v, clone2)
	else
		if data.type ~= SetScriptProfilerRoot.name then
			return v
		end

		local v2 = {}

		local v3 = if v.isClientView then v.client else v.server
		local clone = table.clone(v3)

		if clone.rootNode == data.rootNode then
			clone.rootNode = 0
			clone.rootFunc = 0
			clone.rootNodeName = nil
		else
			clone.rootNode = data.rootNode
			clone.rootFunc = data.rootFunc
			clone.rootNodeName = data.rootNodeName
		end

		if v.isClientView then
			v2.client = clone
		else
			v2.server = clone
		end

		return Immutable.JoinDictionaries(v, v2)
	end
end
