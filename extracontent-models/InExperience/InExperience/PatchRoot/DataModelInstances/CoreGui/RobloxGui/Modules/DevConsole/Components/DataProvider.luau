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
local VoiceDebugData = require(Components.VoiceDebug.VoiceDebugData)
local GetFFlagVoiceDebugConsoleV2 = require(Components.VoiceDebug.GetFFlagVoiceDebugConsoleV2)
local DataContext = require(Components.DataContext)

local extended = Roact.Component:extend("DataProvider")

local engineFeature = game:GetEngineFeature("VoiceChatDevConsoleTabEnabled")
local defineFastFlag = game:DefineFastFlag("DevConsoleStartDataOnMount", false)

function extended.init(object)
	local devConsoleData = {
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
		VoiceChatData = 0,
		VoiceDebugData = 0
	}
	local voiceChatData

	if engineFeature and not GetFFlagVoiceDebugConsoleV2() then
		voiceChatData = VoiceChatData.new()
	end

	devConsoleData.VoiceChatData = voiceChatData
	local voiceDebugData

	if engineFeature and GetFFlagVoiceDebugConsoleV2() then
		voiceDebugData = VoiceDebugData.new()
	end

	devConsoleData.VoiceDebugData = voiceDebugData
	object:setState({ DevConsoleData = devConsoleData })
end

function extended.didMount(p)
	p.state.DevConsoleData.ClientLogData:start()
	p.state.DevConsoleData.ClientMemoryData:start()

	if engineFeature then
		if GetFFlagVoiceDebugConsoleV2() then
			p.state.DevConsoleData.VoiceDebugData:start()
		else
			p.state.DevConsoleData.VoiceChatData:start()
		end
	end

	if defineFastFlag and p.props.isDeveloperView then
		for _, v in pairs(p.state.DevConsoleData) do
			if not v:isRunning() then
				v:start()
			end
		end
	end
end

function extended.willUpdate(p, p2, _)
	if p2.isDeveloperView and not p.props.isDeveloperView then
		for _, v in pairs(p.state.DevConsoleData) do
			if not v:isRunning() then
				v:start()
			end
		end
	end
end

function extended.render(p)
	return Roact.createElement(
		DataContext.Provider,
		{ value = p.state.DevConsoleData },
		Roact.oneChild(p.props[Roact.Children])
	)
end

local function mapStateToProps(p, _)
	return { isDeveloperView = p.MainView.isDeveloperView }
end

return RoactRodux.UNSTABLE_connect2(mapStateToProps, nil)(extended)
