local Chrome = script:FindFirstAncestor("Chrome")

local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Service = require(Chrome.Service)
local ChromeUtils = require(Chrome.ChromeShared.Service.ChromeUtils)
local ConnectIcon = require(script.Parent.ConnectIcon)
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local InExperienceAppChatModal = require(CorePackages.Workspace.Packages.AppChat.InExperienceAppChatModal)
local ChromeIntegrationUtils = require(Chrome.Integrations.ChromeIntegrationUtils)
local LocalStore = require(Chrome.ChromeShared.Service.LocalStore)

local MappedSignal = ChromeUtils.MappedSignal

local GetFStringConnectTooltipLocalStorageKey = require(Chrome.Flags.GetFStringConnectTooltipLocalStorageKey)

local CoreScriptsCommon = require(CorePackages.Workspace.Packages.CoreScriptsCommon)
local MouseIconOverrideService = CoreScriptsCommon.MouseIconOverrideService
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Symbol = AppCommonLib.Symbol

local Chrome2 = require(CorePackages.Workspace.Packages.Chrome)
local FocusUtils = Chrome2.FocusUtils
local UniversalAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy)

local Chrome3 = require(CorePackages.Workspace.Packages.Chrome)
local SideSheetPlacement = Chrome3.Enums.SideSheetPlacement

local defineFastFlag = game:DefineFastFlag("AppChatInExpUseUnibarNotification", false)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled
local FFlagAppChatDistinctUnibarEntryPoint = SharedFlags.FFlagAppChatDistinctUnibarEntryPoint

local SocialCommon = require(CorePackages.Workspace.Packages.SocialCommon)
local ChatEntryPointNames = SocialCommon.Enums.ChatEntryPointNames

local isActivated = MappedSignal.new(InExperienceAppChatModal.default.visibilitySignal.Event, function()
	return InExperienceAppChatModal:getVisible()
end)

return function(p: string, initialAvailability: number)
	local isSquadIndicatorEnabled

	if p == "connect_unibar" then
		isSquadIndicatorEnabled = GetFFlagIsSquadEnabled()
	else
		isSquadIndicatorEnabled = false
	end

	local chromeUnibar

	if FFlagAppChatDistinctUnibarEntryPoint and p == "connect_unibar" then
		chromeUnibar = ChatEntryPointNames.ChromeUnibar
	else
		chromeUnibar = nil
	end

	local v = {
		id = p,
		sideSheetPlacement = 0,
		label = 0,
		activated = 0,
		isActivated = 0,
		components = 0,
		initialAvailability = 0
	}
	local sideSheetPlacement

	if p == "connect_unibar" then
		sideSheetPlacement = SideSheetPlacement.Unibar
	else
		sideSheetPlacement = SideSheetPlacement.BelowFold
	end

	v.sideSheetPlacement = sideSheetPlacement
	v.label = UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTerminology()
		and "Feature.Chat.Title.FriendsChat"
		or "Feature.Squads.Label.Party"

	function v.activated()
		if InExperienceAppChatModal:getVisible() then
			InExperienceAppChatModal.default:setVisible(false)
		else
			ChromeIntegrationUtils.dismissRobloxMenuAndRun(function()
				if Responsive.GetInputModeStore(false).getLastInputType(false) == Responsive.Input.Directional then
					FocusUtils.FocusOffChrome()
				end

				InExperienceAppChatModal.default:setVisible(true, chromeUnibar)
			end)
		end

		LocalStore.storeForLocalPlayer(GetFStringConnectTooltipLocalStorageKey(), true)
	end
	v.isActivated = isActivated
	v.components = {
		Icon = function(p2)
			return React.createElement(ConnectIcon, {
				integrationId = p,
				isIconVisible = p2.visible,
				shouldShowCustomBadge = not defineFastFlag,
				isSquadIndicatorEnabled = isSquadIndicatorEnabled
			})
		end
	}

	v.initialAvailability = initialAvailability
	local v2 = Service:register(v)

	if defineFastFlag then
		if isSquadIndicatorEnabled then
			local function updateNotificationBadge(p2: number, flag: boolean) -- 3 equivalent calls inferred from this helper
				if p2 == 0 or flag then
					v2.notification:clear()
				else
					v2.notification:fireCount(p2)
				end
			end

			InExperienceAppChatModal.default.currentSquadIdSignal.Event:Connect(function(p2)
				updateNotificationBadge(InExperienceAppChatModal.default.unreadCount, p2 ~= "") -- inferred equivalent call
			end)

			InExperienceAppChatModal.default.unreadCountSignal.Event:Connect(function(p2)
				updateNotificationBadge(p2, InExperienceAppChatModal.default.currentSquadId ~= "") -- inferred equivalent call
			end)

			updateNotificationBadge( -- inferred equivalent call
				InExperienceAppChatModal.default.unreadCount,
				InExperienceAppChatModal.default.currentSquadId ~= ""
			)
		else
			local function updateUnreadMessageCount(p2) -- 2 equivalent calls inferred from this helper
				if p2 == 0 then
					v2.notification:clear()
				else
					v2.notification:fireCount(p2)
				end
			end

			InExperienceAppChatModal.default.unreadCountSignal.Event:Connect(function(p2)
				if p2 == 0 then
					updateUnreadMessageCount(0) -- inferred equivalent call
				else
					v2.notification:fireCount(p2)
				end
			end)

			local unreadCount = InExperienceAppChatModal.default.unreadCount

			if unreadCount == 0 then
				updateUnreadMessageCount(0) -- inferred equivalent call
			else
				v2.notification:fireCount(unreadCount)
			end
		end
	end

	local named = Symbol.named("InExperienceRobloxConnect")
	InExperienceAppChatModal.default.visibilitySignal.Event:Connect(function(p2)
		if p2 then
			MouseIconOverrideService.push(named, Enum.OverrideMouseIconBehavior.ForceShow)
		else
			MouseIconOverrideService.pop(named)
		end
	end)

	return v2
end
