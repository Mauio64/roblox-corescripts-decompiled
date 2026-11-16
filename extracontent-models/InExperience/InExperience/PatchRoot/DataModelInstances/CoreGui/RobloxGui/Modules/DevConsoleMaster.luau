local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")

local Roact = require(CorePackages.Packages.Roact)
local Rodux = require(CorePackages.Packages.Rodux)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local DevConsole = script.Parent.DevConsole
local Constants = require(DevConsole.Constants)

local Components = DevConsole.Components
local DevConsoleWindow = require(Components.DevConsoleWindow)
local DataProvider = require(Components.DataProvider)
local MainViewLog = require(Components.Log.MainViewLog)
local MainViewMemory = require(Components.Memory.MainViewMemory)
local MainViewNetwork = require(Components.Network.MainViewNetwork)
local MainViewScripts = require(Components.Scripts.MainViewScripts)
local MainViewDataStores = require(Components.DataStores.MainViewDataStores)
local MainViewServerStats = require(Components.ServerStats.MainViewServerStats)
local MainViewActionBindings = require(Components.ActionBindings.MainViewActionBindings)
local MainViewServerJobs = require(Components.ServerJobs.MainViewServerJobs)
local MainViewMicroProfiler = require(Components.MicroProfiler.MainViewMicroProfiler)
local MainViewScriptProfiler = require(Components.ScriptProfiler.MainViewScriptProfiler)
local MainViewDebugVisualizations = require(Components.DebugVisualizations.MainViewDebugVisualizations)
local MainViewLuauHeap = require(Components.LuauHeap.MainViewLuauHeap)
local MainViewVoiceChat = require(Components.VoiceChat.MainViewVoiceChat)
local MainViewVoiceDebug = require(Components.VoiceDebug.MainViewVoiceDebug)
local GetFFlagVoiceDebugConsoleV2 = require(Components.VoiceDebug.GetFFlagVoiceDebugConsoleV2)
local MainViewRequestOrchestrator = require(Components.RequestOrchestrator.MainViewRequestOrchestrator)

local RCCProfilerDataCompleteListener = require(Components.MicroProfiler.RCCProfilerDataCompleteListener)
local getClientReplicator = require(DevConsole.Util.getClientReplicator)

local MainView = require(DevConsole.Reducers.MainView)
local DevConsoleReducer = require(DevConsole.Reducers.DevConsoleReducer)

local Actions = DevConsole.Actions
local SetDevConsoleVisibility = require(Actions.SetDevConsoleVisibility)
local SetTabList = require(Actions.SetTabList)

local MiddleWare = DevConsole.MiddleWare
local DevConsoleAnalytics = require(MiddleWare.DevConsoleAnalytics)

local PlayerPermissionsModule = require(CoreGui.RobloxGui.Modules.PlayerPermissionsModule)

local engineFeature = game:GetEngineFeature("ScriptProfiler")

local defineFastFlag = game:DefineFastFlag("DevConsoleRequestOrchestratorTab2", false)
local defineFastFlag2 = game:DefineFastFlag("DevConsoleAdminSeesDevTabs", false)

local VoiceChatServiceManager = require(CoreGui.RobloxGui.Modules.VoiceChat.VoiceChatServiceManager)
local default = VoiceChatServiceManager.default

local v = false

local v2 = {
	Log = { tab = MainViewLog, layoutOrder = 1, hasClientServer = true },
	Memory = { tab = MainViewMemory, layoutOrder = 2, hasClientServer = true },
	Network = { tab = MainViewNetwork, layoutOrder = 3, hasClientServer = true },
	Scripts = { tab = MainViewScripts, layoutOrder = 4 },
	DataStores = { tab = MainViewDataStores, layoutOrder = 5 },
	ServerStats = { tab = MainViewServerStats, layoutOrder = 6 },
	ActionBindings = { tab = MainViewActionBindings, layoutOrder = 7 },
	ServerJobs = { tab = MainViewServerJobs, layoutOrder = 8 },
	MicroProfiler = { tab = MainViewMicroProfiler, layoutOrder = 9 },
	DebugVisualizations = { tab = MainViewDebugVisualizations, layoutOrder = 10 },
	ScriptProfiler = engineFeature and { tab = MainViewScriptProfiler, layoutOrder = 11 } or nil,
	LuauHeap = { tab = MainViewLuauHeap, layoutOrder = 12 }
}

local v3 = {
	Log = { tab = MainViewLog, layoutOrder = 1 },
	Memory = { tab = MainViewMemory, layoutOrder = 2 },
	ScriptProfiler = engineFeature and { tab = MainViewScriptProfiler, layoutOrder = 3 } or nil,
	LuauHeap = { tab = MainViewLuauHeap, layoutOrder = 4 },
	VoiceChat = not GetFFlagVoiceDebugConsoleV2() and game:GetEngineFeature("VoiceChatDevConsoleTabEnabled") and default and default:canUseService() and {
		tab = MainViewVoiceChat,
		layoutOrder = 5
	} or nil
}

local tabList = {
	Log = { tab = MainViewLog, layoutOrder = 1 },
	Memory = { tab = MainViewMemory, layoutOrder = 2 }
}

local v4 = {
	VoiceChat = {
		tab = MainViewVoiceChat,
		layoutOrder = 13,
		isEnabled = function()
			local v4 = not GetFFlagVoiceDebugConsoleV2() and game:GetEngineFeature("VoiceChatDevConsoleTabEnabled")

			if v4 then
				if default == nil then
					return false
				end

				return (default:canUseService())
			end

			return v4
		end
	},
	VoiceDebug = {
		tab = MainViewVoiceDebug,
		layoutOrder = 14,
		isEnabled = function()
			return v
		end
	},
	RequestOrchestrator = {
		tab = MainViewRequestOrchestrator,
		layoutOrder = 100,
		isEnabled = function()
			return defineFastFlag
		end
	}
}

local class = {}
class.__index = class

local v5 = {
	[Enum.Platform.Windows] = Constants.FormFactor.Large,
	[Enum.Platform.OSX] = Constants.FormFactor.Large,
	[Enum.Platform.IOS] = Constants.FormFactor.Small,
	[Enum.Platform.Android] = Constants.FormFactor.Small,
	[Enum.Platform.XBoxOne] = Constants.FormFactor.Console,
	[Enum.Platform.PS4] = Constants.FormFactor.Console,
	[Enum.Platform.PS3] = Constants.FormFactor.Console,
	[Enum.Platform.XBox360] = Constants.FormFactor.Console,
	[Enum.Platform.WiiU] = Constants.FormFactor.Console,
	[Enum.Platform.NX] = Constants.FormFactor.Console,
	[Enum.Platform.Ouya] = Constants.FormFactor.Console,
	[Enum.Platform.AndroidTV] = Constants.FormFactor.Console,
	[Enum.Platform.Chromecast] = Constants.FormFactor.Console,
	[Enum.Platform.Linux] = Constants.FormFactor.Large,
	[Enum.Platform.SteamOS] = Constants.FormFactor.Console,
	[Enum.Platform.WebOS] = Constants.FormFactor.Large,
	[Enum.Platform.DOS] = Constants.FormFactor.Large,
	[Enum.Platform.BeOS] = Constants.FormFactor.Large,
	[Enum.Platform.UWP] = Constants.FormFactor.Large,
	[Enum.Platform.None] = Constants.FormFactor.Large
}

local function isAdminAsync() -- 2 equivalent calls inferred from this helper
	return PlayerPermissionsModule.IsPlayerAdminAsync(Players.LocalPlayer)
end

local function getAdminTabList()
	local clone = table.clone(v2)

	for k, v6 in pairs(v4) do
		if v6.isEnabled == nil or v6.isEnabled() then
			clone[k] = { tab = v6.tab, layoutOrder = v6.layoutOrder }
		end
	end

	return clone
end

function class.new()
	local class2 = {}
	setmetatable(class2, class)

	class2.init = false

	class2.isDeveloperTabListActive = false
	class2.isEmployee = false

	class2.waitForStart = true
	class2.waitForStartBindable = Instance.new("BindableEvent")
	coroutine.wrap(function()
		class2:SetupDevConsole()
	end)()

	return class2
end

function class:SetupDevConsole()
	local formFactor = v5[UserInputService:GetPlatform()]

	local v6 = {
		MainView = MainView(nil, SetTabList(tabList, "Log"))
	}

	self.store = Rodux.Store.new(DevConsoleReducer, v6, { DevConsoleAnalytics })

	local isVisible = self.store:getState().DisplayOptions.isVisible

	self.root = Roact.createElement(RoactRodux.StoreProvider, { store = self.store }, {
		DataProvider = Roact.createElement(DataProvider, { isDeveloperView = false }, {
			App = Roact.createElement("ScreenGui", { OnTopOfCoreBlur = true, DisplayOrder = 10 }, {
				DevConsoleWindow = Roact.createElement(DevConsoleWindow, {
					formFactor = formFactor,
					isDeveloperView = false,
					isVisible = isVisible,
					isMinimized = false,
					position = Constants.MainWindowInit.Position,
					size = Constants.MainWindowInit.Size,
					tabList = tabList,
					onCloseCallback = function(p)
						self:SetServerStatsConnection(p)
					end
				}),
				RCCProfilerDataCompleteListener = Roact.createElement(RCCProfilerDataCompleteListener)
			})
		})
	})

	self.waitForStart = false
	self.waitForStartBindable:Fire()
end

local v6 = class.new()

function class:refreshTabList()
	if self.isEmployee then
		self.store:dispatch(SetTabList(getAdminTabList(), "Log", true))
	elseif self.isDeveloperTabListActive then
		self.store:dispatch(SetTabList(v2, "Log", true))
	end
end

function class:refreshVoiceDevConsoleAvailability()
	if not GetFFlagVoiceDebugConsoleV2() then
		return
	end

	if game:GetEngineFeature("VoiceChatDevConsoleTabEnabled") and default then
		local function apply()
			local voiceChatAvailable = default:VoiceChatAvailable()

			if voiceChatAvailable == v then
				return
			end

			v = voiceChatAvailable

			self:refreshTabList()
		end

		default:asyncInit():andThen(apply):catch(apply)
	end
end

function class:Start()
	if not self.init then
		if self.waitForStart then
			self.waitForStartBindable.Event:Wait()
		end

		self.init = true
		self.element = Roact.mount(self.root, CoreGui, "DevConsoleMaster")
		local clientReplicator = getClientReplicator()

		task.spawn(function()
			if defineFastFlag2 then
				if isAdminAsync() then -- inferred equivalent call
					self.isEmployee = true
					self:refreshTabList()
				end
			elseif isAdminAsync() and not self.isDeveloperTabListActive then -- inferred equivalent call
				self.store:dispatch(SetTabList(v3, "Log", false))
			end
		end)

		task.spawn(function()
			self:refreshVoiceDevConsoleAvailability()
		end)

		if clientReplicator then
			self._statsConnector = clientReplicator.StatsReceived:connect(function(_)
				if not self._statsConnector then
					return
				end

				self._statsConnector:Disconnect()
				self._statsConnector = nil

				self.isDeveloperTabListActive = true

				if defineFastFlag2 then
					self:refreshTabList()
				else
					self.store:dispatch(SetTabList(v2, "Log", true))
				end
			end)

			self:SetServerStatsConnection(true)
		end
	end
end

function class:ToggleVisibility()
	if not self.init then
		if GetFFlagVoiceDebugConsoleV2() then
			self:Start()
		else
			v6:Start()
		end
	end

	self:SetVisibility(not self.store:getState().DisplayOptions.isVisible)
end

function class:GetVisibility()
	if not self.init then
		return false
	end

	local state = self.store:getState()

	if state and state.DisplayOptions then
		return state.DisplayOptions.isVisible and not state.DisplayOptions.isMinimized
	end

	return false
end

function class:SetServerStatsConnection(p)
	local clientReplicator = getClientReplicator()

	if clientReplicator then
		clientReplicator:RequestServerStats(p)
	end
end

function class:SetVisibility(p)
	if type(p) == "boolean" then
		if self.init or not p then
			if GetFFlagVoiceDebugConsoleV2() and p then
				self:refreshVoiceDevConsoleAvailability()
			end
		elseif GetFFlagVoiceDebugConsoleV2() then
			self:Start()
		else
			v6:Start()
		end

		self:SetServerStatsConnection(p)

		self.store:dispatch(SetDevConsoleVisibility(p))
	end
end

StarterGui:RegisterGetCore("DevConsoleVisible", function()
	return v6:GetVisibility()
end)

StarterGui:RegisterSetCore("DevConsoleVisible", function(p)
	if type(p) ~= "boolean" then
		error("DevConsoleVisible must be given a boolean value.")
	end

	v6:SetVisibility(p)
end)

if GetFFlagVoiceDebugConsoleV2() then
	v6.Klass = class
end

return v6
