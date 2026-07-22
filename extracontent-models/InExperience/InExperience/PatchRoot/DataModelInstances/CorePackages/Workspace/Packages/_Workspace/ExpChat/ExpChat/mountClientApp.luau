local Chat = game:GetService("Chat")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local Promise = require(ExpChatParent.Promise)
local Roact = require(ExpChatParent.Roact)
local UIBlox = require(ExpChatParent.UIBlox)
local Dictionary = require(ExpChatParent.llama).Dictionary
local ExpChatShared = require(ExpChatParent.ExpChatShared)
local NotificationModalsManager = require(ExpChatParent.NotificationModalsManager)
local SharedFlags = require(ExpChatParent.SharedFlags)
local Signals = require(ExpChatParent.Signals)
local AmpUpsell = require(ExpChatParent.AmpUpsell)
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
local GetPresetChatStore = require(ExpChat.Stores.GetPresetChatStore)
local GetChatTooltipStore = require(ExpChat.Stores.GetChatTooltipStore)
local initializePresetChat = require(ExpChat.PresetChat.initializePresetChat)
local FFlagExpChatPresetChatEnabled = ExpChatShared.Flags.FFlagExpChatPresetChatEnabled
local FFlagExpChatPresetChatLoadTestEnabled = ExpChatShared.Flags.FFlagExpChatPresetChatLoadTestEnabled
local FFlagExpChatUseUnifiedTooltipStore = ExpChatShared.Flags.FFlagExpChatUseUnifiedTooltipStore
local getFFlagExpChatProtectedChatInternalAPIs = SharedFlags.getFFlagExpChatProtectedChatInternalAPIs
local FFlagConnectionsToFriendsRename = SharedFlags.FFlagConnectionsToFriendsRename
local FFlagExpChatUseProximityStore = SharedFlags.FFlagExpChatUseProximityStore
local v40 = if not FFlagExpChatUseProximityStore then nil else require(ExpChat.Stores.GetProximityStore)
local Analytics = ExpChatShared.Analytics
local countParticipantsInTextChannel = ExpChatShared.countParticipantsInTextChannel
local App = require(script.Parent.App)
local v44 = ExpChatShared.Logger:new("ExpChat/" .. script.Name)
local createDispatchBindableEvent = require(script.Parent.createDispatchBindableEvent)
local bindableEventQueue = require(ExpChat.Events.bindableEventQueue)
local createStore = require(script.Parent.createStore)
local GetNameColor = require(script.Parent.GetNameColor)
local reportMessageReceived = require(script.Parent.reportMessageReceived)
local canPlatformEnableChat = require(script.Parent.canPlatformEnableChat)
local watchForErrors = ExpChatShared.watchForErrors
local Commands = ExpChatShared.Commands
local Actions = ExpChat.Actions
local IncomingMessageReceived = require(Actions.IncomingMessageReceived)
local UniverseChatSystemMessageAdded = require(Actions.UniverseChatSystemMessageAdded)
local IncomingBubbleChatMessageReceived = require(Actions.IncomingBubbleChatMessageReceived)
local OutgoingMessageSent = require(Actions.OutgoingMessageSent)
local MarkChannelUnreadForIncomingMessage = require(Actions.MarkChannelUnreadForIncomingMessage)
local MarkChannelUnreadForSystemMessage = require(Actions.MarkChannelUnreadForSystemMessage)
local TextChannelCreated = ExpChatShared.Actions.TextChannelCreated
local TextChannelRemoved = ExpChatShared.Actions.TextChannelRemoved
local UserMuted = ExpChatShared.Actions.UserMuted
local UserUnmuted = ExpChatShared.Actions.UserUnmuted
local PlayerAdded = ExpChatShared.Actions.PlayerAdded
local PlayerRemoved = ExpChatShared.Actions.PlayerRemoved
local CharacterAdded = ExpChatShared.Actions.CharacterAdded
local LocalCharacterLoaded = ExpChatShared.Actions.LocalCharacterLoaded
local LocalTeamChanged = ExpChatShared.Actions.LocalTeamChanged
local ClientAppLoaded = ExpChatShared.Actions.ClientAppLoaded
local LastInputTypeChanged = require(Actions.LastInputTypeChanged)
local ChatPrivacySettingsReceived = require(Actions.ChatPrivacySettingsReceived)
local ChatPrivacySettingsFetchFailed = require(Actions.ChatPrivacySettingsFetchFailed)
local CommandAliasChanged = ExpChatShared.Actions.CommandAliasChanged
local HumanoidDied = require(Actions.HumanoidDied)
local AdorneeAdded = require(Actions.AdorneeAdded)
local LegacyBubbleChatEnabledChanged = require(Actions.LegacyBubbleChatEnabledChanged)
local LegacyBubbleChatSettingsChanged = require(Actions.LegacyBubbleChatSettingsChanged)
local LocalTextChannelParticipantAdded = require(Actions.LocalTextChannelParticipantAdded)
local LocalTextChannelParticipantRemoved = ExpChatShared.Actions.LocalTextChannelParticipantRemoved
local HiddenMessageReceived = require(Actions.HiddenMessageReceived)
local HiddenMessagesCleared = require(Actions.HiddenMessagesCleared)
local UniverseChatChannelAdded = require(Actions.UniverseChatChannelAdded)
local displaySystemMessage = require(ExpChat.displaySystemMessage)
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
local ExpChatPerfTracker = require(ExpChatParent.ChatUIPrimitives).Telemetry.ExpChatPerfTracker
local Flags = ExpChat.Flags
local getEngineFeatureFlagEnableDisplayBubble = require(Flags.getEngineFeatureFlagEnableDisplayBubble)
local getFFlagUnreduxLastInputTypeChanged = require(Flags.getFFlagUnreduxLastInputTypeChanged)
local getFFlagExpChatEnableChannelTabsUI = require(Flags.getFFlagExpChatEnableChannelTabsUI)
local getFFlagUseCharacterStore = ExpChatShared.Flags.getFFlagUseCharacterStore
local GetFFlagExpChatSuppressWelcomeMessageTabUnread = ExpChatShared.Flags.GetFFlagExpChatSuppressWelcomeMessageTabUnread
local getFFlagExpChatTelemetryEventTrigger = require(ExpChat.Flags.getFFlagExpChatTelemetryEventTrigger)
local FFlagAEGIS2EnableGatesForExpChat = require(Flags.FFlagAEGIS2EnableGatesForExpChat)
local v107 = game:DefineFastInt("ExpChatMessageResponseThrottlePermyriad", 0)
local v108 = game:DefineFastInt("ExpChatMessageResponseUserSamplePermyriad", 0)
local v109 = game:DefineFastInt("ExpChatHiddenMessagesPromptThresholdLowerBound", 10)
local v110 = game:DefineFastInt("ExpChatHiddenMessagesPromptThresholdUpperBound", 45)
local FFlagExpChatEnableFOMOUpsell = require(Flags.FFlagExpChatEnableFOMOUpsell)
local FFlagExpChatClearHiddenMessagesPostAgeCheck = require(Flags.FFlagExpChatClearHiddenMessagesPostAgeCheck)
local FFlagEnableInExpChatSummaryOnLua = require(Flags.FFlagEnableInExpChatSummaryOnLua)
local FFlagExpChatEnableCrossAgeChatActivity = require(Flags.FFlagExpChatEnableCrossAgeChatActivity)
local FFlagExpChatUnreadTabIndicatorV2Window = require(Flags.FFlagExpChatUnreadTabIndicatorV2Window)
local FFlagExpChatUseAdorneeStore = SharedFlags.FFlagExpChatUseAdorneeStore
local FFlagExpChatUseMessagesStore = SharedFlags.FFlagExpChatUseMessagesStore
local FFlagExpChatUseChannelTabsStore = SharedFlags.FFlagExpChatUseChannelTabsStore
local FFlagExpChatUseChatConfigStore = SharedFlags.FFlagExpChatUseChatConfigStore
local FFlagEnableModerateChatRemoteEvent = SharedFlags.FFlagEnableModerateChatRemoteEvent
local FFlagEnableClientSummarySystemMessageOnLua = SharedFlags.FFlagEnableClientSummarySystemMessageOnLua
local FFlagExpChatPerfTracking = SharedFlags.FFlagExpChatPerfTracking
local GetFFlagTextChatEnableUniverseChatTabs = ExpChatShared.Flags.GetFFlagTextChatEnableUniverseChatTabs
local GetFFlagEnableExpChatUniverseChatTabNames = ExpChatShared.Flags.GetFFlagEnableExpChatUniverseChatTabNames
local v125 = game:DefineFastFlag("ExpChatRemoveSpaceFromTeamPrefix", false)
local FFlagChatLineReportingGlobalMuteEnabled = SharedFlags.FFlagChatLineReportingGlobalMuteEnabled
local FFlagAIRephraseSettingEnabled = SharedFlags.FFlagAIRephraseSettingEnabled
local FFlagChatSummariesSettingEnabled = SharedFlags.FFlagChatSummariesSettingEnabled
local FFlagExpChatUseChatMuteStore = require(Flags.FFlagExpChatUseChatMuteStore)
local FFlagEnableGlobalChat3pSummaryLuaApps = require(Flags.FFlagEnableGlobalChat3pSummaryLuaApps)
local FFlagExpChatEnableGlobalChatSummarySystemMessage = require(Flags.FFlagExpChatEnableGlobalChatSummarySystemMessage)
local FFlagFixGlobalChat3pSummarySystemMessage = require(Flags.FFlagFixGlobalChat3pSummarySystemMessage)
local v133 = game:DefineFastFlag("ExpChatSuppressGlobalSummaryTabUnread", false)
local FFlagExpChatRefactorEnabledMessageLogic = require(Flags.FFlagExpChatRefactorEnabledMessageLogic)
local FStringExpChatChatWithTFAmpFeatureName = require(Flags.FStringExpChatChatWithTFAmpFeatureName)
local FStringExpChatChatWithTFAmpNameSpace = require(Flags.FStringExpChatChatWithTFAmpNameSpace)
local ExpChatNewSystemMessagesExperimentation = require(ExpChatParent.SocialExperiments).ExpChatNewSystemMessagesExperimentation

function getChatTranslationEnabled() -- line: 161
	-- upvalues: TextChatService (copy)
	local ok, result = pcall(function() -- line: 162
		-- upvalues: TextChatService (copy)
		return TextChatService.ChatTranslationEnabled
	end)

	return ok and result
end

local t1 = {
	eventName = "MessageResponse",
	description = "When a client receives a text chat message through TextChatService.",
	links = "https://github.rbx.com/Roblox/proto-schemas/blob/master/production/eventstream/social/message_response.proto",
	backends = { "EventIngest" },
	throttlingPercentage = v107,
	lastUpdated = {
		25,
		10,
		8
	}
}
local helpers = script.helpers
local setUpConfigurationObjects = require(helpers.setUpConfigurationObjects)
local setUpClientSettings = require(helpers.setUpClientSettings)
local waitForFirst = require(helpers.waitForFirst)
local shouldFilterGlobalMessage = require(helpers.shouldFilterGlobalMessage)
local context = ExpChatShared.context
local reportVersionLoaded = require(script.reportVersionLoaded)
local Version = ExpChatShared.Version
local AtomicBinding = require(ExpChat.AtomicBinding)
local ChatEnabledSystemMessage = require(script.SystemMessages.ChatEnabledSystemMessage)

local function watchPlayersService(p1, p2, p3) -- line: 192
	-- upvalues: v44 (copy), isPlayerVerified (copy), PlayerAdded (copy), Players (copy), LocalTeamChanged (copy), FFlagExpChatUseAdorneeStore (copy), context (copy), AdorneeAdded (copy), HumanoidDied (copy), AtomicBinding (copy), waitForFirst (copy), LocalCharacterLoaded (copy), getFFlagUseCharacterStore (copy), CharacterAdded (copy), Promise (copy), displaySystemMessage (copy), FFlagConnectionsToFriendsRename (copy), PlayerRemoved (copy), FFlagExpChatUseMessagesStore (copy)
	v44:trace("Watching Players service")

	local t2 = {}

	local function onPlayerAdded(p4) -- line: 196
		-- upvalues: v44 (copy), isPlayerVerified (copy), p2 (copy), PlayerAdded (copy), Players (copy), LocalTeamChanged (copy), FFlagExpChatUseAdorneeStore (copy), context (copy), AdorneeAdded (copy), HumanoidDied (copy), AtomicBinding (copy), waitForFirst (copy), LocalCharacterLoaded (copy), getFFlagUseCharacterStore (copy), CharacterAdded (copy), t2 (copy)
		v44:trace("Player added: {} {}", p4.Name, (tostring(p4.UserId)))

		local v229 = not not isPlayerVerified(p4) or nil

		p2:dispatch(PlayerAdded(p4.UserId, p4.Name, p4.DisplayName, v229))

		if p4 == Players.LocalPlayer then
			v44:trace("Found local player")
			p4:GetPropertyChangedSignal("Team"):Connect(function() -- line: 205
				-- upvalues: p2 (copy), LocalTeamChanged (copy), p4 (copy)
				p2:dispatch(LocalTeamChanged(p4.Team))
			end)
		end

		local function getHumanoidBinding() -- line: 210
			-- upvalues: p4 (copy), FFlagExpChatUseAdorneeStore (copy), context (copy), p2 (copy), AdorneeAdded (copy), HumanoidDied (copy), AtomicBinding (copy)
			local function dispatchBubbleChatAdornee(p5) -- line: 213
				-- upvalues: p4 (copy), FFlagExpChatUseAdorneeStore (copy), context (copy), p2 (copy), AdorneeAdded (copy), HumanoidDied (copy)
				local root = p5.root
				local humanoid = p5.humanoid
				local humanoidRootPart = p5.humanoidRootPart

				if humanoid:IsA("Humanoid") and humanoidRootPart:IsA("BasePart") then
					if root and humanoidRootPart and root == p4.Character then
						if FFlagExpChatUseAdorneeStore then
							context.adorneeStore.handleAdorneeAdded(p4.UserId, root, humanoid)
						else
							p2:dispatch(AdorneeAdded(p4.UserId, root, humanoid))
						end
					end

					local connection = humanoid.Died:Connect(function() -- line: 227
						-- upvalues: FFlagExpChatUseAdorneeStore (copy), context (copy), p4 (copy), p2 (copy), HumanoidDied (copy)
						if FFlagExpChatUseAdorneeStore then
							context.adorneeStore.handleHumanoidDied(p4.UserId)

							return
						end

						p2:dispatch(HumanoidDied(p4.UserId))
					end)

					local function disconnectHumanoidDied() -- line: 235
						-- upvalues: connection (copy)
						if connection then
							connection:Disconnect()
						end
					end

					return disconnectHumanoidDied
				end

				return function() -- line: 246
				end
			end

			return (AtomicBinding.new({
				humanoid = "Humanoid",
				humanoidRootPart = "HumanoidRootPart"
			}, dispatchBubbleChatAdornee))
		end
		local function dispatchBubbleChatAdornee(p6) -- line: 213
			-- upvalues: p4 (copy), FFlagExpChatUseAdorneeStore (copy), context (copy), p2 (copy), AdorneeAdded (copy), HumanoidDied (copy)
			local root = p6.root
			local humanoid = p6.humanoid
			local humanoidRootPart = p6.humanoidRootPart

			if humanoid:IsA("Humanoid") and humanoidRootPart:IsA("BasePart") then
				if root and humanoidRootPart and root == p4.Character then
					if FFlagExpChatUseAdorneeStore then
						context.adorneeStore.handleAdorneeAdded(p4.UserId, root, humanoid)
					else
						p2:dispatch(AdorneeAdded(p4.UserId, root, humanoid))
					end
				end

				local connection = humanoid.Died:Connect(function() -- line: 227
					-- upvalues: FFlagExpChatUseAdorneeStore (copy), context (copy), p4 (copy), p2 (copy), HumanoidDied (copy)
					if FFlagExpChatUseAdorneeStore then
						context.adorneeStore.handleHumanoidDied(p4.UserId)

						return
					end

					p2:dispatch(HumanoidDied(p4.UserId))
				end)

				local function disconnectHumanoidDied() -- line: 235
					-- upvalues: connection (copy)
					if connection then
						connection:Disconnect()
					end
				end

				return disconnectHumanoidDied
			end

			return function() -- line: 246
			end
		end

		local v232 = AtomicBinding.new({
			humanoid = "Humanoid",
			humanoidRootPart = "HumanoidRootPart"
		}, dispatchBubbleChatAdornee)

		local function onCharacterAdded(p7) -- line: 257
			-- upvalues: waitForFirst (copy), p4 (copy), v44 (copy), Players (copy), p2 (copy), LocalCharacterLoaded (copy), getFFlagUseCharacterStore (copy), context (copy), CharacterAdded (copy), v232 (copy)
			if not p7.Parent then
				waitForFirst(p7.AncestryChanged, p4.CharacterAdded)
			end

			if p7 ~= p4.Character or not p7.Parent then
				v44:debug("Mismatched or unparented character in onCharacterAdded for {}", (tostring(p4.UserId)))

				return
			end

			if p4 == Players.LocalPlayer then
				v44:debug("Local character loaded: {}", p7.Name)
				p2:dispatch(LocalCharacterLoaded(p7))
			end

			if getFFlagUseCharacterStore() then
				context.characterStore.handleCharacterAdded(p4.UserId, p7)
			else
				p2:dispatch(CharacterAdded(p4.UserId, p7))
			end

			v232:bindRoot(p7)
		end
		local function onCharacterRemoving(p8) -- line: 281
			-- upvalues: v232 (copy)
			v232:unbindRoot(p8)
		end

		if p4.Character then
			onCharacterAdded(p4.Character)
		end

		local connection = p4.CharacterAdded:Connect(onCharacterAdded)
		local connection2 = p4.CharacterRemoving:Connect(onCharacterRemoving)

		if not t2[p4.UserId] then
			t2[p4.UserId] = {
				connection,
				connection2
			}
		end
	end
	local function onNewPlayerAdded(p9) -- line: 299
		-- upvalues: onPlayerAdded (copy), Players (copy), Promise (copy), displaySystemMessage (copy), FFlagConnectionsToFriendsRename (copy), p1 (copy), v44 (copy)
		onPlayerAdded(p9)

		if Players.LocalPlayer then
			Promise.try(function() -- line: 303
				-- upvalues: p9 (copy), Players (copy)
				if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
					return p9:IsFriendsWithAsync(Players.LocalPlayer.UserId)
				end

				return p9:IsFriendsWith(Players.LocalPlayer.UserId)
			end):andThen(function(p10) -- line: 310
				-- upvalues: displaySystemMessage (copy), FFlagConnectionsToFriendsRename (copy), p9 (copy), p1 (copy)
				if p10 then
					displaySystemMessage(not FFlagConnectionsToFriendsRename and "InGame.UnknownNamespace.GameChat_FriendChatNotifier_JoinMessage" or "InGame.UnknownNamespace.GameChat.FriendChatNotifier.JoinMessage", {
						RBX_NAME = p9.DisplayName
					}, "Roblox.Notification.Friend.Joined", p1.translator, p1.defaultSystemTextChannel)
				end
			end):catch(function(p11) -- line: 323
				-- upvalues: v44 (copy)
				v44:error("Could not fetch friendship status. Error: {}", (tostring(p11)))
			end)
		end
	end

	for _, player in pairs(Players:GetPlayers()) do
		if player:IsA("Player") then
			onPlayerAdded(player)
		end
	end

	Players.PlayerAdded:Connect(onNewPlayerAdded)
	Players.PlayerRemoving:Connect(function(player) -- line: 338
		-- upvalues: v44 (copy), p2 (copy), PlayerRemoved (copy), FFlagExpChatUseMessagesStore (copy), p3 (copy), FFlagExpChatUseAdorneeStore (copy), context (copy), getFFlagUseCharacterStore (copy), t2 (copy)
		v44:trace("Player removed: {} {}", player.Name, (tostring(player.UserId)))
		p2:dispatch(PlayerRemoved(player.UserId))

		if FFlagExpChatUseMessagesStore then
			p3.handlePlayerRemoved(player.UserId)
		end

		if FFlagExpChatUseAdorneeStore then
			context.adorneeStore.handlePlayerRemoved(player.UserId)
		end

		if getFFlagUseCharacterStore() then
			context.characterStore.handlePlayerRemoved(player.UserId)
		end

		local v239 = t2[player.UserId]

		if v239 then
			for _, v in ipairs(v239) do
				v:Disconnect()
			end

			t2[player.UserId] = nil
		end
	end)
end

local t3 = {
	canUserChatAsync = function(p12) -- line: 391
		-- upvalues: Chat (copy)
		return Chat:CanUserChatAsync(p12)
	end
}

local function v151(p13) -- line: 396
	-- upvalues: getFFlagExpChatProtectedChatInternalAPIs (copy), v44 (copy), FFlagEnableInExpChatSummaryOnLua (copy), generateRichSystemMessageTextFormat (copy), UIBlox (copy)
	if getFFlagExpChatProtectedChatInternalAPIs() then
		v44:trace("System OnIncomingMessage started: PrefixTextInternal: {} TextInternal: {}", p13.PrefixTextInternal, p13.TextInternal)
	else
		v44:trace("System OnIncomingMessage started: {} {}", p13.PrefixText, p13.Text)
	end

	local TextChatMessageProperties = Instance.new("TextChatMessageProperties")

	TextChatMessageProperties.Text = if not FFlagEnableInExpChatSummaryOnLua then string.format("<font color=\"#%s\">%s</font>", if not string.find(p13.Metadata, "Error") then UIBlox.App.Style.Colors.LightGrey:ToHex() else UIBlox.App.Style.Colors.Red:ToHex(), if not getFFlagExpChatProtectedChatInternalAPIs() then p13.Text else p13.TextInternal) else generateRichSystemMessageTextFormat(if not getFFlagExpChatProtectedChatInternalAPIs() then p13.Text else p13.TextInternal, not not string.find(p13.Metadata, "Error"))
	v44:trace("System OnIncomingMessage finished: {} {}", TextChatMessageProperties.PrefixText, TextChatMessageProperties.Text)

	return TextChatMessageProperties
end

return function(t4: {[any]: any}) -- line: 425
	-- upvalues: v44 (copy), Dictionary (copy), t3 (copy), createStore (copy), createDispatchBindableEvent (copy), bindableEventQueue (copy), watchForErrors (copy), context (copy), FFlagExpChatUseAdorneeStore (copy), GetAdorneeStore (copy), FFlagExpChatUseProximityStore (copy), v40 (copy), FFlagExpChatUseMessagesStore (copy), GetMessagesStore (copy), FFlagExpChatUseChannelTabsStore (copy), GetChannelTabsStore (copy), FFlagExpChatUseChatConfigStore (copy), GetChatConfigurationStore (copy), FFlagAEGIS2EnableGatesForExpChat (copy), GetChatStatusStore (copy), GetGlobalMutedUsersStore (copy), FFlagExpChatUseChatMuteStore (copy), ExpChatParent (copy), Signals (copy), UserMuted (copy), UserUnmuted (copy), getFFlagUseCharacterStore (copy), GetCharacterStore (copy), Analytics (copy), getFFlagUnreduxLastInputTypeChanged (copy), UserInputService (copy), LastInputTypeChanged (copy), v151 (copy), Chat (copy), TextChatService (copy), setUpConfigurationObjects (copy), setUpClientSettings (copy), Players (copy), displaySystemMessage (copy), getFFlagExpChatProtectedChatInternalAPIs (copy), FFlagExpChatPerfTracking (copy), ExpChatPerfTracker (copy), reportMessageReceived (copy), handleChannelWelcomeMessage (copy), GetTransparencyStore (copy), FFlagExpChatUnreadTabIndicatorV2Window (copy), MarkChannelUnreadForIncomingMessage (copy), IncomingMessageReceived (copy), GetFFlagExpChatSuppressWelcomeMessageTabUnread (copy), shouldSuppressUnreadForTabMetadata (copy), MarkChannelUnreadForSystemMessage (copy), UniverseChatSystemMessageAdded (copy), shouldSendHighFrequencyTelemetry (copy), v108 (copy), t1 (copy), TextChannelCreated (copy), getFFlagExpChatEnableChannelTabsUI (copy), GetNameColor (copy), v125 (copy), getOtherDisplayNameInWhisperChannel (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), ExpChatNewSystemMessagesExperimentation (copy), summaryMessageRichText (copy), FFlagExpChatEnableGlobalChatSummarySystemMessage (copy), v133 (copy), FFlagFixGlobalChat3pSummarySystemMessage (copy), FFlagEnableInExpChatSummaryOnLua (copy), FFlagEnableClientSummarySystemMessageOnLua (copy), TextChannelRemoved (copy), TextChatMessageChatActionType (copy), FFlagEnableGlobalChat3pSummaryLuaApps (copy), FFlagAIRephraseSettingEnabled (copy), FFlagChatSummariesSettingEnabled (copy), RobloxReplicatedStorage (copy), GetUserChatSettingsStore (copy), OutgoingMessageSent (copy), countParticipantsInTextChannel (copy), LocalTextChannelParticipantAdded (copy), LocalTextChannelParticipantRemoved (copy), FFlagExpChatUseUnifiedTooltipStore (copy), GetChatTooltipStore (copy), UniverseChatChannelAdded (copy), GetFFlagEnableExpChatUniverseChatTabNames (copy), shouldFilterGlobalMessage (copy), FFlagChatLineReportingGlobalMuteEnabled (copy), HttpService (copy), IncomingBubbleChatMessageReceived (copy), LegacyBubbleChatEnabledChanged (copy), LegacyBubbleChatSettingsChanged (copy), getEngineFeatureFlagEnableDisplayBubble (copy), Commands (copy), CommandAliasChanged (copy), Promise (copy), ChatPrivacySettingsReceived (copy), ChatPrivacySettingsFetchFailed (copy), watchPlayersService (copy), UIBlox (copy), Roact (copy), App (copy), getFFlagExpChatTelemetryEventTrigger (copy), ClientAppLoaded (copy), StarterGui (copy), reportVersionLoaded (copy), Version (copy), ChatEnabledSystemMessage (copy), isChatRegionLocked (copy), canPlatformEnableChat (copy), FFlagExpChatRefactorEnabledMessageLogic (copy), FStringExpChatChatWithTFAmpFeatureName (copy), FStringExpChatChatWithTFAmpNameSpace (copy), AmpApiProvider (copy), AccessResponseEnum (copy), canOnlyChatInRegion (copy), v109 (copy), v110 (copy), HiddenMessageReceived (copy), isUserChatEnabled (copy), FFlagExpChatEnableFOMOUpsell (copy), shouldShowFOMOUpsell (copy), FFlagExpChatEnableCrossAgeChatActivity (copy), shouldShowCrossAgeChatActivity (copy), FFlagEnableModerateChatRemoteEvent (copy), getExperienceChatVisualConfig (copy), GetChatModerationStore (copy), NotificationModalsManager (copy), FFlagConnectionsToFriendsRename (copy), FFlagExpChatPresetChatEnabled (copy), FFlagExpChatPresetChatLoadTestEnabled (copy), initializePresetChat (copy), GetPresetChatStore (copy), FFlagExpChatClearHiddenMessagesPostAgeCheck (copy), HiddenMessagesCleared (copy)
	v44:trace("mountClientApp started")

	local u166 = Dictionary.join(t3, t4)
	local v167 = createStore()

	createDispatchBindableEvent(v167)
	bindableEventQueue:flush()
	watchForErrors(game:GetService("ScriptContext"), u166.script, false)
	context.translator = u166.translator
	context.store = v167

	if FFlagExpChatUseAdorneeStore then
		context.adorneeStore = GetAdorneeStore(false)
	end

	if FFlagExpChatUseProximityStore then
		context.proximityStore = v40(false)
	end

	local v168 = if not FFlagExpChatUseMessagesStore then nil else GetMessagesStore(false)
	local v169 = if not FFlagExpChatUseChannelTabsStore then nil else GetChannelTabsStore(false)
	local v170 = if not FFlagExpChatUseChatConfigStore then nil else GetChatConfigurationStore(false)
	local v171 = if not FFlagAEGIS2EnableGatesForExpChat then nil else GetChatStatusStore(false)

	if FFlagExpChatUseMessagesStore then
		context.messagesStore = v168
	end

	context.globalMutedUsersStore = GetGlobalMutedUsersStore(false)

	if FFlagExpChatUseChatMuteStore and not FFlagExpChatUseMessagesStore then
		local v172 = require(ExpChatParent.ChatMute).getMutedUserIds()
		local t5 = {}

		u166.chatMuteSyncDisposeEffect = Signals.createEffect(function(p14) -- line: 467
			-- upvalues: v172 (copy), t5 (ref), v167 (copy), UserMuted (copy), UserUnmuted (copy)
			local v243 = v172(p14)

			for v244 in v243 do
				if not t5[v244] then
					v167:dispatch(UserMuted(v244))
				end
			end

			for v245 in t5 do
				if not v243[v245] then
					v167:dispatch(UserUnmuted(v245))
				end
			end

			t5 = v243
		end)
	end

	if getFFlagUseCharacterStore() then
		context.characterStore = GetCharacterStore(false)
	end

	if u166.analytics then
		Analytics.with(u166.analytics)
	end

	if not getFFlagUnreduxLastInputTypeChanged() then
		UserInputService.LastInputTypeChanged:Connect(function(p15) -- line: 491
			-- upvalues: v167 (copy), LastInputTypeChanged (copy)
			v167:dispatch(LastInputTypeChanged(p15))
		end)
	end

	if u166.defaultSystemTextChannel then
		u166.defaultSystemTextChannel.OnIncomingMessage = v151
	else
		Chat:GetPropertyChangedSignal("IsAutoMigrated"):Once(function() -- line: 499
			-- upvalues: TextChatService (copy), u166 (ref), v151 (copy)
			local RBXSystem = TextChatService:FindFirstChild("RBXSystem", true)

			if RBXSystem and RBXSystem:IsA("TextChannel") then
				u166.defaultSystemTextChannel = RBXSystem
				RBXSystem.OnIncomingMessage = v151
			end
		end)
	end

	setUpConfigurationObjects(v167, u166)
	setUpClientSettings(v167)

	local LocalPlayer = Players.LocalPlayer

	if LocalPlayer then
		LocalPlayer:GetPropertyChangedSignal("Team"):Connect(function() -- line: 513
			-- upvalues: LocalPlayer (copy), displaySystemMessage (copy), u166 (ref)
			local Team = LocalPlayer.Team

			if Team then
				displaySystemMessage("InGame.UnknownNamespace.GameChat_TeamChat_NowInTeam", {
					RBX_NAME = Team.Name
				}, "Roblox.Team.Success.NowInTeam", u166.translator, u166.defaultSystemTextChannel)
			end
		end)
	end

	local t6 = {
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

	local function _processIncomingMessageCore(p16, s1: string?, b1: boolean?) -- line: 559
		-- upvalues: getFFlagExpChatProtectedChatInternalAPIs (copy), v44 (copy), FFlagExpChatPerfTracking (copy), LocalPlayer (copy), ExpChatPerfTracker (copy), reportMessageReceived (copy), handleChannelWelcomeMessage (copy), displaySystemMessage (copy), u166 (ref), FFlagExpChatUseMessagesStore (copy), v168 (copy), GetTransparencyStore (copy), FFlagExpChatUseChannelTabsStore (copy), v169 (copy), FFlagExpChatUnreadTabIndicatorV2Window (copy), v167 (copy), MarkChannelUnreadForIncomingMessage (copy), IncomingMessageReceived (copy), t6 (copy), GetFFlagExpChatSuppressWelcomeMessageTabUnread (copy), shouldSuppressUnreadForTabMetadata (copy), MarkChannelUnreadForSystemMessage (copy), UniverseChatSystemMessageAdded (copy), TextChatService (copy), shouldSendHighFrequencyTelemetry (copy), v108 (copy), Analytics (copy), t1 (copy)
		if getFFlagExpChatProtectedChatInternalAPIs() then
			v44:debug("Incoming MessageReceived Status: {} TextInternal: {}", p16.Status.Name, p16.TextInternal)
		else
			v44:debug("Incoming MessageReceived Status: {} Text: {}", p16.Status.Name, p16.Text)
		end

		if FFlagExpChatPerfTracking and (p16.TextSource and p16.TextSource.UserId or "UNKNOWN_TEXT_SOURCE_USER_ID") ~= (LocalPlayer and LocalPlayer.UserId or "UNKNOWN_LOCAL_USER_ID") then
			ExpChatPerfTracker.start(ExpChatPerfTracker.Events.MessageReceiveToWindowRenderInterval, {
				messageId = p16.MessageId
			})
		end

		if LocalPlayer then
			reportMessageReceived(LocalPlayer.UserId, p16)
		end

		if LocalPlayer and p16.TextSource and p16.TextSource.UserId ~= LocalPlayer.UserId then
			local v252 = handleChannelWelcomeMessage(p16, LocalPlayer)

			if v252 then
				displaySystemMessage(v252.key, v252.args, v252.metadata, u166.translator, p16.TextChannel)
			end
		end

		local v253 = LocalPlayer and (p16.TextSource and p16.TextSource.UserId == LocalPlayer.UserId)

		if FFlagExpChatUseMessagesStore then
			v168.handleIncomingOrOutgoingMessage(p16, v253, s1, b1)
			GetTransparencyStore(false).resetTextTransparency()

			if FFlagExpChatUseChannelTabsStore and v169 then
				v169.handleIncomingOrOutgoingMessage(p16, v253, s1)
			elseif FFlagExpChatUnreadTabIndicatorV2Window then
				v167:dispatch(MarkChannelUnreadForIncomingMessage(p16, v253, s1, b1))
			end
		else
			v167:dispatch(IncomingMessageReceived(p16, v253, s1, b1))
			GetTransparencyStore(false).resetTextTransparency()
		end

		local v254 = t6[p16.Status]

		if v254 then
			local ok, result = pcall(function() -- line: 643
				-- upvalues: u166 (ref), v254 (copy)
				return u166.translator:FormatByKey(v254.key)
			end)
			local v257 = ok and (result and result ~= "")

			if s1 and v257 then
				if FFlagExpChatUseMessagesStore and v168 then
					v168.addSystemMessage(result, s1, if not GetFFlagExpChatSuppressWelcomeMessageTabUnread() then nil else v254.metadata)

					if FFlagExpChatUseChannelTabsStore and v169 and (not GetFFlagExpChatSuppressWelcomeMessageTabUnread() or not shouldSuppressUnreadForTabMetadata(v254.metadata)) then
						v169.markChannelUnread(s1)
					elseif FFlagExpChatUnreadTabIndicatorV2Window then
						v167:dispatch(MarkChannelUnreadForSystemMessage(result, s1, if not GetFFlagExpChatSuppressWelcomeMessageTabUnread() then nil else v254.metadata))
					end
				else
					v167:dispatch(UniverseChatSystemMessageAdded(result, s1, if not GetFFlagExpChatSuppressWelcomeMessageTabUnread() then nil else v254.metadata))
				end
			else
				local defaultSystemTextChannel = u166.defaultSystemTextChannel

				if s1 then
					local s1_2 = TextChatService:FindFirstChild(s1)

					if s1_2 and s1_2:IsA("TextChannel") then
						defaultSystemTextChannel = s1_2
					end
				end

				displaySystemMessage(v254.key, nil, v254.metadata, u166.translator, defaultSystemTextChannel)
			end
		end

		if shouldSendHighFrequencyTelemetry(v108) then
			Analytics:TelemetryLogEvent(t1, {
				messageStatus = p16.Status.Name
			}, {
				"addOsInfo",
				"addSessionId",
				"addUniverseId",
				"addPlaceId"
			})
		end
	end
	local function processIncomingMessage(p17, s2: string?) -- line: 704
		-- upvalues: _processIncomingMessageCore (copy)
		_processIncomingMessageCore(p17, s2, nil)
	end
	local function processIncomingMessageWithOptions(p18, t7: {[any]: any}?) -- line: 710
		-- upvalues: _processIncomingMessageCore (copy)
		_processIncomingMessageCore(p18, t7 and t7.channelNameOverride, t7 and t7.isUniverseChat)
	end
	local function handleMessageReceived(p19) -- line: 718
		-- upvalues: v167 (copy), TextChannelCreated (copy), getFFlagExpChatEnableChannelTabsUI (copy), TextChatService (copy), GetNameColor (copy), getFFlagExpChatProtectedChatInternalAPIs (copy), v44 (copy), Players (copy), v125 (copy), LocalPlayer (copy), getOtherDisplayNameInWhisperChannel (copy), u166 (ref), GetFFlagTextChatEnableUniverseChatTabs (copy), _processIncomingMessageCore (copy), FFlagExpChatPerfTracking (copy), ExpChatPerfTracker (copy), reportMessageReceived (copy), handleChannelWelcomeMessage (copy), displaySystemMessage (copy), FFlagExpChatUseMessagesStore (copy), v168 (copy), GetTransparencyStore (copy), FFlagExpChatUseChannelTabsStore (copy), v169 (copy), FFlagExpChatUnreadTabIndicatorV2Window (copy), MarkChannelUnreadForIncomingMessage (copy), IncomingMessageReceived (copy), shouldSendHighFrequencyTelemetry (copy), v108 (copy), Analytics (copy), t1 (copy)
		v167:dispatch(TextChannelCreated(p19))

		local u265 = false

		if getFFlagExpChatEnableChannelTabsUI() then
			local ChannelTabsConfiguration = TextChatService:FindFirstChildOfClass("ChannelTabsConfiguration")

			if ChannelTabsConfiguration then
				u265 = ChannelTabsConfiguration.Enabled
			end
		end

		if string.find(p19.Name, "RBXGeneral") then
			function p19.OnIncomingMessage(p20) -- line: 730
				-- upvalues: GetNameColor (copy), getFFlagExpChatProtectedChatInternalAPIs (copy)
				local TextChatMessageProperties = Instance.new("TextChatMessageProperties")

				if p20.TextSource then
					local v350 = GetNameColor(p20.TextSource.UserId)

					if not p20.ChatWindowMessageProperties then
						local v351 = if not getFFlagExpChatProtectedChatInternalAPIs() then p20.PrefixText else p20.PrefixTextInternal

						TextChatMessageProperties.PrefixText = string.format("<font color=\"#%s\">%s</font>", v350:ToHex(), v351)
					end
				end

				return TextChatMessageProperties
			end
		elseif string.find(p19.Name, "^RBXTeam") then
			function p19.OnIncomingMessage(p21) -- line: 747
				-- upvalues: getFFlagExpChatProtectedChatInternalAPIs (copy), v44 (copy), Players (copy), v125 (copy), u265 (ref)
				local v353 = if not getFFlagExpChatProtectedChatInternalAPIs() then p21.PrefixText else p21.PrefixTextInternal

				if getFFlagExpChatProtectedChatInternalAPIs() then
					v44:trace("Team OnIncomingMessage started: PrefixTextInternal: {} TextInternal: {}", v353, p21.TextInternal)
				else
					v44:trace("Team OnIncomingMessage started: {} {}", v353, p21.Text)
				end

				local TextChatMessageProperties = Instance.new("TextChatMessageProperties")

				if Players.LocalPlayer then
					local TeamColorColor = Players.LocalPlayer.TeamColor.Color
					local v356 = if not v125 then not u265 and "[Team] " or "" else if not u265 then not (#(v353 or "") > 0) and "[Team]" or "[Team] " else ""

					TextChatMessageProperties.PrefixText = string.format("<font color=\"#%s\">%s%s</font>", TeamColorColor:ToHex(), v356, v353)
				end

				v44:trace("Team OnIncomingMessage finished: {} {}", TextChatMessageProperties.PrefixText, TextChatMessageProperties.Text)

				return TextChatMessageProperties
			end
		elseif string.find(p19.Name, "^RBXWhisper") and LocalPlayer then
			function p19.OnIncomingMessage(p22) -- line: 784
				-- upvalues: getOtherDisplayNameInWhisperChannel (copy), p19 (copy), LocalPlayer (copy), u265 (ref), u166 (ref), GetNameColor (copy), getFFlagExpChatProtectedChatInternalAPIs (copy)
				local TextSource = p22.TextSource

				if TextSource then
					local v359 = getOtherDisplayNameInWhisperChannel(p19, LocalPlayer)

					if v359 then
						local v360 = nil

						if not u265 then
							v360 = if TextSource.UserId ~= LocalPlayer.UserId then u166.translator:FormatByKey("CoreScripts.TextChat.WhisperChat.PrefixText.Incoming", {
								RBX_NAME = v359
							}) else u166.translator:FormatByKey("CoreScripts.TextChat.WhisperChat.PrefixText.Outgoing", {
								RBX_NAME = v359
							})
						end

						local TextChatMessageProperties = Instance.new("TextChatMessageProperties")
						local v362 = GetNameColor(TextSource.UserId)

						TextChatMessageProperties.PrefixText = string.format("%s<font color=\"#%s\">%s</font>", not v360 and "" or v360 .. " ", v362:ToHex(), if not getFFlagExpChatProtectedChatInternalAPIs() then p22.PrefixText else p22.PrefixTextInternal)

						return TextChatMessageProperties
					end
				end

				return nil
			end
		end

		p19.MessageReceived:Connect(function(p23) -- line: 823
			-- upvalues: GetFFlagTextChatEnableUniverseChatTabs (copy), _processIncomingMessageCore (copy), getFFlagExpChatProtectedChatInternalAPIs (copy), v44 (copy), FFlagExpChatPerfTracking (copy), LocalPlayer (copy), ExpChatPerfTracker (copy), reportMessageReceived (copy), handleChannelWelcomeMessage (copy), displaySystemMessage (copy), u166 (ref), FFlagExpChatUseMessagesStore (copy), v168 (copy), GetTransparencyStore (copy), FFlagExpChatUseChannelTabsStore (copy), v169 (copy), FFlagExpChatUnreadTabIndicatorV2Window (copy), v167 (copy), MarkChannelUnreadForIncomingMessage (copy), IncomingMessageReceived (copy), shouldSendHighFrequencyTelemetry (copy), v108 (copy), Analytics (copy), t1 (copy)
			if GetFFlagTextChatEnableUniverseChatTabs() then
				_processIncomingMessageCore(p23, nil, nil)

				return
			end

			if getFFlagExpChatProtectedChatInternalAPIs() then
				v44:debug("Incoming MessageReceived Status: {} TextInternal: {}", p23.Status.Name, p23.TextInternal)
			else
				v44:debug("Incoming MessageReceived Status: {} Text: {}", p23.Status.Name, p23.Text)
			end

			if FFlagExpChatPerfTracking and (p23.TextSource and p23.TextSource.UserId or "UNKNOWN_TEXT_SOURCE_USER_ID") ~= (LocalPlayer and LocalPlayer.UserId or "UNKNOWN_LOCAL_USER_ID") then
				ExpChatPerfTracker.start(ExpChatPerfTracker.Events.MessageReceiveToWindowRenderInterval, {
					messageId = p23.MessageId
				})
			end

			if LocalPlayer then
				reportMessageReceived(LocalPlayer.UserId, p23)
			end

			if LocalPlayer and p23.TextSource and p23.TextSource.UserId ~= LocalPlayer.UserId then
				local v364 = handleChannelWelcomeMessage(p23, LocalPlayer)

				if v364 then
					displaySystemMessage(v364.key, v364.args, v364.metadata, u166.translator, p23.TextChannel)
				end
			end

			local v365 = LocalPlayer and (p23.TextSource and p23.TextSource.UserId == LocalPlayer.UserId)

			if FFlagExpChatUseMessagesStore then
				v168.handleIncomingOrOutgoingMessage(p23, v365)
				GetTransparencyStore(false).resetTextTransparency()

				if FFlagExpChatUseChannelTabsStore and v169 then
					v169.handleIncomingOrOutgoingMessage(p23, v365)
				elseif FFlagExpChatUnreadTabIndicatorV2Window then
					v167:dispatch(MarkChannelUnreadForIncomingMessage(p23, v365))
				end
			else
				v167:dispatch(IncomingMessageReceived(p23, v365))
				GetTransparencyStore(false).resetTextTransparency()
			end

			if p23.Status == Enum.TextChatMessageStatus.Floodchecked then
				displaySystemMessage("CoreScripts.TextChat.MessageStatus.Warning.Floodchecked", nil, "Roblox.MessageStatus.Warning.Floodchecked", u166.translator, u166.defaultSystemTextChannel)
			elseif p23.Status == Enum.TextChatMessageStatus.TextFilterFailed then
				displaySystemMessage("CoreScripts.TextChat.MessageStatus.Warning.TextFilterFailed", nil, "Roblox.MessageStatus.Warning.TextFilterFailed", u166.translator, u166.defaultSystemTextChannel)
			elseif p23.Status == Enum.TextChatMessageStatus.InvalidPrivacySettings then
				displaySystemMessage("CoreScripts.TextChat.MessageStatus.Warning.InvalidPrivacySettings", nil, "Roblox.MessageStatus.Warning.InvalidPrivacySettings", u166.translator, u166.defaultSystemTextChannel)
			elseif p23.Status == Enum.TextChatMessageStatus.MessageTooLong then
				displaySystemMessage("CoreScripts.TextChat.MessageStatus.Warning.MessageTooLong", nil, "Roblox.MessageStatus.Warning.MessageTooLong", u166.translator, u166.defaultSystemTextChannel)
			elseif p23.Status == Enum.TextChatMessageStatus.ModerationTimeout then
				displaySystemMessage("CoreScripts.TextChat.MessageStatus.Warning.ModerationTimeout", nil, "Roblox.MessageStatus.Warning.ModerationTimeout", u166.translator, u166.defaultSystemTextChannel)
			elseif p23.Status == Enum.TextChatMessageStatus.Unknown then
				displaySystemMessage("CoreScripts.TextChat.MessageStatus.Warning.Unknown", nil, "Roblox.MessageStatus.Warning.Unknown", u166.translator, u166.defaultSystemTextChannel)
			end

			if shouldSendHighFrequencyTelemetry(v108) then
				Analytics:TelemetryLogEvent(t1, {
					messageStatus = p23.Status.Name
				}, {
					"addOsInfo",
					"addSessionId",
					"addUniverseId",
					"addPlaceId"
				})
			end
		end)
	end
	local function watchTextChatCommand(p24) -- line: 953
		-- upvalues: Analytics (copy)
		p24.Triggered:Connect(function() -- line: 954
			-- upvalues: Analytics (copy), p24 (copy)
			Analytics.FireClientAnalyticsWithEventName("CommandSent", {
				commandName = p24.Name
			})
		end)
	end

	for _, descendant in pairs(TextChatService:GetDescendants()) do
		if descendant:IsA("TextChannel") then
			handleMessageReceived(descendant)
		elseif descendant:IsA("TextChatCommand") then
			descendant.Triggered:Connect(function() -- line: 954
				-- upvalues: Analytics (copy), descendant (copy)
				Analytics.FireClientAnalyticsWithEventName("CommandSent", {
					commandName = descendant.Name
				})
			end)
		end
	end

	local u183 = false
	local u184 = false
	local t8 = {}
	local u186 = false

	local function tryLogExposureNewSystemMessages() -- line: 974
		-- upvalues: ExpChatNewSystemMessagesExperimentation (copy), u186 (ref)
		if not ExpChatNewSystemMessagesExperimentation.isExperimentEnabled or u186 then
			return
		end

		u186 = true
		ExpChatNewSystemMessagesExperimentation.logExposure()
	end
	local function postProcessSummarySystemMessage(s3: string) -- line: 983
		-- upvalues: summaryMessageRichText (copy)
		return summaryMessageRichText.wrapInSummaryMutedStyle(`{ summaryMessageRichText.getSummaryIconPrefix() } { s3 }`)
	end
	local function tryShowSummarySystemMessageOnChannel(p25) -- line: 989
		-- upvalues: u183 (ref), t8 (copy), ExpChatNewSystemMessagesExperimentation (copy), u186 (ref), displaySystemMessage (copy), u166 (ref), postProcessSummarySystemMessage (copy)
		if not p25 then
			return
		end

		if not u183 then
			return
		end

		if t8[p25.Name] then
			return
		end

		if p25.Name ~= "RBXGeneral" then
			return
		end

		t8[p25.Name] = true

		if ExpChatNewSystemMessagesExperimentation.isExperimentEnabled and ExpChatNewSystemMessagesExperimentation.isExperimentEnabled and not u186 then
			u186 = true
			ExpChatNewSystemMessagesExperimentation.logExposure()
		end

		displaySystemMessage(not ExpChatNewSystemMessagesExperimentation.getNewSystemMessagesEnabled() and "CoreScripts.TextChat.ChatWindow.SummarySystemMessage" or "CoreScripts.TextChat.Description.RobloxSummarizesMessagesFromAllPlayers", nil, "Roblox.Summary.Info", u166.translator, p25, not ExpChatNewSystemMessagesExperimentation.getNewSystemMessagesEnabled() and "Roblox auto-generates summaries of players' messages." or "Roblox summarizes messages from players of all ages.", postProcessSummarySystemMessage)
	end
	local function tryAddThirdPartySummaryGlobalSystemMessage() -- line: 1026
		-- upvalues: u184 (ref), u183 (ref), FFlagExpChatEnableGlobalChatSummarySystemMessage (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), TextChatService (copy), u166 (ref), v133 (copy), FFlagExpChatUseMessagesStore (copy), v168 (copy), postProcessSummarySystemMessage (copy), v167 (copy), UniverseChatSystemMessageAdded (copy), FFlagFixGlobalChat3pSummarySystemMessage (copy)
		if u184 or (not u183 or not FFlagExpChatEnableGlobalChatSummarySystemMessage or not GetFFlagTextChatEnableUniverseChatTabs() or not TextChatService:HasAllocatedUniverseChatContext("global")) then
			return
		end

		local v270 = u166.translator:FormatByKey("CoreScripts.TextChat.ChatWindow.SummarySystemMessage")
		local v271 = if not v133 then nil else "Roblox.Summary.GlobalChat"

		u184 = true

		if FFlagExpChatUseMessagesStore and v168 then
			v168.addSystemMessage(v270, "RBXGlobal", v271, postProcessSummarySystemMessage)

			return
		end

		v167:dispatch(UniverseChatSystemMessageAdded(v270, "RBXGlobal", v271, nil, if not FFlagFixGlobalChat3pSummarySystemMessage then nil else postProcessSummarySystemMessage))
	end

	TextChatService.DescendantAdded:Connect(function(descendant) -- line: 1069
		-- upvalues: handleMessageReceived (copy), FFlagEnableInExpChatSummaryOnLua (copy), FFlagEnableClientSummarySystemMessageOnLua (copy), tryShowSummarySystemMessageOnChannel (copy), Analytics (copy)
		if descendant:IsA("TextChannel") then
			handleMessageReceived(descendant)

			if FFlagEnableInExpChatSummaryOnLua and FFlagEnableClientSummarySystemMessageOnLua then
				tryShowSummarySystemMessageOnChannel(descendant)

				return
			end
		elseif descendant:IsA("TextChatCommand") then
			descendant.Triggered:Connect(function() -- line: 954
				-- upvalues: Analytics (copy), descendant (copy)
				Analytics.FireClientAnalyticsWithEventName("CommandSent", {
					commandName = descendant.Name
				})
			end)
		end
	end)
	TextChatService.DescendantRemoving:Connect(function(descendant) -- line: 1080
		-- upvalues: v167 (copy), TextChannelRemoved (copy), FFlagExpChatUseChannelTabsStore (copy), v169 (copy)
		if descendant:IsA("TextChannel") then
			v167:dispatch(TextChannelRemoved(descendant))

			if FFlagExpChatUseChannelTabsStore and v169 then
				v169.handleChannelRemoved(descendant.Name)
			end
		end
	end)

	if FFlagEnableInExpChatSummaryOnLua then
		TextChatService.ChatActionReceived:Connect(function(p26) -- line: 1091
			-- upvalues: getFFlagExpChatProtectedChatInternalAPIs (copy), v44 (copy), TextChatMessageChatActionType (copy), FFlagEnableGlobalChat3pSummaryLuaApps (copy), _processIncomingMessageCore (copy)
			if getFFlagExpChatProtectedChatInternalAPIs() then
				v44:debug("Incoming ChatActionReceived ChatActionType: {}, TextInternal: {}", p26.ChatActionType, p26.TextInternal)
			else
				v44:debug("Incoming ChatActionReceived ChatActionType: {}, Text: {}", p26.ChatActionType, p26.Text)
			end

			if p26.ChatActionType == TextChatMessageChatActionType.Summary then
				if FFlagEnableGlobalChat3pSummaryLuaApps then
					local v275 = if p26.TextChannel ~= nil then nil else {
						channelNameOverride = "RBXGlobal",
						isUniverseChat = true
					}

					_processIncomingMessageCore(p26, v275 and v275.channelNameOverride, v275 and v275.isUniverseChat)

					return
				end

				_processIncomingMessageCore(p26, nil, nil)

				return
			end

			v44:error("Unknown ChatActionType: {}", p26.ChatActionType)
		end)
	end

	if FFlagEnableInExpChatSummaryOnLua or FFlagAIRephraseSettingEnabled or FFlagChatSummariesSettingEnabled then
		coroutine.wrap(function() -- line: 1126
			-- upvalues: RobloxReplicatedStorage (copy), v44 (copy), LocalPlayer (copy), FFlagEnableClientSummarySystemMessageOnLua (copy), FFlagChatSummariesSettingEnabled (copy), u183 (ref), TextChatService (copy), tryShowSummarySystemMessageOnChannel (copy), tryAddThirdPartySummaryGlobalSystemMessage (copy), FFlagAIRephraseSettingEnabled (copy), GetUserChatSettingsStore (copy)
			local ExpChatFeatureValueChanged = RobloxReplicatedStorage:WaitForChild("ExpChatFeatureValueChanged", 10)

			if ExpChatFeatureValueChanged then
				ExpChatFeatureValueChanged.OnClientEvent:Connect(function(n1: number, s4: string, s5: string) -- line: 1129
					-- upvalues: v44 (copy), LocalPlayer (copy), FFlagEnableClientSummarySystemMessageOnLua (copy), FFlagChatSummariesSettingEnabled (copy), u183 (ref), TextChatService (copy), tryShowSummarySystemMessageOnChannel (copy), tryAddThirdPartySummaryGlobalSystemMessage (copy), FFlagAIRephraseSettingEnabled (copy), GetUserChatSettingsStore (copy)
					v44:debug("Incoming ExpChatFeatureValueChanged userId: {}, featureName: {}, featureValue: {}", n1, s4, s5)

					if LocalPlayer and n1 == LocalPlayer.UserId then
						if FFlagEnableClientSummarySystemMessageOnLua and s4 == "EligibleForThirdPartySummary" and not FFlagChatSummariesSettingEnabled then
							u183 = s5 == "true"

							if u183 then
								for _, descendant in TextChatService:GetDescendants() do
									if descendant:IsA("TextChannel") then
										tryShowSummarySystemMessageOnChannel(descendant)
									end
								end

								tryAddThirdPartySummaryGlobalSystemMessage()
							end
						end

						if FFlagAIRephraseSettingEnabled and s4 == "AIRephraseSettingStatus" then
							GetUserChatSettingsStore.updateExpChatFeatureValue(s4, s5)
						end

						if FFlagChatSummariesSettingEnabled and s4 == "AllowThirdPartySummary" then
							GetUserChatSettingsStore.updateExpChatFeatureValue(s4, s5)
							u183 = s5 == "Enabled"

							if u183 then
								for _, descendant in TextChatService:GetDescendants() do
									if descendant:IsA("TextChannel") then
										tryShowSummarySystemMessageOnChannel(descendant)
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

	TextChatService.SendingMessage:Connect(function(message) -- line: 1174
		-- upvalues: FFlagExpChatPerfTracking (copy), ExpChatPerfTracker (copy), getFFlagExpChatProtectedChatInternalAPIs (copy), v44 (copy), LocalPlayer (copy), handleChannelWelcomeMessage (copy), displaySystemMessage (copy), u166 (ref), FFlagExpChatUseMessagesStore (copy), v168 (copy), v167 (copy), OutgoingMessageSent (copy), Analytics (copy), countParticipantsInTextChannel (copy)
		if FFlagExpChatPerfTracking then
			ExpChatPerfTracker.start(ExpChatPerfTracker.Events.MessageSendToWindowRenderInterval, {
				messageId = message.MessageId
			})
		end

		if getFFlagExpChatProtectedChatInternalAPIs() then
			v44:debug("Outgoing SendingMessage Status: {} TextInternal: {}", message.Status.Name, message.TextInternal)
		else
			v44:debug("Outgoing SendingMessage Status: {} Text: {}", message.Status.Name, message.Text)
		end

		if LocalPlayer then
			local v278 = handleChannelWelcomeMessage(message, LocalPlayer)

			if v278 and v278.key then
				displaySystemMessage(v278.key, v278.args, v278.metadata, u166.translator, message.TextChannel)
			end
		end

		if FFlagExpChatUseMessagesStore then
			v168.handleIncomingOrOutgoingMessage(message, true)
		else
			v167:dispatch(OutgoingMessageSent(message))
		end

		local TextChannel = message.TextChannel

		if TextChannel then
			Analytics.FireClientAnalyticsWithEventName("MessageSent", {
				channelName = TextChannel.Name,
				totalParticipants = countParticipantsInTextChannel(TextChannel)
			})
		end
	end)

	local function connectSendingUniverseChatMessage() -- line: 1222
		-- upvalues: GetFFlagTextChatEnableUniverseChatTabs (copy), TextChatService (copy), FFlagExpChatPerfTracking (copy), ExpChatPerfTracker (copy), getFFlagExpChatProtectedChatInternalAPIs (copy), v44 (copy), LocalPlayer (copy), handleChannelWelcomeMessage (copy), displaySystemMessage (copy), u166 (ref), FFlagExpChatUseMessagesStore (copy), v168 (copy), v167 (copy), OutgoingMessageSent (copy), FFlagExpChatUseChannelTabsStore (copy), v169 (copy), Analytics (copy), countParticipantsInTextChannel (copy)
		if not GetFFlagTextChatEnableUniverseChatTabs() then
			return
		end

		TextChatService.SendingUniverseChatMessage:Connect(function(p27) -- line: 1226
			-- upvalues: FFlagExpChatPerfTracking (copy), ExpChatPerfTracker (copy), getFFlagExpChatProtectedChatInternalAPIs (copy), v44 (copy), LocalPlayer (copy), handleChannelWelcomeMessage (copy), displaySystemMessage (copy), u166 (ref), TextChatService (copy), FFlagExpChatUseMessagesStore (copy), v168 (copy), v167 (copy), OutgoingMessageSent (copy), FFlagExpChatUseChannelTabsStore (copy), v169 (copy), Analytics (copy), countParticipantsInTextChannel (copy)
			if FFlagExpChatPerfTracking then
				ExpChatPerfTracker.start(ExpChatPerfTracker.Events.MessageSendToWindowRenderInterval, {
					messageId = p27.MessageId
				})
			end

			if getFFlagExpChatProtectedChatInternalAPIs() then
				v44:debug("Outgoing SendingMessage Status: {} TextInternal: {}", p27.Status.Name, p27.TextInternal)
			else
				v44:debug("Outgoing SendingMessage Status: {} Text: {}", p27.Status.Name, p27.Text)
			end

			if LocalPlayer then
				local v374 = handleChannelWelcomeMessage(p27, LocalPlayer)

				if v374 and v374.key then
					displaySystemMessage(v374.key, v374.args, v374.metadata, u166.translator, p27.TextChannel)
				end
			end

			local ChatInputBarConfiguration = TextChatService:FindFirstChildOfClass("ChatInputBarConfiguration")
			local v376 = if ChatInputBarConfiguration and ChatInputBarConfiguration.TargetTextChannel then nil else "RBXGlobal"

			if FFlagExpChatUseMessagesStore then
				v168.handleIncomingOrOutgoingMessage(p27, true, v376)
			else
				v167:dispatch(OutgoingMessageSent(p27, v376))
			end

			if FFlagExpChatUseChannelTabsStore and v169 then
				v169.handleIncomingOrOutgoingMessage(p27, true, v376)
			end

			local TextChannel = p27.TextChannel

			if TextChannel then
				Analytics.FireClientAnalyticsWithEventName("MessageSent", {
					channelName = TextChannel.Name,
					totalParticipants = countParticipantsInTextChannel(TextChannel)
				})
			end
		end)
	end

	if GetFFlagTextChatEnableUniverseChatTabs() then
		TextChatService.SendingUniverseChatMessage:Connect(function(p28) -- line: 1226
			-- upvalues: FFlagExpChatPerfTracking (copy), ExpChatPerfTracker (copy), getFFlagExpChatProtectedChatInternalAPIs (copy), v44 (copy), LocalPlayer (copy), handleChannelWelcomeMessage (copy), displaySystemMessage (copy), u166 (ref), TextChatService (copy), FFlagExpChatUseMessagesStore (copy), v168 (copy), v167 (copy), OutgoingMessageSent (copy), FFlagExpChatUseChannelTabsStore (copy), v169 (copy), Analytics (copy), countParticipantsInTextChannel (copy)
			if FFlagExpChatPerfTracking then
				ExpChatPerfTracker.start(ExpChatPerfTracker.Events.MessageSendToWindowRenderInterval, {
					messageId = p28.MessageId
				})
			end

			if getFFlagExpChatProtectedChatInternalAPIs() then
				v44:debug("Outgoing SendingMessage Status: {} TextInternal: {}", p28.Status.Name, p28.TextInternal)
			else
				v44:debug("Outgoing SendingMessage Status: {} Text: {}", p28.Status.Name, p28.Text)
			end

			if LocalPlayer then
				local v281 = handleChannelWelcomeMessage(p28, LocalPlayer)

				if v281 and v281.key then
					displaySystemMessage(v281.key, v281.args, v281.metadata, u166.translator, p28.TextChannel)
				end
			end

			local ChatInputBarConfiguration = TextChatService:FindFirstChildOfClass("ChatInputBarConfiguration")
			local v283 = if ChatInputBarConfiguration and ChatInputBarConfiguration.TargetTextChannel then nil else "RBXGlobal"

			if FFlagExpChatUseMessagesStore then
				v168.handleIncomingOrOutgoingMessage(p28, true, v283)
			else
				v167:dispatch(OutgoingMessageSent(p28, v283))
			end

			if FFlagExpChatUseChannelTabsStore and v169 then
				v169.handleIncomingOrOutgoingMessage(p28, true, v283)
			end

			local TextChannel = p28.TextChannel

			if TextChannel then
				Analytics.FireClientAnalyticsWithEventName("MessageSent", {
					channelName = TextChannel.Name,
					totalParticipants = countParticipantsInTextChannel(TextChannel)
				})
			end
		end)
	end

	local function isInstanceALocalTextChannelParticipant(p29) -- line: 1284
		-- upvalues: Players (copy)
		return p29 and (p29:IsA("TextSource") and (Players.LocalPlayer and Players.LocalPlayer.UserId == p29.UserId))
	end
	local function getChannelTabIndex(s6: string) -- line: 1291
		if s6 == "RBXGeneral" then
			return 1
		end

		if s6 == "RBXGlobal" then
			return 2
		end

		return 3
	end

	if getFFlagExpChatEnableChannelTabsUI() then
		local ChannelTabsConfiguration = TextChatService:FindFirstChildOfClass("ChannelTabsConfiguration")
		local v195 = not not ChannelTabsConfiguration and ChannelTabsConfiguration.Enabled
		local v196 = GetFFlagTextChatEnableUniverseChatTabs() and not v195

		for _, descendant in pairs(TextChatService:GetDescendants()) do
			if descendant.Parent and descendant.Parent:IsA("TextChannel") and (descendant and (descendant:IsA("TextSource") and (Players.LocalPlayer and Players.LocalPlayer.UserId == descendant.UserId))) then
				v167:dispatch(LocalTextChannelParticipantAdded(descendant.Parent))

				if FFlagExpChatUseChannelTabsStore and v169 then
					local ParentName = descendant.Parent.Name

					if ParentName ~= "RBXSystem" and (not v196 or ParentName == "RBXGeneral") then
						local v200 = if ParentName ~= "RBXGeneral" then not GetFFlagTextChatEnableUniverseChatTabs() and 2 or if ParentName ~= "RBXGeneral" then ParentName ~= "RBXGlobal" and 3 or 2 else 1 else nil

						v169.addChannelTab({
							type = "TextChat",
							name = ParentName
						}, v200)
					end
				end
			end

			if descendant:IsA("TextChannel") then
				descendant.DescendantRemoving:Connect(function(descendant2) -- line: 1336
					-- upvalues: Players (copy), v167 (copy), LocalTextChannelParticipantRemoved (copy), descendant (copy), FFlagExpChatUseChannelTabsStore (copy), v169 (copy)
					if descendant2 and (descendant2:IsA("TextSource") and (Players.LocalPlayer and Players.LocalPlayer.UserId == descendant2.UserId)) then
						v167:dispatch(LocalTextChannelParticipantRemoved(descendant))

						if FFlagExpChatUseChannelTabsStore and v169 then
							local descendantName = descendant.Name

							v169.removeChannelTab(descendantName)
						end
					end
				end)
			end
		end

		TextChatService.DescendantAdded:Connect(function(descendant) -- line: 1350
			-- upvalues: Players (copy), v167 (copy), LocalTextChannelParticipantAdded (copy), FFlagExpChatUseChannelTabsStore (copy), v169 (copy), v196 (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), LocalTextChannelParticipantRemoved (copy)
			if descendant.Parent and (descendant.Parent:IsA("TextChannel") and (descendant and (descendant:IsA("TextSource") and (Players.LocalPlayer and Players.LocalPlayer.UserId == descendant.UserId)))) then
				v167:dispatch(LocalTextChannelParticipantAdded(descendant.Parent))

				if FFlagExpChatUseChannelTabsStore and v169 then
					local ParentName = descendant.Parent.Name

					if ParentName ~= "RBXSystem" and (not v196 or ParentName == "RBXGeneral") then
						local v291 = if ParentName ~= "RBXGeneral" then not GetFFlagTextChatEnableUniverseChatTabs() and 2 or if ParentName ~= "RBXGeneral" then ParentName ~= "RBXGlobal" and 3 or 2 else 1 else nil

						v169.addChannelTab({
							type = "TextChat",
							name = ParentName
						}, v291)
					end
				end
			end

			if descendant:IsA("TextChannel") then
				descendant.DescendantRemoving:Connect(function(descendant3) -- line: 1380
					-- upvalues: Players (copy), v167 (copy), LocalTextChannelParticipantRemoved (copy), descendant (copy), FFlagExpChatUseChannelTabsStore (copy), v169 (copy)
					if descendant3 and (descendant3:IsA("TextSource") and (Players.LocalPlayer and Players.LocalPlayer.UserId == descendant3.UserId)) then
						v167:dispatch(LocalTextChannelParticipantRemoved(descendant))

						if FFlagExpChatUseChannelTabsStore and v169 then
							local descendantName = descendant.Name

							v169.removeChannelTab(descendantName)
						end
					end
				end)
			end
		end)
	end

	if GetFFlagTextChatEnableUniverseChatTabs() then
		local t9 = {}

		local function handleUniverseChatChannelAllocated(s7: string) -- line: 1399
			-- upvalues: t9 (copy), TextChatService (copy), FFlagExpChatUseUnifiedTooltipStore (copy), GetChatTooltipStore (copy), v167 (copy), UniverseChatChannelAdded (copy), FFlagExpChatUseChannelTabsStore (copy), v169 (copy), GetFFlagEnableExpChatUniverseChatTabNames (copy), u166 (ref), FFlagExpChatUseMessagesStore (copy), v168 (copy), GetFFlagExpChatSuppressWelcomeMessageTabUnread (copy), FFlagExpChatUnreadTabIndicatorV2Window (copy), MarkChannelUnreadForSystemMessage (copy), UniverseChatSystemMessageAdded (copy), tryAddThirdPartySummaryGlobalSystemMessage (copy)
			if t9[s7] then
				return
			end

			t9[s7] = true

			local ChatWindowConfiguration = TextChatService:FindFirstChildOfClass("ChatWindowConfiguration")
			local ChatInputBarConfiguration = TextChatService:FindFirstChildOfClass("ChatInputBarConfiguration")
			local v295 = not ChatWindowConfiguration or ChatWindowConfiguration.Enabled ~= false
			local v296 = not ChatInputBarConfiguration or ChatInputBarConfiguration.Enabled ~= false

			if not v295 or not v296 then
				return
			end

			local s8 = ""

			if s7 == "global" then
				s8 = "RBXGlobal"

				if FFlagExpChatUseUnifiedTooltipStore then
					GetChatTooltipStore(false).setIsGlobalChatAvailable(true)
				end
			end

			v167:dispatch(UniverseChatChannelAdded(s8, if s8 ~= "RBXGeneral" then s8 ~= "RBXGlobal" and 3 or 2 else 1))

			if FFlagExpChatUseChannelTabsStore and v169 then
				v169.addChannelTab({
					type = "UniverseChat",
					name = s8
				}, nil)
			end

			if GetFFlagEnableExpChatUniverseChatTabNames() and s8 ~= "" then
				local ok, result = pcall(function() -- line: 1430
					-- upvalues: u166 (ref)
					return u166.translator:FormatByKey("CoreScripts.TextChat.ChatWindow.ChatEnabled.Global2")
				end)

				if ok and result and result ~= "" then
					if FFlagExpChatUseMessagesStore and v168 then
						if GetFFlagExpChatSuppressWelcomeMessageTabUnread() then
							v168.addSystemMessage(result, s8, "Roblox.Welcome.GlobalChat")
						else
							v168.addSystemMessage(result, s8)
						end

						if FFlagExpChatUseChannelTabsStore and v169 and not GetFFlagExpChatSuppressWelcomeMessageTabUnread() then
							v169.markChannelUnread(s8)
						elseif FFlagExpChatUnreadTabIndicatorV2Window then
							v167:dispatch(MarkChannelUnreadForSystemMessage(result, s8, if not GetFFlagExpChatSuppressWelcomeMessageTabUnread() then nil else "Roblox.Welcome.GlobalChat"))
						end
					elseif GetFFlagExpChatSuppressWelcomeMessageTabUnread() then
						v167:dispatch(UniverseChatSystemMessageAdded(result, s8, "Roblox.Welcome.GlobalChat"))
					else
						v167:dispatch(UniverseChatSystemMessageAdded(result, s8))
					end
				end
			end

			tryAddThirdPartySummaryGlobalSystemMessage()
		end

		if TextChatService:HasAllocatedUniverseChatContext("global") then
			handleUniverseChatChannelAllocated("global")
		end

		TextChatService.UniverseChatChannelAllocated:Connect(handleUniverseChatChannelAllocated)
		TextChatService.UniverseChatMessageReceived:Connect(function(p30) -- line: 1494
			-- upvalues: shouldFilterGlobalMessage (copy), GetGlobalMutedUsersStore (copy), LocalPlayer (copy), FFlagChatLineReportingGlobalMuteEnabled (copy), _processIncomingMessageCore (copy)
			if shouldFilterGlobalMessage(p30, GetGlobalMutedUsersStore(false), LocalPlayer and LocalPlayer.UserId) then
				return
			end

			if FFlagChatLineReportingGlobalMuteEnabled then
				local t10 = {
					channelNameOverride = "RBXGlobal",
					isUniverseChat = true
				}

				_processIncomingMessageCore(p30, t10 and t10.channelNameOverride, t10 and t10.isUniverseChat)

				return
			end

			_processIncomingMessageCore(p30, "RBXGlobal", nil)
		end)
	end

	local function runOnBubbleDisplayed(p31, s9: string, p32) -- line: 1516
		-- upvalues: Players (copy), HttpService (copy), getFFlagExpChatProtectedChatInternalAPIs (copy), FFlagExpChatUseMessagesStore (copy), v168 (copy), v167 (copy), IncomingBubbleChatMessageReceived (copy)
		local player = nil

		if p31:IsA("Model") then
			player = Players:GetPlayerFromCharacter(p31)
		end

		local guid = HttpService:GenerateGUID(false)
		local BubbleChatMessageProperties = nil
		local v308 = nil

		if p32 then
			guid = p32.MessageId
			BubbleChatMessageProperties = p32.BubbleChatMessageProperties
			v308 = if not getFFlagExpChatProtectedChatInternalAPIs() then p32.Translation else p32.TranslationInternal
		end

		local dateTime = DateTime.fromUnixTimestampMillis(workspace:GetServerTimeNow() * 1000)
		local t11 = {
			message = s9,
			translation = v308,
			bubbleChatMessageId = guid,
			bubbleChatMessageUserId = player and tostring(player.UserId) or nil,
			partOrModel = p31,
			timestamp = dateTime,
			bubbleChatMessageProperties = BubbleChatMessageProperties
		}

		if FFlagExpChatUseMessagesStore then
			v168.handleIncomingBubbleChatMessage(t11)

			return
		end

		v167:dispatch(IncomingBubbleChatMessageReceived(t11))
	end

	Chat.Chatted:Connect(function(message, p33) -- line: 1551
		-- upvalues: TextChatService (copy), Chat (copy), runOnBubbleDisplayed (copy)
		if TextChatService.ChatVersion ~= Enum.ChatVersion.LegacyChatService or Chat.BubbleChatEnabled then
			runOnBubbleDisplayed(message, p33)
		end
	end)
	Chat:GetPropertyChangedSignal("BubbleChatEnabled"):Connect(function() -- line: 1558
		-- upvalues: Chat (copy), v167 (copy), LegacyBubbleChatEnabledChanged (copy)
		local BubbleChatEnabled = Chat.BubbleChatEnabled

		v167:dispatch(LegacyBubbleChatEnabledChanged("Enabled", BubbleChatEnabled))
	end)

	local BubbleChatEnabled = Chat.BubbleChatEnabled

	v167:dispatch(LegacyBubbleChatEnabledChanged("Enabled", BubbleChatEnabled))
	Chat.BubbleChatSettingsChanged:Connect(function(p34) -- line: 1567
		-- upvalues: u166 (ref), FFlagExpChatUseMessagesStore (copy), v170 (copy), v167 (copy), LegacyBubbleChatSettingsChanged (copy)
		if u166.validateLegacyBubbleChatSettings then
			local v315, v316 = u166.validateLegacyBubbleChatSettings(p34)

			assert(v315, "Bad settings object passed to Chat:SetBubbleChatSettings:\n inside consolidated BubbleChat " .. (v316 or ""))

			if FFlagExpChatUseMessagesStore and v170 then
				v170.setBubbleChatSettings(p34)

				return
			end

			v167:dispatch(LegacyBubbleChatSettingsChanged(p34))
		end
	end)

	if getEngineFeatureFlagEnableDisplayBubble() then
		TextChatService.BubbleDisplayed:Connect(function(p35, p36) -- line: 1585
			-- upvalues: getFFlagExpChatProtectedChatInternalAPIs (copy), runOnBubbleDisplayed (copy)
			local v319 = p36 and if not getFFlagExpChatProtectedChatInternalAPIs() then p36.Text else p36.TextInternal

			runOnBubbleDisplayed(p35, v319, p36)
		end)
	end

	local function findCommandInstance(s10: string) -- line: 1596
		-- upvalues: TextChatService (copy)
		for _, descendant in ipairs(TextChatService:GetDescendants()) do
			if s10 == descendant.Name and descendant:IsA("TextChatCommand") then
				return descendant
			end
		end

		return nil
	end

	local t12 = {}

	local function setupTextChatCommands() -- line: 1607
		-- upvalues: Commands (copy), findCommandInstance (copy), t12 (copy), FFlagExpChatUseMessagesStore (copy), v167 (copy), context (copy), displaySystemMessage (copy), u166 (ref), CommandAliasChanged (copy)
		for _, v in ipairs(Commands.enabledCommands) do
			if v.clientRun then
				local v325 = findCommandInstance(v.name)

				if v325 and not t12[v325] then
					t12[v325] = true
					v325.Triggered:Connect(function(p37, ...) -- line: 1618
						-- upvalues: FFlagExpChatUseMessagesStore (copy), v (copy), v167 (copy), context (copy), displaySystemMessage (copy), u166 (ref)
						local v381 = if not FFlagExpChatUseMessagesStore then v.clientRun(v167, p37.UserId, ...) else v.clientRun(v167, p37.UserId, ..., context)

						if v381 then
							displaySystemMessage(v381.key, v381.args, v381.metadata, u166.translator, u166.defaultSystemTextChannel)
						end
					end)

					if string.find(v325.Name, "RBXTeamCommand") or string.find(v325.Name, "RBXWhisperCommand") then
						for _, v327 in {
							"PrimaryAlias",
							"SecondaryAlias"
						} do
							v325:GetPropertyChangedSignal(v327):Connect(function() -- line: 1641
								-- upvalues: v167 (copy), CommandAliasChanged (copy), v325 (copy)
								v167:dispatch(CommandAliasChanged(v325.Name, v325.PrimaryAlias, v325.SecondaryAlias))
							end)
						end
					end
				end
			end
		end
	end

	setupTextChatCommands()
	Chat:GetPropertyChangedSignal("IsAutoMigrated"):Once(setupTextChatCommands)

	if u166.canUserChatAsync and Players.LocalPlayer then
		Promise.try(function() -- line: 1661
			-- upvalues: u166 (ref), Players (copy)
			return u166.canUserChatAsync(Players.LocalPlayer.UserId)
		end):andThen(function(p38) -- line: 1664
			-- upvalues: FFlagExpChatUseMessagesStore (copy), v168 (copy), v167 (copy), ChatPrivacySettingsReceived (copy)
			if FFlagExpChatUseMessagesStore then
				v168.setCanLocalUserChat(p38)

				return
			end

			v167:dispatch(ChatPrivacySettingsReceived(p38))
		end):catch(function() -- line: 1671
			-- upvalues: FFlagExpChatUseMessagesStore (copy), v168 (copy), v167 (copy), ChatPrivacySettingsFetchFailed (copy)
			if FFlagExpChatUseMessagesStore then
				v168.setCanLocalUserChat(false)

				return
			end

			v167:dispatch(ChatPrivacySettingsFetchFailed())
		end)
	end

	watchPlayersService(u166, v167, v168)

	local AppStyleProvider = UIBlox.App.Style.AppStyleProvider
	local Constants = UIBlox.App.Style.Constants
	local Dark = Constants.ThemeName.Dark
	local Gotham = Constants.FontName.Gotham
	local t13 = {
		Dark = {
			themeName = Dark,
			fontName = Gotham
		}
	}
	local v213 = Roact.createElement(AppStyleProvider, {
		style = t13.Dark
	}, {
		app = Roact.createElement(App, {
			isChatWindowVisible = true,
			isChatInputBarVisible = true,
			isChannelBarVisible = false,
			isDefaultChatEnabled = true,
			store = v167,
			translator = u166.translator,
			gameTranslator = if not getFFlagExpChatEnableChannelTabsUI() then nil else u166.gameTranslator,
			getIconVoiceIndicator = u166.getIconVoiceIndicator,
			onClickedVoiceIndicator = u166.onClickedVoiceIndicator,
			onClickedCameraIndicator = u166.onClickedCameraIndicator,
			selfViewListenerChanged = u166.selfViewListenerChanged,
			getPermissions = u166.getPermissions,
			displayCameraDeniedToast = u166.displayCameraDeniedToast,
			isCamEnabledForUserAndPlace = u166.isCamEnabledForUserAndPlace,
			isCameraOnlyUser = u166.isCameraOnlyUser,
			isVoiceServiceInitialized = u166.isVoiceServiceInitialized,
			isSpatialUIEnabled = u166.isSpatialUIEnabled,
			expChatLoadStartTime = if not getFFlagExpChatTelemetryEventTrigger() then nil else os.clock()
		})
	})

	v167:dispatch(ClientAppLoaded({
		team = Players.LocalPlayer and Players.LocalPlayer.Team,
		isChatCoreGuiEnabled = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Chat),
		isTouchEnabled = UserInputService.TouchEnabled,
		isGamepadEnabled = UserInputService.PreferredInput == Enum.PreferredInput.Gamepad
	}))
	reportVersionLoaded(Analytics, Version[1])
	v44:trace("Roact.mount to {}", (tostring(u166.parent)))

	local v214 = Roact.mount(v213, u166.parent, "ExperienceChat")
	local v215 = ChatEnabledSystemMessage({
		translator = u166.translator,
		defaultSystemTextChannel = u166.defaultSystemTextChannel,
		localPlayer = LocalPlayer
	})

	local function updateChatStatus(p39) -- line: 1736
		-- upvalues: v171 (copy), isChatRegionLocked (copy), displaySystemMessage (copy), u166 (ref), ExpChatNewSystemMessagesExperimentation (copy), u186 (ref), canPlatformEnableChat (copy), FFlagExpChatRefactorEnabledMessageLogic (copy), FStringExpChatChatWithTFAmpFeatureName (copy), FStringExpChatChatWithTFAmpNameSpace (copy), v44 (copy), AmpApiProvider (copy), LocalPlayer (copy), AccessResponseEnum (copy), canOnlyChatInRegion (copy), v215 (copy)
		v171.setChatStatus(p39)

		if p39 == "GeoBlocked" or p39 ~= "Unknown" and isChatRegionLocked() then
			displaySystemMessage("CoreScripts.TextChat.ChatWindow.ChatDisabled.RegionUnavailable", nil, "Roblox.ChatDisabled.Info", u166.translator, u166.defaultSystemTextChannel, "You can only view system messages here. Chat is not available in your region.")

			return
		end

		if p39 == "AgeCheckGateExperiment" then
			displaySystemMessage("CoreScripts.TextChat.ChatWindow.ChatDisabled.CheckAgeInAccountInfo", nil, "Roblox.ChatDisabled.Info", u166.translator, u166.defaultSystemTextChannel, "You can only view system messages here. Unlock chat with an age check at Settings > Account info.")

			return
		end

		if p39 == "SettingsDisabled" then
			if ExpChatNewSystemMessagesExperimentation.isExperimentEnabled and ExpChatNewSystemMessagesExperimentation.isExperimentEnabled and not u186 then
				u186 = true
				ExpChatNewSystemMessagesExperimentation.logExposure()
			end

			displaySystemMessage(not ExpChatNewSystemMessagesExperimentation.getNewSystemMessagesEnabled() and "CoreScripts.TextChat.ChatWindow.ChatDisabled.SettingOff" or "CoreScripts.TextChat.Description.TurnOnChatInSettings", nil, "Roblox.ChatDisabled.Info", u166.translator, u166.defaultSystemTextChannel, not ExpChatNewSystemMessagesExperimentation.getNewSystemMessagesEnabled() and "You can only view system messages here. Update your Communication settings to turn on chat." or "Chat with people of similar age groups and trusted friends.")

			return
		end

		if p39 == "SettingsDisabledVpc" then
			if ExpChatNewSystemMessagesExperimentation.isExperimentEnabled and ExpChatNewSystemMessagesExperimentation.isExperimentEnabled and not u186 then
				u186 = true
				ExpChatNewSystemMessagesExperimentation.logExposure()
			end

			displaySystemMessage(not ExpChatNewSystemMessagesExperimentation.getNewSystemMessagesEnabled() and "CoreScripts.TextChat.ChatWindow.ChatDisabled.AskForPermission" or "CoreScripts.TextChat.Description.AskYourParentForPermissionToChat", nil, "Roblox.ChatDisabled.Info", u166.translator, u166.defaultSystemTextChannel, not ExpChatNewSystemMessagesExperimentation.getNewSystemMessagesEnabled() and "You can only view system messages here. Ask your parent for permission to chat in Communication settings." or "Ask your parent for permission to chat in Privacy>Communication settings.")

			return
		end

		if p39 == "AgeCheckVpc" then
			if ExpChatNewSystemMessagesExperimentation.isExperimentEnabled and ExpChatNewSystemMessagesExperimentation.isExperimentEnabled and not u186 then
				u186 = true
				ExpChatNewSystemMessagesExperimentation.logExposure()
			end

			displaySystemMessage(not ExpChatNewSystemMessagesExperimentation.getNewSystemMessagesEnabled() and "CoreScripts.TextChat.ChatWindow.ChatDisabled.AskForPermissionToAgeCheck" or "CoreScripts.TextChat.Description.AskYourParentForPermissionToChat", nil, "Roblox.ChatDisabled.Info", u166.translator, u166.defaultSystemTextChannel, not ExpChatNewSystemMessagesExperimentation.getNewSystemMessagesEnabled() and "You can only view system messages here. Ask your parent for permission to age check in Communication settings." or "Ask your parent for permission to chat in Privacy>Communication settings.")

			return
		end

		if not canPlatformEnableChat() and p39 == "AgeVerificationRequired" or p39 == "IdVerificationRequired" then
			if ExpChatNewSystemMessagesExperimentation.isExperimentEnabled and ExpChatNewSystemMessagesExperimentation.isExperimentEnabled and not u186 then
				u186 = true
				ExpChatNewSystemMessagesExperimentation.logExposure()
			end

			displaySystemMessage(not ExpChatNewSystemMessagesExperimentation.getNewSystemMessagesEnabled() and "CoreScripts.TextChat.ChatWindow.ChatDisabled.CheckAgeInSettings" or "CoreScripts.TextChat.Description.UnlockChatPrivacyCommunications", nil, "Roblox.ChatDisabled.Info", u166.translator, u166.defaultSystemTextChannel, not ExpChatNewSystemMessagesExperimentation.getNewSystemMessagesEnabled() and "You can only view system messages here. To chat, get an age check in your Communication settings." or "Unlock chat with an age check in Privacy>Communication settings.")

			return
		end

		if p39 == "AgeVerificationRequired" then
			if ExpChatNewSystemMessagesExperimentation.isExperimentEnabled and ExpChatNewSystemMessagesExperimentation.isExperimentEnabled and not u186 then
				u186 = true
				ExpChatNewSystemMessagesExperimentation.logExposure()
			end

			displaySystemMessage(not ExpChatNewSystemMessagesExperimentation.getNewSystemMessagesEnabled() and "CoreScripts.TextChat.ChatWindow.ChatDisabled.GetAnAgeCheck" or "CoreScripts.TextChat.Description.UnlockChatWithAnAgeCheck", nil, "Roblox.ChatDisabled.Info", u166.translator, u166.defaultSystemTextChannel, not ExpChatNewSystemMessagesExperimentation.getNewSystemMessagesEnabled() and "You can only view system messages here. Get an age check to chat." or "Unlock chat with an age check.")

			return
		end

		if FFlagExpChatRefactorEnabledMessageLogic and p39 == "Enabled" then
			coroutine.wrap(function() -- line: 1856
				-- upvalues: FStringExpChatChatWithTFAmpFeatureName (copy), FStringExpChatChatWithTFAmpNameSpace (copy), v44 (copy), AmpApiProvider (copy), LocalPlayer (copy), AccessResponseEnum (copy), displaySystemMessage (copy), u166 (ref), canOnlyChatInRegion (copy), v215 (copy)
				if FStringExpChatChatWithTFAmpFeatureName == "" or FStringExpChatChatWithTFAmpNameSpace == "" then
					v44:error("AMP feature name or namespace are not set")

					return
				end

				local v382 = AmpApiProvider.getFeatureAccess({ FStringExpChatChatWithTFAmpFeatureName }, FStringExpChatChatWithTFAmpNameSpace)

				if LocalPlayer.ChatAvailabilityStatus ~= "Enabled" then
					return
				end

				local v383 = nil

				if v382.featureAccessList and #v382.featureAccessList > 0 and v382.featureAccessList[1] then
					v383 = v382.featureAccessList[1].access == AccessResponseEnum.Granted
				end

				if v383 ~= nil then
					if v383 then
						displaySystemMessage("CoreScripts.TextChat.ChatWindow.ChatEnabled.ChatWithTF", nil, "Roblox.ChatEnabled.Info", u166.translator, u166.defaultSystemTextChannel, "Only your trusted friends can chat with you.")

						return
					end

					if canOnlyChatInRegion() then
						displaySystemMessage("CoreScripts.TextChat.ChatWindow.ChatEnabled.ChatInRegion", nil, "Roblox.ChatEnabled.Info", u166.translator, u166.defaultSystemTextChannel, "You can view system messages and chat with users in your region only.")

						return
					end

					v215()

					return
				end

				v44:error("No feature access list found after AMP call")
			end)()

			return
		end

		if p39 == "EnabledBubble" or p39 == "Enabled" and canOnlyChatInRegion() then
			displaySystemMessage("CoreScripts.TextChat.ChatWindow.ChatEnabled.ChatInRegion", nil, "Roblox.ChatEnabled.Info", u166.translator, u166.defaultSystemTextChannel, "You can view system messages and chat with users in your region only.")

			return
		end

		if p39 == "Enabled" then
			v215()

			return
		end

		if p39 == "AllUsers" or p39 == "NoOne" then
			if getChatTranslationEnabled() then
				displaySystemMessage("CoreScripts.TextChat.ChatTranslation.ChatWindow.SystemMessageNew", nil, "Roblox.ChatTranslation.ChatWindow.SystemMessage", u166.translator, u166.defaultSystemTextChannel, "Roblox automatically translates supported languages in chat")

				return
			end
		elseif p39 == "Ineligible" or p39 ~= "Unknown" then
			displaySystemMessage("CoreScripts.TextChat.ChatWindow.ChatDisabled.OnlyViewSystemMessages", nil, "Roblox.ChatDisabled.Info", u166.translator, u166.defaultSystemTextChannel, "You can only view system messages here.")
		end
	end

	local n2 = 0
	local u218 = math.random(v109, v110)

	local function handleUserMessageIntentSent(p40) -- line: 1958
		-- upvalues: v44 (copy), FFlagExpChatUseMessagesStore (copy), v168 (copy), v167 (copy), HiddenMessageReceived (copy), isUserChatEnabled (copy), LocalPlayer (copy), n2 (ref), u218 (ref), v109 (copy), v110 (copy), displaySystemMessage (copy), u166 (ref), GetTransparencyStore (copy)
		v44:debug("Handling a message from UserMessageIntentSent")

		if FFlagExpChatUseMessagesStore then
			v168.handleHiddenMessageReceived(p40)
		else
			v167:dispatch(HiddenMessageReceived(p40))
		end

		if not isUserChatEnabled(LocalPlayer.ChatAvailabilityStatus) then
			n2 += 1

			if n2 == u218 then
				u218 += math.random(v109, v110)
				displaySystemMessage("CoreScripts.TextChat.ChatWindow.ChatDisabled.DontMissMessages", nil, "Roblox.ChatDisabled.Info", u166.translator, u166.defaultSystemTextChannel, "Don’t miss messages. Unlock chat with an age check.")
			end
		end

		GetTransparencyStore(false).resetTextTransparency()
	end
	local function shouldConnectToUserMessageIntentSent() -- line: 1989
		-- upvalues: FFlagExpChatEnableFOMOUpsell (copy), shouldShowFOMOUpsell (copy), FFlagExpChatEnableCrossAgeChatActivity (copy), shouldShowCrossAgeChatActivity (copy)
		local v331 = FFlagExpChatEnableFOMOUpsell and shouldShowFOMOUpsell()
		local v332 = FFlagExpChatEnableCrossAgeChatActivity and shouldShowCrossAgeChatActivity()

		return v331 or v332
	end

	if FFlagAEGIS2EnableGatesForExpChat and LocalPlayer then
		if FFlagEnableModerateChatRemoteEvent then
			local v221 = getExperienceChatVisualConfig()
			local v222 = GetChatModerationStore(false)
			local u223 = false

			u166.moderateChatStoreDisposeEffect = Signals.createEffect(function(p41) -- line: 2003
				-- upvalues: v222 (copy), u223 (ref), displaySystemMessage (copy), u166 (ref), NotificationModalsManager (copy), UIBlox (copy), v221 (copy), FFlagConnectionsToFriendsRename (copy)
				local v334 = v222.getIsSettingEnabled(p41)

				if v334 ~= u223 then
					if v334 then
						displaySystemMessage("CoreScripts.TextChat.MessageStatus.Warning.ModerateChatOn", nil, "Roblox.MessageStatus.Warning.ModerateChatOn", u166.translator, u166.defaultSystemTextChannel)
						NotificationModalsManager.SetUIBloxToast({
							iconImage = UIBlox.App.ImageSet.Images[v221.icon.off],
							toastSubtitle = u166.translator:FormatByKey("CoreScripts.TextChat.Toast.ModerateChatOn.Subtitle"),
							toastTitle = u166.translator:FormatByKey("CoreScripts.TextChat.Toast.ModerateChatOn.Title")
						})
					else
						displaySystemMessage("CoreScripts.TextChat.MessageStatus.Warning.ModerateChatOff", nil, "Roblox.MessageStatus.Warning.ModerateChatOff", u166.translator, u166.defaultSystemTextChannel)
						NotificationModalsManager.SetUIBloxToast({
							iconImage = UIBlox.App.ImageSet.Images[v221.icon.off],
							toastSubtitle = u166.translator:FormatByKey(not FFlagConnectionsToFriendsRename and "CoreScripts.TextChat.Toast.ModerateChatOff.Subtitle" or "CoreScripts.TextChat.Toast.ModerateChatOff.Subtitle.FriendsRename"),
							toastTitle = u166.translator:FormatByKey("CoreScripts.TextChat.Toast.ModerateChatOff.Title")
						})
					end

					u223 = v334
				end
			end)
		end

		local ChatAvailabilityStatus = LocalPlayer.ChatAvailabilityStatus

		v44:debug("Local player's initial ChatAvailabilityStatus is {}", ChatAvailabilityStatus)
		updateChatStatus(ChatAvailabilityStatus)

		local connection = nil
		local v226 = FFlagExpChatEnableFOMOUpsell and shouldShowFOMOUpsell()
		local v227 = FFlagExpChatEnableCrossAgeChatActivity and shouldShowCrossAgeChatActivity()

		if v226 or v227 then
			v44:debug("Connecting to UserMessageIntentSent")
			connection = TextChatService.UserMessageIntentSent:Connect(handleUserMessageIntentSent)
		end

		LocalPlayer:GetPropertyChangedSignal("ChatAvailabilityStatus"):Connect(function() -- line: 2066
			-- upvalues: ChatAvailabilityStatus (ref), LocalPlayer (copy), v44 (copy), updateChatStatus (copy), FFlagExpChatPresetChatEnabled (copy), FFlagExpChatPresetChatLoadTestEnabled (copy), isUserChatEnabled (copy), initializePresetChat (copy), GetPresetChatStore (copy), FFlagExpChatEnableFOMOUpsell (copy), shouldShowFOMOUpsell (copy), FFlagExpChatEnableCrossAgeChatActivity (copy), shouldShowCrossAgeChatActivity (copy), connection (ref), TextChatService (copy), handleUserMessageIntentSent (copy), FFlagExpChatClearHiddenMessagesPostAgeCheck (copy), FFlagExpChatUseMessagesStore (copy), v168 (copy), v167 (copy), HiddenMessagesCleared (copy), GetTransparencyStore (copy), ChatPrivacySettingsReceived (copy)
			ChatAvailabilityStatus = LocalPlayer.ChatAvailabilityStatus
			v44:debug("Local player's ChatAvailabilityStatus has changed to {}", ChatAvailabilityStatus)
			updateChatStatus(ChatAvailabilityStatus)

			if (FFlagExpChatPresetChatEnabled or FFlagExpChatPresetChatLoadTestEnabled) and isUserChatEnabled(ChatAvailabilityStatus) then
				initializePresetChat(GetPresetChatStore(false), not FFlagExpChatPresetChatEnabled and FFlagExpChatPresetChatLoadTestEnabled)
			end

			local v335 = FFlagExpChatEnableFOMOUpsell and shouldShowFOMOUpsell()
			local v336 = FFlagExpChatEnableCrossAgeChatActivity and shouldShowCrossAgeChatActivity()

			if (v335 or v336) and not connection then
				v44:debug("Connecting to UserMessageIntentSent")
				connection = TextChatService.UserMessageIntentSent:Connect(handleUserMessageIntentSent)
			end

			if FFlagExpChatEnableFOMOUpsell and isUserChatEnabled(ChatAvailabilityStatus) and connection and (not FFlagExpChatEnableCrossAgeChatActivity or not shouldShowCrossAgeChatActivity()) then
				v44:debug("Disconnecting from UserMessageIntentSent")
				connection:Disconnect()

				if FFlagExpChatClearHiddenMessagesPostAgeCheck then
					if FFlagExpChatUseMessagesStore then
						v168.handleHiddenMessagesCleared()
					else
						v167:dispatch(HiddenMessagesCleared())
					end

					GetTransparencyStore(false).resetTextTransparency()
				end
			end

			if FFlagExpChatUseMessagesStore then
				v168.setCanLocalUserChat(isUserChatEnabled(ChatAvailabilityStatus))

				return
			end

			v167:dispatch(ChatPrivacySettingsReceived(isUserChatEnabled(ChatAvailabilityStatus)))
		end)
	elseif isChatRegionLocked() then
		displaySystemMessage("CoreScripts.TextChat.ChatWindow.ChatDisabled.RegionUnavailable", nil, "Roblox.ChatDisabled.Info", u166.translator, u166.defaultSystemTextChannel, not FFlagAEGIS2EnableGatesForExpChat and "Chat is unavailable in your region. You can still receive system messages." or "You can only view system messages here. Chat is currently unavailable in your region.")
	elseif not FFlagAEGIS2EnableGatesForExpChat and getChatTranslationEnabled() then
		displaySystemMessage("CoreScripts.TextChat.ChatTranslation.ChatWindow.SystemMessageNew", nil, "Roblox.ChatTranslation.ChatWindow.SystemMessage", u166.translator, u166.defaultSystemTextChannel, "Roblox automatically translates supported languages in chat")
	end

	if FFlagExpChatPresetChatEnabled or FFlagExpChatPresetChatLoadTestEnabled then
		initializePresetChat(GetPresetChatStore(false), not FFlagExpChatPresetChatEnabled and FFlagExpChatPresetChatLoadTestEnabled)
	end

	return {
		roactInstance = v214
	}
end
