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
local EngineFeature = game:GetEngineFeature("ScriptProfiler")
local v39 = game:DefineFastFlag("DevConsoleRequestOrchestratorTab", false)
local v40 = game:DefineFastFlag("DevConsoleAdminSeesDevTabs", false)
local default = require(CoreGui.RobloxGui.Modules.VoiceChat.VoiceChatServiceManager).default
local t1 = {
	Log = {
		layoutOrder = 1,
		hasClientServer = true,
		tab = MainViewLog
	},
	Memory = {
		layoutOrder = 2,
		hasClientServer = true,
		tab = MainViewMemory
	},
	Network = {
		layoutOrder = 3,
		hasClientServer = true,
		tab = MainViewNetwork
	},
	Scripts = {
		layoutOrder = 4,
		tab = MainViewScripts
	},
	DataStores = {
		layoutOrder = 5,
		tab = MainViewDataStores
	},
	ServerStats = {
		layoutOrder = 6,
		tab = MainViewServerStats
	},
	ActionBindings = {
		layoutOrder = 7,
		tab = MainViewActionBindings
	},
	ServerJobs = {
		layoutOrder = 8,
		tab = MainViewServerJobs
	},
	MicroProfiler = {
		layoutOrder = 9,
		tab = MainViewMicroProfiler
	},
	DebugVisualizations = {
		layoutOrder = 10,
		tab = MainViewDebugVisualizations
	},
	ScriptProfiler = if not EngineFeature then nil else {
		layoutOrder = 11,
		tab = MainViewScriptProfiler
	},
	LuauHeap = {
		layoutOrder = 12,
		tab = MainViewLuauHeap
	}
}
local t2 = {
	Log = {
		layoutOrder = 1,
		tab = MainViewLog
	},
	Memory = {
		layoutOrder = 2,
		tab = MainViewMemory
	},
	ScriptProfiler = if not EngineFeature then nil else {
		layoutOrder = 3,
		tab = MainViewScriptProfiler
	},
	LuauHeap = {
		layoutOrder = 4,
		tab = MainViewLuauHeap
	},
	VoiceChat = if not game:GetEngineFeature("VoiceChatDevConsoleTabEnabled") or (not default or not default:canUseService()) then nil else {
		layoutOrder = 5,
		tab = MainViewVoiceChat
	}
}
local t3 = {
	Log = {
		layoutOrder = 1,
		tab = MainViewLog
	},
	Memory = {
		layoutOrder = 2,
		tab = MainViewMemory
	}
}
local t4 = {
	VoiceChat = {
		layoutOrder = 13,
		tab = MainViewVoiceChat,
		isEnabled = function() -- line: 159
			-- upvalues: default (copy)
			return game:GetEngineFeature("VoiceChatDevConsoleTabEnabled") and (default ~= nil and default:canUseService())
		end
	},
	RequestOrchestrator = {
		layoutOrder = 100,
		tab = MainViewRequestOrchestrator,
		isEnabled = function() -- line: 168
			-- upvalues: v39 (copy)
			return v39
		end
	}
}
local t5 = {}

t5.__index = t5

local t6 = {
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

local function isAdminAsync() -- line: 200
	-- upvalues: PlayerPermissionsModule (copy), Players (copy)
	return PlayerPermissionsModule.IsPlayerAdminAsync(Players.LocalPlayer)
end
local function getAdminTabList() -- line: 207
	-- upvalues: t1 (copy), t4 (copy)
	local v51 = table.clone(t1)

	for k, v in pairs(t4) do
		if v.isEnabled == nil or v.isEnabled() then
			v51[k] = {
				tab = v.tab,
				layoutOrder = v.layoutOrder
			}
		end
	end

	return v51
end

function t5.new() -- line: 222
	-- upvalues: t5 (copy)
	local t7 = {}

	setmetatable(t7, t5)
	t7.init = false
	t7.isDeveloperTabListActive = false
	t7.isEmployee = false
	t7.waitForStart = true
	t7.waitForStartBindable = Instance.new("BindableEvent")
	coroutine.wrap(function() -- line: 233
		-- upvalues: t7 (copy)
		t7:SetupDevConsole()
	end)()

	return t7
end
function t5.SetupDevConsole(p1) -- line: 240
	-- upvalues: UserInputService (copy), t6 (copy), MainView (copy), SetTabList (copy), t3 (copy), DevConsoleAnalytics (copy), Rodux (copy), DevConsoleReducer (copy), Roact (copy), RoactRodux (copy), DataProvider (copy), DevConsoleWindow (copy), Constants (copy), RCCProfilerDataCompleteListener (copy)
	local v56 = t6[UserInputService:GetPlatform()]
	local t8 = {
		MainView = MainView(nil, SetTabList(t3, "Log"))
	}
	local t9 = { DevConsoleAnalytics }

	p1.store = Rodux.Store.new(DevConsoleReducer, t8, t9)

	local isVisible = p1.store:getState().DisplayOptions.isVisible

	p1.root = Roact.createElement(RoactRodux.StoreProvider, {
		store = p1.store
	}, {
		DataProvider = Roact.createElement(DataProvider, {
			isDeveloperView = false
		}, {
			App = Roact.createElement("ScreenGui", {
				OnTopOfCoreBlur = true,
				DisplayOrder = 10
			}, {
				DevConsoleWindow = Roact.createElement(DevConsoleWindow, {
					isDeveloperView = false,
					isMinimized = false,
					formFactor = v56,
					isVisible = isVisible,
					position = Constants.MainWindowInit.Position,
					size = Constants.MainWindowInit.Size,
					tabList = t3,
					onCloseCallback = function(p2) -- line: 275
						-- upvalues: p1 (copy)
						p1:SetServerStatsConnection(p2)
					end
				}),
				RCCProfilerDataCompleteListener = Roact.createElement(RCCProfilerDataCompleteListener)
			})
		})
	})
	p1.waitForStart = false
	p1.waitForStartBindable:Fire()
end

local v50 = t5.new()

function t5.refreshTabList(p3) -- line: 294
	-- upvalues: SetTabList (copy), getAdminTabList (copy), t1 (copy)
	if p3.isEmployee then
		p3.store:dispatch(SetTabList(getAdminTabList(), "Log", true))

		return
	end

	if p3.isDeveloperTabListActive then
		p3.store:dispatch(SetTabList(t1, "Log", true))
	end
end
function t5.Start(p4) -- line: 302
	-- upvalues: Roact (copy), CoreGui (copy), getClientReplicator (copy), v40 (copy), PlayerPermissionsModule (copy), Players (copy), SetTabList (copy), t2 (copy), t1 (copy)
	if not p4.init then
		if p4.waitForStart then
			p4.waitForStartBindable.Event:Wait()
		end

		p4.init = true
		p4.element = Roact.mount(p4.root, CoreGui, "DevConsoleMaster")

		local v62 = getClientReplicator()

		task.spawn(function() -- line: 312
			-- upvalues: v40 (copy), PlayerPermissionsModule (copy), Players (copy), p4 (copy), SetTabList (copy), t2 (copy)
			if v40 then
				if PlayerPermissionsModule.IsPlayerAdminAsync(Players.LocalPlayer) then
					p4.isEmployee = true
					p4:refreshTabList()

					return
				end
			elseif PlayerPermissionsModule.IsPlayerAdminAsync(Players.LocalPlayer) and not p4.isDeveloperTabListActive then
				p4.store:dispatch(SetTabList(t2, "Log", false))
			end
		end)

		if v62 then
			p4._statsConnector = v62.StatsReceived:connect(function(_) -- line: 327
				-- upvalues: p4 (copy), v40 (copy), SetTabList (copy), t1 (copy)
				if not p4._statsConnector then
					return
				end

				p4._statsConnector:Disconnect()
				p4._statsConnector = nil
				p4.isDeveloperTabListActive = true

				if v40 then
					p4:refreshTabList()

					return
				end

				p4.store:dispatch(SetTabList(t1, "Log", true))
			end)
			p4:SetServerStatsConnection(true)
		end
	end
end
function t5.ToggleVisibility(p6) -- line: 348
	-- upvalues: v50 (copy)
	if not p6.init then
		v50:Start()
	end

	p6:SetVisibility(not p6.store:getState().DisplayOptions.isVisible)
end
function t5.GetVisibility(p7) -- line: 357
	if not p7.init then
		return false
	end

	local v65 = p7.store:getState()

	if v65 and v65.DisplayOptions then
		return v65.DisplayOptions.isVisible and not v65.DisplayOptions.isMinimized
	end

	return false
end
function t5.SetServerStatsConnection(_, p9) -- line: 372
	-- upvalues: getClientReplicator (copy)
	local v68 = getClientReplicator()

	if v68 then
		v68:RequestServerStats(p9)
	end
end
function t5.SetVisibility(p10, p11) -- line: 379
	-- upvalues: v50 (copy), SetDevConsoleVisibility (copy)
	if type(p11) == "boolean" then
		if not p10.init and p11 then
			v50:Start()
		end

		p10:SetServerStatsConnection(p11)
		p10.store:dispatch(SetDevConsoleVisibility(p11))
	end
end

StarterGui:RegisterGetCore("DevConsoleVisible", function() -- line: 391
	-- upvalues: v50 (copy)
	return v50:GetVisibility()
end)
StarterGui:RegisterSetCore("DevConsoleVisible", function(p12) -- line: 395
	-- upvalues: v50 (copy)
	if type(p12) ~= "boolean" then
		error("DevConsoleVisible must be given a boolean value.")
	end

	v50:SetVisibility(p12)
end)

return v50
