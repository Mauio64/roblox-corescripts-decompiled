local scriptParent = script.Parent
local DevConsoleDisplayOptions = require(scriptParent.DevConsoleDisplayOptions)
local MainView = require(scriptParent.MainView)
local MemoryData = require(scriptParent.MemoryData)
local NetworkData = require(scriptParent.NetworkData)
local ScriptsData = require(scriptParent.ScriptsData)
local DataStoresData = require(scriptParent.DataStoresData)
local ServerStatsData = require(scriptParent.ServerStatsData)
local ServerJobsData = require(scriptParent.ServerJobsData)
local ActionBindingsData = require(scriptParent.ActionBindingsData)
local MicroProfiler = require(scriptParent.MicroProfiler)
local DebugVisualizationsData = require(scriptParent.DebugVisualizationsData)
local ScriptProfiler = require(scriptParent.ScriptProfiler)
local LuauHeap = require(scriptParent.LuauHeap)

return function(t1: {[any]: any}?, t2: {[any]: any}) -- line: 18
	-- upvalues: DevConsoleDisplayOptions (copy), MainView (copy), MemoryData (copy), NetworkData (copy), ScriptsData (copy), DataStoresData (copy), ServerStatsData (copy), ServerJobsData (copy), ActionBindingsData (copy), MicroProfiler (copy), DebugVisualizationsData (copy), ScriptProfiler (copy), LuauHeap (copy)
	local v17 = t1 or {}

	return {
		DisplayOptions = DevConsoleDisplayOptions(v17.DisplayOptions, t2),
		MainView = MainView(v17.MainView, t2),
		MemoryData = MemoryData(v17.MemoryData, t2),
		NetworkData = NetworkData(v17.NetworkData, t2),
		ScriptsData = ScriptsData(v17.ScriptsData, t2),
		DataStoresData = DataStoresData(v17.DataStoresData, t2),
		ServerStatsData = ServerStatsData(v17.ServerStatsData, t2),
		ServerJobsData = ServerJobsData(v17.ServerJobsData, t2),
		ActionBindingsData = ActionBindingsData(v17.ActionBindingsData, t2),
		MicroProfiler = MicroProfiler(v17.MicroProfiler, t2),
		DebugVisualizationsData = DebugVisualizationsData(v17.DebugVisualizationsData, t2),
		ScriptProfiler = ScriptProfiler(v17.ScriptProfiler, t2),
		LuauHeap = LuauHeap(v17.LuauHeap, t2)
	}
end
