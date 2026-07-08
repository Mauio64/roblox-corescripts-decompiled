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

local function GetSessionState(p1, p2) -- line: 68
	if p1 then
		return p2.client
	end

	return p2.server
end
local function Update(p3, t1: {[any]: any}, t2: {[any]: any}) -- line: 72
	-- upvalues: Immutable (copy)
	local v23 = if not p3 then t1.server else t1.client
	local v24 = Immutable.JoinDictionaries(v23, t2)
	local t3 = {
		client = if not p3 then nil else v24,
		server = if not p3 then v24 else nil
	}

	return Immutable.JoinDictionaries(t1, t3)
end

return function(t4: {[any]: any}?, t5: {[any]: any}) -- line: 85
	-- upvalues: SetScriptProfilerState (copy), Immutable (copy), SetIsProfiling (copy), Update (copy), SetAverage (copy), SetFrequency (copy), SetDataView (copy), SetLiveUpdate (copy), SetShowPlugins (copy), SetShowGC (copy), SetSearchData (copy), SetTimerState (copy), SetData (copy), SetThreads (copy), ClearStateForNewProfilingSession (copy), SetScriptProfilerRoot (copy)
	local v28 = t4 or {
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
			rootNode = 0,
			rootFunc = 0,
			rootNodeName = nil,
			liveUpdate = false,
			liveUpdateThread = nil,
			showPlugins = false,
			showGC = false,
			searchFilterGraph = {},
			searchFilterFlat = {},
			pluginOffsets = {},
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
			rootNode = 0,
			rootFunc = 0,
			rootNodeName = nil,
			liveUpdate = false,
			liveUpdateThread = nil,
			showPlugins = false,
			showGC = false,
			searchFilterGraph = {},
			searchFilterFlat = {},
			pluginOffsets = {},
			gcFunctionOffsets = {},
			gcNodeOffsets = {},
			pluginGCOffsets = {},
			expandedNodes = {}
		}
	}

	if t5.type == SetScriptProfilerState.name then
		local t6 = {
			isClientView = t5.isClientView,
			usePercentages = t5.usePercentages,
			isExporting = t5.isExporting,
			isShowingMobileSettings = t5.isShowingMobileSettings,
			client = t5.clientSessionState,
			server = t5.serverSessionState
		}

		return (Immutable.JoinDictionaries(v28, t6))
	end

	if t5.type == SetIsProfiling.name then
		return Update(t5.isClient, v28, {
			isProfiling = t5.isProfiling
		})
	end

	if t5.type == SetAverage.name then
		return Update(t5.isClient, v28, {
			average = t5.average
		})
	end

	if t5.type == SetFrequency.name then
		return Update(t5.isClient, v28, {
			frequency = t5.frequency
		})
	end

	if t5.type == SetDataView.name then
		return Update(t5.isClient, v28, {
			isFunctionsView = t5.isFunctionsView
		})
	end

	if t5.type == SetLiveUpdate.name then
		return Update(t5.isClient, v28, {
			liveUpdate = t5.liveUpdate
		})
	end

	if t5.type == SetShowPlugins.name then
		return Update(t5.isClient, v28, {
			showPlugins = t5.showPlugins
		})
	end

	if t5.type == SetShowGC.name then
		return Update(t5.isClient, v28, {
			showGC = t5.showGC
		})
	end

	if t5.type == SetSearchData.name then
		return Update(t5.isClient, v28, {
			searchTerm = t5.state.searchTerm,
			searchFilterFlat = t5.state.searchFilterFlat,
			searchFilterGraph = t5.state.searchFilterGraph
		})
	end

	if t5.type == SetTimerState.name then
		local t7 = {
			timedProfilingDuration = t5.state.timedProfilingDuration,
			timedProfilingCountdown = t5.state.timedProfilingCountdown
		}

		return Update(t5.isClient, v28, t7)
	end

	if t5.type == SetData.name then
		local v31 = table.clone(if not t5.isClient then v28.server else v28.client)

		v31.data = t5.state.data
		v31.serializedData = t5.state.serializedData
		v31.pluginOffsets = t5.state.pluginOffsets or {}
		v31.pluginGCOffsets = t5.state.pluginGCOffsets or {}
		v31.gcFunctionOffsets = t5.state.gcFunctionOffsets or {}
		v31.gcNodeOffsets = t5.state.gcNodeOffsets or {}
		v31.expandedNodes = t5.state.expandedNodes or {}

		local v32 = table.clone(v28)

		if t5.isClient then
			v32.client = v31
		else
			v32.server = v31
		end

		return Immutable.JoinDictionaries(v28, v32)
	end

	if t5.type == SetThreads.name then
		local v33 = table.clone(if not t5.isClient then v28.server else v28.client)

		v33.timedProfilingThread = t5.state.timedProfilingThread
		v33.timedProfilingTimerThread = t5.state.timedProfilingTimerThread
		v33.liveUpdateThread = t5.state.liveUpdateThread

		local v34 = table.clone(v28)

		if t5.isClient then
			v34.client = v33
		else
			v34.server = v33
		end

		return Immutable.JoinDictionaries(v28, v34)
	end

	if t5.type == ClearStateForNewProfilingSession.name then
		local v35 = table.clone(if not t5.isClient then v28.server else v28.client)

		v35.rootNode = 0
		v35.rootFunc = 0
		v35.rootNodeName = nil
		v35.searchFilterFlat = {}
		v35.searchFilterGraph = {}
		v35.expandedNodes = {}

		local v36 = table.clone(v28)

		if t5.isClient then
			v36.client = v35
		else
			v36.server = v35
		end

		return Immutable.JoinDictionaries(v28, v36)
	end

	if t5.type == SetScriptProfilerRoot.name then
		local t8 = {}
		local v38 = table.clone(if not v28.isClientView then v28.server else v28.client)

		if v38.rootNode ~= t5.rootNode then
			v38.rootNode = t5.rootNode
			v38.rootFunc = t5.rootFunc
			v38.rootNodeName = t5.rootNodeName
		else
			v38.rootNode = 0
			v38.rootFunc = 0
			v38.rootNodeName = nil
		end

		if v28.isClientView then
			t8.client = v38
		else
			t8.server = v38
		end

		return Immutable.JoinDictionaries(v28, t8)
	end

	return v28
end
