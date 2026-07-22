local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Components = script.Parent.Parent.Components
local LogData = require(Components.Log.LogData)
local ClientMemoryData = require(Components.Memory.ClientMemoryData)
local ServerMemoryData = require(Components.Memory.ServerMemoryData)
local NetworkData = require(Components.Network.NetworkData)
local ServerScriptsData = require(Components.Scripts.ServerScriptsData)
local DataStoresData = require(Components.DataStores.DataStoresData)
local ServerStatsData = require(Components.ServerStats.ServerStatsData)
local ActionBindingsData = require(Components.ActionBindings.ActionBindingsData)
local ServerJobsData = require(Components.ServerJobs.ServerJobsData)
local DebugVisualizationsData = require(Components.DebugVisualizations.DebugVisualizationsData)
local LuauHeapData = require(Components.LuauHeap.LuauHeapData)
local VoiceChatData = require(Components.VoiceChat.VoiceChatData)
local DataContext = require(Components.DataContext)
local v18 = Roact.Component:extend("DataProvider")
local EngineFeature = game:GetEngineFeature("VoiceChatDevConsoleTabEnabled")
local v20 = game:DefineFastFlag("DevConsoleStartDataOnMount", false)

function v18.init(p1) -- line: 26
	-- upvalues: LogData (copy), ClientMemoryData (copy), ServerMemoryData (copy), NetworkData (copy), ServerScriptsData (copy), DataStoresData (copy), ServerStatsData (copy), ActionBindingsData (copy), ServerJobsData (copy), DebugVisualizationsData (copy), LuauHeapData (copy), EngineFeature (copy), VoiceChatData (copy)
	p1:setState({
		DevConsoleData = {
			ClientLogData = LogData.new(true),
			ServerLogData = LogData.new(false),
			ClientMemoryData = ClientMemoryData.new(),
			ServerMemoryData = ServerMemoryData.new(),
			ClientNetworkData = NetworkData.new(true),
			ServerNetworkData = NetworkData.new(false),
			ServerScriptsData = ServerScriptsData.new(),
			DataStoresData = DataStoresData.new(),
			ServerStatsData = ServerStatsData.new(),
			ActionBindingsData = ActionBindingsData.new(),
			ServerJobsData = ServerJobsData.new(),
			DebugVisualizationsData = DebugVisualizationsData.new(),
			LuauHeapData = LuauHeapData.new(),
			VoiceChatData = if not EngineFeature then nil else VoiceChatData.new()
		}
	})
end
function v18.didMount(p2) -- line: 47
	-- upvalues: EngineFeature (copy), v20 (copy)
	p2.state.DevConsoleData.ClientLogData:start()
	p2.state.DevConsoleData.ClientMemoryData:start()

	if EngineFeature then
		p2.state.DevConsoleData.VoiceChatData:start()
	end

	if v20 and p2.props.isDeveloperView then
		for _, v in pairs(p2.state.DevConsoleData) do
			if not v:isRunning() then
				v:start()
			end
		end
	end
end
function v18.willUpdate(p3, p4, _) -- line: 64
	if p4.isDeveloperView and not p3.props.isDeveloperView then
		for _, v in pairs(p3.state.DevConsoleData) do
			if not v:isRunning() then
				v:start()
			end
		end
	end
end
function v18.render(p6) -- line: 74
	-- upvalues: Roact (copy), DataContext (copy)
	return Roact.createElement(DataContext.Provider, {
		value = p6.state.DevConsoleData
	}, Roact.oneChild(p6.props[Roact.Children]))
end

local function mapStateToProps(p7, _) -- line: 80
	return {
		isDeveloperView = p7.MainView.isDeveloperView
	}
end

return RoactRodux.UNSTABLE_connect2(mapStateToProps, nil)(v18)
