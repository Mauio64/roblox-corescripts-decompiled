local parent = script.Parent
local DevConsoleDisplayOptions = require(parent.DevConsoleDisplayOptions)
local MainView = require(parent.MainView)

local MemoryData = require(parent.MemoryData)
local NetworkData = require(parent.NetworkData)
local ScriptsData = require(parent.ScriptsData)
local DataStoresData = require(parent.DataStoresData)
local ServerStatsData = require(parent.ServerStatsData)
local ServerJobsData = require(parent.ServerJobsData)
local ActionBindingsData = require(parent.ActionBindingsData)
local MicroProfiler = require(parent.MicroProfiler)
local DebugVisualizationsData = require(parent.DebugVisualizationsData)
local ScriptProfiler = require(parent.ScriptProfiler)
local LuauHeap = require(parent.LuauHeap)

return function(options, p)
	local v = options or {}
	return {
		DisplayOptions = DevConsoleDisplayOptions(v.DisplayOptions, p),
		MainView = MainView(v.MainView, p),
		MemoryData = MemoryData(v.MemoryData, p),
		NetworkData = NetworkData(v.NetworkData, p),
		ScriptsData = ScriptsData(v.ScriptsData, p),
		DataStoresData = DataStoresData(v.DataStoresData, p),
		ServerStatsData = ServerStatsData(v.ServerStatsData, p),
		ServerJobsData = ServerJobsData(v.ServerJobsData, p),
		ActionBindingsData = ActionBindingsData(v.ActionBindingsData, p),
		MicroProfiler = MicroProfiler(v.MicroProfiler, p),
		DebugVisualizationsData = DebugVisualizationsData(v.DebugVisualizationsData, p),
		ScriptProfiler = ScriptProfiler(v.ScriptProfiler, p),
		LuauHeap = LuauHeap(v.LuauHeap, p)
	}
end
