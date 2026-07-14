local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local ChatEntryPointNames = require(CorePackages.Workspace.Packages.SocialCommon).Enums.ChatEntryPointNames
local ApolloClient = require(CoreGui.RobloxGui.Modules.ApolloClient)
local GetFFlagFixSettingshubImportOrder = require(RobloxGui.Modules.Flags.GetFFlagFixSettingshubImportOrder)
local FFlagRemoveLoadingTimeout = require(RobloxGui.Modules.Flags.FFlagRemoveLoadingTimeout)
local v8 = require(CorePackages.Workspace.Packages.Chrome).Enabled()

if GetFFlagFixSettingshubImportOrder() and (not FFlagRemoveLoadingTimeout or not v8) then
	CoreGui:WaitForChild("TopBarApp", if not FFlagRemoveLoadingTimeout then nil else 1e999)
end

local SettingsHub = require(RobloxGui.Modules.Settings.SettingsHub)

require(CorePackages.Workspace.Packages.AppChat.ParentContainer)

local InExperienceAppChatModal = require(CorePackages.Workspace.Packages.AppChat.InExperienceAppChatModal)
local renderCoreScriptInExperienceAppChat = require(CorePackages.Workspace.Packages.AppChat.renderCoreScriptInExperienceAppChat)
local ViewportUtil = require(RobloxGui.Modules.Chrome.ChromeShared.Service.ViewportUtil)
local ChatSelector = require(RobloxGui.Modules.ChatSelector)
local PlayerListManager = require(RobloxGui.Modules.PlayerList.PlayerListManager)
local Constants = require(RobloxGui.Modules.TopBar.Constants)
local GetFFlagIsSquadEnabled = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagIsSquadEnabled
local EngineFeature = game:GetEngineFeature("SSUIMetaLua")
local v18 = Constants.ApplyDisplayScale(Constants.TopBarTopMargin)

InExperienceAppChatModal.default:initialize(v18, SettingsHub, ViewportUtil, ChatSelector, PlayerListManager)

if EngineFeature then
	pcall(function() -- line: 38
		-- upvalues: InExperienceAppChatModal (copy)
		local SafetyService = game:GetService("SafetyService")

		InExperienceAppChatModal.default.visibilitySignal.Event:Connect(function(p1) -- line: 40
			-- upvalues: SafetyService (copy)
			if p1 then
				SafetyService:ReportPartyChatWindowOpen()

				return
			end

			SafetyService:ReportPartyChatWindowClose()
		end)
	end)
end

renderCoreScriptInExperienceAppChat(ApolloClient, {
	getParentContainer = function() -- line: 55
		-- upvalues: InExperienceAppChatModal (copy)
		return InExperienceAppChatModal.default.frame
	end,
	visibilitySignal = InExperienceAppChatModal.default.visibilitySignal.Event,
	getRequestedRoute = function() -- line: 59
		-- upvalues: InExperienceAppChatModal (copy)
		return InExperienceAppChatModal.default.requestedRoute
	end,
	requestedRouteSignal = InExperienceAppChatModal.default.requestedRouteSignal.Event,
	clearRequestedRoute = function() -- line: 63
		-- upvalues: InExperienceAppChatModal (copy)
		InExperienceAppChatModal.default:clearRequestedRoute()
	end,
	getShouldSetAppChatVisible = function(...) -- line: 66
		-- upvalues: InExperienceAppChatModal (copy)
		return InExperienceAppChatModal:getVisible()
	end,
	entryPoint = ChatEntryPointNames.ChromeDropdown,
	hideParentContainer = function() -- line: 71
		-- upvalues: InExperienceAppChatModal (copy)
		InExperienceAppChatModal.default:setVisible(false)
	end,
	showParentContainer = function() -- line: 74
		-- upvalues: InExperienceAppChatModal (copy)
		InExperienceAppChatModal.default:setVisible(true)
	end,
	updateCurrentSquadId = function(p2) -- line: 77
		-- upvalues: GetFFlagIsSquadEnabled (copy), InExperienceAppChatModal (copy)
		if GetFFlagIsSquadEnabled() then
			InExperienceAppChatModal:setCurrentSquadId(p2)
		end
	end
}, function(p3) -- line: 50
	-- upvalues: InExperienceAppChatModal (copy)
	InExperienceAppChatModal:setUnreadCount(p3)
end)
