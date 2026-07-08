local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local TextChatService = game:GetService("TextChatService")
local StarterGui = game:GetService("StarterGui")
local RobloxGui = CoreGui.RobloxGui
local FFlagEnableUIManagerPackgify = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableUIManagerPackgify
local isInExperienceUIVREnabled = require(CorePackages.Workspace.Packages.SharedExperimentDefinition).isInExperienceUIVREnabled
local PanelType, UIManager, SpatialUIType

if isInExperienceUIVREnabled or FFlagEnableUIManagerPackgify then
	local VrSpatialUi = require(CorePackages.Workspace.Packages.VrSpatialUi)

	PanelType = VrSpatialUi.Constants.PanelType
	UIManager = VrSpatialUi.UIManager
	SpatialUIType = VrSpatialUi.Constants.SpatialUIType
else
	local UIManager2 = RobloxGui:WaitForChild("Modules"):WaitForChild("UIManager")
	local Constants = require(UIManager2.Constants)

	PanelType = Constants.PanelType
	UIManager = require(UIManager2.UIManager)
	SpatialUIType = Constants.SpatialUIType
end

if game:DefineFastFlag("DebugExpChat", false) then
	require(CorePackages.Workspace.Packages.ExpChatDebug).start()
end

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local GameTranslator = require(RobloxGui.Modules.GameTranslator)
local ApolloClient = require(RobloxGui.Modules.ApolloClient)
local ExpChat = require(CorePackages.Workspace.Packages.ExpChat)
local getFFlagAddApolloClientToExperienceChat = require(RobloxGui.Modules.Flags.getFFlagAddApolloClientToExperienceChat)
local v19 = require(CorePackages.Workspace.Packages.Chrome).Enabled()
local IsSpatialRobloxGuiEnabled = require(RobloxGui.Modules.VR.IsSpatialRobloxGuiEnabled)
local getFFlagExpChatAlwaysRunTCS = require(CorePackages.Workspace.Packages.SharedFlags).getFFlagExpChatAlwaysRunTCS
local getIconVoiceIndicator = require(RobloxGui.Modules.VoiceChat.Components.getIconVoiceIndicator)
local onClickedVoiceIndicator = require(RobloxGui.Modules.VoiceChat.Components.onClickedVoiceIndicator)
local getPermissions = nil

if v19 then
	getPermissions = require(RobloxGui.Modules.VoiceChat.Components.getPermissions)
end

local v25 = nil
local panelObject

if IsSpatialRobloxGuiEnabled then
	local t1 = {
		panelType = PanelType.Chat,
		screenGuiProps = {
			Name = "ExperienceChat",
			ResetOnSpawn = false,
			DisplayOrder = -1,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		}
	}

	v25 = UIManager.getInstance():createUI(t1)
	panelObject = v25.panelObject

	if isInExperienceUIVREnabled then
		local Observable = require(CorePackages.Workspace.Packages.Observable)
		local ChatSelector = require(CoreGui.RobloxGui.Modules.ChatSelector)
		local v30 = Observable.ObservableValue.new(ChatSelector:GetVisibility())

		ChatSelector.VisibilityStateChanged:connect(function(p1) -- line: 73
			-- upvalues: v30 (copy)
			v30:set(p1)
		end)
		UIManager.getInstance():connectPanelVisibility(t1.panelType, v30)
	end
else
	panelObject = Instance.new("ScreenGui")
	panelObject.Name = "ExperienceChat"
	panelObject.ResetOnSpawn = false
	panelObject.DisplayOrder = -1
	panelObject.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	panelObject.Parent = CoreGui
end

local function findTextChannel(s1: string) -- line: 87
	-- upvalues: TextChatService (copy)
	local s1_2 = TextChatService:FindFirstChild(s1, true)

	while not s1_2 do
		wait()
		s1_2 = TextChatService:FindFirstChild(s1, true)
	end

	return s1_2
end

StarterGui.CoreGuiChangedSignal:Connect(function(p2, p3) -- line: 97
	-- upvalues: ExpChat (copy)
	if p2 == Enum.CoreGuiType.All or p2 == Enum.CoreGuiType.Chat then
		ExpChat.Events.SetCoreGuiEnabledChanged(p3)
	end
end)

local IChatSettings = require(RobloxGui.Modules.InGameChat.BubbleChat.Types).IChatSettings
local v33 = if not getFFlagExpChatAlwaysRunTCS() then TextChatService.ChatVersion == Enum.ChatVersion.TextChatService and TextChatService.CreateDefaultTextChannels else TextChatService.CreateDefaultTextChannels

if game:GetEngineFeature("TextChatServiceProtectedChatEnabled") and game:DefineFastFlag("DebugExpChatTextChannelWindow", false) then
	require(CorePackages.Workspace.Packages.TextChannelWindow).start()
end

ExpChat.mountClientApp({
	apolloClient = if not getFFlagAddApolloClientToExperienceChat() then nil else ApolloClient,
	getIconVoiceIndicator = getIconVoiceIndicator or nil,
	onClickedVoiceIndicator = onClickedVoiceIndicator or nil,
	getPermissions = getPermissions or nil,
	defaultTargetTextChannel = if not v33 then nil else findTextChannel("RBXGeneral"),
	defaultSystemTextChannel = if not v33 then nil else findTextChannel("RBXSystem"),
	validateLegacyBubbleChatSettings = IChatSettings or nil,
	translator = RobloxTranslator,
	gameTranslator = GameTranslator,
	parent = panelObject,
	isSpatialUIEnabled = v25 and v25.type == SpatialUIType.SpatialUI
})
