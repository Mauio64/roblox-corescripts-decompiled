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
local VoiceChatServiceManager = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager)
local default = VoiceChatServiceManager.default
local initVoiceChatStore = require(RobloxGui.Modules.VoiceChat.initVoiceChatStore)
local GetFFlagEnableVoiceChatVoiceUISync = require(RobloxGui.Modules.Flags.GetFFlagEnableVoiceChatVoiceUISync)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagLocalMutedNilFix = SharedFlags.GetFFlagLocalMutedNilFix
local GetFFlagBatchVoiceParticipantsUpdates = VoiceChatCore.Flags.GetFFlagBatchVoiceParticipantsUpdates
local SharedFlags2 = require(CorePackages.Workspace.Packages.SharedFlags)
local getFFlagExpChatAlwaysRunTCS = SharedFlags2.getFFlagExpChatAlwaysRunTCS

local SharedFlags3 = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagExpChatUseVoiceParticipantsStore = SharedFlags3.GetFFlagExpChatUseVoiceParticipantsStore

local SharedFlags4 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagExpChatUseChatConfigStore = SharedFlags4.FFlagExpChatUseChatConfigStore

local ExpChat = require(CorePackages.Workspace.Packages.ExpChat)
local Logger = require(RobloxGui.Modules.InGameChat.BubbleChat.Logger)
local logger = Logger(script.Name)
local v

if GetFFlagExpChatUseVoiceParticipantsStore() then
	v = ExpChat.Stores.GetVoiceStore(false)
else
	v = nil
end

local v2 = {
	[VoiceEnabledChanged.name] = function(p)
		ExpChat.Events.VoiceEnabledChanged(p.enabled)
	end,
	[VoiceStateChanged.name] = function(p)
		if GetFFlagExpChatUseVoiceParticipantsStore() then
			v.handleVoiceStateChanged(p.userId, p.newState)
		else
			ExpChat.Events.VoiceStateChanged(p.userId, p.newState)
		end
	end,
	[ParticipantsChanged.name] = function(p)
		if GetFFlagExpChatUseVoiceParticipantsStore() then
			v.handleVoiceParticipantsChanged(p.newParticipants)
		else
			ExpChat.Events.VoiceParticipantsChanged(p.newParticipants)
		end
	end,
	[ParticipantAdded.name] = not GetFFlagExpChatUseVoiceParticipantsStore() and function(p)
		ExpChat.Events.VoiceParticipantAdded(p.userId)
	end or nil,
	[ParticipantRemoved.name] = not GetFFlagExpChatUseVoiceParticipantsStore() and function(p)
		ExpChat.Events.VoiceParticipantRemoved(p.userId)
	end or nil
}

local store = Rodux.Store.new(chatReducer, nil, {
	Rodux.thunkMiddleware,
	function(callback)
		return function(p)
			local v3 = v2[p.type]

			if v3 then
				v3(p)
			end

			callback(p)
		end
	end
})

local loadedConnection = nil
local function isTextChatServiceOn(): boolean
	if getFFlagExpChatAlwaysRunTCS() then
		return true
	end

	return TextChatService.ChatVersion == Enum.ChatVersion.TextChatService
end

if
	game:IsLoaded()
	and (getFFlagExpChatAlwaysRunTCS() or TextChatService.ChatVersion == Enum.ChatVersion.TextChatService)
then
	return
end

loadedConnection = game.Loaded:Connect(function()
	if game:IsLoaded() then
		loadedConnection:Disconnect()
	end
end)

local function validateMessageWithWarning(p, message)
	local v3, v4 = validateMessage(message)

	if v3 then
		return v3
	end

	if v4 then
		warn(("Message text %q is too long for chat event %q (expected a message of length %i, got %i)"):format(
			message,
			p,
			Constants.MAX_MESSAGE_LENGTH,
			v4
		))
		return v3
	end

	warn(("Message text %q sent to chat event %q is not a valid UTF-8 characters sequence"):format(message, p))

	return v3
end

local function validateMessageData(p, p2) -- 2 equivalent calls inferred from this helper
	local iMessageData, v3 = Types.IMessageData(p2)

	if not iMessageData then
		warn(("Malformed message data sent to chat event %q. If you have modified the chat system, check what you are firing to this event"):format(p))
		warn(v3)
	end

	return iMessageData
end

local onClientEventConnection = nil
local onClientEventConnection2 = nil
local chattedConnection = nil
local connection = nil
local connection2 = nil
local count = 0
local count2 = 0
local v3 = {}
local function initBubbleChat()
	coroutine.resume(coroutine.create(function()
		local defaultChatSystemChatEvents = ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents", 1e999)

		onClientEventConnection = defaultChatSystemChatEvents:WaitForChild("OnNewMessage", 1e999).OnClientEvent:Connect(function(p)
			if not validateMessageData("OnNewMessage", p) then -- inferred equivalent call
				return
			end

			if p.FromSpeaker == Players.LocalPlayer.Name then
				if not validateMessageWithWarning("OnNewMessage", p.Message) then
					return
				end

				local clone = table.clone(p)
				clone.Time = workspace:GetServerTimeNow() * 1000
				store:dispatch(AddMessageFromEvent(clone))
			end
		end)

		onClientEventConnection2 = defaultChatSystemChatEvents:WaitForChild("OnMessageDoneFiltering", 1e999).OnClientEvent:Connect(function(p)
			if not (validateMessageData("OnMessageDoneFiltering", p) and validateMessageWithWarning( -- inferred equivalent call
				"OnMessageDoneFiltering",
				p.Message
			)) then
				return
			end

			local id = tostring(p.ID)

			if store:getState().messages[id] then
				store:dispatch(SetMessageText(id, p.Message))
				return
			end

			local clone = table.clone(p)
			clone.Time = workspace:GetServerTimeNow() * 1000
			store:dispatch(AddMessageFromEvent(clone))
		end)
	end))

	local function addMessageWithId(model, p, count3)
		local v4

		if model:IsA("Model") then
			if model.PrimaryPart then
				v4 = model.PrimaryPart
			else
				v4 = model:FindFirstChildWhichIsA("BasePart", true)
			end
		else
			v4 = model
		end

		local v5

		if v4 then
			v5 = getPlayerFromPart(v4)
		end

		local userId

		if v5 then
			userId = tostring(v5.UserId)
		else
			userId = v3[model]

			if not userId then
				count += 1
				userId = "adornee_" .. count
				v3[model] = userId
			end
		end

		store:dispatch(AddMessageWithTimeout({
			id = "chatted_" .. count3,
			userId = userId,
			name = model.Name,
			text = GameTranslator:TranslateGameText(CoreGui, p),
			timestamp = os.time(),
			adornee = model
		}))
	end

	local function addMessage(adornee, p)
		count2 += 1
		addMessageWithId(adornee, p, count2)
	end

	chattedConnection = Chat.Chatted:Connect(addMessage)
end

local function destroyBubbleChat()
	if onClientEventConnection then
		onClientEventConnection:Disconnect()
		onClientEventConnection = nil
	end

	if onClientEventConnection2 then
		onClientEventConnection2:Disconnect()
		onClientEventConnection2 = nil
	end

	if chattedConnection then
		chattedConnection:Disconnect()
		chattedConnection = nil
	end

	if connection2 then
		connection2:Disconnect()
		connection2 = nil
	end

	if connection then
		connection:Disconnect()
		connection = nil
	end
end

local function onBubbleChatEnabledChanged() -- 1 equivalent call inferred from this helper
	destroyBubbleChat()
	local v4 = not game:GetEngineFeature("EnableBubbleChatFromChatService") or Chat.BubbleChatEnabled

	if v4 then
		initBubbleChat()
	end

	store:dispatch(BubbleChatEnabledChanged(v4))
end

local v4 = {}

local function setVoiceEnabled(p)
	local userId = tostring(Players.LocalPlayer.UserId)
	store:dispatch(VoiceEnabledChanged(p ~= Enum.VoiceChatState.Ended))

	if v4[p] then
		store:dispatch(VoiceStateChanged(userId, v4[p]))
	else
		logger:warning("LOCAL_STATE_MAP does not exist for {} state", p)
		store:dispatch(VoiceStateChanged(userId, Constants.VOICE_STATE.MUTED))
	end

	if p == Enum.VoiceChatState.Failed then
		for _, v5 in pairs(Players:GetPlayers()) do
			local userId2 = tostring(v5.UserId)

			if v5 ~= Players.LocalPlayer then
				store:dispatch(VoiceStateChanged(userId2, Constants.VOICE_STATE.HIDDEN))
			end
		end
	elseif p == Enum.VoiceChatState.Joined then
		local v5

		if GetFFlagLocalMutedNilFix then
			v5 = default.localMuted == false
		else
			v5 = not default.localMuted
		end

		if v5 then
			store:dispatch(VoiceStateChanged(userId, Constants.VOICE_STATE.INACTIVE))
		end
	end
end

local function shorten(p) -- 4 equivalent calls inferred from this helper
	return "..." .. string.sub(tostring(p), -4)
end

local function initVoiceChat()
	if GetFFlagEnableVoiceChatVoiceUISync() then
		initVoiceChatStore(store)
		return
	end

	logger:debug("Initializing VoiceChatService connections")
	local service = default:getService()

	if not service then
		logger:debug("VoiceChatService is not available")
		return
	end

	if not Enum.VoiceChatState then
		logger:error("Enum.VoiceChatState does not exist but voice is enabled")
		return
	end

	v4 = {
		[Enum.VoiceChatState.Idle] = Constants.VOICE_STATE.HIDDEN,
		[Enum.VoiceChatState.Joining] = Constants.VOICE_STATE.CONNECTING,
		[Enum.VoiceChatState.JoiningRetry] = Constants.VOICE_STATE.CONNECTING,
		[Enum.VoiceChatState.Joined] = Constants.VOICE_STATE.MUTED,
		[Enum.VoiceChatState.Leaving] = Constants.VOICE_STATE.MUTED,
		[Enum.VoiceChatState.Ended] = Constants.VOICE_STATE.HIDDEN,
		[Enum.VoiceChatState.Failed] = Constants.VOICE_STATE.ERROR
	}

	local userId = Players.LocalPlayer.UserId

	for _, v5 in pairs(Players:GetPlayers()) do
		logger:trace("Adding existing player {}", shorten(v5.UserId)) -- inferred equivalent call
		store:dispatch(ParticipantAdded((tostring(v5.UserId))))
	end

	Players.PlayerAdded:Connect(function(player)
		logger:trace("Adding joining player {}", shorten(player.UserId)) -- inferred equivalent call
		store:dispatch(ParticipantAdded((tostring(player.userId))))
	end)

	Players.PlayerRemoving:Connect(function(player)
		logger:trace("Removing player {}", shorten(player.UserId)) -- inferred equivalent call

		store:dispatch(PlayerRemoved((tostring(player.userId))))
		store:dispatch(ParticipantRemoved((tostring(player.userId))))
	end)

	store:dispatch(VoiceStateChanged(userId, Constants.VOICE_STATE.HIDDEN))
	default.muteChanged.Event:connect(function(p)
		logger:debug("Mute changed to {}", p)
		local muted = p and Constants.VOICE_STATE.MUTED or Constants.VOICE_STATE.INACTIVE
		store:dispatch(VoiceStateChanged(userId, muted))
	end)

	default.participantsUpdate.Event:Connect(function(items)
		if GetFFlagBatchVoiceParticipantsUpdates() then
			store:dispatch(ParticipantsChanged(items))
			return
		end

		for k, item in pairs(items) do
			local v5 = Constants.VOICE_STATE.INACTIVE

			if item.subscriptionCompleted then
				if item.isMutedLocally then
					v5 = Constants.VOICE_STATE.LOCAL_MUTED
				elseif item.isMuted then
					v5 = Constants.VOICE_STATE.MUTED
				elseif item.isSignalActive then
					v5 = Constants.VOICE_STATE.TALKING
				end
			else
				v5 = Constants.VOICE_STATE.CONNECTING
			end

			logger:trace("Participant update for {}, voice state {}", shorten(k), v5) -- inferred equivalent call
			store:dispatch(VoiceStateChanged(k, v5))
		end
	end)

	default.talkingChanged.Event:Connect(function(p)
		if p then
			store:dispatch(VoiceStateChanged(userId, Constants.VOICE_STATE.TALKING))
		else
			store:dispatch(VoiceStateChanged(userId, Constants.VOICE_STATE.INACTIVE))
		end
	end)

	BlockingUtility:GetBlockedStatusChangedEvent():Connect(function(p, p2)
		if p2 then
			store:dispatch(ParticipantRemoved((tostring(p))))
		else
			store:dispatch(ParticipantAdded((tostring(p))))
		end
	end)

	logger:debug("Initial voice state is {}", service.VoiceChatState)
	setVoiceEnabled(service.VoiceChatState)
	service.StateChanged:Connect(function(_, p)
		logger:debug("Voice state changed to {}", p)
		setVoiceEnabled(p)
	end)
end

if game:GetEngineFeature("EnableBubbleChatFromChatService") then
	Chat:GetPropertyChangedSignal("BubbleChatEnabled"):Connect(onBubbleChatEnabledChanged)
end

onBubbleChatEnabledChanged() -- inferred equivalent call

if game:GetEngineFeature("BubbleChatSettingsApi") then
	Chat.BubbleChatSettingsChanged:Connect(function(p)
		local iChatSettings, v5 = Types.IChatSettings(p)
		assert(iChatSettings, "Bad settings object passed to Chat:SetBubbleChatSettings:\n" .. (v5 or ""))

		if FFlagExpChatUseChatConfigStore then
			ExpChat.Stores.GetChatConfigurationStore(false).setBubbleChatSettings(p)
		else
			store:dispatch(UpdateChatSettings(p))
		end
	end)
end

default:asyncInit():andThen(initVoiceChat):catch(function()
	logger:debug("VoiceChatServiceManager failed to initialize")
end)
