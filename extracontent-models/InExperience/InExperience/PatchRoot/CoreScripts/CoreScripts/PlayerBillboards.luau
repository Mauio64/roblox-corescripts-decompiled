local Chat = game:GetService("Chat")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

game:GetService("StarterGui")

local TextChatService = game:GetService("TextChatService")
local RobloxGui = CoreGui.RobloxGui
local VoiceChatCore = require(CorePackages.Workspace.Packages.VoiceChatCore)
local Rodux = require(CorePackages.Packages.Rodux)
local chatReducer = require(RobloxGui.Modules.InGameChat.BubbleChat.Reducers.chatReducer)
local SetMessageText = require(RobloxGui.Modules.InGameChat.BubbleChat.Actions.SetMessageText)
local AddMessageFromEvent = require(RobloxGui.Modules.InGameChat.BubbleChat.Actions.AddMessageFromEvent)
local AddMessageWithTimeout = require(RobloxGui.Modules.InGameChat.BubbleChat.Actions.AddMessageWithTimeout)
local UpdateChatSettings = require(RobloxGui.Modules.InGameChat.BubbleChat.Actions.UpdateChatSettings)
local BubbleChatEnabledChanged = require(RobloxGui.Modules.InGameChat.BubbleChat.Actions.BubbleChatEnabledChanged)
local VoiceEnabledChanged = require(RobloxGui.Modules.VoiceChat.Actions.VoiceEnabledChanged)
local ParticipantsChanged = require(RobloxGui.Modules.VoiceChat.Actions.ParticipantsChanged)
local VoiceStateChanged = require(RobloxGui.Modules.VoiceChat.Actions.VoiceStateChanged)
local ParticipantAdded = require(RobloxGui.Modules.VoiceChat.Actions.ParticipantAdded)
local ParticipantRemoved = require(RobloxGui.Modules.VoiceChat.Actions.ParticipantRemoved)
local PlayerRemoved = require(RobloxGui.Modules.VoiceChat.Actions.PlayerRemoved)
local getPlayerFromPart = require(RobloxGui.Modules.InGameChat.BubbleChat.Helpers.getPlayerFromPart)
local validateMessage = require(RobloxGui.Modules.InGameChat.BubbleChat.Helpers.validateMessage)
local Constants = require(RobloxGui.Modules.InGameChat.BubbleChat.Constants)
local Types = require(RobloxGui.Modules.InGameChat.BubbleChat.Types)
local BlockingUtility = require(CorePackages.Workspace.Packages.BlockingUtility)
local GameTranslator = require(RobloxGui.Modules.GameTranslator)
local default = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager).default
local initVoiceChatStore = require(RobloxGui.Modules.VoiceChat.initVoiceChatStore)
local GetFFlagEnableVoiceChatVoiceUISync = require(RobloxGui.Modules.Flags.GetFFlagEnableVoiceChatVoiceUISync)
local GetFFlagLocalMutedNilFix = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagLocalMutedNilFix
local GetFFlagBatchVoiceParticipantsUpdates = VoiceChatCore.Flags.GetFFlagBatchVoiceParticipantsUpdates
local getFFlagExpChatAlwaysRunTCS = require(CorePackages.Workspace.Packages.SharedFlags).getFFlagExpChatAlwaysRunTCS
local GetFFlagExpChatUseVoiceParticipantsStore = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagExpChatUseVoiceParticipantsStore
local _ = require(CorePackages.Workspace.Packages.SharedFlags).FFlagExpChatUseMessagesStore
local FFlagExpChatUseChatConfigStore = require(CorePackages.Workspace.Packages.SharedFlags).FFlagExpChatUseChatConfigStore
local ExpChat = require(CorePackages.Workspace.Packages.ExpChat)
local v38 = require(RobloxGui.Modules.InGameChat.BubbleChat.Logger)(script.Name)
local v39 = if not GetFFlagExpChatUseVoiceParticipantsStore() then nil else ExpChat.Stores.GetVoiceStore(false)
local t1 = {
	[VoiceEnabledChanged.name] = function(p1) -- line: 68
		-- upvalues: ExpChat (copy)
		ExpChat.Events.VoiceEnabledChanged(p1.enabled)
	end,
	[VoiceStateChanged.name] = function(p2) -- line: 72
		-- upvalues: GetFFlagExpChatUseVoiceParticipantsStore (copy), v39 (copy), ExpChat (copy)
		if GetFFlagExpChatUseVoiceParticipantsStore() then
			v39.handleVoiceStateChanged(p2.userId, p2.newState)

			return
		end

		ExpChat.Events.VoiceStateChanged(p2.userId, p2.newState)
	end,
	[ParticipantsChanged.name] = function(p3) -- line: 80
		-- upvalues: GetFFlagExpChatUseVoiceParticipantsStore (copy), v39 (copy), ExpChat (copy)
		if GetFFlagExpChatUseVoiceParticipantsStore() then
			v39.handleVoiceParticipantsChanged(p3.newParticipants)

			return
		end

		ExpChat.Events.VoiceParticipantsChanged(p3.newParticipants)
	end,
	[ParticipantAdded.name] = not GetFFlagExpChatUseVoiceParticipantsStore() and function(p4) -- line: 91
		-- upvalues: ExpChat (copy)
		ExpChat.Events.VoiceParticipantAdded(p4.userId)
	end or nil,
	[ParticipantRemoved.name] = not GetFFlagExpChatUseVoiceParticipantsStore() and function(p5) -- line: 98
		-- upvalues: ExpChat (copy)
		ExpChat.Events.VoiceParticipantRemoved(p5.userId)
	end or nil
}
local u41 = Rodux.Store.new(chatReducer, nil, {
	Rodux.thunkMiddleware,
	function(p6) -- line: 103
		-- upvalues: t1 (copy)
		return function(p7) -- line: 104
			-- upvalues: t1 (copy), p6 (copy)
			local v94 = t1[p7.type]

			if v94 then
				v94(p7)
			end

			p6(p7)
		end
	end
})
local connection = nil

local function isTextChatServiceOn() -- line: 120
	-- upvalues: getFFlagExpChatAlwaysRunTCS (copy), TextChatService (copy)
	if getFFlagExpChatAlwaysRunTCS() then
		return true
	end

	return TextChatService.ChatVersion == Enum.ChatVersion.TextChatService
end

if game:IsLoaded() and (not not getFFlagExpChatAlwaysRunTCS() or TextChatService.ChatVersion == Enum.ChatVersion.TextChatService) then
	return
end

connection = game.Loaded:Connect(function() -- line: 131
	-- upvalues: connection (ref)
	if game:IsLoaded() then
		connection:Disconnect()
	end
end)

local function validateMessageWithWarning(p8, p9) -- line: 138
	-- upvalues: validateMessage (copy), Constants (copy)
	local v70, v71 = validateMessage(p9)

	if not v70 then
		if v71 then
			warn(("Message text %q is too long for chat event %q (expected a message of length %i, got %i)"):format(p9, p8, Constants.MAX_MESSAGE_LENGTH, v71))

			return v70
		end

		warn(("Message text %q sent to chat event %q is not a valid UTF-8 characters sequence"):format(p9, p8))
	end

	return v70
end
local function validateMessageData(p10, p11) -- line: 152
	-- upvalues: Types (copy)
	local v74, v75 = Types.IMessageData(p11)

	if not v74 then
		warn(("Malformed message data sent to chat event %q. If you have modified the chat system, check what you are firing to this event"):format(p10))
		warn(v75)
	end

	return v74
end

local connection2 = nil
local connection3 = nil
local connection4 = nil
local u49 = nil
local u50 = nil
local n1 = 0
local n2 = 0
local t2 = {}

local function initBubbleChat() -- line: 167
	-- upvalues: ReplicatedStorage (copy), connection2 (ref), Types (copy), Players (copy), validateMessageWithWarning (copy), u41 (ref), AddMessageFromEvent (copy), connection3 (ref), SetMessageText (copy), getPlayerFromPart (copy), t2 (copy), n1 (ref), GameTranslator (copy), CoreGui (copy), AddMessageWithTimeout (copy), n2 (ref), connection4 (ref), Chat (copy)
	coroutine.resume(coroutine.create(function() -- line: 168
		-- upvalues: ReplicatedStorage (copy), connection2 (ref), Types (copy), Players (copy), validateMessageWithWarning (copy), u41 (ref), AddMessageFromEvent (copy), connection3 (ref), SetMessageText (copy)
		local DefaultChatSystemChatEvents = ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents", 1e999)

		connection2 = DefaultChatSystemChatEvents:WaitForChild("OnNewMessage", 1e999).OnClientEvent:Connect(function(p12) -- line: 176
			-- upvalues: Types (copy), Players (copy), validateMessageWithWarning (copy), u41 (ref), AddMessageFromEvent (copy)
			local v119, v120 = Types.IMessageData(p12)

			if not v119 then
				warn(("Malformed message data sent to chat event %q. If you have modified the chat system, check what you are firing to this event"):format("OnNewMessage"))
				warn(v120)
			end

			if not v119 then
				return
			end

			if p12.FromSpeaker == Players.LocalPlayer.Name then
				if not validateMessageWithWarning("OnNewMessage", p12.Message) then
					return
				end

				local v121 = table.clone(p12)

				v121.Time = workspace:GetServerTimeNow() * 1000
				u41:dispatch(AddMessageFromEvent(v121))
			end
		end)
		connection3 = DefaultChatSystemChatEvents:WaitForChild("OnMessageDoneFiltering", 1e999).OnClientEvent:Connect(function(p13) -- line: 194
			-- upvalues: Types (copy), validateMessageWithWarning (copy), u41 (ref), SetMessageText (copy), AddMessageFromEvent (copy)
			local v123, v124 = Types.IMessageData(p13)

			if not v123 then
				warn(("Malformed message data sent to chat event %q. If you have modified the chat system, check what you are firing to this event"):format("OnMessageDoneFiltering"))
				warn(v124)
			end

			if not v123 or not validateMessageWithWarning("OnMessageDoneFiltering", p13.Message) then
				return
			end

			local str = tostring(p13.ID)

			if u41:getState().messages[str] then
				u41:dispatch(SetMessageText(str, p13.Message))

				return
			end

			local v126 = table.clone(p13)

			v126.Time = workspace:GetServerTimeNow() * 1000
			u41:dispatch(AddMessageFromEvent(v126))
		end)
	end))

	local function addMessageWithId(p14, p15, p16) -- line: 213
		-- upvalues: getPlayerFromPart (copy), t2 (copy), n1 (ref), GameTranslator (copy), CoreGui (copy), u41 (ref), AddMessageWithTimeout (copy)
		local v99 = if not p14:IsA("Model") then p14 else if not p14.PrimaryPart then p14:FindFirstChildWhichIsA("BasePart", true) else p14.PrimaryPart
		local v100 = nil

		if v99 then
			v100 = getPlayerFromPart(v99)
		end

		local str

		if v100 then
			str = tostring(v100.UserId)
		else
			str = t2[p14]

			if str then
			else
				n1 += 1
				str = "adornee_" .. n1
				t2[p14] = str
			end
		end

		local t3 = {
			id = "chatted_" .. p16,
			userId = str,
			name = p14.Name,
			text = GameTranslator:TranslateGameText(CoreGui, p15),
			timestamp = os.time(),
			adornee = p14
		}

		u41:dispatch(AddMessageWithTimeout(t3))
	end
	local function addMessage(p17, p18) -- line: 256
		-- upvalues: n2 (ref), addMessageWithId (copy)
		n2 += 1
		addMessageWithId(p17, p18, n2)
	end

	connection4 = Chat.Chatted:Connect(addMessage)
end
local function destroyBubbleChat() -- line: 264
	-- upvalues: connection2 (ref), connection3 (ref), connection4 (ref), u50 (ref), u49 (ref)
	if connection2 then
		connection2:Disconnect()
		connection2 = nil
	end

	if connection3 then
		connection3:Disconnect()
		connection3 = nil
	end

	if connection4 then
		connection4:Disconnect()
		connection4 = nil
	end

	if u50 then
		u50:Disconnect()
		u50 = nil
	end

	if u49 then
		u49:Disconnect()
		u49 = nil
	end
end
local function onBubbleChatEnabledChanged() -- line: 288
	-- upvalues: destroyBubbleChat (copy), Chat (copy), initBubbleChat (copy), u41 (ref), BubbleChatEnabledChanged (copy)
	destroyBubbleChat()

	local v78 = not game:GetEngineFeature("EnableBubbleChatFromChatService") or Chat.BubbleChatEnabled

	if v78 then
		initBubbleChat()
	end

	u41:dispatch(BubbleChatEnabledChanged(v78))
end

local t4 = {}

local function setVoiceEnabled(p19) -- line: 300
	-- upvalues: Players (copy), u41 (ref), VoiceEnabledChanged (copy), t4 (ref), v38 (copy), VoiceStateChanged (copy), Constants (copy), GetFFlagLocalMutedNilFix (copy), default (copy)
	local str = tostring(Players.LocalPlayer.UserId)
	local v81 = p19 ~= Enum.VoiceChatState.Ended

	u41:dispatch(VoiceEnabledChanged(v81))

	if not t4[p19] then
		v38:warning("LOCAL_STATE_MAP does not exist for {} state", p19)
		u41:dispatch(VoiceStateChanged(str, Constants.VOICE_STATE.MUTED))
	else
		u41:dispatch(VoiceStateChanged(str, t4[p19]))
	end

	if p19 == Enum.VoiceChatState.Failed then
		for _, player in pairs(Players:GetPlayers()) do
			local str2 = tostring(player.UserId)

			if player ~= Players.LocalPlayer then
				u41:dispatch(VoiceStateChanged(str2, Constants.VOICE_STATE.HIDDEN))
			end
		end

		return
	end

	if p19 == Enum.VoiceChatState.Joined and if not GetFFlagLocalMutedNilFix then not default.localMuted else default.localMuted == false then
		u41:dispatch(VoiceStateChanged(str, Constants.VOICE_STATE.INACTIVE))
	end
end
local function shorten(p20) -- line: 331
	return "..." .. string.sub(tostring(p20), -4)
end
local function initVoiceChat() -- line: 335
	-- upvalues: GetFFlagEnableVoiceChatVoiceUISync (copy), initVoiceChatStore (copy), u41 (ref), v38 (copy), default (copy), t4 (ref), Constants (copy), Players (copy), ParticipantAdded (copy), PlayerRemoved (copy), ParticipantRemoved (copy), VoiceStateChanged (copy), GetFFlagBatchVoiceParticipantsUpdates (copy), ParticipantsChanged (copy), BlockingUtility (copy), setVoiceEnabled (copy)
	if GetFFlagEnableVoiceChatVoiceUISync() then
		initVoiceChatStore(u41)

		return
	end

	v38:debug("Initializing VoiceChatService connections")

	local v86 = default:getService()

	if not v86 then
		v38:debug("VoiceChatService is not available")

		return
	end

	if not Enum.VoiceChatState then
		v38:error("Enum.VoiceChatState does not exist but voice is enabled")

		return
	end

	t4 = {
		[Enum.VoiceChatState.Idle] = Constants.VOICE_STATE.HIDDEN,
		[Enum.VoiceChatState.Joining] = Constants.VOICE_STATE.CONNECTING,
		[Enum.VoiceChatState.JoiningRetry] = Constants.VOICE_STATE.CONNECTING,
		[Enum.VoiceChatState.Joined] = Constants.VOICE_STATE.MUTED,
		[Enum.VoiceChatState.Leaving] = Constants.VOICE_STATE.MUTED,
		[Enum.VoiceChatState.Ended] = Constants.VOICE_STATE.HIDDEN,
		[Enum.VoiceChatState.Failed] = Constants.VOICE_STATE.ERROR
	}

	local UserId = Players.LocalPlayer.UserId

	for _, player in pairs(Players:GetPlayers()) do
		v38:trace("Adding existing player {}", "..." .. string.sub(tostring(player.UserId), -4))
		u41:dispatch(ParticipantAdded((tostring(player.UserId))))
	end

	Players.PlayerAdded:Connect(function(player) -- line: 371
		-- upvalues: v38 (copy), u41 (ref), ParticipantAdded (copy)
		v38:trace("Adding joining player {}", "..." .. string.sub(tostring(player.UserId), -4))
		u41:dispatch(ParticipantAdded((tostring(player.userId))))
	end)
	Players.PlayerRemoving:Connect(function(player) -- line: 376
		-- upvalues: v38 (copy), u41 (ref), PlayerRemoved (copy), ParticipantRemoved (copy)
		v38:trace("Removing player {}", "..." .. string.sub(tostring(player.UserId), -4))
		u41:dispatch(PlayerRemoved((tostring(player.userId))))
		u41:dispatch(ParticipantRemoved((tostring(player.userId))))
	end)
	u41:dispatch(VoiceStateChanged(UserId, Constants.VOICE_STATE.HIDDEN))
	default.muteChanged.Event:connect(function(p21) -- line: 385
		-- upvalues: v38 (copy), Constants (copy), u41 (ref), VoiceStateChanged (copy), UserId (copy)
		v38:debug("Mute changed to {}", p21)

		local v108 = p21 and Constants.VOICE_STATE.MUTED or Constants.VOICE_STATE.INACTIVE

		u41:dispatch(VoiceStateChanged(UserId, v108))
	end)
	default.participantsUpdate.Event:Connect(function(p22) -- line: 391
		-- upvalues: GetFFlagBatchVoiceParticipantsUpdates (copy), u41 (ref), ParticipantsChanged (copy), Constants (copy), v38 (copy), VoiceStateChanged (copy)
		if GetFFlagBatchVoiceParticipantsUpdates() then
			u41:dispatch(ParticipantsChanged(p22))

			return
		end

		for k, v in pairs(p22) do
			local INACTIVE = Constants.VOICE_STATE.INACTIVE

			if not v.subscriptionCompleted then
				INACTIVE = Constants.VOICE_STATE.CONNECTING
			elseif v.isMutedLocally then
				INACTIVE = Constants.VOICE_STATE.LOCAL_MUTED
			elseif v.isMuted then
				INACTIVE = Constants.VOICE_STATE.MUTED
			elseif v.isSignalActive then
				INACTIVE = Constants.VOICE_STATE.TALKING
			end

			v38:trace("Participant update for {}, voice state {}", "..." .. string.sub(tostring(k), -4), INACTIVE)
			u41:dispatch(VoiceStateChanged(k, INACTIVE))
		end
	end)
	default.talkingChanged.Event:Connect(function(p23) -- line: 413
		-- upvalues: u41 (ref), VoiceStateChanged (copy), UserId (copy), Constants (copy)
		if p23 then
			u41:dispatch(VoiceStateChanged(UserId, Constants.VOICE_STATE.TALKING))

			return
		end

		u41:dispatch(VoiceStateChanged(UserId, Constants.VOICE_STATE.INACTIVE))
	end)
	BlockingUtility:GetBlockedStatusChangedEvent():Connect(function(p24, p25) -- line: 422
		-- upvalues: u41 (ref), ParticipantRemoved (copy), ParticipantAdded (copy)
		if p25 then
			u41:dispatch(ParticipantRemoved((tostring(p24))))

			return
		end

		u41:dispatch(ParticipantAdded((tostring(p24))))
	end)
	v38:debug("Initial voice state is {}", v86.VoiceChatState)
	setVoiceEnabled(v86.VoiceChatState)
	v86.StateChanged:Connect(function(_, newState) -- line: 432
		-- upvalues: v38 (copy), setVoiceEnabled (copy)
		v38:debug("Voice state changed to {}", newState)
		setVoiceEnabled(newState)
	end)
end

if game:GetEngineFeature("EnableBubbleChatFromChatService") then
	Chat:GetPropertyChangedSignal("BubbleChatEnabled"):Connect(onBubbleChatEnabledChanged)
end

destroyBubbleChat()

local v61 = not game:GetEngineFeature("EnableBubbleChatFromChatService") or Chat.BubbleChatEnabled

if v61 then
	initBubbleChat()
end

u41:dispatch(BubbleChatEnabledChanged(v61))

if game:GetEngineFeature("BubbleChatSettingsApi") then
	Chat.BubbleChatSettingsChanged:Connect(function(p27) -- line: 444
		-- upvalues: Types (copy), FFlagExpChatUseChatConfigStore (copy), ExpChat (copy), u41 (ref), UpdateChatSettings (copy)
		local v91, v92 = Types.IChatSettings(p27)

		assert(v91, "Bad settings object passed to Chat:SetBubbleChatSettings:\n" .. (v92 or ""))

		if FFlagExpChatUseChatConfigStore then
			ExpChat.Stores.GetChatConfigurationStore(false).setBubbleChatSettings(p27)

			return
		end

		u41:dispatch(UpdateChatSettings(p27))
	end)
end

default:asyncInit():andThen(initVoiceChat):catch(function() -- line: 459
	-- upvalues: v38 (copy)
	v38:debug("VoiceChatServiceManager failed to initialize")
end)
