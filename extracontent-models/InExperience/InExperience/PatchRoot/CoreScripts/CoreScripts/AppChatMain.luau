local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local SocialCommon = require(CorePackages.Workspace.Packages.SocialCommon)
local ChatEntryPointNames = SocialCommon.Enums.ChatEntryPointNames

local ApolloClient = require(CoreGui.RobloxGui.Modules.ApolloClient)

local GetFFlagFixSettingshubImportOrder = require(RobloxGui.Modules.Flags.GetFFlagFixSettingshubImportOrder)

local FFlagRemoveLoadingTimeout = require(RobloxGui.Modules.Flags.FFlagRemoveLoadingTimeout)
local Chrome = require(CorePackages.Workspace.Packages.Chrome)
local enabled = Chrome.Enabled()

if GetFFlagFixSettingshubImportOrder() and not (FFlagRemoveLoadingTimeout and enabled) then
	CoreGui:WaitForChild("TopBarApp", FFlagRemoveLoadingTimeout and 1e999 or nil)
end

local SettingsHub = require(RobloxGui.Modules.Settings.SettingsHub)
local ParentContainer = require(CorePackages.Workspace.Packages.AppChat.ParentContainer)
local InExperienceAppChatModal = require(CorePackages.Workspace.Packages.AppChat.InExperienceAppChatModal)

local renderCoreScriptInExperienceAppChat = require(CorePackages.Workspace.Packages.AppChat.renderCoreScriptInExperienceAppChat)
local ViewportUtil = require(RobloxGui.Modules.Chrome.ChromeShared.Service.ViewportUtil)
local ChatSelector = require(RobloxGui.Modules.ChatSelector)
local PlayerListManager = require(RobloxGui.Modules.PlayerList.PlayerListManager)

local Constants = require(RobloxGui.Modules.TopBar.Constants)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled
local ChatChromeIntegration

if enabled then
	ChatChromeIntegration = require(RobloxGui.Modules.Chrome.Integrations.ExpChat.ChatChromeIntegration)
end

local ExpChat = require(CorePackages.Workspace.Packages.ExpChat)
local openConversation = require(CorePackages.Workspace.Packages.FriendsChat.openConversation)
local Promise = require(CorePackages.Packages.Promise)
local engineFeature = game:GetEngineFeature("SSUIMetaLua")

local v = Constants.ApplyDisplayScale(Constants.TopBarTopMargin)

InExperienceAppChatModal.default:initialize(v, SettingsHub, ViewportUtil, ChatSelector, PlayerListManager)

if engineFeature then
	pcall(function()
		local SafetyService = game:GetService("SafetyService")
		InExperienceAppChatModal.default.visibilitySignal.Event:Connect(function(p)
			if p then
				SafetyService:ReportPartyChatWindowOpen()
			else
				SafetyService:ReportPartyChatWindowClose()
			end
		end)
	end)
end

local function fn(p)
	InExperienceAppChatModal:setUnreadCount(p)
end

local chatOpenCapability

if ChatChromeIntegration then
	chatOpenCapability = ChatChromeIntegration.chatOpenCapability
end

local fn2 = not chatOpenCapability and function(_: string)
	return Promise.resolve(false)
end or ParentContainer.createOpenFriendsChatConversation({
	isChatAvailable = chatOpenCapability.isAvailable,
	openConversation = openConversation,
	requestSelectFriendsTab = ExpChat.requestSelectFriendsTab,
	ensureOpenChat = chatOpenCapability.ensureOpenChat
})

renderCoreScriptInExperienceAppChat(ApolloClient, {
	getParentContainer = function()
		return InExperienceAppChatModal.default.frame
	end,
	visibilitySignal = InExperienceAppChatModal.default.visibilitySignal.Event,
	getRequestedRoute = function()
		return InExperienceAppChatModal.default.requestedRoute
	end,
	requestedRouteSignal = InExperienceAppChatModal.default.requestedRouteSignal.Event,
	clearRequestedRoute = function()
		InExperienceAppChatModal.default:clearRequestedRoute()
	end,
	getShouldSetAppChatVisible = function(...)
		return InExperienceAppChatModal:getVisible()
	end,
	entryPoint = ChatEntryPointNames.ChromeDropdown,
	hideParentContainer = function()
		InExperienceAppChatModal.default:setVisible(false)
	end,
	showParentContainer = function()
		InExperienceAppChatModal.default:setVisible(true)
	end,
	updateCurrentSquadId = function(p)
		if GetFFlagIsSquadEnabled() then
			InExperienceAppChatModal:setCurrentSquadId(p)
		end
	end,
	openFriendsChatConversation = fn2
}, fn)
