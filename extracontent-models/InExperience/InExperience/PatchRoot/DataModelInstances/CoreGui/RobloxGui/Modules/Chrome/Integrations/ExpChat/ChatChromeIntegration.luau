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
local FFlagChatIntegrationFixShortcut = require(Chrome.Flags.FFlagChatIntegrationFixShortcut)
local FocusSelectExpChat = require(Chrome.ChromeShared.Utility.FocusSelectExpChat)
local ViewportUtil = require(Chrome.ChromeShared.Service.ViewportUtil)
local MappedSignal = ChromeUtils.MappedSignal
local GameSettings = UserSettings().GameSettings
local GuiService = game:GetService("GuiService")
local GamepadUtils = require(CorePackages.Workspace.Packages.InputUi).Gamepad.GamepadUtils
local isSpatial = require(CorePackages.Workspace.Packages.AppCommonLib).isSpatial
local default = require(script.Parent.ChatIconVisibleSignals).default
local SignalsRoblox = require(CorePackages.Packages.SignalsRoblox)
local SideSheetPlacement = require(CorePackages.Workspace.Packages.Chrome).Enums.SideSheetPlacement
local ExpChat = require(CorePackages.Workspace.Packages.ExpChat)
local v27 = ExpChat.Stores.GetFocusNavigationStore(false)
local shouldSuppressUnreadForTabMetadata = ExpChat.shouldSuppressUnreadForTabMetadata
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls
local FFlagExpChatWindowSyncUnibar = SharedFlags.FFlagExpChatWindowSyncUnibar
local FFlagChromeActivatedMappedSignal = SharedFlags.FFlagChromeActivatedMappedSignal
local FFlagRemoveFriendsChatUnibarEntrypoints = SharedFlags.FFlagRemoveFriendsChatUnibarEntrypoints
local FFlagExpChatEnableFriendsTab = SharedFlags.FFlagExpChatEnableFriendsTab
local InExperienceAppChatModal = require(CorePackages.Workspace.Packages.AppChat.InExperienceAppChatModal)
local ChatSelector = require(RobloxGui.Modules.ChatSelector)
local getExperienceChatVisualConfig = require(CorePackages.Workspace.Packages.ExpChat).getExperienceChatVisualConfig
local GetFFlagTextChatEnableUniverseChatTabs = require(CorePackages.Workspace.Packages.ExpChatShared).Flags.GetFFlagTextChatEnableUniverseChatTabs
local v39 = game:DefineFastFlag("ExpChatSuppressWelcomeMessageUnibarUnread", false)
local v40 = game:DefineFastFlag("ExpChatUnibarThumbstickNavigate", false)
local v41 = game:DefineFastFlag("ExpChatUnibarAvailabilityRefactor", false)
local isInExperienceUIVREnabled = require(CorePackages.Workspace.Packages.SharedExperimentDefinition).isInExperienceUIVREnabled
local InExperienceUIVRIXP = require(CorePackages.Workspace.Packages.SharedExperimentDefinition).InExperienceUIVRIXP
local FFlagExpChatPerfTracking = SharedFlags.FFlagExpChatPerfTracking
local ExpChatPerfTracker = ExpChat.ExpChatPerfTracker
local ArgoPartyExperimentation = require(CorePackages.Workspace.Packages.SocialExperiments).ArgoPartyExperimentation
local n1 = 0
local n2 = 0
local Visibility = ChatSelector:GetVisibility()
local u50 = nil
local VisibilityStateChanged = ChatSelector.VisibilityStateChanged

local function updateUnreadNotification() -- line: 67
	-- upvalues: u50 (ref), FFlagExpChatEnableFriendsTab (copy), n1 (ref), n2 (ref), Visibility (ref)
	if not u50.notification then
		return
	end

	if not FFlagExpChatEnableFriendsTab then
		u50.notification:fireCount(n1)

		return
	end

	local v60 = n1 + n2

	if Visibility or v60 == 0 then
		u50.notification:clear()

		return
	end

	u50.notification:fireCount(v60)
end
local function localUserCanChat() -- line: 85
	-- upvalues: RunService (copy), Chat (copy), Players (copy)
	if not RunService:IsStudio() then
		local ok, result = pcall(function() -- line: 87
			-- upvalues: Chat (copy), Players (copy)
			return Chat:CanUserChatAsync(Players.LocalPlayer and Players.LocalPlayer.UserId or 0)
		end)

		return ok and result
	end

	return true
end

if not FFlagExpChatWindowSyncUnibar then
	VisibilityStateChanged:connect(function(p1) -- line: 98
		-- upvalues: v41 (copy), default (copy), u50 (ref)
		if v41 then
			default.setVisibleViaChatSelector(p1)

			return
		end

		if p1 then
			u50.availability:pinned()
		end
	end)
	ChatSelector.ChatWindowToggled:connect(function(p2) -- line: 109
		-- upvalues: v41 (copy), default (copy), u50 (ref)
		if v41 then
			default.setVisibleViaChatSelector(p2)

			return
		end

		if p2 then
			u50.availability:pinned()
		end
	end)
end

if FFlagExpChatWindowSyncUnibar then
	GameSettings:GetPropertyChangedSignal("ChatVisible"):Connect(function() -- line: 123
		-- upvalues: default (copy), GameSettings (copy)
		default.setGameSettingsChatVisible(GameSettings.ChatVisible)
	end)
	default.setGameSettingsChatVisible(GameSettings.ChatVisible)
end

local v54 = MappedSignal.new(VisibilityStateChanged, function() -- line: 129
	-- upvalues: Visibility (ref)
	return Visibility
end, function() -- line: 131
	-- upvalues: ChatSelector (copy), v41 (copy), RunService (copy), Chat (copy), Players (copy), u50 (ref), GuiService (copy), GameSettings (copy), Visibility (ref), FFlagExpChatEnableFriendsTab (copy), n1 (ref), n2 (ref)
	local v65 = ChatSelector.GetVisibility()

	if not v41 and not v65 then
		local v68

		if not RunService:IsStudio() then
			local ok, result = pcall(function() -- line: 87
				-- upvalues: Chat (copy), Players (copy)
				return Chat:CanUserChatAsync(Players.LocalPlayer and Players.LocalPlayer.UserId or 0)
			end)

			v68 = ok and result
		else
			v68 = true
		end

		if not v68 then
			u50.availability:unavailable()
		end
	end

	if not GuiService.MenuIsOpen then
		GameSettings.ChatVisible = v65
	end

	Visibility = v65

	if FFlagExpChatEnableFriendsTab then
		if v65 then
			n1 = 0
		end

		if not u50.notification then
			return
		end

		if not FFlagExpChatEnableFriendsTab then
			u50.notification:fireCount(n1)

			return
		end

		local v69 = n1 + n2

		if Visibility or v69 == 0 then
			u50.notification:clear()

			return
		end

		u50.notification:fireCount(v69)

		return
	end

	if v65 and n1 and u50.notification then
		n1 = 0
		u50.notification:clear()
	end
end)

u50 = Service:register({
	id = "chat",
	label = "CoreScripts.TopBar.Chat",
	sideSheetPlacement = if not ArgoPartyExperimentation.getIsRenameEnabled() or not not FFlagRemoveFriendsChatUnibarEntrypoints and FFlagExpChatEnableFriendsTab then SideSheetPlacement.Unibar else SideSheetPlacement.None,
	activated = function(_) -- line: 177
		-- upvalues: Visibility (ref), ChatSelector (copy), FFlagExpChatPerfTracking (copy), ExpChatPerfTracker (copy), isInExperienceUIVREnabled (copy), isSpatial (copy), InExperienceUIVRIXP (copy), ChromeIntegrationUtils (copy), InExperienceAppChatModal (copy), FFlagEnableConsoleExpControls (copy), FocusSelectExpChat (copy), u50 (ref)
		if Visibility then
			ChatSelector:SetVisible(false)

			return
		end

		if FFlagExpChatPerfTracking then
			ExpChatPerfTracker.start(ExpChatPerfTracker.Events.ChatWindowMountTTI, {})
		end

		if isInExperienceUIVREnabled and isSpatial() and not InExperienceUIVRIXP:isMovePanelToCenter() then
			ChatSelector:SetVisible(true)

			return
		end

		ChromeIntegrationUtils.dismissRobloxMenuAndRun(function() -- line: 187
			-- upvalues: InExperienceAppChatModal (copy), ChatSelector (copy), FFlagEnableConsoleExpControls (copy), FocusSelectExpChat (copy), u50 (ref)
			if InExperienceAppChatModal:getVisible() then
				InExperienceAppChatModal.default:setVisible(false)
			end

			ChatSelector:SetVisible(true)

			if FFlagEnableConsoleExpControls then
				FocusSelectExpChat(u50.id)
			end
		end)
	end,
	isActivated = not FFlagChromeActivatedMappedSignal and function() -- line: 195
		-- upvalues: v54 (copy)
		return v54:get()
	end or v54,
	selected = if not FFlagEnableConsoleExpControls then nil else function(p4) -- line: 199
		-- upvalues: v40 (copy), Service (copy), UserInputService (copy), GamepadUtils (copy), FocusSelectExpChat (copy), u50 (ref)
		if v40 then
			local u72 = nil
			local connection = nil
			local connection2 = nil

			u72 = Service:selectedItem():connect(function(p5) -- line: 205
				-- upvalues: p4 (copy), u72 (ref), connection (ref), connection2 (ref)
				assert(p5 ~= p4.id, "Expected selectedId to not be self.id on selection")
				u72:disconnect()
				connection:Disconnect()
				connection2:Disconnect()
			end)
			connection = UserInputService.InputChanged:Connect(function(input) -- line: 215
				-- upvalues: GamepadUtils (copy), FocusSelectExpChat (copy), u50 (ref)
				if input.KeyCode == Enum.KeyCode.Thumbstick1 and GamepadUtils.mapPositionToDirection(Vector2.new(input.Position.X, input.Position.Y)) == Enum.KeyCode.Down then
					FocusSelectExpChat(u50.id)
				end
			end)
			connection2 = UserInputService.InputBegan:Connect(function(input) -- line: 224
				-- upvalues: FocusSelectExpChat (copy), u50 (ref)
				local KeyCode = input.KeyCode

				if KeyCode == Enum.KeyCode.DPadDown or KeyCode == Enum.KeyCode.Down then
					FocusSelectExpChat(u50.id)
				end
			end)

			return
		end

		local connection = nil

		connection = UserInputService.InputEnded:Connect(function(input) -- line: 232
			-- upvalues: FocusSelectExpChat (copy), u50 (ref), connection (ref), Service (copy), p4 (copy)
			if input.KeyCode == Enum.KeyCode.DPadDown then
				FocusSelectExpChat(u50.id)
			end

			if connection and Service:selectedItem():get() ~= p4.id then
				connection:Disconnect()
			end
		end)
	end,
	components = {
		Icon = function(_) -- line: 245
			-- upvalues: getExperienceChatVisualConfig (copy), CommonIcon (copy), v54 (copy)
			local v77 = getExperienceChatVisualConfig()

			return CommonIcon(v77.icon.off, v77.icon.on, v54)
		end
	}
})

if v41 then
	SignalsRoblox.createDetachedEffect(function(p7) -- line: 256
		-- upvalues: default (copy), u50 (ref), FFlagExpChatWindowSyncUnibar (copy), ExpChat (copy)
		if default.getIsChatIconVisible(p7) then
			u50.availability:available()
		else
			u50.availability:unavailable()
		end

		if FFlagExpChatWindowSyncUnibar then
			local v79 = default.getIsChatWindowVisible(p7)

			ExpChat.Events.ChatTopBarButtonActivated(v79)
		end
	end)
	ChromeUtils.setCoreGuiAvailability(u50, Enum.CoreGuiType.Chat, function(p8) -- line: 273
		-- upvalues: default (copy)
		default.setCoreGuiEnabled(p8)
	end)
end

if FFlagChatIntegrationFixShortcut and FFlagEnableConsoleExpControls then
	SignalsRoblox.createDetachedEffect(function(p9) -- line: 279
		-- upvalues: v27 (copy), Service (copy), Constants (copy)
		if v27.getChatInputBarFocused(p9) then
			Service:setShortcutBar(Constants.UNIBAR_SHORTCUTBAR_ID)

			return
		end

		Service:setShortcutBar(nil)
	end)
end

if FFlagExpChatEnableFriendsTab then
	local function updateFriendsChatUnreadMessages(n3: number?) -- line: 290
		-- upvalues: n2 (ref), u50 (ref), FFlagExpChatEnableFriendsTab (copy), n1 (ref), Visibility (ref)
		n2 = n3 or 0

		if not u50.notification then
			return
		end

		if not FFlagExpChatEnableFriendsTab then
			u50.notification:fireCount(n1)

			return
		end

		local v83 = n1 + n2

		if Visibility or v83 == 0 then
			u50.notification:clear()

			return
		end

		u50.notification:fireCount(v83)
	end

	n2 = InExperienceAppChatModal.default.unreadCount or 0

	if u50.notification then
		if not FFlagExpChatEnableFriendsTab then
			u50.notification:fireCount(n1)
		else
			local v56 = n1 + n2

			if Visibility or v56 == 0 then
				u50.notification:clear()
			else
				u50.notification:fireCount(v56)
			end
		end
	end

	InExperienceAppChatModal.default.unreadCountSignal.Event:Connect(updateFriendsChatUnreadMessages)
end

local function shouldIgnoreUnreadForMessage(p10) -- line: 301
	-- upvalues: v39 (copy), shouldSuppressUnreadForTabMetadata (copy)
	return v39 and shouldSuppressUnreadForTabMetadata(p10 and p10.Metadata)
end

TextChatService.MessageReceived:Connect(function(p11) -- line: 306
	-- upvalues: v39 (copy), shouldSuppressUnreadForTabMetadata (copy), Visibility (ref), n1 (ref), u50 (ref), FFlagExpChatEnableFriendsTab (copy), n2 (ref)
	if v39 and shouldSuppressUnreadForTabMetadata(p11 and p11.Metadata) then
		return
	end

	if not Visibility then
		n1 += 1

		if not u50.notification then
			return
		end

		if not FFlagExpChatEnableFriendsTab then
			u50.notification:fireCount(n1)

			return
		end

		local v86 = n1 + n2

		if Visibility or v86 == 0 then
			u50.notification:clear()

			return
		end

		u50.notification:fireCount(v86)
	end
end)

if GetFFlagTextChatEnableUniverseChatTabs() then
	TextChatService.UniverseChatMessageReceived:Connect(function(p12) -- line: 318
		-- upvalues: v39 (copy), shouldSuppressUnreadForTabMetadata (copy), Visibility (ref), n1 (ref), u50 (ref), FFlagExpChatEnableFriendsTab (copy), n2 (ref)
		if v39 and shouldSuppressUnreadForTabMetadata(p12 and p12.Metadata) then
			return
		end

		if not Visibility then
			n1 += 1

			if not u50.notification then
				return
			end

			if not FFlagExpChatEnableFriendsTab then
				u50.notification:fireCount(n1)

				return
			end

			local v88 = n1 + n2

			if Visibility or v88 == 0 then
				u50.notification:clear()

				return
			end

			u50.notification:fireCount(v88)
		end
	end)
end

local n4 = 0

ChatSelector.MessagesChanged:connect(function(n5: number) -- line: 330
	-- upvalues: Visibility (ref), n1 (ref), n4 (ref), u50 (ref), FFlagExpChatEnableFriendsTab (copy), n2 (ref)
	if not Visibility then
		n1 += n5 - n4

		if u50.notification then
			if not FFlagExpChatEnableFriendsTab then
				u50.notification:fireCount(n1)
			else
				local v90 = n1 + n2

				if Visibility or v90 == 0 then
					u50.notification:clear()
				else
					u50.notification:fireCount(v90)
				end
			end
		end
	end

	n4 = n5
end)

if not FFlagExpChatWindowSyncUnibar then
	ChatSelector.ChatActiveChanged:connect(function(b1: boolean) -- line: 339
		-- upvalues: v41 (copy), default (copy), RunService (copy), Chat (copy), Players (copy), u50 (ref)
		if v41 then
			default.setChatActiveCalledByDeveloper(b1)

			return
		end

		if b1 then
			local v94

			if not RunService:IsStudio() then
				local ok, result = pcall(function() -- line: 87
					-- upvalues: Chat (copy), Players (copy)
					return Chat:CanUserChatAsync(Players.LocalPlayer and Players.LocalPlayer.UserId or 0)
				end)

				v94 = ok and result
			else
				v94 = true
			end

			if not v94 then
				u50.availability:available()
			end
		end
	end)
end

local function setChatVisibilityOnLoad() -- line: 353
	-- upvalues: GameSettings (copy), ViewportUtil (copy), Visibility (ref), ChatSelector (copy)
	local ChatVisible = GameSettings.ChatVisible

	if ViewportUtil.isSmallTouchScreen() then
		ChatVisible = false
	end

	Visibility = ChatVisible
	ChatSelector:SetVisible(ChatVisible)
end

coroutine.wrap(function() -- line: 363
	-- upvalues: Players (copy), RunService (copy), Chat (copy), v41 (copy), default (copy), GameSettings (copy), ViewportUtil (copy), Visibility (ref), ChatSelector (copy), u50 (ref), ChromeUtils (copy)
	local LocalPlayer = Players.LocalPlayer

	while not LocalPlayer do
		Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
		LocalPlayer = Players.LocalPlayer
	end

	local v99

	if not RunService:IsStudio() then
		local ok, result = pcall(function() -- line: 87
			-- upvalues: Chat (copy), Players (copy)
			return Chat:CanUserChatAsync(Players.LocalPlayer and Players.LocalPlayer.UserId or 0)
		end)

		v99 = ok and result
	else
		v99 = true
	end

	if v41 then
		default.setLocalUserChat(v99)

		if v99 then
			local ChatVisible = GameSettings.ChatVisible

			if ViewportUtil.isSmallTouchScreen() then
				ChatVisible = false
			end

			Visibility = ChatVisible
			ChatSelector:SetVisible(ChatVisible)

			return
		end
	elseif v99 and u50.availability then
		ChromeUtils.setCoreGuiAvailability(u50, Enum.CoreGuiType.Chat, function(p13) -- line: 378
			-- upvalues: u50 (ref)
			if p13 then
				u50.availability:pinned()

				return
			end

			u50.availability:unavailable()
		end)

		local ChatVisible = GameSettings.ChatVisible

		if ViewportUtil.isSmallTouchScreen() then
			ChatVisible = false
		end

		Visibility = ChatVisible
		ChatSelector:SetVisible(ChatVisible)
	end
end)()

function _simulateChat() -- line: 398
	-- upvalues: Visibility (ref), n1 (ref), u50 (ref), FFlagExpChatEnableFriendsTab (copy), n2 (ref)
	while true do
		task.wait(math.random(1, 15))

		if not Visibility then
			n1 += 1

			if u50.notification then
				if not FFlagExpChatEnableFriendsTab then
					u50.notification:fireCount(n1)
				else
					local v102 = n1 + n2

					if Visibility or v102 == 0 then
						u50.notification:clear()
					else
						u50.notification:fireCount(v102)
					end
				end
			end
		end
	end
end

return u50
