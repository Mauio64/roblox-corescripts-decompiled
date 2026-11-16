local Chat = game:GetService("Chat")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local Promise = require(parent.Promise)
local Roact = require(parent.Roact)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local ColorMode = Foundation.Enums.ColorMode
local llama = require(parent.llama)
local dictionary = llama.Dictionary
local ExpChatShared = require(parent.ExpChatShared)
local NotificationModalsManager = require(parent.NotificationModalsManager)
local SharedFlags = require(parent.SharedFlags)
local Signals = require(parent.Signals)
local AmpUpsell = require(parent.AmpUpsell)
local AmpApiProvider = AmpUpsell.AmpApiProvider
local AccessResponseEnum = AmpUpsell.AmpEnums.AccessResponseEnum

local GetAdorneeStore = require(ExpChat.Stores.GetAdorneeStore)
local GetMessagesStore = require(ExpChat.Stores.GetMessagesStore)
local GetChannelTabsStore = require(ExpChat.Stores.GetChannelTabsStore)
local GetTransparencyStore = require(ExpChat.Stores.GetTransparencyStore)
local GetCharacterStore = require(ExpChat.Stores.GetCharacterStore)
local GetChatConfigurationStore = require(ExpChat.Stores.GetChatConfigurationStore)
local GetChatStatusStore = require(ExpChat.Stores.GetChatStatusStore)
local GetChatModerationStore = require(ExpChat.Stores.GetChatModerationStore)
local GetUserChatSettingsStore = require(ExpChat.Stores.GetUserChatSettingsStore)
local GetGlobalMutedUsersStore = require(ExpChat.Stores.GetGlobalMutedUsersStore)
local DictationSafetyReminder = require(ExpChat.ChatInput.UI.ChatInputBar.Dictation.DictationSafetyReminder)
local DictationRateLimit = require(ExpChat.ChatInput.UI.ChatInputBar.Dictation.DictationRateLimit)
local GetPresetChatStore = require(ExpChat.Stores.GetPresetChatStore)
local GetChatTooltipStore = require(ExpChat.Stores.GetChatTooltipStore)
local GetChatWindowStatusStore = require(ExpChat.Stores.GetChatWindowStatusStore)
local initializePresetChat = require(ExpChat.PresetChat.initializePresetChat)
local isMessageForOpenChannel = require(ExpChat.isMessageForOpenChannel)
local FFlagExpChatPresetChatEnabled = ExpChatShared.Flags.FFlagExpChatPresetChatEnabled
local FFlagExpChatPresetChatLoadTestEnabled = ExpChatShared.Flags.FFlagExpChatPresetChatLoadTestEnabled
local FFlagExpChatUseUnifiedTooltipStore = ExpChatShared.Flags.FFlagExpChatUseUnifiedTooltipStore
local getFFlagExpChatProtectedChatInternalAPIs = SharedFlags.getFFlagExpChatProtectedChatInternalAPIs
local FFlagExpChatDictationContinuousSafetyReminder = SharedFlags.FFlagExpChatDictationContinuousSafetyReminder
local FFlagExpChatDictationStopOnRateLimit = require(ExpChat.Flags.FFlagExpChatDictationStopOnRateLimit)
local FFlagExpChatInitializeWindowFromGameSettings = SharedFlags.FFlagExpChatInitializeWindowFromGameSettings

local FFlagExpChatUseProximityStore = SharedFlags.FFlagExpChatUseProximityStore
local GetProximityStore

if FFlagExpChatUseProximityStore then
	GetProximityStore = require(ExpChat.Stores.GetProximityStore)
else
	GetProximityStore = nil
end

local Analytics = ExpChatShared.Analytics
local countParticipantsInTextChannel = ExpChatShared.countParticipantsInTextChannel

local App = require(script.Parent.App)

local v = ExpChatShared.Logger:new("ExpChat/" .. script.Name)

local createDispatchBindableEvent = require(script.Parent.createDispatchBindableEvent)
local bindableEventQueue = require(ExpChat.Events.bindableEventQueue)
local createStore = require(script.Parent.createStore)
local GetNameColor = require(script.Parent.GetNameColor)
local reportMessageReceived = require(script.Parent.reportMessageReceived)
local canPlatformEnableChat = require(script.Parent.canPlatformEnableChat)
local watchForErrors = ExpChatShared.watchForErrors

local Commands = ExpChatShared.Commands

local Actions = ExpChat.Actions
local MarkChannelUnreadForIncomingMessage = require(Actions.MarkChannelUnreadForIncomingMessage)
local MarkChannelUnreadForSystemMessage = require(Actions.MarkChannelUnreadForSystemMessage)
local TextChannelCreated = ExpChatShared.Actions.TextChannelCreated
local TextChannelRemoved = ExpChatShared.Actions.TextChannelRemoved
local PlayerAdded = ExpChatShared.Actions.PlayerAdded
local PlayerRemoved = ExpChatShared.Actions.PlayerRemoved
local CharacterAdded = ExpChatShared.Actions.CharacterAdded
local LocalCharacterLoaded = ExpChatShared.Actions.LocalCharacterLoaded
local LocalTeamChanged = ExpChatShared.Actions.LocalTeamChanged
local ClientAppLoaded = ExpChatShared.Actions.ClientAppLoaded
local LastInputTypeChanged = require(Actions.LastInputTypeChanged)
local ChatTopBarButtonActivated = require(Actions.ChatTopBarButtonActivated)
local CommandAliasChanged = ExpChatShared.Actions.CommandAliasChanged
local HumanoidDied = require(Actions.HumanoidDied)
local AdorneeAdded = require(Actions.AdorneeAdded)
local LegacyBubbleChatEnabledChanged = require(Actions.LegacyBubbleChatEnabledChanged)
local LegacyBubbleChatSettingsChanged = require(Actions.LegacyBubbleChatSettingsChanged)
local LocalTextChannelParticipantAdded = require(Actions.LocalTextChannelParticipantAdded)
local LocalTextChannelParticipantRemoved = ExpChatShared.Actions.LocalTextChannelParticipantRemoved
local UniverseChatChannelAdded = require(Actions.UniverseChatChannelAdded)
local UniverseChatChannelSelected = ExpChatShared.Actions.UniverseChatChannelSelected

local displaySystemMessage = require(ExpChat.displaySystemMessage)
local sanitizeForRichText = require(ExpChat.sanitizeForRichText)
local generateRichSystemMessageTextFormat = require(ExpChat.generateRichSystemMessageTextFormat)
local summaryMessageRichText = require(ExpChat.summaryMessageRichText)
local TextChatMessageChatActionType = require(ExpChat.TextChatMessageChatActionType)
local getExperienceChatVisualConfig = require(ExpChat.getExperienceChatVisualConfig)
local getOtherDisplayNameInWhisperChannel = require(ExpChat.getOtherDisplayNameInWhisperChannel)
local handleChannelWelcomeMessage = require(ExpChat.handleChannelWelcomeMessage)
local isPlayerVerified = require(ExpChat.isPlayerVerified)
local isChatRegionLocked = require(ExpChat.isChatRegionLocked)
local isUserChatEnabled = require(ExpChat.isUserChatEnabled)
local canOnlyChatInRegion = require(ExpChat.canOnlyChatInRegion)
local shouldSendHighFrequencyTelemetry = require(ExpChat.shouldSendHighFrequencyTelemetry)
local shouldShowFOMOUpsell = require(ExpChat.shouldShowFOMOUpsell)
local shouldShowCrossAgeChatActivity = require(ExpChat.shouldShowCrossAgeChatActivity)
local shouldSuppressUnreadForTabMetadata = require(ExpChat.shouldSuppressUnreadForTabMetadata)
local ChatUIPrimitives = require(parent.ChatUIPrimitives)
local ExpChatPerfTracker = ChatUIPrimitives.Telemetry.ExpChatPerfTracker
local connectHistoryReplay = require(ExpChat.connectHistoryReplay)
local createHistoryReplayReporter = require(ExpChat.createHistoryReplayReporter)
local isHistoricalMessage = require(ExpChat.isHistoricalMessage)
local whenFirstTrue = require(ExpChat.whenFirstTrue)
local whenPresetAccessKnown = require(script.helpers.whenPresetAccessKnown)
local prefixWithPresetIcon = require(script.helpers.prefixWithPresetIcon)
local getChannelsWithKeptHistory = require(ExpChat.getChannelsWithKeptHistory)
local ChatUIPrimitives2 = require(parent.ChatUIPrimitives)
local FFlagExpChatPerfTrackerTabName = ChatUIPrimitives2.Flags.FFlagExpChatPerfTrackerTabName
local selectSelectedTabName = require(ExpChat.selectSelectedTabName)

local Flags = ExpChat.Flags

local getEngineFeatureFlagEnableDisplayBubble = require(Flags.getEngineFeatureFlagEnableDisplayBubble)
local getFFlagUnreduxLastInputTypeChanged = require(Flags.getFFlagUnreduxLastInputTypeChanged)
local getFFlagUseCharacterStore = ExpChatShared.Flags.getFFlagUseCharacterStore

local GetFFlagExpChatSuppressWelcomeMessageTabUnread = ExpChatShared.Flags.GetFFlagExpChatSuppressWelcomeMessageTabUnread
local getFFlagExpChatTelemetryEventTrigger = require(ExpChat.Flags.getFFlagExpChatTelemetryEventTrigger)
local FFlagExpChatWindowStatusEventFixes = require(Flags.FFlagExpChatWindowStatusEventFixes)
local defineFastInt = game:DefineFastInt("ExpChatMessageResponseThrottlePermyriad", 0)
local defineFastInt2 = game:DefineFastInt("ExpChatMessageResponseUserSamplePermyriad", 0)

local defineFastInt3 = game:DefineFastInt("ExpChatHiddenMessagesPromptThresholdLowerBound", 10)

local defineFastInt4 = game:DefineFastInt("ExpChatHiddenMessagesPromptThresholdUpperBound", 45)
local FFlagExpChatEnableFOMOUpsell = require(Flags.FFlagExpChatEnableFOMOUpsell)
local FFlagExpChatClearHiddenMessagesPostAgeCheck = require(Flags.FFlagExpChatClearHiddenMessagesPostAgeCheck)
local FFlagEnableInExpChatSummaryOnLua = require(Flags.FFlagEnableInExpChatSummaryOnLua)
local FFlagExpChatEnableCrossAgeChatActivity = require(Flags.FFlagExpChatEnableCrossAgeChatActivity)
local FFlagExpChatUnreadTabIndicatorV2Window = require(Flags.FFlagExpChatUnreadTabIndicatorV2Window)
local defineFastFlag = game:DefineFastFlag("ExpChatOnlyWakeTextForSelectedTab", false)
local FFlagExpChatFixOutgoingUniverseChatBubble = require(Flags.FFlagExpChatFixOutgoingUniverseChatBubble)
local FFlagExpChatHistoricalMessagesUnibarUnread = SharedFlags.FFlagExpChatHistoricalMessagesUnibarUnread
local FFlagExpChatRenderHistoricalMessages = SharedFlags.FFlagExpChatRenderHistoricalMessages
local FFlagExpChatReportHistoryReplayed = SharedFlags.FFlagExpChatReportHistoryReplayed
local FFlagExpChatUseAdorneeStore = SharedFlags.FFlagExpChatUseAdorneeStore
local FFlagExpChatUseChannelTabsStore = SharedFlags.FFlagExpChatUseChannelTabsStore
local FFlagExpChatUseChatConfigStore = SharedFlags.FFlagExpChatUseChatConfigStore
local FFlagEnableModerateChatRemoteEvent = SharedFlags.FFlagEnableModerateChatRemoteEvent
local FFlagLuaSupportMicroGamepadPreferredInput = SharedFlags.FFlagLuaSupportMicroGamepadPreferredInput
local FFlagEnableClientSummarySystemMessageOnLua = SharedFlags.FFlagEnableClientSummarySystemMessageOnLua
local GetFFlagTextChatEnableUniverseChatTabs = ExpChatShared.Flags.GetFFlagTextChatEnableUniverseChatTabs
local GetFFlagEnableExpChatUniverseChatTabNames = ExpChatShared.Flags.GetFFlagEnableExpChatUniverseChatTabNames
local defineFastFlag2 = game:DefineFastFlag("ExpChatRemoveSpaceFromTeamPrefix", false)
local FFlagAIRephraseSettingEnabled = SharedFlags.FFlagAIRephraseSettingEnabled
local FFlagChatSummariesSettingEnabled = SharedFlags.FFlagChatSummariesSettingEnabled
local FFlagEnableGlobalChat3pSummaryLuaApps = require(Flags.FFlagEnableGlobalChat3pSummaryLuaApps)
local FFlagExpChatEnableGlobalChatSummarySystemMessage = require(Flags.FFlagExpChatEnableGlobalChatSummarySystemMessage)
local defineFastFlag3 = game:DefineFastFlag("ExpChatSuppressGlobalSummaryTabUnread", false)
local FFlagExpChatRefactorEnabledMessageLogic = require(Flags.FFlagExpChatRefactorEnabledMessageLogic)
local FFlagExpChatMEUpdatedSystemMessage = require(Flags.FFlagExpChatMEUpdatedSystemMessage)
local FFlagExpChatVirtualizeSystemMessages = require(Flags.FFlagExpChatVirtualizeSystemMessages)
local FStringExpChatChatWithTFAmpFeatureName = require(Flags.FStringExpChatChatWithTFAmpFeatureName)
local FStringExpChatChatWithTFAmpNameSpace = require(Flags.FStringExpChatChatWithTFAmpNameSpace)

local SocialExperiments = require(parent.SocialExperiments)
local ExpChatNewSystemMessagesExperimentation = SocialExperiments.ExpChatNewSystemMessagesExperimentation

local SocialExperiments2 = require(parent.SocialExperiments)
local ExpChatGlobalTabDefaultExperimentation = SocialExperiments2.ExpChatGlobalTabDefaultExperimentation
local isGlobalTabFirst = require(ExpChat.isGlobalTabFirst)
local getGlobalWelcomeMessageKey = require(ExpChat.getGlobalWelcomeMessageKey)
local FFlagExpChatGlobalTabDefault = require(Flags.FFlagExpChatGlobalTabDefault)

function getChatTranslationEnabled()
	local success, result = pcall(function()
		return TextChatService.ChatTranslationEnabled
	end)

	return success and result
end

local v2 = {
	eventName = "MessageResponse",
	backends = { "EventIngest" },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 25, 10, 8 },
	description = "When a client receives a text chat message through TextChatService.",
	links = "https://github.rbx.com/Roblox/proto-schemas/blob/master/production/eventstream/social/message_response.proto"
}

local helpers = script.helpers
local setUpConfigurationObjects = require(helpers.setUpConfigurationObjects)
local setUpClientSettings = require(helpers.setUpClientSettings)
local waitForFirst = require(helpers.waitForFirst)
local shouldFilterGlobalMessage = require(helpers.shouldFilterGlobalMessage)
local hasUserSelectedTab = require(helpers.hasUserSelectedTab)
local writeVirtualSystemMessage = require(helpers.writeVirtualSystemMessage)
local shouldSkipHistoricalMessage = require(ExpChat.shouldSkipHistoricalMessage)

local context = ExpChatShared.context
local reportVersionLoaded = require(script.reportVersionLoaded)
local Version = ExpChatShared.Version
local AtomicBinding = require(ExpChat.AtomicBinding)
local ChatEnabledSystemMessage = require(script.SystemMessages.ChatEnabledSystemMessage)

local function watchPlayersService(joined, store, p)
	v:trace("Watching Players service")

	local v3 = {}
	local function onPlayerAdded(player)
		v:trace("Player added: {} {}", player.Name, (tostring(player.UserId)))

		local v4 = isPlayerVerified(player) and true or nil
		store:dispatch(PlayerAdded(player.UserId, player.Name, player.DisplayName, v4))

		if player == Players.LocalPlayer then
			v:trace("Found local player")

			player:GetPropertyChangedSignal("Team"):Connect(function()
				store:dispatch(LocalTeamChanged(player.Team))
			end)
		end

		local function getHumanoidBinding() -- 1 equivalent call inferred from this helper
			local function dispatchBubbleChatAdornee(data)
				local root = data.root
				local humanoid = data.humanoid
				local humanoidRootPart = data.humanoidRootPart

				if not (humanoid:IsA("Humanoid") and humanoidRootPart:IsA("BasePart")) then
					return function() end
				end

				if root and humanoidRootPart and player.Character == root then
					if FFlagExpChatUseAdorneeStore then
						context.adorneeStore.handleAdorneeAdded(player.UserId, root, humanoid)
					else
						store:dispatch(AdorneeAdded(player.UserId, root, humanoid))
					end
				end

				local diedConnection = humanoid.Died:Connect(function()
					if FFlagExpChatUseAdorneeStore then
						context.adorneeStore.handleHumanoidDied(player.UserId)
					else
						store:dispatch(HumanoidDied(player.UserId))
					end
				end)

				local function disconnectHumanoidDied()
					if diedConnection then
						diedConnection:Disconnect()
					end
				end

				return disconnectHumanoidDied
			end

			return (AtomicBinding.new(
				{ humanoid = "Humanoid", humanoidRootPart = "HumanoidRootPart" },
				dispatchBubbleChatAdornee
			))
		end

		local humanoidBinding = getHumanoidBinding() -- inferred equivalent call

		local function onCharacterAdded(character)
			if not character.Parent then
				waitForFirst(character.AncestryChanged, player.CharacterAdded)
			end

			if player.Character ~= character or not character.Parent then
				v:debug("Mismatched or unparented character in onCharacterAdded for {}", (tostring(player.UserId)))
				return
			end

			if player == Players.LocalPlayer then
				v:debug("Local character loaded: {}", character.Name)
				store:dispatch(LocalCharacterLoaded(character))
			end

			if getFFlagUseCharacterStore() then
				context.characterStore.handleCharacterAdded(player.UserId, character)
			else
				store:dispatch(CharacterAdded(player.UserId, character))
			end

			humanoidBinding:bindRoot(character)
		end

		local function onCharacterRemoving(p2)
			humanoidBinding:unbindRoot(p2)
		end

		if player.Character then
			onCharacterAdded(player.Character)
		end

		local characterAddedConnection = player.CharacterAdded:Connect(onCharacterAdded)
		local characterRemovingConnection = player.CharacterRemoving:Connect(onCharacterRemoving)

		if not v3[player.UserId] then
			v3[player.UserId] = { characterAddedConnection, characterRemovingConnection }
		end
	end

	local function onNewPlayerAdded(object)
		onPlayerAdded(object)

		if Players.LocalPlayer then
			Promise.try(function()
				return object:IsFriendsWithAsync(Players.LocalPlayer.UserId)
			end):andThen(function(p2)
				if p2 then
					displaySystemMessage(
						"InGame.UnknownNamespace.GameChat.FriendChatNotifier.JoinMessage",
						{ RBX_NAME = object.DisplayName },
						"Roblox.Notification.Friend.Joined",
						joined.translator,
						joined.defaultSystemTextChannel
					)
				end
			end):catch(function(p2)
				v:error("Could not fetch friendship status. Error: {}", (tostring(p2)))
			end)
		end
	end

	for _, player in pairs(Players:GetPlayers()) do
		if player:IsA("Player") then
			onPlayerAdded(player)
		end
	end

	Players.PlayerAdded:Connect(onNewPlayerAdded)

	Players.PlayerRemoving:Connect(function(player)
		v:trace("Player removed: {} {}", player.Name, (tostring(player.UserId)))

		if FFlagExpChatWindowStatusEventFixes and player == Players.LocalPlayer then
			local v4, v5 = GetChatWindowStatusStore(false).flushFinalDuration(os.clock())

			if v5 then
				TextChatService:SendExpChatWindowStatusChange(
					v4.closedDuration,
					v4.openDuration,
					v4.backgroundIdleDuration,
					v4.textIdleDuration
				)
			end
		end

		store:dispatch(PlayerRemoved(player.UserId))

		p.handlePlayerRemoved(player.UserId)

		if FFlagExpChatUseAdorneeStore then
			context.adorneeStore.handlePlayerRemoved(player.UserId)
		end

		if getFFlagUseCharacterStore() then
			context.characterStore.handlePlayerRemoved(player.UserId)
		end

		local v4 = v3[player.UserId]

		if v4 then
			for _, connection in ipairs(v4) do
				connection:Disconnect()
			end

			v3[player.UserId] = nil
		end
	end)
end

local v3 = {
	canUserChatAsync = function(p)
		return Chat:CanUserChatAsync(p)
	end
}

local function fn(data)
	if getFFlagExpChatProtectedChatInternalAPIs() then
		v:trace(
			"System OnIncomingMessage started: PrefixTextInternal: {} TextInternal: {}",
			data.PrefixTextInternal,
			data.TextInternal
		)
	else
		v:trace("System OnIncomingMessage started: {} {}", data.PrefixText, data.Text)
	end

	local textChatMessageProperties = Instance.new("TextChatMessageProperties")
	local text

	if FFlagEnableInExpChatSummaryOnLua then
		local v4

		if getFFlagExpChatProtectedChatInternalAPIs() then
			v4 = data.TextInternal
		else
			v4 = data.Text
		end

		text = generateRichSystemMessageTextFormat(v4, string.find(data.Metadata, "Error") and true or false)
	else
		local v4

		if string.find(data.Metadata, "Error") then
			v4 = UIBlox.App.Style.Colors.Red:ToHex()
		else
			v4 = UIBlox.App.Style.Colors.LightGrey:ToHex()
		end

		local v5

		if getFFlagExpChatProtectedChatInternalAPIs() then
			v5 = data.TextInternal
		else
			v5 = data.Text
		end

		text = string.format("<font color=\"#%s\">%s</font>", v4, v5)
	end

	textChatMessageProperties.Text = text

	v:trace(
		"System OnIncomingMessage finished: {} {}",
		textChatMessageProperties.PrefixText,
		textChatMessageProperties.Text
	)

	return textChatMessageProperties
end

return function(p)
	v:trace("mountClientApp started")

	local joined = dictionary.join(v3, p)
	local textChatService = joined.textChatService or TextChatService

	local store = createStore()
	createDispatchBindableEvent(store)
	bindableEventQueue:flush()

	local ScriptContext = game:GetService("ScriptContext")
	watchForErrors(ScriptContext, joined.script, false)

	context.translator = joined.translator

	context.store = store

	if FFlagExpChatUseAdorneeStore then
		context.adorneeStore = GetAdorneeStore(false)
	end

	if FFlagExpChatUseProximityStore then
		context.proximityStore = GetProximityStore(false)
	end

	local messagesStore = GetMessagesStore(false)
	local channelTabsStore

	if FFlagExpChatUseChannelTabsStore then
		channelTabsStore = GetChannelTabsStore(false)
	else
		channelTabsStore = nil
	end

	local v4 = FFlagExpChatVirtualizeSystemMessages and messagesStore ~= nil
	local v5 = {
		messagesStore = messagesStore,
		channelTabsStore = channelTabsStore,
		store = store,
		suppressWelcomeMessageTabUnread = GetFFlagExpChatSuppressWelcomeMessageTabUnread(),
		resetTextTransparency = function(p2: string)
			if not defineFastFlag or isMessageForOpenChannel(store:getState(), nil, p2) then
				GetTransparencyStore(false).resetTextTransparency()
			end
		end
	}

	local function showWelcomeSystemMessage(data, textChannel)
		if not v4 then
			displaySystemMessage(data.key, data.args, data.metadata, joined.translator, textChannel)
			return
		end

		if not textChannel then
			return
		end

		local success, result = pcall(function()
			return joined.translator:FormatByKey(data.key, data.args)
		end)

		if not success or type(result) ~= "string" or result == "" then
			return
		end

		writeVirtualSystemMessage(v5, {
			text = result,
			channelName = textChannel.Name,
			metadata = data.metadata,
			textChannel = textChannel
		})
	end
	local function showVirtualChatEnabledSystemMessage(p2: string, p3, p4: string)
		local defaultSystemTextChannel = joined.defaultSystemTextChannel

		if not defaultSystemTextChannel then
			return
		end

		local success, result = pcall(function()
			return joined.translator:FormatByKey(p2, p3)
		end)

		if not success or type(result) ~= "string" or result == "" then
			result = p4
		end

		writeVirtualSystemMessage(v5, {
			text = result,
			channelName = "RBXGeneral",
			metadata = "Roblox.ChatEnabled.Info",
			textChannel = defaultSystemTextChannel
		})
	end

	local v6

	if FFlagExpChatUseChatConfigStore then
		v6 = GetChatConfigurationStore(false)
	else
		v6 = nil
	end

	local chatStatusStore = GetChatStatusStore(false)

	context.messagesStore = messagesStore

	context.globalMutedUsersStore = GetGlobalMutedUsersStore(false)

	if getFFlagUseCharacterStore() then
		context.characterStore = GetCharacterStore(false)
	end

	if joined.analytics then
		Analytics.with(joined.analytics)
	end

	if not getFFlagUnreduxLastInputTypeChanged() then
		UserInputService.LastInputTypeChanged:Connect(function(p2)
			store:dispatch(LastInputTypeChanged(p2))
		end)
	end

	if joined.defaultSystemTextChannel then
		joined.defaultSystemTextChannel.OnIncomingMessage = fn
	else
		Chat:GetPropertyChangedSignal("IsAutoMigrated"):Once(function()
			local rbxSystem = textChatService:FindFirstChild("RBXSystem", true)

			if rbxSystem and rbxSystem:IsA("TextChannel") then
				joined.defaultSystemTextChannel = rbxSystem
				rbxSystem.OnIncomingMessage = fn
			end
		end)
	end

	setUpConfigurationObjects(store, joined)
	setUpClientSettings(store)

	if FFlagExpChatInitializeWindowFromGameSettings then
		store:dispatch(ChatTopBarButtonActivated(UserSettings().GameSettings.ChatVisible))
	end

	local localPlayer = Players.LocalPlayer

	if localPlayer then
		localPlayer:GetPropertyChangedSignal("Team"):Connect(function()
			local team = localPlayer.Team

			if team then
				displaySystemMessage(
					"InGame.UnknownNamespace.GameChat_TeamChat_NowInTeam",
					{ RBX_NAME = team.Name },
					"Roblox.Team.Success.NowInTeam",
					joined.translator,
					joined.defaultSystemTextChannel
				)
			end
		end)
	end

	local v7 = {
		[Enum.TextChatMessageStatus.Floodchecked] = {
			key = "CoreScripts.TextChat.MessageStatus.Warning.Floodchecked",
			metadata = "Roblox.MessageStatus.Warning.Floodchecked"
		},
		[Enum.TextChatMessageStatus.TextFilterFailed] = {
			key = "CoreScripts.TextChat.MessageStatus.Warning.TextFilterFailed",
			metadata = "Roblox.MessageStatus.Warning.TextFilterFailed"
		},
		[Enum.TextChatMessageStatus.InvalidPrivacySettings] = {
			key = "CoreScripts.TextChat.MessageStatus.Warning.InvalidPrivacySettings",
			metadata = "Roblox.MessageStatus.Warning.InvalidPrivacySettings"
		},
		[Enum.TextChatMessageStatus.MessageTooLong] = {
			key = "CoreScripts.TextChat.MessageStatus.Warning.MessageTooLong",
			metadata = "Roblox.MessageStatus.Warning.MessageTooLong"
		},
		[Enum.TextChatMessageStatus.ModerationTimeout] = {
			key = "CoreScripts.TextChat.MessageStatus.Warning.ModerationTimeout",
			metadata = "Roblox.MessageStatus.Warning.ModerationTimeout"
		},
		[Enum.TextChatMessageStatus.Unknown] = {
			key = "CoreScripts.TextChat.MessageStatus.Warning.Unknown",
			metadata = "Roblox.MessageStatus.Warning.Unknown"
		}
	}

	local function processHistoricalMessage(p2, childName: string?, flag: boolean?) -- 2 equivalent calls inferred from this helper
		local v8 = localPlayer ~= nil and p2.TextSource ~= nil and p2.TextSource.UserId == localPlayer.UserId
		messagesStore.handleIncomingOrOutgoingMessage(p2, v8, childName, flag, true)
	end

	local function _processIncomingMessageCore(data, childName: string?, flag: boolean?)
		if FFlagExpChatRenderHistoricalMessages and isHistoricalMessage(data) then
			processHistoricalMessage(data, childName, flag) -- inferred equivalent call
		else
			if shouldSkipHistoricalMessage(data) then
				return
			end

			if getFFlagExpChatProtectedChatInternalAPIs() then
				v:debug("Incoming MessageReceived Status: {} TextInternal: {}", data.Status.Name, data.TextInternal)
			else
				v:debug("Incoming MessageReceived Status: {} Text: {}", data.Status.Name, data.Text)
			end

			if (data.TextSource and data.TextSource.UserId or "UNKNOWN_TEXT_SOURCE_USER_ID") ~= (localPlayer and localPlayer.UserId or "UNKNOWN_LOCAL_USER_ID") then
				ExpChatPerfTracker.start(
					ExpChatPerfTracker.Events.MessageReceiveToWindowRenderInterval,
					{ messageId = data.MessageId },
					FFlagExpChatPerfTrackerTabName and {
						tabName = selectSelectedTabName(store:getState())
					} or nil
				)
			end

			if localPlayer then
				reportMessageReceived(localPlayer.UserId, data)
			end

			local v8 = localPlayer
				and data.TextSource
				and data.TextSource.UserId ~= localPlayer.UserId
				and handleChannelWelcomeMessage(data, localPlayer)

			if v8 then
				showWelcomeSystemMessage(v8, data.TextChannel)
			end

			local v9 = localPlayer and data.TextSource and data.TextSource.UserId == localPlayer.UserId

			local v10 = not defineFastFlag or isMessageForOpenChannel(store:getState(), data, childName)

			messagesStore.handleIncomingOrOutgoingMessage(data, v9, childName, flag)

			if v10 then
				GetTransparencyStore(false).resetTextTransparency()
			end

			if FFlagExpChatUseChannelTabsStore and channelTabsStore then
				channelTabsStore.handleIncomingOrOutgoingMessage(data, v9, childName)
			elseif FFlagExpChatUnreadTabIndicatorV2Window then
				store:dispatch(MarkChannelUnreadForIncomingMessage(data, v9, childName, flag))
			end

			local v11 = v7[data.Status]
			local v12 = nil

			if
				FFlagExpChatDictationStopOnRateLimit
				and DictationRateLimit.onIncomingMessage(data, localPlayer and localPlayer.UserId)
			then
				local stoppedMessage = DictationRateLimit.getStoppedMessage(joined.translator)

				if stoppedMessage ~= "" then
					v12 = stoppedMessage
				end
			end

			if v11 then
				local result, success

				if FFlagExpChatDictationStopOnRateLimit then
					if v12 then
						result = v12
						success = true
					else
						success, result = pcall(function()
							return joined.translator:FormatByKey(v11.key)
						end)
					end
				else
					success, result = pcall(function()
						return joined.translator:FormatByKey(v11.key)
					end)
				end

				local v13 = success and result and result ~= ""

				if childName and v13 then
					local addSystemMessage = messagesStore.addSystemMessage
					local v14

					if GetFFlagExpChatSuppressWelcomeMessageTabUnread() then
						v14 = v11.metadata
					end

					addSystemMessage(result, childName, v14)

					if
						FFlagExpChatUseChannelTabsStore
						and channelTabsStore
						and not (GetFFlagExpChatSuppressWelcomeMessageTabUnread() and shouldSuppressUnreadForTabMetadata(v11.metadata))
					then
						channelTabsStore.markChannelUnread(childName)
					elseif FFlagExpChatUnreadTabIndicatorV2Window then
						local v15

						if GetFFlagExpChatSuppressWelcomeMessageTabUnread() then
							v15 = v11.metadata
						end

						store:dispatch(MarkChannelUnreadForSystemMessage(result, childName, v15))
					end
				else
					local v14 = joined.defaultSystemTextChannel

					if childName then
						local textChannel = textChatService:FindFirstChild(childName)

						if textChannel and textChannel:IsA("TextChannel") then
							v14 = textChannel
						end
					end

					if FFlagExpChatDictationStopOnRateLimit then
						if v12 and v14 then
							v14:DisplaySystemMessage(sanitizeForRichText(v12), v11.metadata)
						else
							displaySystemMessage(v11.key, nil, v11.metadata, joined.translator, v14)
						end
					else
						displaySystemMessage(v11.key, nil, v11.metadata, joined.translator, v14)
					end
				end
			end

			if shouldSendHighFrequencyTelemetry(defineFastInt2) then
				Analytics:TelemetryLogEvent(v2, { messageStatus = data.Status.Name }, {
					"addOsInfo",
					"addSessionId",
					"addUniverseId",
					"addPlaceId"
				})
			end
		end
	end

	local function processIncomingMessage(data, p2: string?) -- 2 equivalent calls inferred from this helper
		_processIncomingMessageCore(data, p2, nil)
	end

	local function processIncomingMessageWithOptions(p2, p3) -- 2 equivalent calls inferred from this helper
		_processIncomingMessageCore(p2, p3 and p3.channelNameOverride, p3 and p3.isUniverseChat)
	end

	local function handleMessageReceived(descendant)
		store:dispatch(TextChannelCreated(descendant))

		local channelTabsConfiguration = textChatService:FindFirstChildOfClass("ChannelTabsConfiguration")
		local v8

		if channelTabsConfiguration then
			v8 = channelTabsConfiguration.Enabled
		else
			v8 = false
		end

		if string.find(descendant.Name, "RBXGeneral") then
			descendant.OnIncomingMessage = function(data)
				local textChatMessageProperties = Instance.new("TextChatMessageProperties")

				if not data.TextSource then
					return textChatMessageProperties
				end

				local nameColor = GetNameColor(data.TextSource.UserId)

				if data.ChatWindowMessageProperties then
					return textChatMessageProperties
				end

				local v9

				if getFFlagExpChatProtectedChatInternalAPIs() then
					v9 = data.PrefixTextInternal
				else
					v9 = data.PrefixText
				end

				textChatMessageProperties.PrefixText = string.format(
					"<font color=\"#%s\">%s</font>",
					nameColor:ToHex(),
					v9
				)

				return textChatMessageProperties
			end
		elseif string.find(descendant.Name, "^RBXTeam") then
			descendant.OnIncomingMessage = function(data)
				local v9

				if getFFlagExpChatProtectedChatInternalAPIs() then
					v9 = data.PrefixTextInternal
				else
					v9 = data.PrefixText
				end

				if getFFlagExpChatProtectedChatInternalAPIs() then
					v:trace(
						"Team OnIncomingMessage started: PrefixTextInternal: {} TextInternal: {}",
						v9,
						data.TextInternal
					)
				else
					v:trace("Team OnIncomingMessage started: {} {}", v9, data.Text)
				end

				local textChatMessageProperties = Instance.new("TextChatMessageProperties")

				if Players.LocalPlayer then
					local color = Players.LocalPlayer.TeamColor.Color
					local v10

					if defineFastFlag2 then
						v10 = v8 and "" or #(v9 or "") > 0 and "[Team] " or "[Team]"
					else
						v10 = v8 and "" or "[Team] "
					end

					textChatMessageProperties.PrefixText = string.format(
						"<font color=\"#%s\">%s%s</font>",
						color:ToHex(),
						v10,
						v9
					)
				end

				v:trace(
					"Team OnIncomingMessage finished: {} {}",
					textChatMessageProperties.PrefixText,
					textChatMessageProperties.Text
				)

				return textChatMessageProperties
			end
		elseif string.find(descendant.Name, "^RBXWhisper") and localPlayer then
			descendant.OnIncomingMessage = function(data)
				local textSource = data.TextSource

				local v9 = textSource and getOtherDisplayNameInWhisperChannel(descendant, localPlayer)

				if not v9 then
					return nil
				end

				local v10

				if not v8 then
					if textSource.UserId == localPlayer.UserId then
						v10 = joined.translator:FormatByKey("CoreScripts.TextChat.WhisperChat.PrefixText.Outgoing", {
							RBX_NAME = v9
						})
					else
						v10 = joined.translator:FormatByKey("CoreScripts.TextChat.WhisperChat.PrefixText.Incoming", {
							RBX_NAME = v9
						})
					end
				end

				local textChatMessageProperties = Instance.new("TextChatMessageProperties")
				local nameColor = GetNameColor(textSource.UserId)

				local v11 = not v10 and "" or v10 .. " "
				local hex = nameColor:ToHex()
				local v12

				if getFFlagExpChatProtectedChatInternalAPIs() then
					v12 = data.PrefixTextInternal
				else
					v12 = data.PrefixText
				end

				textChatMessageProperties.PrefixText = string.format("%s<font color=\"#%s\">%s</font>", v11, hex, v12)

				return textChatMessageProperties
			end
		end

		descendant.MessageReceived:Connect(function(data)
			if shouldSkipHistoricalMessage(data) then
				return
			end

			if FFlagExpChatDictationContinuousSafetyReminder then
				DictationSafetyReminder.onIncomingMessage(data)
			end

			if GetFFlagTextChatEnableUniverseChatTabs() then
				processIncomingMessage(data) -- inferred equivalent call
				return
			end

			if getFFlagExpChatProtectedChatInternalAPIs() then
				v:debug("Incoming MessageReceived Status: {} TextInternal: {}", data.Status.Name, data.TextInternal)
			else
				v:debug("Incoming MessageReceived Status: {} Text: {}", data.Status.Name, data.Text)
			end

			if (data.TextSource and data.TextSource.UserId or "UNKNOWN_TEXT_SOURCE_USER_ID") ~= (localPlayer and localPlayer.UserId or "UNKNOWN_LOCAL_USER_ID") then
				ExpChatPerfTracker.start(
					ExpChatPerfTracker.Events.MessageReceiveToWindowRenderInterval,
					{ messageId = data.MessageId },
					FFlagExpChatPerfTrackerTabName and {
						tabName = selectSelectedTabName(store:getState())
					} or nil
				)
			end

			if localPlayer then
				reportMessageReceived(localPlayer.UserId, data)
			end

			local v9 = localPlayer
				and data.TextSource
				and data.TextSource.UserId ~= localPlayer.UserId
				and handleChannelWelcomeMessage(data, localPlayer)

			if v9 then
				showWelcomeSystemMessage(v9, data.TextChannel)
			end

			local v10 = localPlayer and data.TextSource and data.TextSource.UserId == localPlayer.UserId

			messagesStore.handleIncomingOrOutgoingMessage(data, v10)
			GetTransparencyStore(false).resetTextTransparency()

			if FFlagExpChatUseChannelTabsStore and channelTabsStore then
				channelTabsStore.handleIncomingOrOutgoingMessage(data, v10)
			elseif FFlagExpChatUnreadTabIndicatorV2Window then
				store:dispatch(MarkChannelUnreadForIncomingMessage(data, v10))
			end

			if data.Status == Enum.TextChatMessageStatus.Floodchecked then
				if FFlagExpChatDictationStopOnRateLimit then
					local v11 = nil

					if DictationRateLimit.onIncomingMessage(data, localPlayer and localPlayer.UserId) then
						local stoppedMessage = DictationRateLimit.getStoppedMessage(joined.translator)

						if stoppedMessage ~= "" then
							v11 = stoppedMessage
						end
					end

					if v11 and joined.defaultSystemTextChannel then
						joined.defaultSystemTextChannel:DisplaySystemMessage(
							sanitizeForRichText(v11),
							"Roblox.MessageStatus.Warning.Floodchecked"
						)
					else
						displaySystemMessage(
							"CoreScripts.TextChat.MessageStatus.Warning.Floodchecked",
							nil,
							"Roblox.MessageStatus.Warning.Floodchecked",
							joined.translator,
							joined.defaultSystemTextChannel
						)
					end
				else
					displaySystemMessage(
						"CoreScripts.TextChat.MessageStatus.Warning.Floodchecked",
						nil,
						"Roblox.MessageStatus.Warning.Floodchecked",
						joined.translator,
						joined.defaultSystemTextChannel
					)
				end
			elseif data.Status == Enum.TextChatMessageStatus.TextFilterFailed then
				displaySystemMessage(
					"CoreScripts.TextChat.MessageStatus.Warning.TextFilterFailed",
					nil,
					"Roblox.MessageStatus.Warning.TextFilterFailed",
					joined.translator,
					joined.defaultSystemTextChannel
				)
			elseif data.Status == Enum.TextChatMessageStatus.InvalidPrivacySettings then
				displaySystemMessage(
					"CoreScripts.TextChat.MessageStatus.Warning.InvalidPrivacySettings",
					nil,
					"Roblox.MessageStatus.Warning.InvalidPrivacySettings",
					joined.translator,
					joined.defaultSystemTextChannel
				)
			elseif data.Status == Enum.TextChatMessageStatus.MessageTooLong then
				displaySystemMessage(
					"CoreScripts.TextChat.MessageStatus.Warning.MessageTooLong",
					nil,
					"Roblox.MessageStatus.Warning.MessageTooLong",
					joined.translator,
					joined.defaultSystemTextChannel
				)
			elseif data.Status == Enum.TextChatMessageStatus.ModerationTimeout then
				displaySystemMessage(
					"CoreScripts.TextChat.MessageStatus.Warning.ModerationTimeout",
					nil,
					"Roblox.MessageStatus.Warning.ModerationTimeout",
					joined.translator,
					joined.defaultSystemTextChannel
				)
			elseif data.Status == Enum.TextChatMessageStatus.Unknown then
				displaySystemMessage(
					"CoreScripts.TextChat.MessageStatus.Warning.Unknown",
					nil,
					"Roblox.MessageStatus.Warning.Unknown",
					joined.translator,
					joined.defaultSystemTextChannel
				)
			end

			if shouldSendHighFrequencyTelemetry(defineFastInt2) then
				Analytics:TelemetryLogEvent(v2, { messageStatus = data.Status.Name }, {
					"addOsInfo",
					"addSessionId",
					"addUniverseId",
					"addPlaceId"
				})
			end
		end)
	end

	local function watchTextChatCommand(descendant) -- 2 equivalent calls inferred from this helper
		descendant.Triggered:Connect(function()
			Analytics.FireClientAnalyticsWithEventName("CommandSent", {
				commandName = descendant.Name
			})
		end)
	end

	for _, descendant in pairs(textChatService:GetDescendants()) do
		if descendant:IsA("TextChannel") then
			handleMessageReceived(descendant)
		elseif descendant:IsA("TextChatCommand") then
			watchTextChatCommand(descendant) -- inferred equivalent call
		end
	end

	local v8 = false
	local v9 = false
	local nameSet = {}

	local v10 = false
	local function tryLogExposureNewSystemMessages() -- 6 equivalent calls inferred from this helper
		if ExpChatNewSystemMessagesExperimentation.isExperimentEnabled and not v10 then
			v10 = true
			ExpChatNewSystemMessagesExperimentation.logExposure()
		end
	end

	local function postProcessSummarySystemMessage(p2: string)
		return summaryMessageRichText.wrapInSummaryMutedStyle(`{summaryMessageRichText.getSummaryIconPrefix()} {p2}`)
	end

	local function tryShowSummarySystemMessageOnChannel(textChannel)
		if not textChannel or not v8 or nameSet[textChannel.Name] or textChannel.Name ~= "RBXGeneral" then
			return
		end

		nameSet[textChannel.Name] = true

		if ExpChatNewSystemMessagesExperimentation.isExperimentEnabled then
			tryLogExposureNewSystemMessages() -- inferred equivalent call
		end

		if not v4 then
			displaySystemMessage(
				ExpChatNewSystemMessagesExperimentation.getNewSystemMessagesEnabled() and "CoreScripts.TextChat.Description.RobloxSummarizesMessagesFromAllPlayers" or "CoreScripts.TextChat.ChatWindow.SummarySystemMessage",
				nil,
				"Roblox.Summary.Info",
				joined.translator,
				textChannel,
				ExpChatNewSystemMessagesExperimentation.getNewSystemMessagesEnabled() and "Roblox summarizes messages from players of all ages." or "Roblox auto-generates summaries of players' messages.",
				postProcessSummarySystemMessage
			)

			return
		end

		local newSystemMessagesEnabled = ExpChatNewSystemMessagesExperimentation.getNewSystemMessagesEnabled()
		local v11 = newSystemMessagesEnabled
			and "CoreScripts.TextChat.Description.RobloxSummarizesMessagesFromAllPlayers"
			or "CoreScripts.TextChat.ChatWindow.SummarySystemMessage"
		local success, result = pcall(function()
			return joined.translator:FormatByKey(v11)
		end)

		writeVirtualSystemMessage(v5, {
			text = (not success or type(result) ~= "string" or result == "") and (newSystemMessagesEnabled and "Roblox summarizes messages from players of all ages." or "Roblox auto-generates summaries of players' messages.") or result,
			channelName = textChannel.Name,
			metadata = "Roblox.Summary.Info",
			postProcessMessage = postProcessSummarySystemMessage,
			textChannel = textChannel
		})
	end

	local function tryAddThirdPartySummaryGlobalSystemMessage()
		if
			v9
			or not (v8 and FFlagExpChatEnableGlobalChatSummarySystemMessage and GetFFlagTextChatEnableUniverseChatTabs() and textChatService:HasAllocatedUniverseChatContext("global"))
		then
			return
		end

		local formatByKey = joined.translator:FormatByKey("CoreScripts.TextChat.ChatWindow.SummarySystemMessage")

		v9 = true
		messagesStore.addSystemMessage(
			formatByKey,
			"RBXGlobal",
			defineFastFlag3 and "Roblox.Summary.GlobalChat" or nil,
			postProcessSummarySystemMessage
		)
	end

	textChatService.DescendantAdded:Connect(function(descendant)
		if descendant:IsA("TextChannel") then
			handleMessageReceived(descendant)

			if FFlagEnableInExpChatSummaryOnLua and FFlagEnableClientSummarySystemMessageOnLua then
				tryShowSummarySystemMessageOnChannel(descendant)
			end
		elseif descendant:IsA("TextChatCommand") then
			watchTextChatCommand(descendant) -- inferred equivalent call
		end
	end)

	textChatService.DescendantRemoving:Connect(function(textChannel)
		if textChannel:IsA("TextChannel") then
			store:dispatch(TextChannelRemoved(textChannel))

			if FFlagExpChatUseChannelTabsStore and channelTabsStore then
				channelTabsStore.handleChannelRemoved(textChannel.Name)
			end
		end
	end)

	if FFlagEnableInExpChatSummaryOnLua then
		textChatService.ChatActionReceived:Connect(function(data)
			if getFFlagExpChatProtectedChatInternalAPIs() then
				v:debug(
					"Incoming ChatActionReceived ChatActionType: {}, TextInternal: {}",
					data.ChatActionType,
					data.TextInternal
				)
			else
				v:debug("Incoming ChatActionReceived ChatActionType: {}, Text: {}", data.ChatActionType, data.Text)
			end

			if data.ChatActionType ~= TextChatMessageChatActionType.Summary then
				v:error("Unknown ChatActionType: {}", data.ChatActionType)

				return
			end

			if not FFlagEnableGlobalChat3pSummaryLuaApps then
				processIncomingMessage(data) -- inferred equivalent call
				return
			end

			processIncomingMessageWithOptions( -- inferred equivalent call
				data,
				data.TextChannel == nil and {
					channelNameOverride = "RBXGlobal",
					isUniverseChat = true
				} or nil
			)
		end)
	end

	if FFlagEnableInExpChatSummaryOnLua or FFlagAIRephraseSettingEnabled or FFlagChatSummariesSettingEnabled then
		coroutine.wrap(function()
			local expChatFeatureValueChanged = RobloxReplicatedStorage:WaitForChild("ExpChatFeatureValueChanged", 10)

			if expChatFeatureValueChanged then
				expChatFeatureValueChanged.OnClientEvent:Connect(function(p2: number, p3: string, p4: string)
					v:debug(
						"Incoming ExpChatFeatureValueChanged userId: {}, featureName: {}, featureValue: {}",
						p2,
						p3,
						p4
					)

					if localPlayer and p2 == localPlayer.UserId then
						if
							FFlagEnableClientSummarySystemMessageOnLua
							and p3 == "EligibleForThirdPartySummary"
							and not FFlagChatSummariesSettingEnabled
						then
							v8 = p4 == "true"

							if v8 then
								for _, textChannel in textChatService:GetDescendants() do
									if textChannel:IsA("TextChannel") then
										tryShowSummarySystemMessageOnChannel(textChannel)
									end
								end

								tryAddThirdPartySummaryGlobalSystemMessage()
							end
						end

						if FFlagAIRephraseSettingEnabled and p3 == "AIRephraseSettingStatus" then
							GetUserChatSettingsStore.updateExpChatFeatureValue("AIRephraseSettingStatus", p4)
						end

						if FFlagChatSummariesSettingEnabled and p3 == "AllowThirdPartySummary" then
							GetUserChatSettingsStore.updateExpChatFeatureValue("AllowThirdPartySummary", p4)
							v8 = p4 == "Enabled"

							if v8 then
								for _, textChannel in textChatService:GetDescendants() do
									if textChannel:IsA("TextChannel") then
										tryShowSummarySystemMessageOnChannel(textChannel)
									end
								end

								tryAddThirdPartySummaryGlobalSystemMessage()
							end
						end
					end
				end)
			end
		end)()
	end

	local function markChannelsUnreadForKeptHistory(list)
		local getHistoricalWindowMessageCount = messagesStore.getHistoricalWindowMessageCount

		local channelsWithKeptHistory = getChannelsWithKeptHistory(
			list,
			not getHistoricalWindowMessageCount and 0 or getHistoricalWindowMessageCount(false)
		)

		for k, v11 in channelsWithKeptHistory do
			if FFlagExpChatUseChannelTabsStore and channelTabsStore then
				channelTabsStore.markChannelUnread(k)
			elseif FFlagExpChatUnreadTabIndicatorV2Window then
				store:dispatch(MarkChannelUnreadForIncomingMessage(v11, false))
			end
		end
	end

	if FFlagExpChatRenderHistoricalMessages then
		whenFirstTrue(messagesStore.getCanLocalUserChat, function()
			local v11

			if FFlagExpChatReportHistoryReplayed then
				v11 = createHistoryReplayReporter({
					getHistoricalCount = messagesStore.getHistoricalWindowMessageCount and function()
						return messagesStore.getHistoricalWindowMessageCount(false)
					end or nil
				})
			else
				v11 = nil
			end

			connectHistoryReplay(function(list)
				messagesStore.batchWrites(function()
					for _, item in list do
						processHistoricalMessage(item) -- inferred equivalent call
					end
				end)

				if FFlagExpChatHistoricalMessagesUnibarUnread then
					markChannelsUnreadForKeptHistory(list)
				end

				if v11 then
					v11(#list)
				end
			end)
		end)
	end

	textChatService.SendingMessage:Connect(function(data)
		if FFlagExpChatDictationContinuousSafetyReminder then
			DictationSafetyReminder.onOutgoingMessage(data)
		end

		ExpChatPerfTracker.start(
			ExpChatPerfTracker.Events.MessageSendToWindowRenderInterval,
			{ messageId = data.MessageId },
			FFlagExpChatPerfTrackerTabName and {
				tabName = selectSelectedTabName(store:getState())
			} or nil
		)

		if getFFlagExpChatProtectedChatInternalAPIs() then
			v:debug("Outgoing SendingMessage Status: {} TextInternal: {}", data.Status.Name, data.TextInternal)
		else
			v:debug("Outgoing SendingMessage Status: {} Text: {}", data.Status.Name, data.Text)
		end

		if localPlayer then
			local v11 = handleChannelWelcomeMessage(data, localPlayer)

			if v11 and v11.key then
				showWelcomeSystemMessage(v11, data.TextChannel)
			end
		end

		messagesStore.handleIncomingOrOutgoingMessage(data, true)

		local textChannel = data.TextChannel

		if textChannel then
			Analytics.FireClientAnalyticsWithEventName("MessageSent", {
				channelName = textChannel.Name,
				totalParticipants = countParticipantsInTextChannel(textChannel)
			})
		end
	end)

	local function connectSendingUniverseChatMessage()
		if not GetFFlagTextChatEnableUniverseChatTabs() then
			return
		end

		textChatService.SendingUniverseChatMessage:Connect(function(data)
			if FFlagExpChatDictationContinuousSafetyReminder then
				DictationSafetyReminder.onOutgoingMessage(data)
			end

			ExpChatPerfTracker.start(
				ExpChatPerfTracker.Events.MessageSendToWindowRenderInterval,
				{ messageId = data.MessageId },
				FFlagExpChatPerfTrackerTabName and {
					tabName = selectSelectedTabName(store:getState())
				} or nil
			)

			if getFFlagExpChatProtectedChatInternalAPIs() then
				v:debug("Outgoing SendingMessage Status: {} TextInternal: {}", data.Status.Name, data.TextInternal)
			else
				v:debug("Outgoing SendingMessage Status: {} Text: {}", data.Status.Name, data.Text)
			end

			if localPlayer then
				local v11 = handleChannelWelcomeMessage(data, localPlayer)

				if v11 and v11.key then
					showWelcomeSystemMessage(v11, data.TextChannel)
				end
			end

			local chatInputBarConfiguration = textChatService:FindFirstChildOfClass("ChatInputBarConfiguration")
			local v11 = not (chatInputBarConfiguration and chatInputBarConfiguration.TargetTextChannel)
				and "RBXGlobal"
				or nil

			local v12 = FFlagExpChatGlobalTabDefault
				and selectSelectedTabName(store:getState()) == "RBXGlobal"
				and "RBXGlobal"
				or v11

			messagesStore.handleIncomingOrOutgoingMessage(
				data,
				true,
				v12,
				FFlagExpChatFixOutgoingUniverseChatBubble and true or nil
			)

			if FFlagExpChatUseChannelTabsStore and channelTabsStore then
				channelTabsStore.handleIncomingOrOutgoingMessage(data, true, v12)
			end

			local textChannel = data.TextChannel

			if textChannel then
				Analytics.FireClientAnalyticsWithEventName("MessageSent", {
					channelName = textChannel.Name,
					totalParticipants = countParticipantsInTextChannel(textChannel)
				})
			end
		end)
	end

	if GetFFlagTextChatEnableUniverseChatTabs() then
		textChatService.SendingUniverseChatMessage:Connect(function(data)
			if FFlagExpChatDictationContinuousSafetyReminder then
				DictationSafetyReminder.onOutgoingMessage(data)
			end

			ExpChatPerfTracker.start(
				ExpChatPerfTracker.Events.MessageSendToWindowRenderInterval,
				{ messageId = data.MessageId },
				FFlagExpChatPerfTrackerTabName and {
					tabName = selectSelectedTabName(store:getState())
				} or nil
			)

			if getFFlagExpChatProtectedChatInternalAPIs() then
				v:debug("Outgoing SendingMessage Status: {} TextInternal: {}", data.Status.Name, data.TextInternal)
			else
				v:debug("Outgoing SendingMessage Status: {} Text: {}", data.Status.Name, data.Text)
			end

			if localPlayer then
				local v11 = handleChannelWelcomeMessage(data, localPlayer)

				if v11 and v11.key then
					showWelcomeSystemMessage(v11, data.TextChannel)
				end
			end

			local chatInputBarConfiguration = textChatService:FindFirstChildOfClass("ChatInputBarConfiguration")
			local v11 = not (chatInputBarConfiguration and chatInputBarConfiguration.TargetTextChannel)
				and "RBXGlobal"
				or nil

			local v12 = FFlagExpChatGlobalTabDefault
				and selectSelectedTabName(store:getState()) == "RBXGlobal"
				and "RBXGlobal"
				or v11

			messagesStore.handleIncomingOrOutgoingMessage(
				data,
				true,
				v12,
				FFlagExpChatFixOutgoingUniverseChatBubble and true or nil
			)

			if FFlagExpChatUseChannelTabsStore and channelTabsStore then
				channelTabsStore.handleIncomingOrOutgoingMessage(data, true, v12)
			end

			local textChannel = data.TextChannel

			if textChannel then
				Analytics.FireClientAnalyticsWithEventName("MessageSent", {
					channelName = textChannel.Name,
					totalParticipants = countParticipantsInTextChannel(textChannel)
				})
			end
		end)
	end

	local function isInstanceALocalTextChannelParticipant(textSource) -- 2 equivalent calls inferred from this helper
		return textSource
			and textSource:IsA("TextSource")
			and Players.LocalPlayer
			and Players.LocalPlayer.UserId == textSource.UserId
	end

	local function getChannelTabIndex(p2: string): number -- 1 equivalent call inferred from this helper
		if p2 == "RBXGeneral" then
			return 1
		elseif p2 == "RBXGlobal" then
			return 2
		end

		return 3
	end

	for _, descendant in pairs(textChatService:GetDescendants()) do
		if
			descendant.Parent
			and descendant.Parent:IsA("TextChannel")
			and descendant
			and descendant:IsA("TextSource")
			and Players.LocalPlayer
			and Players.LocalPlayer.UserId == descendant.UserId
		then
			if FFlagExpChatUseChannelTabsStore and channelTabsStore then
				channelTabsStore.handleLocalTextChannelParticipantAdded(descendant.Parent)
			else
				store:dispatch(LocalTextChannelParticipantAdded(descendant.Parent))
			end
		end

		if descendant:IsA("TextChannel") then
			descendant.DescendantRemoving:Connect(function(descendant2)
				if isInstanceALocalTextChannelParticipant(descendant2) then -- inferred equivalent call
					store:dispatch(LocalTextChannelParticipantRemoved(descendant))

					if FFlagExpChatUseChannelTabsStore and channelTabsStore then
						local name = descendant.Name
						channelTabsStore.handleChannelRemoved(name)
					end
				end
			end)
		end
	end

	textChatService.DescendantAdded:Connect(function(descendant)
		if
			descendant.Parent
			and descendant.Parent:IsA("TextChannel")
			and descendant
			and descendant:IsA("TextSource")
			and Players.LocalPlayer
			and Players.LocalPlayer.UserId == descendant.UserId
		then
			if FFlagExpChatUseChannelTabsStore and channelTabsStore then
				channelTabsStore.handleLocalTextChannelParticipantAdded(descendant.Parent)
			else
				store:dispatch(LocalTextChannelParticipantAdded(descendant.Parent))
			end
		end

		if descendant:IsA("TextChannel") then
			descendant.DescendantRemoving:Connect(function(descendant2)
				if isInstanceALocalTextChannelParticipant(descendant2) then -- inferred equivalent call
					store:dispatch(LocalTextChannelParticipantRemoved(descendant))

					if FFlagExpChatUseChannelTabsStore and channelTabsStore then
						local name = descendant.Name
						channelTabsStore.handleChannelRemoved(name)
					end
				end
			end)
		end
	end)

	if GetFFlagTextChatEnableUniverseChatTabs() then
		local set = {}

		local function handleUniverseChatChannelAllocated(p2: string)
			if set[p2] then
				return
			end

			set[p2] = true

			local chatWindowConfiguration = textChatService:FindFirstChildOfClass("ChatWindowConfiguration")
			local chatInputBarConfiguration = textChatService:FindFirstChildOfClass("ChatInputBarConfiguration")
			local v11 = not chatWindowConfiguration or chatWindowConfiguration.Enabled ~= false
			local v12 = not chatInputBarConfiguration or chatInputBarConfiguration.Enabled ~= false

			if not (v11 and v12) then
				return
			end

			local name

			if p2 == "global" then
				name = "RBXGlobal"

				if FFlagExpChatUseUnifiedTooltipStore then
					GetChatTooltipStore(false).setIsGlobalChatAvailable(true)
				end

				if FFlagExpChatGlobalTabDefault then
					ExpChatGlobalTabDefaultExperimentation.logExposure()
				end
			else
				name = ""
			end

			if FFlagExpChatUseChannelTabsStore and channelTabsStore then
				channelTabsStore.addChannelTab({ type = "UniverseChat", name = name }, nil)
			else
				store:dispatch(UniverseChatChannelAdded(name, getChannelTabIndex(name))) -- inferred equivalent call
			end

			if
				FFlagExpChatGlobalTabDefault
				and isGlobalTabFirst()
				and name == "RBXGlobal"
				and not hasUserSelectedTab(store)
			then
				store:dispatch(UniverseChatChannelSelected("RBXGlobal"))

				if FFlagExpChatUseChannelTabsStore and channelTabsStore then
					channelTabsStore.setTargetChannel("RBXGlobal", false)
				end
			end

			if GetFFlagEnableExpChatUniverseChatTabNames() and name ~= "" then
				local success, result = pcall(function()
					if FFlagExpChatGlobalTabDefault then
						return joined.translator:FormatByKey(getGlobalWelcomeMessageKey())
					end

					return joined.translator:FormatByKey("CoreScripts.TextChat.ChatWindow.ChatEnabled.Global2")
				end)

				if success and result and result ~= "" then
					if GetFFlagExpChatSuppressWelcomeMessageTabUnread() then
						messagesStore.addSystemMessage(result, name, "Roblox.Welcome.GlobalChat")
					else
						messagesStore.addSystemMessage(result, name)
					end

					if
						FFlagExpChatUseChannelTabsStore
						and channelTabsStore
						and not GetFFlagExpChatSuppressWelcomeMessageTabUnread()
					then
						channelTabsStore.markChannelUnread(name)
					elseif FFlagExpChatUnreadTabIndicatorV2Window then
						store:dispatch(MarkChannelUnreadForSystemMessage(
							result,
							name,
							GetFFlagExpChatSuppressWelcomeMessageTabUnread() and "Roblox.Welcome.GlobalChat" or nil
						))
					end
				end
			end

			tryAddThirdPartySummaryGlobalSystemMessage()
		end

		if textChatService:HasAllocatedUniverseChatContext("global") then
			handleUniverseChatChannelAllocated("global")
		end

		textChatService.UniverseChatChannelAllocated:Connect(handleUniverseChatChannelAllocated)

		textChatService.UniverseChatMessageReceived:Connect(function(p2)
			if FFlagExpChatDictationContinuousSafetyReminder then
				DictationSafetyReminder.onIncomingMessage(p2)
			end

			if shouldFilterGlobalMessage(p2, GetGlobalMutedUsersStore(false), localPlayer and localPlayer.UserId) then
				return
			end

			processIncomingMessageWithOptions(p2, { -- inferred equivalent call
				channelNameOverride = "RBXGlobal",
				isUniverseChat = true
			})
		end)
	end

	local function runOnBubbleDisplayed(model, message: string, data)
		local playerFromCharacter

		if model:IsA("Model") then
			playerFromCharacter = Players:GetPlayerFromCharacter(model)
		end

		local bubbleChatMessageId = HttpService:GenerateGUID(false)
		local bubbleChatMessageProperties, translation

		if data then
			bubbleChatMessageId = data.MessageId
			bubbleChatMessageProperties = data.BubbleChatMessageProperties

			if getFFlagExpChatProtectedChatInternalAPIs() then
				translation = data.TranslationInternal
			else
				translation = data.Translation
			end
		end

		local dateTime = DateTime.fromUnixTimestampMillis(workspace:GetServerTimeNow() * 1000)
		local v11 = {
			message = message,
			translation = translation,
			bubbleChatMessageId = bubbleChatMessageId,
			bubbleChatMessageUserId = playerFromCharacter and tostring(playerFromCharacter.UserId) or nil,
			partOrModel = model,
			timestamp = dateTime,
			bubbleChatMessageProperties = bubbleChatMessageProperties
		}

		messagesStore.handleIncomingBubbleChatMessage(v11)
	end

	Chat.Chatted:Connect(function(p2, p3)
		if textChatService.ChatVersion ~= Enum.ChatVersion.LegacyChatService or Chat.BubbleChatEnabled then
			runOnBubbleDisplayed(p2, p3)
		end
	end)

	local function fn2() -- 1 equivalent call inferred from this helper
		store:dispatch(LegacyBubbleChatEnabledChanged("Enabled", Chat.BubbleChatEnabled))
	end

	Chat:GetPropertyChangedSignal("BubbleChatEnabled"):Connect(fn2)
	fn2() -- inferred equivalent call
	Chat.BubbleChatSettingsChanged:Connect(function(p2)
		if joined.validateLegacyBubbleChatSettings then
			local v11, v12 = joined.validateLegacyBubbleChatSettings(p2)
			assert(
				v11,
				"Bad settings object passed to Chat:SetBubbleChatSettings:\n inside consolidated BubbleChat " .. (v12 or "")
			)

			if v6 then
				v6.setBubbleChatSettings(p2)
			else
				store:dispatch(LegacyBubbleChatSettingsChanged(p2))
			end
		end
	end)

	if getEngineFeatureFlagEnableDisplayBubble() then
		textChatService.BubbleDisplayed:Connect(function(partOrModel, p2)
			local v11

			if p2 then
				if getFFlagExpChatProtectedChatInternalAPIs() then
					v11 = p2.TextInternal
				else
					v11 = p2.Text
				end
			else
				v11 = p2
			end

			runOnBubbleDisplayed(partOrModel, v11, p2)
		end)
	end

	local function findCommandInstance(name: string)
		for _, textChatCommand in ipairs(textChatService:GetDescendants()) do
			if textChatCommand.Name == name and textChatCommand:IsA("TextChatCommand") then
				return textChatCommand
			end
		end

		return nil
	end

	local commandInstanceSet = {}
	local function setupTextChatCommands()
		for _, enabledCommand in ipairs(Commands.enabledCommands) do
			if not enabledCommand.clientRun then
				continue
			end

			local commandInstance = findCommandInstance(enabledCommand.name)

			if not commandInstance or commandInstanceSet[commandInstance] then
				continue
			end

			commandInstanceSet[commandInstance] = true

			commandInstance.Triggered:Connect(function(player, ...)
				local clientRun = enabledCommand.clientRun(store, player.UserId, ..., context)

				if clientRun then
					displaySystemMessage(
						clientRun.key,
						clientRun.args,
						clientRun.metadata,
						joined.translator,
						joined.defaultSystemTextChannel
					)
				end
			end)

			if not (string.find(commandInstance.Name, "RBXTeamCommand") or string.find(commandInstance.Name, "RBXWhisperCommand")) then
				continue
			end

			for _, propertyName in { "PrimaryAlias", "SecondaryAlias" } do
				commandInstance:GetPropertyChangedSignal(propertyName):Connect(function()
					store:dispatch(CommandAliasChanged(
						commandInstance.Name,
						commandInstance.PrimaryAlias,
						commandInstance.SecondaryAlias
					))
				end)
			end
		end
	end

	setupTextChatCommands()
	Chat:GetPropertyChangedSignal("IsAutoMigrated"):Once(setupTextChatCommands)

	if joined.canUserChatAsync and Players.LocalPlayer then
		Promise.try(function()
			return joined.canUserChatAsync(Players.LocalPlayer.UserId)
		end):andThen(function(p2)
			messagesStore.setCanLocalUserChat(p2)
		end):catch(function()
			messagesStore.setCanLocalUserChat(false)
		end)
	end

	watchPlayersService(joined, store, messagesStore)

	local appStyleProvider = UIBlox.App.Style.AppStyleProvider
	local constants = UIBlox.App.Style.Constants
	local v11 = {
		Dark = { themeName = ColorMode.Dark, fontName = constants.FontName.Gotham }
	}

	local createElement = Roact.createElement
	local v12 = { style = v11.Dark }

	local createElement2 = Roact.createElement
	local v13 = {
		store = store,
		translator = joined.translator,
		gameTranslator = joined.gameTranslator,
		isChatWindowVisible = true,
		isChatInputBarVisible = true,
		isChannelBarVisible = false,
		isDefaultChatEnabled = true,
		getIconVoiceIndicator = joined.getIconVoiceIndicator,
		onClickedVoiceIndicator = joined.onClickedVoiceIndicator,
		onClickedCameraIndicator = joined.onClickedCameraIndicator,
		selfViewListenerChanged = joined.selfViewListenerChanged,
		getPermissions = joined.getPermissions,
		displayCameraDeniedToast = joined.displayCameraDeniedToast,
		isCamEnabledForUserAndPlace = joined.isCamEnabledForUserAndPlace,
		isCameraOnlyUser = joined.isCameraOnlyUser,
		isVoiceServiceInitialized = joined.isVoiceServiceInitialized,
		isSpatialUIEnabled = joined.isSpatialUIEnabled,
		expChatLoadStartTime = 0
	}
	local expChatLoadStartTime

	if getFFlagExpChatTelemetryEventTrigger() then
		expChatLoadStartTime = os.clock()
	end

	v13.expChatLoadStartTime = expChatLoadStartTime
	local element = createElement(appStyleProvider, v12, { app = createElement2(App, v13) })

	store:dispatch(ClientAppLoaded({
		team = Players.LocalPlayer and Players.LocalPlayer.Team,
		isChatCoreGuiEnabled = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Chat),
		isTouchEnabled = UserInputService.TouchEnabled,
		isGamepadEnabled = UserInputService.PreferredInput == Enum.PreferredInput.Gamepad or FFlagLuaSupportMicroGamepadPreferredInput and UserInputService.PreferredInput == Enum.PreferredInput.MicroGamepad
	}))

	reportVersionLoaded(Analytics, Version[1])

	v:trace("Roact.mount to {}", (tostring(joined.parent)))
	local roactInstance = Roact.mount(element, joined.parent, "ExperienceChat")

	local v14 = {
		translator = joined.translator,
		defaultSystemTextChannel = joined.defaultSystemTextChannel,
		displayVirtualSystemMessage = 0
	}
	local displayVirtualSystemMessage

	if v4 then
		displayVirtualSystemMessage = showVirtualChatEnabledSystemMessage
	end

	v14.displayVirtualSystemMessage = displayVirtualSystemMessage
	local chatEnabledSystemMessage = ChatEnabledSystemMessage(v14)

	local function displayRegionUnavailableMessage() -- 1 equivalent call inferred from this helper
		displaySystemMessage(
			"CoreScripts.TextChat.ChatWindow.ChatDisabled.RegionUnavailable",
			nil,
			"Roblox.ChatDisabled.Info",
			joined.translator,
			joined.defaultSystemTextChannel,
			"You can only view system messages here. Chat is not available in your region."
		)
	end

	local v15 = FFlagExpChatMEUpdatedSystemMessage
		and FFlagExpChatPresetChatEnabled
		and FFlagEnableClientSummarySystemMessageOnLua

	local function displayQuickWordsMessageOr(p2: string, p3: string, callback) -- 1 equivalent call inferred from this helper
		whenPresetAccessKnown(GetPresetChatStore(false), function(p4)
			if p4 then
				displaySystemMessage(
					p2,
					nil,
					"Roblox.ChatDisabled.Info",
					joined.translator,
					joined.defaultSystemTextChannel,
					p3,
					prefixWithPresetIcon
				)
			else
				callback()
			end
		end)
	end

	local function updateChatStatus(chatAvailabilityStatus)
		chatStatusStore.setChatStatus(chatAvailabilityStatus)

		if v15 and chatAvailabilityStatus == "GeoBlocked" then
			displayQuickWordsMessageOr( -- inferred equivalent call
				"CoreScripts.TextChat.Description.UseQuickWordsChatIsntAvailableInYourRegion",
				"Use Quick Words to coordinate gameplay. Chat isn’t available in your region.",
				displayRegionUnavailableMessage
			)
		elseif
			chatAvailabilityStatus == "GeoBlocked"
			or chatAvailabilityStatus ~= "Unknown" and isChatRegionLocked()
		then
			displayRegionUnavailableMessage() -- inferred equivalent call
		elseif chatAvailabilityStatus == "AgeCheckGateExperiment" then
			displaySystemMessage(
				"CoreScripts.TextChat.ChatWindow.ChatDisabled.CheckAgeInAccountInfo",
				nil,
				"Roblox.ChatDisabled.Info",
				joined.translator,
				joined.defaultSystemTextChannel,
				"You can only view system messages here. Unlock chat with an age check at Settings > Account info."
			)
		elseif chatAvailabilityStatus == "SettingsDisabled" then
			if ExpChatNewSystemMessagesExperimentation.isExperimentEnabled then
				tryLogExposureNewSystemMessages() -- inferred equivalent call
			end

			displaySystemMessage(
				ExpChatNewSystemMessagesExperimentation.getNewSystemMessagesEnabled() and "CoreScripts.TextChat.Description.TurnOnChatInSettings" or "CoreScripts.TextChat.ChatWindow.ChatDisabled.SettingOff",
				nil,
				"Roblox.ChatDisabled.Info",
				joined.translator,
				joined.defaultSystemTextChannel,
				ExpChatNewSystemMessagesExperimentation.getNewSystemMessagesEnabled() and "Chat with people of similar age groups and trusted friends." or "You can only view system messages here. Update your Communication settings to turn on chat."
			)
		elseif chatAvailabilityStatus == "SettingsDisabledVpc" then
			if ExpChatNewSystemMessagesExperimentation.isExperimentEnabled then
				tryLogExposureNewSystemMessages() -- inferred equivalent call
			end

			displaySystemMessage(
				ExpChatNewSystemMessagesExperimentation.getNewSystemMessagesEnabled() and "CoreScripts.TextChat.Description.AskYourParentForPermissionToChat" or "CoreScripts.TextChat.ChatWindow.ChatDisabled.AskForPermission",
				nil,
				"Roblox.ChatDisabled.Info",
				joined.translator,
				joined.defaultSystemTextChannel,
				ExpChatNewSystemMessagesExperimentation.getNewSystemMessagesEnabled() and "Ask your parent for permission to chat in Privacy>Communication settings." or "You can only view system messages here. Ask your parent for permission to chat in Communication settings."
			)
		elseif chatAvailabilityStatus == "AgeCheckVpc" then
			if ExpChatNewSystemMessagesExperimentation.isExperimentEnabled then
				tryLogExposureNewSystemMessages() -- inferred equivalent call
			end

			displaySystemMessage(
				ExpChatNewSystemMessagesExperimentation.getNewSystemMessagesEnabled() and "CoreScripts.TextChat.Description.AskYourParentForPermissionToChat" or "CoreScripts.TextChat.ChatWindow.ChatDisabled.AskForPermissionToAgeCheck",
				nil,
				"Roblox.ChatDisabled.Info",
				joined.translator,
				joined.defaultSystemTextChannel,
				ExpChatNewSystemMessagesExperimentation.getNewSystemMessagesEnabled() and "Ask your parent for permission to chat in Privacy>Communication settings." or "You can only view system messages here. Ask your parent for permission to age check in Communication settings."
			)
		elseif
			(canPlatformEnableChat() or chatAvailabilityStatus ~= "AgeVerificationRequired")
			and chatAvailabilityStatus ~= "IdVerificationRequired"
		then
			if chatAvailabilityStatus == "AgeVerificationRequired" then
				if ExpChatNewSystemMessagesExperimentation.isExperimentEnabled then
					tryLogExposureNewSystemMessages() -- inferred equivalent call
				end

				displaySystemMessage(
					ExpChatNewSystemMessagesExperimentation.getNewSystemMessagesEnabled() and "CoreScripts.TextChat.Description.UnlockChatWithAnAgeCheck" or "CoreScripts.TextChat.ChatWindow.ChatDisabled.GetAnAgeCheck",
					nil,
					"Roblox.ChatDisabled.Info",
					joined.translator,
					joined.defaultSystemTextChannel,
					ExpChatNewSystemMessagesExperimentation.getNewSystemMessagesEnabled() and "Unlock chat with an age check." or "You can only view system messages here. Get an age check to chat."
				)
			elseif FFlagExpChatRefactorEnabledMessageLogic and chatAvailabilityStatus == "Enabled" then
				coroutine.wrap(function()
					if FStringExpChatChatWithTFAmpFeatureName == "" or FStringExpChatChatWithTFAmpNameSpace == "" then
						v:error("AMP feature name or namespace are not set")
						return
					end

					local featureAccess = AmpApiProvider.getFeatureAccess(
						{ FStringExpChatChatWithTFAmpFeatureName },
						FStringExpChatChatWithTFAmpNameSpace
					)

					if localPlayer.ChatAvailabilityStatus ~= "Enabled" then
						return
					end

					local v16

					if
						featureAccess.featureAccessList
						and #featureAccess.featureAccessList > 0
						and featureAccess.featureAccessList[1]
					then
						v16 = featureAccess.featureAccessList[1].access == AccessResponseEnum.Granted
					end

					if v16 == nil then
						v:error("No feature access list found after AMP call")
					elseif v16 then
						if v4 then
							showVirtualChatEnabledSystemMessage(
								"CoreScripts.TextChat.ChatWindow.ChatEnabled.ChatWithTF",
								nil,
								"Only your trusted friends can chat with you."
							)
						else
							displaySystemMessage(
								"CoreScripts.TextChat.ChatWindow.ChatEnabled.ChatWithTF",
								nil,
								"Roblox.ChatEnabled.Info",
								joined.translator,
								joined.defaultSystemTextChannel,
								"Only your trusted friends can chat with you."
							)
						end
					elseif not canOnlyChatInRegion() then
						chatEnabledSystemMessage()
					elseif v4 then
						showVirtualChatEnabledSystemMessage(
							"CoreScripts.TextChat.ChatWindow.ChatEnabled.ChatInRegion",
							nil,
							"You can view system messages and chat with users in your region only."
						)
					else
						displaySystemMessage(
							"CoreScripts.TextChat.ChatWindow.ChatEnabled.ChatInRegion",
							nil,
							"Roblox.ChatEnabled.Info",
							joined.translator,
							joined.defaultSystemTextChannel,
							"You can view system messages and chat with users in your region only."
						)
					end
				end)()
			elseif
				chatAvailabilityStatus == "EnabledBubble"
				or chatAvailabilityStatus == "Enabled" and canOnlyChatInRegion()
			then
				if v4 then
					showVirtualChatEnabledSystemMessage(
						"CoreScripts.TextChat.ChatWindow.ChatEnabled.ChatInRegion",
						nil,
						"You can view system messages and chat with users in your region only."
					)
				else
					displaySystemMessage(
						"CoreScripts.TextChat.ChatWindow.ChatEnabled.ChatInRegion",
						nil,
						"Roblox.ChatEnabled.Info",
						joined.translator,
						joined.defaultSystemTextChannel,
						"You can view system messages and chat with users in your region only."
					)
				end
			elseif chatAvailabilityStatus == "Enabled" then
				chatEnabledSystemMessage()
			elseif chatAvailabilityStatus == "AllUsers" or chatAvailabilityStatus == "NoOne" then
				if getChatTranslationEnabled() then
					displaySystemMessage(
						"CoreScripts.TextChat.ChatTranslation.ChatWindow.SystemMessageNew",
						nil,
						"Roblox.ChatTranslation.ChatWindow.SystemMessage",
						joined.translator,
						joined.defaultSystemTextChannel,
						"Roblox automatically translates supported languages in chat"
					)
				end
			elseif chatAvailabilityStatus == "Ineligible" or chatAvailabilityStatus ~= "Unknown" then
				displaySystemMessage(
					"CoreScripts.TextChat.ChatWindow.ChatDisabled.OnlyViewSystemMessages",
					nil,
					"Roblox.ChatDisabled.Info",
					joined.translator,
					joined.defaultSystemTextChannel,
					"You can only view system messages here."
				)
			end
		else
			if ExpChatNewSystemMessagesExperimentation.isExperimentEnabled then
				tryLogExposureNewSystemMessages() -- inferred equivalent call
			end

			displaySystemMessage(
				ExpChatNewSystemMessagesExperimentation.getNewSystemMessagesEnabled() and "CoreScripts.TextChat.Description.UnlockChatPrivacyCommunications" or "CoreScripts.TextChat.ChatWindow.ChatDisabled.CheckAgeInSettings",
				nil,
				"Roblox.ChatDisabled.Info",
				joined.translator,
				joined.defaultSystemTextChannel,
				ExpChatNewSystemMessagesExperimentation.getNewSystemMessagesEnabled() and "Unlock chat with an age check in Privacy>Communication settings." or "You can only view system messages here. To chat, get an age check in your Communication settings."
			)
		end
	end

	local count = 0
	local v16 = math.random(defineFastInt3, defineFastInt4)

	local function handleUserMessageIntentSent(p2)
		v:debug("Handling a message from UserMessageIntentSent")

		messagesStore.handleHiddenMessageReceived(p2)

		if not isUserChatEnabled(localPlayer.ChatAvailabilityStatus) then
			count += 1

			if count == v16 then
				v16 += math.random(defineFastInt3, defineFastInt4)

				displaySystemMessage(
					"CoreScripts.TextChat.ChatWindow.ChatDisabled.DontMissMessages",
					nil,
					"Roblox.ChatDisabled.Info",
					joined.translator,
					joined.defaultSystemTextChannel,
					"Don’t miss messages. Unlock chat with an age check."
				)
			end
		end

		GetTransparencyStore(false).resetTextTransparency()
	end

	local function shouldConnectToUserMessageIntentSent() -- 2 equivalent calls inferred from this helper
		local v17 = FFlagExpChatEnableFOMOUpsell and shouldShowFOMOUpsell()
		local v18 = FFlagExpChatEnableCrossAgeChatActivity and shouldShowCrossAgeChatActivity()

		return v17 or v18
	end

	if localPlayer then
		if FFlagEnableModerateChatRemoteEvent then
			local experienceChatVisualConfig = getExperienceChatVisualConfig()
			local chatModerationStore = GetChatModerationStore(false)
			local v17 = false

			joined.moderateChatStoreDisposeEffect = Signals.createEffect(function(p2)
				local isSettingEnabled = chatModerationStore.getIsSettingEnabled(p2)

				if isSettingEnabled ~= v17 then
					if isSettingEnabled then
						displaySystemMessage(
							"CoreScripts.TextChat.MessageStatus.Warning.ModerateChatOn",
							nil,
							"Roblox.MessageStatus.Warning.ModerateChatOn",
							joined.translator,
							joined.defaultSystemTextChannel
						)

						NotificationModalsManager.SetUIBloxToast({
							iconImage = UIBlox.App.ImageSet.Images[experienceChatVisualConfig.icon.off],
							toastSubtitle = joined.translator:FormatByKey("CoreScripts.TextChat.Toast.ModerateChatOn.Subtitle"),
							toastTitle = joined.translator:FormatByKey("CoreScripts.TextChat.Toast.ModerateChatOn.Title")
						})
					else
						displaySystemMessage(
							"CoreScripts.TextChat.MessageStatus.Warning.ModerateChatOff",
							nil,
							"Roblox.MessageStatus.Warning.ModerateChatOff",
							joined.translator,
							joined.defaultSystemTextChannel
						)

						NotificationModalsManager.SetUIBloxToast({
							iconImage = UIBlox.App.ImageSet.Images[experienceChatVisualConfig.icon.off],
							toastSubtitle = joined.translator:FormatByKey("CoreScripts.TextChat.Toast.ModerateChatOff.Subtitle.FriendsRename"),
							toastTitle = joined.translator:FormatByKey("CoreScripts.TextChat.Toast.ModerateChatOff.Title")
						})
					end

					v17 = isSettingEnabled
				end
			end)
		end

		local chatAvailabilityStatus = localPlayer.ChatAvailabilityStatus
		v:debug("Local player's initial ChatAvailabilityStatus is {}", chatAvailabilityStatus)
		updateChatStatus(chatAvailabilityStatus)
		local userMessageIntentSentConnection

		if shouldConnectToUserMessageIntentSent() then -- inferred equivalent call
			v:debug("Connecting to UserMessageIntentSent")
			userMessageIntentSentConnection = textChatService.UserMessageIntentSent:Connect(handleUserMessageIntentSent)
		else
			userMessageIntentSentConnection = nil
		end

		localPlayer:GetPropertyChangedSignal("ChatAvailabilityStatus"):Connect(function()
			chatAvailabilityStatus = localPlayer.ChatAvailabilityStatus
			v:debug("Local player's ChatAvailabilityStatus has changed to {}", chatAvailabilityStatus)

			updateChatStatus(chatAvailabilityStatus)

			if
				(FFlagExpChatPresetChatEnabled or FFlagExpChatPresetChatLoadTestEnabled)
				and isUserChatEnabled(chatAvailabilityStatus)
			then
				initializePresetChat(
					GetPresetChatStore(false),
					not FFlagExpChatPresetChatEnabled and FFlagExpChatPresetChatLoadTestEnabled
				)
			end

			if shouldConnectToUserMessageIntentSent() and not userMessageIntentSentConnection then -- inferred equivalent call
				v:debug("Connecting to UserMessageIntentSent")
				userMessageIntentSentConnection = textChatService.UserMessageIntentSent:Connect(handleUserMessageIntentSent)
			end

			if
				FFlagExpChatEnableFOMOUpsell
				and isUserChatEnabled(chatAvailabilityStatus)
				and userMessageIntentSentConnection
				and not (FFlagExpChatEnableCrossAgeChatActivity and shouldShowCrossAgeChatActivity())
			then
				v:debug("Disconnecting from UserMessageIntentSent")

				userMessageIntentSentConnection:Disconnect()

				if FFlagExpChatClearHiddenMessagesPostAgeCheck then
					messagesStore.handleHiddenMessagesCleared()
					GetTransparencyStore(false).resetTextTransparency()
				end
			end

			messagesStore.setCanLocalUserChat(isUserChatEnabled(chatAvailabilityStatus))
		end)
	elseif isChatRegionLocked() then
		displaySystemMessage(
			"CoreScripts.TextChat.ChatWindow.ChatDisabled.RegionUnavailable",
			nil,
			"Roblox.ChatDisabled.Info",
			joined.translator,
			joined.defaultSystemTextChannel,
			"You can only view system messages here. Chat is currently unavailable in your region."
		)
	end

	if FFlagExpChatPresetChatEnabled or FFlagExpChatPresetChatLoadTestEnabled then
		initializePresetChat(
			GetPresetChatStore(false),
			not FFlagExpChatPresetChatEnabled and FFlagExpChatPresetChatLoadTestEnabled
		)
	end

	return { roactInstance = roactInstance }
end
