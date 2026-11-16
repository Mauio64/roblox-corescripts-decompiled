local Chrome = script:FindFirstAncestor("Chrome")

local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local TextChatService = game:GetService("TextChatService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local Chat = game:GetService("Chat")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Constants = require(Chrome.ChromeShared.Unibar.Constants)
local ChromeIntegrationUtils = require(Chrome.Integrations.ChromeIntegrationUtils)
local Service = require(Chrome.Service)
local ChromeUtils = require(Chrome.ChromeShared.Service.ChromeUtils)
local CommonIcon = require(Chrome.Integrations.CommonIcon)
local FocusSelectExpChat = require(Chrome.ChromeShared.Utility.FocusSelectExpChat)
local ViewportUtil = require(Chrome.ChromeShared.Service.ViewportUtil)
local MappedSignal = ChromeUtils.MappedSignal
local gameSettings = UserSettings().GameSettings
local GuiService = game:GetService("GuiService")
local InputUi = require(CorePackages.Workspace.Packages.InputUi)
local GamepadUtils = InputUi.Gamepad.GamepadUtils
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local isSpatial = AppCommonLib.isSpatial
local ChatIconVisibleSignals = require(script.Parent.ChatIconVisibleSignals)
local default = ChatIconVisibleSignals.default
local SignalsUtils = require(CorePackages.Workspace.Packages.SignalsUtils)
local React = require(CorePackages.Packages.React)
local SignalsReact = require(CorePackages.Packages.SignalsReact)

local Chrome2 = require(CorePackages.Workspace.Packages.Chrome)
local UnibarStyle = Chrome2.UnibarStyle

local Flags = require(Chrome.ChromeShared.Flags)
local FFlagTokenizeUnibarConstantsWithStyleProvider = Flags.FFlagTokenizeUnibarConstantsWithStyleProvider
local SideSheetPlacement = Chrome2.Enums.SideSheetPlacement

local FFlagDebugDisableExperienceChatMain = require(RobloxGui.Modules.Flags.FFlagDebugDisableExperienceChatMain)

if FFlagDebugDisableExperienceChatMain then
	return nil
end

local ExpChat = require(CorePackages.Workspace.Packages.ExpChat)
local focusNavigationStore = ExpChat.Stores.GetFocusNavigationStore(false)
local GetMessagesStore = ExpChat.Stores.GetMessagesStore
local shouldSkipHistoricalMessage = ExpChat.shouldSkipHistoricalMessage
local isHistoricalMessage = ExpChat.isHistoricalMessage
local shouldSuppressUnreadForTabMetadata = ExpChat.shouldSuppressUnreadForTabMetadata

local GetFriendsChatIconUnreadStore = require(CorePackages.Workspace.Packages.FriendsChat.GetFriendsChatIconUnreadStore)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls
local FFlagExpChatWindowSyncUnibar = SharedFlags.FFlagExpChatWindowSyncUnibar
local FFlagExpChatInitializeWindowFromGameSettings = SharedFlags.FFlagExpChatInitializeWindowFromGameSettings
local FFlagRemoveFriendsChatUnibarEntrypoints = SharedFlags.FFlagRemoveFriendsChatUnibarEntrypoints
local FFlagExpChatEnableFriendsTab = SharedFlags.FFlagExpChatEnableFriendsTab
local FFlagExpChatCanShowFriendsTab = SharedFlags.FFlagExpChatCanShowFriendsTab
local FFlagExpChatHistoricalMessagesUnibarUnread = SharedFlags.FFlagExpChatHistoricalMessagesUnibarUnread
local FFlagExpChatContinuousListeningChatIconDot = SharedFlags.FFlagExpChatContinuousListeningChatIconDot
local RedDot

if FFlagExpChatContinuousListeningChatIconDot then
	RedDot = require(Chrome.Integrations.RedDot)
else
	RedDot = nil
end

local getDictationStateStore

if FFlagExpChatContinuousListeningChatIconDot then
	getDictationStateStore = ExpChat.Stores.GetDictationStateStore
else
	getDictationStateStore = nil
end

local InExperienceAppChatModal = require(CorePackages.Workspace.Packages.AppChat.InExperienceAppChatModal)

local ChatSelector = require(RobloxGui.Modules.ChatSelector)
local ExpChat2 = require(CorePackages.Workspace.Packages.ExpChat)
local getExperienceChatVisualConfig = ExpChat2.getExperienceChatVisualConfig
local ExpChatShared = require(CorePackages.Workspace.Packages.ExpChatShared)
local GetFFlagTextChatEnableUniverseChatTabs = ExpChatShared.Flags.GetFFlagTextChatEnableUniverseChatTabs
local shouldRenderTextChannelInDefaultWindow = ExpChatShared.shouldRenderTextChannelInDefaultWindow
local getTextChannelDisplayMode = ExpChatShared.getTextChannelDisplayMode

local defineFastFlag = game:DefineFastFlag("ExpChatSuppressWelcomeMessageUnibarUnread", false)
local defineFastFlag2 = game:DefineFastFlag("ExpChatUnibarAvailabilityRefactor", false)

local SharedExperimentDefinition = require(CorePackages.Workspace.Packages.SharedExperimentDefinition)
local isInExperienceUIVREnabled = SharedExperimentDefinition.isInExperienceUIVREnabled
local SharedExperimentDefinition2 = require(CorePackages.Workspace.Packages.SharedExperimentDefinition)
local InExperienceUIVRIXP = SharedExperimentDefinition2.InExperienceUIVRIXP
local ExpChatPerfTracker = ExpChat.ExpChatPerfTracker

local total = 0
local v

if FFlagExpChatInitializeWindowFromGameSettings then
	v = gameSettings.ChatVisible
	ChatSelector:SetVisible(v)
else
	v = ChatSelector:GetVisibility()
end

local v2 = nil

local VisibilityStateChanged = ChatSelector.VisibilityStateChanged

local v3 = 0
local v4 = false

local function readHistoricalWindowMessageCount(p) -- 3 equivalent calls inferred from this helper
	local getHistoricalWindowMessageCount = GetMessagesStore(p).getHistoricalWindowMessageCount

	if getHistoricalWindowMessageCount then
		return (getHistoricalWindowMessageCount(p))
	end

	return 0
end

local function getHistoricalUnreadCount() -- 1 equivalent call inferred from this helper
	local historicalWindowMessageCount = readHistoricalWindowMessageCount(false) -- inferred equivalent call
	v3 = math.min(v3, historicalWindowMessageCount)
	return historicalWindowMessageCount - v3
end

local function acknowledgeHistoricalMessages() -- 3 equivalent calls inferred from this helper
	v3 = readHistoricalWindowMessageCount(false) -- inferred equivalent call
end

local function updateUnreadNotification()
	if not v2.notification then
		return
	end

	local v5

	if FFlagExpChatHistoricalMessagesUnibarUnread then
		v5 = getHistoricalUnreadCount() -- inferred equivalent call
	else
		v5 = 0
	end

	if not FFlagExpChatEnableFriendsTab then
		v2.notification:fireCount(total + v5)
		return
	end

	local unreadCountToDisplay = GetFriendsChatIconUnreadStore(false).getUnreadCountToDisplay(false)
	local v6 = total + unreadCountToDisplay + v5

	if v or v6 == 0 then
		v2.notification:clear()
	else
		v2.notification:fireCount(v6)
	end
end

local function localUserCanChat()
	if RunService:IsStudio() then
		return true
	end

	local success, result = pcall(function()
		return Chat:CanUserChatAsync(Players.LocalPlayer and Players.LocalPlayer.UserId or 0)
	end)

	return success and result
end

if not FFlagExpChatWindowSyncUnibar then
	VisibilityStateChanged:connect(function(p)
		if defineFastFlag2 then
			default.setVisibleViaChatSelector(p)
		elseif p then
			v2.availability:pinned()
		end
	end)

	ChatSelector.ChatWindowToggled:connect(function(p)
		if defineFastFlag2 then
			default.setVisibleViaChatSelector(p)
		elseif p then
			v2.availability:pinned()
		end
	end)
end

if FFlagExpChatWindowSyncUnibar then
	gameSettings:GetPropertyChangedSignal("ChatVisible"):Connect(function()
		default.setGameSettingsChatVisible(gameSettings.ChatVisible)
	end)
	default.setGameSettingsChatVisible(gameSettings.ChatVisible)
end

local isActivated = MappedSignal.new(VisibilityStateChanged, function()
	return v
end, function()
	local visibility = ChatSelector.GetVisibility()

	if not (defineFastFlag2 or visibility) then
		local v5

		if RunService:IsStudio() then
			v5 = true
		else
			local success, result = pcall(function()
				return Chat:CanUserChatAsync(Players.LocalPlayer and Players.LocalPlayer.UserId or 0)
			end)
			v5 = success and result
		end

		if not v5 then
			v2.availability:unavailable()
		end
	end

	if not GuiService.MenuIsOpen then
		gameSettings.ChatVisible = visibility
	end

	v = visibility
	v4 = true

	if FFlagExpChatEnableFriendsTab then
		if visibility then
			total = 0

			if FFlagExpChatHistoricalMessagesUnibarUnread then
				acknowledgeHistoricalMessages() -- inferred equivalent call
			end

			GetFriendsChatIconUnreadStore(false).clearDisplayCount()
		end

		updateUnreadNotification()
	elseif visibility and total and v2.notification then
		total = 0

		if FFlagExpChatHistoricalMessagesUnibarUnread then
			acknowledgeHistoricalMessages() -- inferred equivalent call
		end

		v2.notification:clear()
	end
end)

local function hideAppChat() -- 2 equivalent calls inferred from this helper
	if not InExperienceAppChatModal:getVisible() then
		return
	end

	InExperienceAppChatModal.default:setVisible(false)
end

local function revealChat() -- 2 equivalent calls inferred from this helper
	hideAppChat() -- inferred equivalent call
	ChatSelector:SetVisible(true)

	if FFlagEnableConsoleExpControls then
		FocusSelectExpChat(v2.id)
	end
end

local function isChatOpenAvailable(): boolean -- 1 equivalent call inferred from this helper
	return v2.availability:get() ~= Service.AvailabilitySignal.Unavailable
end

local function isSpatialDirectOpen() -- 2 equivalent calls inferred from this helper
	return isInExperienceUIVREnabled and isSpatial() and not InExperienceUIVRIXP:isMovePanelToCenter()
end

local function ensureOpenChat(callback)
	if v then
		hideAppChat() -- inferred equivalent call
	elseif isSpatialDirectOpen() then -- inferred equivalent call
		revealChat() -- inferred equivalent call
	else
		ChromeIntegrationUtils.dismissRobloxMenuAndRun(function()
			if callback() and isChatOpenAvailable() then -- inferred equivalent call
				revealChat() -- inferred equivalent call
			end
		end)
	end
end

local sideSheetPlacement

if FFlagRemoveFriendsChatUnibarEntrypoints and FFlagExpChatCanShowFriendsTab then
	sideSheetPlacement = SideSheetPlacement.Unibar
else
	sideSheetPlacement = SideSheetPlacement.None
end

v2 = Service:register({
	id = "chat",
	label = "CoreScripts.TopBar.Chat",
	sideSheetPlacement = sideSheetPlacement,
	activated = function(_)
		if v then
			ChatSelector:SetVisible(false)
			return
		end

		ExpChatPerfTracker.start(ExpChatPerfTracker.Events.ChatWindowMountTTI, {})

		if isSpatialDirectOpen() then -- inferred equivalent call
			ChatSelector:SetVisible(true)
		else
			ChromeIntegrationUtils.dismissRobloxMenuAndRun(function()
				if InExperienceAppChatModal:getVisible() then
					InExperienceAppChatModal.default:setVisible(false)
				end

				ChatSelector:SetVisible(true)

				if FFlagEnableConsoleExpControls then
					FocusSelectExpChat(v2.id)
				end
			end)
		end
	end,
	isActivated = isActivated,
	selected = FFlagEnableConsoleExpControls and function(p)
		local connection = nil
		local inputChangedConnection = nil
		local inputBeganConnection = nil

		connection = Service:selectedItem():connect(function(p2)
			assert(p2 ~= p.id, "Expected selectedId to not be self.id on selection")

			connection:disconnect()

			inputChangedConnection:Disconnect()
			inputBeganConnection:Disconnect()
		end)

		inputChangedConnection = UserInputService.InputChanged:Connect(function(input)
			if
				input.KeyCode == Enum.KeyCode.Thumbstick1
				and GamepadUtils.mapPositionToDirection(Vector2.new(input.Position.X, input.Position.Y)) == Enum.KeyCode.Down
			then
				FocusSelectExpChat(v2.id)
			end
		end)

		inputBeganConnection = UserInputService.InputBegan:Connect(function(input)
			local keyCode = input.KeyCode

			if keyCode == Enum.KeyCode.DPadDown or keyCode == Enum.KeyCode.Down then
				FocusSelectExpChat(v2.id)
			end
		end)
	end or nil,
	components = {
		Icon = function(_)
			local experienceChatVisualConfig = getExperienceChatVisualConfig()
			local icon = CommonIcon(
				experienceChatVisualConfig.icon.off,
				experienceChatVisualConfig.icon.on,
				isActivated
			)

			if not FFlagExpChatContinuousListeningChatIconDot then
				return icon
			end

			local ICON_SIZE

			if FFlagTokenizeUnibarConstantsWithStyleProvider then
				ICON_SIZE = UnibarStyle.use().ICON_SIZE
			else
				ICON_SIZE = Constants.ICON_SIZE
			end

			local visible = SignalsReact.useSignalState(getDictationStateStore(false).getIsListening)

			return React.createElement(
				"Frame",
				{
					Size = UDim2.fromOffset(ICON_SIZE, ICON_SIZE),
					BackgroundTransparency = 1
				},
				{
					Icon = icon,
					ListeningDot = React.createElement(RedDot, {
						position = UDim2.new(1, -7, 1, -7),
						visible = visible
					})
				}
			)
		end
	}
})

v2.chatOpenCapability = FFlagExpChatEnableFriendsTab
	and { isAvailable = isChatOpenAvailable, ensureOpenChat = ensureOpenChat }
	or nil

if defineFastFlag2 then
	SignalsUtils.createDetachedEffect(function(p)
		if default.getIsChatIconVisible(p) then
			v2.availability:available()
		else
			v2.availability:unavailable()
		end

		if FFlagExpChatWindowSyncUnibar then
			local isChatWindowVisible = default.getIsChatWindowVisible(p)

			ExpChat.Events.ChatTopBarButtonActivated(isChatWindowVisible)
		end
	end)

	ChromeUtils.setCoreGuiAvailability(v2, Enum.CoreGuiType.Chat, function(p)
		default.setCoreGuiEnabled(p)
	end)
end

if FFlagEnableConsoleExpControls then
	SignalsUtils.createDetachedEffect(function(p)
		if focusNavigationStore.getChatInputBarFocused(p) then
			Service:setShortcutBar(Constants.UNIBAR_SHORTCUTBAR_ID)
		else
			Service:setShortcutBar(nil)
		end
	end)
end

if FFlagExpChatEnableFriendsTab then
	SignalsUtils.createDetachedEffect(function(p)
		GetFriendsChatIconUnreadStore(p).getUnreadCountToDisplay(p)
		updateUnreadNotification()
	end)
end

if FFlagExpChatHistoricalMessagesUnibarUnread then
	SignalsUtils.createDetachedEffect(function(p)
		readHistoricalWindowMessageCount(p) -- inferred equivalent call

		if v4 and v then
			acknowledgeHistoricalMessages() -- inferred equivalent call
		end

		updateUnreadNotification()
	end)
end

local function shouldIgnoreUnreadForMessage(p) -- 2 equivalent calls inferred from this helper
	if FFlagExpChatHistoricalMessagesUnibarUnread and isHistoricalMessage(p) then
		return true
	end

	return p ~= nil and shouldSkipHistoricalMessage(p)
		or defineFastFlag and shouldSuppressUnreadForTabMetadata(p and p.Metadata)
end

TextChatService.MessageReceived:Connect(function(p)
	local textChannelDisplayMode = getTextChannelDisplayMode()

	if
		not shouldRenderTextChannelInDefaultWindow(p.TextChannel, textChannelDisplayMode)
		or shouldIgnoreUnreadForMessage(p) -- inferred equivalent call
	then
		return
	end

	if not v then
		total += 1
		updateUnreadNotification()
	end
end)

if GetFFlagTextChatEnableUniverseChatTabs() then
	TextChatService.UniverseChatMessageReceived:Connect(function(p)
		if shouldIgnoreUnreadForMessage(p) then -- inferred equivalent call
			return
		end

		if not v then
			total += 1
			updateUnreadNotification()
		end
	end)
end

local v5 = 0
ChatSelector.MessagesChanged:connect(function(p: number)
	if not v then
		total += p - v5
		updateUnreadNotification()
	end

	v5 = p
end)

if not FFlagExpChatWindowSyncUnibar then
	ChatSelector.ChatActiveChanged:connect(function(flag: boolean)
		if defineFastFlag2 then
			default.setChatActiveCalledByDeveloper(flag)
		elseif flag then
			local v6

			if RunService:IsStudio() then
				v6 = true
			else
				local success, result = pcall(function()
					return Chat:CanUserChatAsync(Players.LocalPlayer and Players.LocalPlayer.UserId or 0)
				end)
				v6 = success and result
			end

			if not v6 then
				v2.availability:available()
			end
		end
	end)
end

local function setChatVisibilityOnLoad() -- 1 equivalent call inferred from this helper
	local v6 = gameSettings.ChatVisible

	if ViewportUtil.isSmallTouchScreen() then
		v6 = false
	end

	v = v6
	ChatSelector:SetVisible(v6)
end

coroutine.wrap(function()
	local localPlayer = Players.LocalPlayer

	while not localPlayer do
		Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
		localPlayer = Players.LocalPlayer
	end

	local v6

	if RunService:IsStudio() then
		v6 = true
	else
		local success, result = pcall(function()
			return Chat:CanUserChatAsync(Players.LocalPlayer and Players.LocalPlayer.UserId or 0)
		end)
		v6 = success and result
	end

	if defineFastFlag2 then
		default.setLocalUserChat(v6)

		if v6 then
			setChatVisibilityOnLoad() -- inferred equivalent call
		end
	elseif v6 and v2.availability then
		ChromeUtils.setCoreGuiAvailability(v2, Enum.CoreGuiType.Chat, function(p)
			if p then
				v2.availability:pinned()
			else
				v2.availability:unavailable()
			end
		end)

		local v7 = gameSettings.ChatVisible

		if ViewportUtil.isSmallTouchScreen() then
			v7 = false
		end

		v = v7
		ChatSelector:SetVisible(v7)
	end
end)()

function _simulateChat()
	while true do
		task.wait(math.random(1, 15))

		if v then
			continue
		end

		total += 1
		updateUnreadNotification()
	end
end

return v2
