local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local TextChatService = game:GetService("TextChatService")
local StarterGui = game:GetService("StarterGui")
local RobloxGui = CoreGui.RobloxGui
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableUIManagerPackgify = SharedFlags.FFlagEnableUIManagerPackgify

local SharedExperimentDefinition = require(CorePackages.Workspace.Packages.SharedExperimentDefinition)
local isInExperienceUIVREnabled = SharedExperimentDefinition.isInExperienceUIVREnabled
local panelType, v, spatialUIType

if isInExperienceUIVREnabled or FFlagEnableUIManagerPackgify then
	local VrSpatialUi = require(CorePackages.Workspace.Packages.VrSpatialUi)
	panelType = VrSpatialUi.Constants.PanelType
	v = VrSpatialUi.UIManager
	spatialUIType = VrSpatialUi.Constants.SpatialUIType
else
	local uiManager = RobloxGui:WaitForChild("Modules"):WaitForChild("UIManager")
	local Constants = require(uiManager.Constants)
	panelType = Constants.PanelType
	v = require(uiManager.UIManager)
	spatialUIType = Constants.SpatialUIType
end

if game:DefineFastFlag("DebugExpChat", false) then
	local ExpChatDebug = require(CorePackages.Workspace.Packages.ExpChatDebug)
	ExpChatDebug.start()
end

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local GameTranslator = require(RobloxGui.Modules.GameTranslator)
local ApolloClient = require(RobloxGui.Modules.ApolloClient)
local ExpChat = require(CorePackages.Workspace.Packages.ExpChat)
local getFFlagAddApolloClientToExperienceChat = require(RobloxGui.Modules.Flags.getFFlagAddApolloClientToExperienceChat)
local Chrome = require(CorePackages.Workspace.Packages.Chrome)
local enabled = Chrome.Enabled()
local IsSpatialRobloxGuiEnabled = require(RobloxGui.Modules.VR.IsSpatialRobloxGuiEnabled)
local SharedFlags2 = require(CorePackages.Workspace.Packages.SharedFlags)
local getFFlagExpChatAlwaysRunTCS = SharedFlags2.getFFlagExpChatAlwaysRunTCS

local getIconVoiceIndicator = require(RobloxGui.Modules.VoiceChat.Components.getIconVoiceIndicator)
local onClickedVoiceIndicator = require(RobloxGui.Modules.VoiceChat.Components.onClickedVoiceIndicator)
local getPermissions

if enabled then
	getPermissions = require(RobloxGui.Modules.VoiceChat.Components.getPermissions)
end

local v2 = nil
local experienceChat

if IsSpatialRobloxGuiEnabled then
	local v3 = {
		panelType = panelType.Chat,
		screenGuiProps = {
			Name = "ExperienceChat",
			ResetOnSpawn = false,
			DisplayOrder = -1,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		}
	}

	v2 = v.getInstance():createUI(v3)
	experienceChat = v2.panelObject

	if isInExperienceUIVREnabled then
		local Observable = require(CorePackages.Workspace.Packages.Observable)
		local ChatSelector = require(CoreGui.RobloxGui.Modules.ChatSelector)
		local observableValue = Observable.ObservableValue.new(ChatSelector:GetVisibility())
		ChatSelector.VisibilityStateChanged:connect(function(p)
			observableValue:set(p)
		end)
		v.getInstance():connectPanelVisibility(v3.panelType, observableValue)
	end
else
	experienceChat = Instance.new("ScreenGui")
	experienceChat.Name = "ExperienceChat"
	experienceChat.ResetOnSpawn = false
	experienceChat.DisplayOrder = -1
	experienceChat.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	experienceChat.Parent = CoreGui
end

local function findTextChannel(childName: string)
	local textChannel = TextChatService:FindFirstChild(childName, true)

	while not textChannel do
		wait()
		textChannel = TextChatService:FindFirstChild(childName, true)
	end

	return textChannel
end

StarterGui.CoreGuiChangedSignal:Connect(function(p, p2)
	if p == Enum.CoreGuiType.All or p == Enum.CoreGuiType.Chat then
		ExpChat.Events.SetCoreGuiEnabledChanged(p2)
	end
end)

local Types = require(RobloxGui.Modules.InGameChat.BubbleChat.Types)
local IChatSettings = Types.IChatSettings
local v3

if getFFlagExpChatAlwaysRunTCS() then
	v3 = TextChatService.CreateDefaultTextChannels
elseif TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
	v3 = TextChatService.CreateDefaultTextChannels
else
	v3 = false
end

if
	game:GetEngineFeature("TextChatServiceProtectedChatEnabled")
	and game:DefineFastFlag("ExpChatTextChannelWindow", false)
	and TextChatService:IsProtectedChatEnabled()
then
	local TextChannelWindow = require(CorePackages.Workspace.Packages.TextChannelWindow)
	TextChannelWindow.start()
end

local mountClientApp = ExpChat.mountClientApp

if not getFFlagAddApolloClientToExperienceChat() then
	ApolloClient = nil
end

local v4 = {
	apolloClient = ApolloClient,
	getIconVoiceIndicator = getIconVoiceIndicator or nil,
	onClickedVoiceIndicator = onClickedVoiceIndicator or nil,
	getPermissions = getPermissions or nil,
	defaultTargetTextChannel = 0,
	defaultSystemTextChannel = 0,
	validateLegacyBubbleChatSettings = 0,
	translator = 0,
	gameTranslator = 0,
	parent = 0,
	isSpatialUIEnabled = 0
}
local defaultTargetTextChannel

if v3 then
	defaultTargetTextChannel = findTextChannel("RBXGeneral")
end

v4.defaultTargetTextChannel = defaultTargetTextChannel
local defaultSystemTextChannel

if v3 then
	defaultSystemTextChannel = findTextChannel("RBXSystem")
end

v4.defaultSystemTextChannel = defaultSystemTextChannel
v4.validateLegacyBubbleChatSettings = IChatSettings or nil

v4.translator = RobloxTranslator
v4.gameTranslator = GameTranslator
v4.parent = experienceChat
v4.isSpatialUIEnabled = v2 and v2.type == spatialUIType.SpatialUI
mountClientApp(v4)
