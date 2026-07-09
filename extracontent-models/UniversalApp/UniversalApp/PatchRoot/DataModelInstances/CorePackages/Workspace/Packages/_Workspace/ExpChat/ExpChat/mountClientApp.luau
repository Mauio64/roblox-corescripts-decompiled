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
local v105 = game:DefineFastInt("ExpChatMessageResponseThrottlePermyriad", 0)
local v106 = game:DefineFastInt("ExpChatMessageResponseUserSamplePermyriad", 0)
local v107 = game:DefineFastInt("ExpChatHiddenMessagesPromptThresholdLowerBound", 10)
local v108 = game:DefineFastInt("ExpChatHiddenMessagesPromptThresholdUpperBound", 45)
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
local v123 = game:DefineFastFlag("ExpChatRemoveSpaceFromTeamPrefix", false)
local FFlagChatLineReportingGlobalMuteEnabled = SharedFlags.FFlagChatLineReportingGlobalMuteEnabled
local FFlagAIRephraseSettingEnabled = SharedFlags.FFlagAIRephraseSettingEnabled
local FFlagChatSummariesSettingEnabled = SharedFlags.FFlagChatSummariesSettingEnabled
local FFlagEnableGlobalChat3pSummaryLuaApps = require(Flags.FFlagEnableGlobalChat3pSummaryLuaApps)
local FFlagExpChatEnableGlobalChatSummarySystemMessage = require(Flags.FFlagExpChatEnableGlobalChatSummarySystemMessage)
local FFlagExpChatEnablePostProcessRichSystemMessageTextFormat = require(Flags.FFlagExpChatEnablePostProcessRichSystemMessageTextFormat)
local FFlagFixGlobalChat3pSummarySystemMessage = require(Flags.FFlagFixGlobalChat3pSummarySystemMessage)
local v131 = game:DefineFastFlag("ExpChatSuppressGlobalSummaryTabUnread", false)
local FFlagExpChatRefactorEnabledMessageLogic = require(Flags.FFlagExpChatRefactorEnabledMessageLogic)
local FStringExpChatChatWithTFAmpFeatureName = require(Flags.FStringExpChatChatWithTFAmpFeatureName)
local FStringExpChatChatWithTFAmpNameSpace = require(Flags.FStringExpChatChatWithTFAmpNameSpace)
local ExpChatNewSystemMessagesExperimentation = require(ExpChatParent.SocialExperiments).ExpChatNewSystemMessagesExperimentation

function getChatTranslationEnabled() -- line: 160
	-- upvalues: TextChatService (copy)
	local ok, result = pcall(function() -- line: 161
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
	throttlingPercentage = v105,
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

local function watchPlayersService(p1, p2, p3) -- line: 191
	-- upvalues: v44 (copy), isPlayerVerified (copy), PlayerAdded (copy), Players (copy), LocalTeamChanged (copy), FFlagExpChatUseAdorneeStore (copy), context (copy), AdorneeAdded (copy), HumanoidDied (copy), AtomicBinding (copy), waitForFirst (copy), LocalCharacterLoaded (copy), getFFlagUseCharacterStore (copy), CharacterAdded (copy), Promise (copy), displaySystemMessage (copy), FFlagConnectionsToFriendsRename (copy), PlayerRemoved (copy), FFlagExpChatUseMessagesStore (copy)
	v44:trace("Watching Players service")

	local t2 = {}

	local function onPlayerAdded(p4) -- line: 195
		-- upvalues: v44 (copy), isPlayerVerified (copy), p2 (copy), PlayerAdded (copy), Players (copy), LocalTeamChanged (copy), FFlagExpChatUseAdorneeStore (copy), context (copy), AdorneeAdded (copy), HumanoidDied (copy), AtomicBinding (copy), waitForFirst (copy), LocalCharacterLoaded (copy), getFFlagUseCharacterStore (copy), CharacterAdded (copy), t2 (copy)
		v44:trace("Player added: {} {}", p4.Name, (tostring(p4.UserId)))

		local v225 = not not isPlayerVerified(p4) or nil

		p2:dispatch(PlayerAdded(p4.UserId, p4.Name, p4.DisplayName, v225))

		if p4 == Players.LocalPlayer then
			v44:trace("Found local player")
			p4:GetPropertyChangedSignal("Team"):Connect(function() -- line: 204
				-- upvalues: p2 (copy), LocalTeamChanged (copy), p4 (copy)
				p2:dispatch(LocalTeamChanged(p4.Team))
			end)
		end

		local function getHumanoidBinding() -- line: 209
			-- upvalues: p4 (copy), FFlagExpChatUseAdorneeStore (copy), context (copy), p2 (copy), AdorneeAdded (copy), HumanoidDied (copy), AtomicBinding (copy)
			local function dispatchBubbleChatAdornee(p5) -- line: 212
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

					local connection = humanoid.Died:Connect(function() -- line: 226
						-- upvalues: FFlagExpChatUseAdorneeStore (copy), context (copy), p4 (copy), p2 (copy), HumanoidDied (copy)
						if FFlagExpChatUseAdorneeStore then
							context.adorneeStore.handleHumanoidDied(p4.UserId)

							return
						end

						p2:dispatch(HumanoidDied(p4.UserId))
					end)

					local function disconnectHumanoidDied() -- line: 234
						-- upvalues: connection (copy)
						if connection then
							connection:Disconnect()
						end
					end

					return disconnectHumanoidDied
				end

				return function() -- line: 245
				end
			end

			return (AtomicBinding.new({
				humanoid = "Humanoid",
				humanoidRootPart = "HumanoidRootPart"
			}, dispatchBubbleChatAdornee))
		end
		local function dispatchBubbleChatAdornee(p6) -- line: 212
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

				local connection = humanoid.Died:Connect(function() -- line: 226
					-- upvalues: FFlagExpChatUseAdorneeStore (copy), context (copy), p4 (copy), p2 (copy), HumanoidDied (copy)
					if FFlagExpChatUseAdorneeStore then
						context.adorneeStore.handleHumanoidDied(p4.UserId)

						return
					end

					p2:dispatch(HumanoidDied(p4.UserId))
				end)

				local function disconnectHumanoidDied() -- line: 234
					-- upvalues: connection (copy)
					if connection then
						connection:Disconnect()
					end
				end

				return disconnectHumanoidDied
			end

			return function() -- line: 245
			end
		end

		local v228 = AtomicBinding.new({
			humanoid = "Humanoid",
			humanoidRootPart = "HumanoidRootPart"
		}, dispatchBubbleChatAdornee)

		local function onCharacterAdded(p7) -- line: 256
			-- upvalues: waitForFirst (copy), p4 (copy), v44 (copy), Players (copy), p2 (copy), LocalCharacterLoaded (copy), getFFlagUseCharacterStore (copy), context (copy), CharacterAdded (copy), v228 (copy)
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

			v228:bindRoot(p7)
		end
		local function onCharacterRemoving(p8) -- line: 280
			-- upvalues: v228 (copy)
			v228:unbindRoot(p8)
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
	local function onNewPlayerAdded(p9) -- line: 298
		-- upvalues: onPlayerAdded (copy), Players (copy), Promise (copy), displaySystemMessage (copy), FFlagConnectionsToFriendsRename (copy), p1 (copy), v44 (copy)
		onPlayerAdded(p9)

		if Players.LocalPlayer then
			Promise.try(function() -- line: 302
				-- upvalues: p9 (copy), Players (copy)
				if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
					return p9:IsFriendsWithAsync(Players.LocalPlayer.UserId)
				end

				return p9:IsFriendsWith(Players.LocalPlayer.UserId)
			end):andThen(function(p10) -- line: 309
				-- upvalues: displaySystemMessage (copy), FFlagConnectionsToFriendsRename (copy), p9 (copy), p1 (copy)
				if p10 then
					displaySystemMessage(not FFlagConnectionsToFriendsRename and "InGame.UnknownNamespace.GameChat_FriendChatNotifier_JoinMessage" or "InGame.UnknownNamespace.GameChat.FriendChatNotifier.JoinMessage", {
						RBX_NAME = p9.DisplayName
					}, "Roblox.Notification.Friend.Joined", p1.translator, p1.defaultSystemTextChannel)
				end
			end):catch(function(p11) -- line: 322
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
	Players.PlayerRemoving:Connect(function(player) -- line: 337
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

		local v235 = t2[player.UserId]

		if v235 then
			for _, v in ipairs(v235) do
				v:Disconnect()
			end

			t2[player.UserId] = nil
		end
	end)
end

local t3 = {
	canUserChatAsync = function(p12) -- line: 389
		-- upvalues: Chat (copy)
		return Chat:CanUserChatAsync(p12)
	end
}

local function v149(p13) -- line: 394
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

return function(t4: {[any]: any}) -- line: 423
	-- upvalues: v44 (copy), Dictionary (copy), t3 (copy), createStore (copy), createDispatchBindableEvent (copy), bindableEventQueue (copy), watchForErrors (copy), context (copy), FFlagExpChatUseAdorneeStore (copy), GetAdorneeStore (copy), FFlagExpChatUseProximityStore (copy), v40 (copy), FFlagExpChatUseMessagesStore (copy), GetMessagesStore (copy), FFlagExpChatUseChannelTabsStore (copy), GetChannelTabsStore (copy), FFlagExpChatUseChatConfigStore (copy), GetChatConfigurationStore (copy), FFlagAEGIS2EnableGatesForExpChat (copy), GetChatStatusStore (copy), GetGlobalMutedUsersStore (copy), getFFlagUseCharacterStore (copy), GetCharacterStore (copy), Analytics (copy), getFFlagUnreduxLastInputTypeChanged (copy), UserInputService (copy), LastInputTypeChanged (copy), v149 (copy), Chat (copy), TextChatService (copy), setUpConfigurationObjects (copy), setUpClientSettings (copy), Players (copy), displaySystemMessage (copy), getFFlagExpChatProtectedChatInternalAPIs (copy), FFlagExpChatPerfTracking (copy), ExpChatPerfTracker (copy), reportMessageReceived (copy), handleChannelWelcomeMessage (copy), GetTransparencyStore (copy), FFlagExpChatUnreadTabIndicatorV2Window (copy), MarkChannelUnreadForIncomingMessage (copy), IncomingMessageReceived (copy), GetFFlagExpChatSuppressWelcomeMessageTabUnread (copy), shouldSuppressUnreadForTabMetadata (copy), MarkChannelUnreadForSystemMessage (copy), UniverseChatSystemMessageAdded (copy), shouldSendHighFrequencyTelemetry (copy), v106 (copy), t1 (copy), TextChannelCreated (copy), getFFlagExpChatEnableChannelTabsUI (copy), GetNameColor (copy), v123 (copy), getOtherDisplayNameInWhisperChannel (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), ExpChatNewSystemMessagesExperimentation (copy), summaryMessageRichText (copy), FFlagExpChatEnablePostProcessRichSystemMessageTextFormat (copy), FFlagExpChatEnableGlobalChatSummarySystemMessage (copy), v131 (copy), FFlagFixGlobalChat3pSummarySystemMessage (copy), FFlagEnableInExpChatSummaryOnLua (copy), FFlagEnableClientSummarySystemMessageOnLua (copy), TextChannelRemoved (copy), TextChatMessageChatActionType (copy), FFlagEnableGlobalChat3pSummaryLuaApps (copy), FFlagAIRephraseSettingEnabled (copy), FFlagChatSummariesSettingEnabled (copy), RobloxReplicatedStorage (copy), GetUserChatSettingsStore (copy), OutgoingMessageSent (copy), countParticipantsInTextChannel (copy), LocalTextChannelParticipantAdded (copy), LocalTextChannelParticipantRemoved (copy), FFlagExpChatUseUnifiedTooltipStore (copy), GetChatTooltipStore (copy), UniverseChatChannelAdded (copy), GetFFlagEnableExpChatUniverseChatTabNames (copy), shouldFilterGlobalMessage (copy), FFlagChatLineReportingGlobalMuteEnabled (copy), HttpService (copy), IncomingBubbleChatMessageReceived (copy), LegacyBubbleChatEnabledChanged (copy), LegacyBubbleChatSettingsChanged (copy), getEngineFeatureFlagEnableDisplayBubble (copy), Commands (copy), CommandAliasChanged (copy), Promise (copy), ChatPrivacySettingsReceived (copy), ChatPrivacySettingsFetchFailed (copy), watchPlayersService (copy), UIBlox (copy), Roact (copy), App (copy), getFFlagExpChatTelemetryEventTrigger (copy), ClientAppLoaded (copy), StarterGui (copy), reportVersionLoaded (copy), Version (copy), ChatEnabledSystemMessage (copy), isChatRegionLocked (copy), canPlatformEnableChat (copy), FFlagExpChatRefactorEnabledMessageLogic (copy), FStringExpChatChatWithTFAmpFeatureName (copy), FStringExpChatChatWithTFAmpNameSpace (copy), AmpApiProvider (copy), AccessResponseEnum (copy), canOnlyChatInRegion (copy), v107 (copy), v108 (copy), HiddenMessageReceived (copy), isUserChatEnabled (copy), FFlagExpChatEnableFOMOUpsell (copy), shouldShowFOMOUpsell (copy), FFlagExpChatEnableCrossAgeChatActivity (copy), shouldShowCrossAgeChatActivity (copy), FFlagEnableModerateChatRemoteEvent (copy), getExperienceChatVisualConfig (copy), GetChatModerationStore (copy), Signals (copy), NotificationModalsManager (copy), FFlagConnectionsToFriendsRename (copy), FFlagExpChatPresetChatEnabled (copy), FFlagExpChatPresetChatLoadTestEnabled (copy), initializePresetChat (copy), GetPresetChatStore (copy), FFlagExpChatClearHiddenMessagesPostAgeCheck (copy), HiddenMessagesCleared (copy)
	v44:trace("mountClientApp started")

	local u164 = Dictionary.join(t3, t4)
	local v165 = createStore()

	createDispatchBindableEvent(v165)
	bindableEventQueue:flush()
	watchForErrors(game:GetService("ScriptContext"), u164.script, false)
	context.translator = u164.translator
	context.store = v165

	if FFlagExpChatUseAdorneeStore then
		context.adorneeStore = GetAdorneeStore(false)
	end

	if FFlagExpChatUseProximityStore then
		context.proximityStore = v40(false)
	end

	local v166 = if not FFlagExpChatUseMessagesStore then nil else GetMessagesStore(false)
	local v167 = if not FFlagExpChatUseChannelTabsStore then nil else GetChannelTabsStore(false)
	local v168 = if not FFlagExpChatUseChatConfigStore then nil else GetChatConfigurationStore(false)
	local v169 = if not FFlagAEGIS2EnableGatesForExpChat then nil else GetChatStatusStore(false)

	if FFlagExpChatUseMessagesStore then
		context.messagesStore = v166
	end

	context.globalMutedUsersStore = GetGlobalMutedUsersStore(false)

	if getFFlagUseCharacterStore() then
		context.characterStore = GetCharacterStore(false)
	end

	if u164.analytics then
		Analytics.with(u164.analytics)
	end

	if not getFFlagUnreduxLastInputTypeChanged() then
		UserInputService.LastInputTypeChanged:Connect(function(p14) -- line: 468
			-- upvalues: v165 (copy), LastInputTypeChanged (copy)
			v165:dispatch(LastInputTypeChanged(p14))
		end)
	end

	if u164.defaultSystemTextChannel then
		u164.defaultSystemTextChannel.OnIncomingMessage = v149
	else
		Chat:GetPropertyChangedSignal("IsAutoMigrated"):Once(function() -- line: 476
			-- upvalues: TextChatService (copy), u164 (ref), v149 (copy)
			local RBXSystem = TextChatService:FindFirstChild("RBXSystem", true)

			if RBXSystem and RBXSystem:IsA("TextChannel") then
				u164.defaultSystemTextChannel = RBXSystem
				RBXSystem.OnIncomingMessage = v149
			end
		end)
	end

	setUpConfigurationObjects(v165, u164)
	setUpClientSettings(v165)

	local LocalPlayer = Players.LocalPlayer

	if LocalPlayer then
		LocalPlayer:GetPropertyChangedSignal("Team"):Connect(function() -- line: 490
			-- upvalues: LocalPlayer (copy), displaySystemMessage (copy), u164 (ref)
			local Team = LocalPlayer.Team

			if Team then
				displaySystemMessage("InGame.UnknownNamespace.GameChat_TeamChat_NowInTeam", {
					RBX_NAME = Team.Name
				}, "Roblox.Team.Success.NowInTeam", u164.translator, u164.defaultSystemTextChannel)
			end
		end)
	end

	local t5 = {
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

	local function _processIncomingMessageCore(p15, s1: string?, b1: boolean?) -- line: 536
		-- upvalues: getFFlagExpChatProtectedChatInternalAPIs (copy), v44 (copy), FFlagExpChatPerfTracking (copy), LocalPlayer (copy), ExpChatPerfTracker (copy), reportMessageReceived (copy), handleChannelWelcomeMessage (copy), displaySystemMessage (copy), u164 (ref), FFlagExpChatUseMessagesStore (copy), v166 (copy), GetTransparencyStore (copy), FFlagExpChatUseChannelTabsStore (copy), v167 (copy), FFlagExpChatUnreadTabIndicatorV2Window (copy), v165 (copy), MarkChannelUnreadForIncomingMessage (copy), IncomingMessageReceived (copy), t5 (copy), GetFFlagExpChatSuppressWelcomeMessageTabUnread (copy), shouldSuppressUnreadForTabMetadata (copy), MarkChannelUnreadForSystemMessage (copy), UniverseChatSystemMessageAdded (copy), TextChatService (copy), shouldSendHighFrequencyTelemetry (copy), v106 (copy), Analytics (copy), t1 (copy)
		if getFFlagExpChatProtectedChatInternalAPIs() then
			v44:debug("Incoming MessageReceived Status: {} TextInternal: {}", p15.Status.Name, p15.TextInternal)
		else
			v44:debug("Incoming MessageReceived Status: {} Text: {}", p15.Status.Name, p15.Text)
		end

		if FFlagExpChatPerfTracking and (p15.TextSource and p15.TextSource.UserId or "UNKNOWN_TEXT_SOURCE_USER_ID") ~= (LocalPlayer and LocalPlayer.UserId or "UNKNOWN_LOCAL_USER_ID") then
			ExpChatPerfTracker.start(ExpChatPerfTracker.Events.MessageReceiveToWindowRenderInterval, {
				messageId = p15.MessageId
			})
		end

		if LocalPlayer then
			reportMessageReceived(LocalPlayer.UserId, p15)
		end

		if LocalPlayer and p15.TextSource and p15.TextSource.UserId ~= LocalPlayer.UserId then
			local v244 = handleChannelWelcomeMessage(p15, LocalPlayer)

			if v244 then
				displaySystemMessage(v244.key, v244.args, v244.metadata, u164.translator, p15.TextChannel)
			end
		end

		local v245 = LocalPlayer and (p15.TextSource and p15.TextSource.UserId == LocalPlayer.UserId)

		if FFlagExpChatUseMessagesStore then
			v166.handleIncomingOrOutgoingMessage(p15, v245, s1, b1)
			GetTransparencyStore(false).resetTextTransparency()

			if FFlagExpChatUseChannelTabsStore and v167 then
				v167.handleIncomingOrOutgoingMessage(p15, v245, s1)
			elseif FFlagExpChatUnreadTabIndicatorV2Window then
				v165:dispatch(MarkChannelUnreadForIncomingMessage(p15, v245, s1, b1))
			end
		else
			v165:dispatch(IncomingMessageReceived(p15, v245, s1, b1))
			GetTransparencyStore(false).resetTextTransparency()
		end

		local v246 = t5[p15.Status]

		if v246 then
			local ok, result = pcall(function() -- line: 620
				-- upvalues: u164 (ref), v246 (copy)
				return u164.translator:FormatByKey(v246.key)
			end)
			local v249 = ok and (result and result ~= "")

			if s1 and v249 then
				if FFlagExpChatUseMessagesStore and v166 then
					v166.addSystemMessage(result, s1, if not GetFFlagExpChatSuppressWelcomeMessageTabUnread() then nil else v246.metadata)

					if FFlagExpChatUseChannelTabsStore and v167 and (not GetFFlagExpChatSuppressWelcomeMessageTabUnread() or not shouldSuppressUnreadForTabMetadata(v246.metadata)) then
						v167.markChannelUnread(s1)
					elseif FFlagExpChatUnreadTabIndicatorV2Window then
						v165:dispatch(MarkChannelUnreadForSystemMessage(result, s1, if not GetFFlagExpChatSuppressWelcomeMessageTabUnread() then nil else v246.metadata))
					end
				else
					v165:dispatch(UniverseChatSystemMessageAdded(result, s1, if not GetFFlagExpChatSuppressWelcomeMessageTabUnread() then nil else v246.metadata))
				end
			else
				local defaultSystemTextChannel = u164.defaultSystemTextChannel

				if s1 then
					local s1_2 = TextChatService:FindFirstChild(s1)

					if s1_2 and s1_2:IsA("TextChannel") then
						defaultSystemTextChannel = s1_2
					end
				end

				displaySystemMessage(v246.key, nil, v246.metadata, u164.translator, defaultSystemTextChannel)
			end
		end

		if shouldSendHighFrequencyTelemetry(v106) then
			Analytics:TelemetryLogEvent(t1, {
				messageStatus = p15.Status.Name
			}, {
				"addOsInfo",
				"addSessionId",
				"addUniverseId",
				"addPlaceId"
			})
		end
	end
	local function processIncomingMessage(p16, s2: string?) -- line: 681
		-- upvalues: _processIncomingMessageCore (copy)
		_processIncomingMessageCore(p16, s2, nil)
	end
	local function processIncomingMessageWithOptions(p17, t6: {[any]: any}?) -- line: 687
		-- upvalues: _processIncomingMessageCore (copy)
		_processIncomingMessageCore(p17, t6 and t6.channelNameOverride, t6 and t6.isUniverseChat)
	end
	local function handleMessageReceived(p18) -- line: 695
		-- upvalues: v165 (copy), TextChannelCreated (copy), getFFlagExpChatEnableChannelTabsUI (copy), TextChatService (copy), GetNameColor (copy), getFFlagExpChatProtectedChatInternalAPIs (copy), v44 (copy), Players (copy), v123 (copy), LocalPlayer (copy), getOtherDisplayNameInWhisperChannel (copy), u164 (ref), GetFFlagTextChatEnableUniverseChatTabs (copy), _processIncomingMessageCore (copy), FFlagExpChatPerfTracking (copy), ExpChatPerfTracker (copy), reportMessageReceived (copy), handleChannelWelcomeMessage (copy), displaySystemMessage (copy), FFlagExpChatUseMessagesStore (copy), v166 (copy), GetTransparencyStore (copy), FFlagExpChatUseChannelTabsStore (copy), v167 (copy), FFlagExpChatUnreadTabIndicatorV2Window (copy), MarkChannelUnreadForIncomingMessage (copy), IncomingMessageReceived (copy), shouldSendHighFrequencyTelemetry (copy), v106 (copy), Analytics (copy), t1 (copy)
		v165:dispatch(TextChannelCreated(p18))

		local u257 = false

		if getFFlagExpChatEnableChannelTabsUI() then
			local ChannelTabsConfiguration = TextChatService:FindFirstChildOfClass("ChannelTabsConfiguration")

			if ChannelTabsConfiguration then
				u257 = ChannelTabsConfiguration.Enabled
			end
		end

		if string.find(p18.Name, "RBXGeneral") then
			function p18.OnIncomingMessage(p19) -- line: 707
				-- upvalues: GetNameColor (copy), getFFlagExpChatProtectedChatInternalAPIs (copy)
				local TextChatMessageProperties = Instance.new("TextChatMessageProperties")

				if p19.TextSource then
					local v342 = GetNameColor(p19.TextSource.UserId)

					if not p19.ChatWindowMessageProperties then
						local v343 = if not getFFlagExpChatProtectedChatInternalAPIs() then p19.PrefixText else p19.PrefixTextInternal

						TextChatMessageProperties.PrefixText = string.format("<font color=\"#%s\">%s</font>", v342:ToHex(), v343)
					end
				end

				return TextChatMessageProperties
			end
		elseif string.find(p18.Name, "^RBXTeam") then
			function p18.OnIncomingMessage(p20) -- line: 724
				-- upvalues: getFFlagExpChatProtectedChatInternalAPIs (copy), v44 (copy), Players (copy), v123 (copy), u257 (ref)
				local v345 = if not getFFlagExpChatProtectedChatInternalAPIs() then p20.PrefixText else p20.PrefixTextInternal

				if getFFlagExpChatProtectedChatInternalAPIs() then
					v44:trace("Team OnIncomingMessage started: PrefixTextInternal: {} TextInternal: {}", v345, p20.TextInternal)
				else
					v44:trace("Team OnIncomingMessage started: {} {}", v345, p20.Text)
				end

				local TextChatMessageProperties = Instance.new("TextChatMessageProperties")

				if Players.LocalPlayer then
					local TeamColorColor = Players.LocalPlayer.TeamColor.Color
					local v348 = if not v123 then not u257 and "[Team] " or "" else if not u257 then not (#(v345 or "") > 0) and "[Team]" or "[Team] " else ""

					TextChatMessageProperties.PrefixText = string.format("<font color=\"#%s\">%s%s</font>", TeamColorColor:ToHex(), v348, v345)
				end

				v44:trace("Team OnIncomingMessage finished: {} {}", TextChatMessageProperties.PrefixText, TextChatMessageProperties.Text)

				return TextChatMessageProperties
			end
		elseif string.find(p18.Name, "^RBXWhisper") and LocalPlayer then
			function p18.OnIncomingMessage(p21) -- line: 761
				-- upvalues: getOtherDisplayNameInWhisperChannel (copy), p18 (copy), LocalPlayer (copy), u257 (ref), u164 (ref), GetNameColor (copy), getFFlagExpChatProtectedChatInternalAPIs (copy)
				local TextSource = p21.TextSource

				if TextSource then
					local v351 = getOtherDisplayNameInWhisperChannel(p18, LocalPlayer)

					if v351 then
						local v352 = nil

						if not u257 then
							v352 = if TextSource.UserId ~= LocalPlayer.UserId then u164.translator:FormatByKey("CoreScripts.TextChat.WhisperChat.PrefixText.Incoming", {
								RBX_NAME = v351
							}) else u164.translator:FormatByKey("CoreScripts.TextChat.WhisperChat.PrefixText.Outgoing", {
								RBX_NAME = v351
							})
						end

						local TextChatMessageProperties = Instance.new("TextChatMessageProperties")
						local v354 = GetNameColor(TextSource.UserId)

						TextChatMessageProperties.PrefixText = string.format("%s<font color=\"#%s\">%s</font>", not v352 and "" or v352 .. " ", v354:ToHex(), if not getFFlagExpChatProtectedChatInternalAPIs() then p21.PrefixText else p21.PrefixTextInternal)

						return TextChatMessageProperties
					end
				end

				return nil
			end
		end

		p18.MessageReceived:Connect(function(p22) -- line: 800
			-- upvalues: GetFFlagTextChatEnableUniverseChatTabs (copy), _processIncomingMessageCore (copy), getFFlagExpChatProtectedChatInternalAPIs (copy), v44 (copy), FFlagExpChatPerfTracking (copy), LocalPlayer (copy), ExpChatPerfTracker (copy), reportMessageReceived (copy), handleChannelWelcomeMessage (copy), displaySystemMessage (copy), u164 (ref), FFlagExpChatUseMessagesStore (copy), v166 (copy), GetTransparencyStore (copy), FFlagExpChatUseChannelTabsStore (copy), v167 (copy), FFlagExpChatUnreadTabIndicatorV2Window (copy), v165 (copy), MarkChannelUnreadForIncomingMessage (copy), IncomingMessageReceived (copy), shouldSendHighFrequencyTelemetry (copy), v106 (copy), Analytics (copy), t1 (copy)
			if GetFFlagTextChatEnableUniverseChatTabs() then
				_processIncomingMessageCore(p22, nil, nil)

				return
			end

			if getFFlagExpChatProtectedChatInternalAPIs() then
				v44:debug("Incoming MessageReceived Status: {} TextInternal: {}", p22.Status.Name, p22.TextInternal)
			else
				v44:debug("Incoming MessageReceived Status: {} Text: {}", p22.Status.Name, p22.Text)
			end

			if FFlagExpChatPerfTracking and (p22.TextSource and p22.TextSource.UserId or "UNKNOWN_TEXT_SOURCE_USER_ID") ~= (LocalPlayer and LocalPlayer.UserId or "UNKNOWN_LOCAL_USER_ID") then
				ExpChatPerfTracker.start(ExpChatPerfTracker.Events.MessageReceiveToWindowRenderInterval, {
					messageId = p22.MessageId
				})
			end

			if LocalPlayer then
				reportMessageReceived(LocalPlayer.UserId, p22)
			end

			if LocalPlayer and p22.TextSource and p22.TextSource.UserId ~= LocalPlayer.UserId then
				local v356 = handleChannelWelcomeMessage(p22, LocalPlayer)

				if v356 then
					displaySystemMessage(v356.key, v356.args, v356.metadata, u164.translator, p22.TextChannel)
				end
			end

			local v357 = LocalPlayer and (p22.TextSource and p22.TextSource.UserId == LocalPlayer.UserId)

			if FFlagExpChatUseMessagesStore then
				v166.handleIncomingOrOutgoingMessage(p22, v357)
				GetTransparencyStore(false).resetTextTransparency()

				if FFlagExpChatUseChannelTabsStore and v167 then
					v167.handleIncomingOrOutgoingMessage(p22, v357)
				elseif FFlagExpChatUnreadTabIndicatorV2Window then
					v165:dispatch(MarkChannelUnreadForIncomingMessage(p22, v357))
				end
			else
				v165:dispatch(IncomingMessageReceived(p22, v357))
				GetTransparencyStore(false).resetTextTransparency()
			end

			if p22.Status == Enum.TextChatMessageStatus.Floodchecked then
				displaySystemMessage("CoreScripts.TextChat.MessageStatus.Warning.Floodchecked", nil, "Roblox.MessageStatus.Warning.Floodchecked", u164.translator, u164.defaultSystemTextChannel)
			elseif p22.Status == Enum.TextChatMessageStatus.TextFilterFailed then
				displaySystemMessage("CoreScripts.TextChat.MessageStatus.Warning.TextFilterFailed", nil, "Roblox.MessageStatus.Warning.TextFilterFailed", u164.translator, u164.defaultSystemTextChannel)
			elseif p22.Status == Enum.TextChatMessageStatus.InvalidPrivacySettings then
				displaySystemMessage("CoreScripts.TextChat.MessageStatus.Warning.InvalidPrivacySettings", nil, "Roblox.MessageStatus.Warning.InvalidPrivacySettings", u164.translator, u164.defaultSystemTextChannel)
			elseif p22.Status == Enum.TextChatMessageStatus.MessageTooLong then
				displaySystemMessage("CoreScripts.TextChat.MessageStatus.Warning.MessageTooLong", nil, "Roblox.MessageStatus.Warning.MessageTooLong", u164.translator, u164.defaultSystemTextChannel)
			elseif p22.Status == Enum.TextChatMessageStatus.ModerationTimeout then
				displaySystemMessage("CoreScripts.TextChat.MessageStatus.Warning.ModerationTimeout", nil, "Roblox.MessageStatus.Warning.ModerationTimeout", u164.translator, u164.defaultSystemTextChannel)
			elseif p22.Status == Enum.TextChatMessageStatus.Unknown then
				displaySystemMessage("CoreScripts.TextChat.MessageStatus.Warning.Unknown", nil, "Roblox.MessageStatus.Warning.Unknown", u164.translator, u164.defaultSystemTextChannel)
			end

			if shouldSendHighFrequencyTelemetry(v106) then
				Analytics:TelemetryLogEvent(t1, {
					messageStatus = p22.Status.Name
				}, {
					"addOsInfo",
					"addSessionId",
					"addUniverseId",
					"addPlaceId"
				})
			end
		end)
	end
	local function watchTextChatCommand(p23) -- line: 930
		-- upvalues: Analytics (copy)
		p23.Triggered:Connect(function() -- line: 931
			-- upvalues: Analytics (copy), p23 (copy)
			Analytics.FireClientAnalyticsWithEventName("CommandSent", {
				commandName = p23.Name
			})
		end)
	end

	for _, descendant in pairs(TextChatService:GetDescendants()) do
		if descendant:IsA("TextChannel") then
			handleMessageReceived(descendant)
		elseif descendant:IsA("TextChatCommand") then
			descendant.Triggered:Connect(function() -- line: 931
				-- upvalues: Analytics (copy), descendant (copy)
				Analytics.FireClientAnalyticsWithEventName("CommandSent", {
					commandName = descendant.Name
				})
			end)
		end
	end

	local u179 = false
	local u180 = false
	local t7 = {}
	local u182 = false

	local function tryLogExposureNewSystemMessages() -- line: 951
		-- upvalues: ExpChatNewSystemMessagesExperimentation (copy), u182 (ref)
		if not ExpChatNewSystemMessagesExperimentation.isExperimentEnabled or u182 then
			return
		end

		u182 = true
		ExpChatNewSystemMessagesExperimentation.logExposure()
	end
	local function postProcessSummarySystemMessage(s3: string) -- line: 960
		-- upvalues: summaryMessageRichText (copy)
		return summaryMessageRichText.wrapInSummaryMutedStyle(`{ summaryMessageRichText.getSummaryIconPrefix() } { s3 }`)
	end
	local function tryShowSummarySystemMessageOnChannel(p24) -- line: 966
		-- upvalues: u179 (ref), t7 (copy), ExpChatNewSystemMessagesExperimentation (copy), u182 (ref), displaySystemMessage (copy), u164 (ref), FFlagExpChatEnablePostProcessRichSystemMessageTextFormat (copy), postProcessSummarySystemMessage (copy), summaryMessageRichText (copy)
		if not p24 then
			return
		end

		if not u179 then
			return
		end

		if t7[p24.Name] then
			return
		end

		if p24.Name ~= "RBXGeneral" then
			return
		end

		t7[p24.Name] = true

		if ExpChatNewSystemMessagesExperimentation.isExperimentEnabled and ExpChatNewSystemMessagesExperimentation.isExperimentEnabled and not u182 then
			u182 = true
			ExpChatNewSystemMessagesExperimentation.logExposure()
		end

		displaySystemMessage(not ExpChatNewSystemMessagesExperimentation.getNewSystemMessagesEnabled() and "CoreScripts.TextChat.ChatWindow.SummarySystemMessage" or "CoreScripts.TextChat.Description.RobloxSummarizesMessagesFromAllPlayers", nil, "Roblox.Summary.Info", u164.translator, p24, not ExpChatNewSystemMessagesExperimentation.getNewSystemMessagesEnabled() and "Roblox auto-generates summaries of players' messages." or "Roblox summarizes messages from players of all ages.", not FFlagExpChatEnablePostProcessRichSystemMessageTextFormat and function(s4: string) -- line: 1001
			-- upvalues: summaryMessageRichText (copy)
			return summaryMessageRichText.wrapInSummaryMutedStyle(`{ summaryMessageRichText.getSummaryIconPrefix() } { s4 }`)
		end or postProcessSummarySystemMessage)
	end
	local function tryAddThirdPartySummaryGlobalSystemMessage() -- line: 1009
		-- upvalues: u180 (ref), u179 (ref), FFlagExpChatEnableGlobalChatSummarySystemMessage (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), TextChatService (copy), u164 (ref), v131 (copy), FFlagExpChatUseMessagesStore (copy), v166 (copy), FFlagExpChatEnablePostProcessRichSystemMessageTextFormat (copy), postProcessSummarySystemMessage (copy), v165 (copy), UniverseChatSystemMessageAdded (copy), FFlagFixGlobalChat3pSummarySystemMessage (copy)
		if u180 or (not u179 or not FFlagExpChatEnableGlobalChatSummarySystemMessage or not GetFFlagTextChatEnableUniverseChatTabs() or not TextChatService:HasAllocatedUniverseChatContext("global")) then
			return
		end

		local v262 = u164.translator:FormatByKey("CoreScripts.TextChat.ChatWindow.SummarySystemMessage")
		local v263 = if not v131 then nil else "Roblox.Summary.GlobalChat"

		u180 = true

		if FFlagExpChatUseMessagesStore and v166 then
			v166.addSystemMessage(v262, "RBXGlobal", v263, if not FFlagExpChatEnablePostProcessRichSystemMessageTextFormat then nil else postProcessSummarySystemMessage)

			return
		end

		v165:dispatch(UniverseChatSystemMessageAdded(v262, "RBXGlobal", v263, nil, if not FFlagFixGlobalChat3pSummarySystemMessage or not FFlagExpChatEnablePostProcessRichSystemMessageTextFormat then nil else postProcessSummarySystemMessage))
	end

	TextChatService.DescendantAdded:Connect(function(descendant) -- line: 1057
		-- upvalues: handleMessageReceived (copy), FFlagEnableInExpChatSummaryOnLua (copy), FFlagEnableClientSummarySystemMessageOnLua (copy), tryShowSummarySystemMessageOnChannel (copy), Analytics (copy)
		if descendant:IsA("TextChannel") then
			handleMessageReceived(descendant)

			if FFlagEnableInExpChatSummaryOnLua and FFlagEnableClientSummarySystemMessageOnLua then
				tryShowSummarySystemMessageOnChannel(descendant)

				return
			end
		elseif descendant:IsA("TextChatCommand") then
			descendant.Triggered:Connect(function() -- line: 931
				-- upvalues: Analytics (copy), descendant (copy)
				Analytics.FireClientAnalyticsWithEventName("CommandSent", {
					commandName = descendant.Name
				})
			end)
		end
	end)
	TextChatService.DescendantRemoving:Connect(function(descendant) -- line: 1068
		-- upvalues: v165 (copy), TextChannelRemoved (copy), FFlagExpChatUseChannelTabsStore (copy), v167 (copy)
		if descendant:IsA("TextChannel") then
			v165:dispatch(TextChannelRemoved(descendant))

			if FFlagExpChatUseChannelTabsStore and v167 then
				v167.handleChannelRemoved(descendant.Name)
			end
		end
	end)

	if FFlagEnableInExpChatSummaryOnLua then
		TextChatService.ChatActionReceived:Connect(function(p25) -- line: 1079
			-- upvalues: getFFlagExpChatProtectedChatInternalAPIs (copy), v44 (copy), TextChatMessageChatActionType (copy), FFlagEnableGlobalChat3pSummaryLuaApps (copy), _processIncomingMessageCore (copy)
			if getFFlagExpChatProtectedChatInternalAPIs() then
				v44:debug("Incoming ChatActionReceived ChatActionType: {}, TextInternal: {}", p25.ChatActionType, p25.TextInternal)
			else
				v44:debug("Incoming ChatActionReceived ChatActionType: {}, Text: {}", p25.ChatActionType, p25.Text)
			end

			if p25.ChatActionType == TextChatMessageChatActionType.Summary then
				if FFlagEnableGlobalChat3pSummaryLuaApps then
					local v267 = if p25.TextChannel ~= nil then nil else {
						channelNameOverride = "RBXGlobal",
						isUniverseChat = true
					}

					_processIncomingMessageCore(p25, v267 and v267.channelNameOverride, v267 and v267.isUniverseChat)

					return
				end

				_processIncomingMessageCore(p25, nil, nil)

				return
			end

			v44:error("Unknown ChatActionType: {}", p25.ChatActionType)
		end)
	end

	if FFlagEnableInExpChatSummaryOnLua or FFlagAIRephraseSettingEnabled or FFlagChatSummariesSettingEnabled then
		coroutine.wrap(function() -- line: 1114
			-- upvalues: RobloxReplicatedStorage (copy), v44 (copy), LocalPlayer (copy), FFlagEnableClientSummarySystemMessageOnLua (copy), FFlagChatSummariesSettingEnabled (copy), u179 (ref), TextChatService (copy), tryShowSummarySystemMessageOnChannel (copy), tryAddThirdPartySummaryGlobalSystemMessage (copy), FFlagAIRephraseSettingEnabled (copy), GetUserChatSettingsStore (copy)
			local ExpChatFeatureValueChanged = RobloxReplicatedStorage:WaitForChild("ExpChatFeatureValueChanged", 10)

			if ExpChatFeatureValueChanged then
				ExpChatFeatureValueChanged.OnClientEvent:Connect(function(n1: number, s5: string, s6: string) -- line: 1117
					-- upvalues: v44 (copy), LocalPlayer (copy), FFlagEnableClientSummarySystemMessageOnLua (copy), FFlagChatSummariesSettingEnabled (copy), u179 (ref), TextChatService (copy), tryShowSummarySystemMessageOnChannel (copy), tryAddThirdPartySummaryGlobalSystemMessage (copy), FFlagAIRephraseSettingEnabled (copy), GetUserChatSettingsStore (copy)
					v44:debug("Incoming ExpChatFeatureValueChanged userId: {}, featureName: {}, featureValue: {}", n1, s5, s6)

					if LocalPlayer and n1 == LocalPlayer.UserId then
						if FFlagEnableClientSummarySystemMessageOnLua and s5 == "EligibleForThirdPartySummary" and not FFlagChatSummariesSettingEnabled then
							u179 = s6 == "true"

							if u179 then
								for _, descendant in TextChatService:GetDescendants() do
									if descendant:IsA("TextChannel") then
										tryShowSummarySystemMessageOnChannel(descendant)
									end
								end

								tryAddThirdPartySummaryGlobalSystemMessage()
							end
						end

						if FFlagAIRephraseSettingEnabled and s5 == "AIRephraseSettingStatus" then
							GetUserChatSettingsStore.updateExpChatFeatureValue(s5, s6)
						end

						if FFlagChatSummariesSettingEnabled and s5 == "AllowThirdPartySummary" then
							GetUserChatSettingsStore.updateExpChatFeatureValue(s5, s6)
							u179 = s6 == "Enabled"

							if u179 then
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

	TextChatService.SendingMessage:Connect(function(message) -- line: 1162
		-- upvalues: FFlagExpChatPerfTracking (copy), ExpChatPerfTracker (copy), getFFlagExpChatProtectedChatInternalAPIs (copy), v44 (copy), LocalPlayer (copy), handleChannelWelcomeMessage (copy), displaySystemMessage (copy), u164 (ref), FFlagExpChatUseMessagesStore (copy), v166 (copy), v165 (copy), OutgoingMessageSent (copy), Analytics (copy), countParticipantsInTextChannel (copy)
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
			local v270 = handleChannelWelcomeMessage(message, LocalPlayer)

			if v270 and v270.key then
				displaySystemMessage(v270.key, v270.args, v270.metadata, u164.translator, message.TextChannel)
			end
		end

		if FFlagExpChatUseMessagesStore then
			v166.handleIncomingOrOutgoingMessage(message, true)
		else
			v165:dispatch(OutgoingMessageSent(message))
		end

		local TextChannel = message.TextChannel

		if TextChannel then
			Analytics.FireClientAnalyticsWithEventName("MessageSent", {
				channelName = TextChannel.Name,
				totalParticipants = countParticipantsInTextChannel(TextChannel)
			})
		end
	end)

	local function connectSendingUniverseChatMessage() -- line: 1210
		-- upvalues: GetFFlagTextChatEnableUniverseChatTabs (copy), TextChatService (copy), FFlagExpChatPerfTracking (copy), ExpChatPerfTracker (copy), getFFlagExpChatProtectedChatInternalAPIs (copy), v44 (copy), LocalPlayer (copy), handleChannelWelcomeMessage (copy), displaySystemMessage (copy), u164 (ref), FFlagExpChatUseMessagesStore (copy), v166 (copy), v165 (copy), OutgoingMessageSent (copy), FFlagExpChatUseChannelTabsStore (copy), v167 (copy), Analytics (copy), countParticipantsInTextChannel (copy)
		if not GetFFlagTextChatEnableUniverseChatTabs() then
			return
		end

		TextChatService.SendingUniverseChatMessage:Connect(function(p26) -- line: 1214
			-- upvalues: FFlagExpChatPerfTracking (copy), ExpChatPerfTracker (copy), getFFlagExpChatProtectedChatInternalAPIs (copy), v44 (copy), LocalPlayer (copy), handleChannelWelcomeMessage (copy), displaySystemMessage (copy), u164 (ref), TextChatService (copy), FFlagExpChatUseMessagesStore (copy), v166 (copy), v165 (copy), OutgoingMessageSent (copy), FFlagExpChatUseChannelTabsStore (copy), v167 (copy), Analytics (copy), countParticipantsInTextChannel (copy)
			if FFlagExpChatPerfTracking then
				ExpChatPerfTracker.start(ExpChatPerfTracker.Events.MessageSendToWindowRenderInterval, {
					messageId = p26.MessageId
				})
			end

			if getFFlagExpChatProtectedChatInternalAPIs() then
				v44:debug("Outgoing SendingMessage Status: {} TextInternal: {}", p26.Status.Name, p26.TextInternal)
			else
				v44:debug("Outgoing SendingMessage Status: {} Text: {}", p26.Status.Name, p26.Text)
			end

			if LocalPlayer then
				local v367 = handleChannelWelcomeMessage(p26, LocalPlayer)

				if v367 and v367.key then
					displaySystemMessage(v367.key, v367.args, v367.metadata, u164.translator, p26.TextChannel)
				end
			end

			local ChatInputBarConfiguration = TextChatService:FindFirstChildOfClass("ChatInputBarConfiguration")
			local v369 = if ChatInputBarConfiguration and ChatInputBarConfiguration.TargetTextChannel then nil else "RBXGlobal"

			if FFlagExpChatUseMessagesStore then
				v166.handleIncomingOrOutgoingMessage(p26, true, v369)
			else
				v165:dispatch(OutgoingMessageSent(p26, v369))
			end

			if FFlagExpChatUseChannelTabsStore and v167 then
				v167.handleIncomingOrOutgoingMessage(p26, true, v369)
			end

			local TextChannel = p26.TextChannel

			if TextChannel then
				Analytics.FireClientAnalyticsWithEventName("MessageSent", {
					channelName = TextChannel.Name,
					totalParticipants = countParticipantsInTextChannel(TextChannel)
				})
			end
		end)
	end

	if GetFFlagTextChatEnableUniverseChatTabs() then
		TextChatService.SendingUniverseChatMessage:Connect(function(p27) -- line: 1214
			-- upvalues: FFlagExpChatPerfTracking (copy), ExpChatPerfTracker (copy), getFFlagExpChatProtectedChatInternalAPIs (copy), v44 (copy), LocalPlayer (copy), handleChannelWelcomeMessage (copy), displaySystemMessage (copy), u164 (ref), TextChatService (copy), FFlagExpChatUseMessagesStore (copy), v166 (copy), v165 (copy), OutgoingMessageSent (copy), FFlagExpChatUseChannelTabsStore (copy), v167 (copy), Analytics (copy), countParticipantsInTextChannel (copy)
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
				local v273 = handleChannelWelcomeMessage(p27, LocalPlayer)

				if v273 and v273.key then
					displaySystemMessage(v273.key, v273.args, v273.metadata, u164.translator, p27.TextChannel)
				end
			end

			local ChatInputBarConfiguration = TextChatService:FindFirstChildOfClass("ChatInputBarConfiguration")
			local v275 = if ChatInputBarConfiguration and ChatInputBarConfiguration.TargetTextChannel then nil else "RBXGlobal"

			if FFlagExpChatUseMessagesStore then
				v166.handleIncomingOrOutgoingMessage(p27, true, v275)
			else
				v165:dispatch(OutgoingMessageSent(p27, v275))
			end

			if FFlagExpChatUseChannelTabsStore and v167 then
				v167.handleIncomingOrOutgoingMessage(p27, true, v275)
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

	local function isInstanceALocalTextChannelParticipant(p28) -- line: 1272
		-- upvalues: Players (copy)
		return p28 and (p28:IsA("TextSource") and (Players.LocalPlayer and Players.LocalPlayer.UserId == p28.UserId))
	end
	local function getChannelTabIndex(s7: string) -- line: 1279
		if s7 == "RBXGeneral" then
			return 1
		end

		if s7 == "RBXGlobal" then
			return 2
		end

		return 3
	end

	if getFFlagExpChatEnableChannelTabsUI() then
		local ChannelTabsConfiguration = TextChatService:FindFirstChildOfClass("ChannelTabsConfiguration")
		local v191 = not not ChannelTabsConfiguration and ChannelTabsConfiguration.Enabled
		local v192 = GetFFlagTextChatEnableUniverseChatTabs() and not v191

		for _, descendant in pairs(TextChatService:GetDescendants()) do
			if descendant.Parent and descendant.Parent:IsA("TextChannel") and (descendant and (descendant:IsA("TextSource") and (Players.LocalPlayer and Players.LocalPlayer.UserId == descendant.UserId))) then
				v165:dispatch(LocalTextChannelParticipantAdded(descendant.Parent))

				if FFlagExpChatUseChannelTabsStore and v167 then
					local ParentName = descendant.Parent.Name

					if ParentName ~= "RBXSystem" and (not v192 or ParentName == "RBXGeneral") then
						local v196 = if ParentName ~= "RBXGeneral" then not GetFFlagTextChatEnableUniverseChatTabs() and 2 or if ParentName ~= "RBXGeneral" then ParentName ~= "RBXGlobal" and 3 or 2 else 1 else nil

						v167.addChannelTab({
							type = "TextChat",
							name = ParentName
						}, v196)
					end
				end
			end

			if descendant:IsA("TextChannel") then
				descendant.DescendantRemoving:Connect(function(descendant2) -- line: 1324
					-- upvalues: Players (copy), v165 (copy), LocalTextChannelParticipantRemoved (copy), descendant (copy), FFlagExpChatUseChannelTabsStore (copy), v167 (copy)
					if descendant2 and (descendant2:IsA("TextSource") and (Players.LocalPlayer and Players.LocalPlayer.UserId == descendant2.UserId)) then
						v165:dispatch(LocalTextChannelParticipantRemoved(descendant))

						if FFlagExpChatUseChannelTabsStore and v167 then
							local descendantName = descendant.Name

							v167.removeChannelTab(descendantName)
						end
					end
				end)
			end
		end

		TextChatService.DescendantAdded:Connect(function(descendant) -- line: 1338
			-- upvalues: Players (copy), v165 (copy), LocalTextChannelParticipantAdded (copy), FFlagExpChatUseChannelTabsStore (copy), v167 (copy), v192 (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), LocalTextChannelParticipantRemoved (copy)
			if descendant.Parent and (descendant.Parent:IsA("TextChannel") and (descendant and (descendant:IsA("TextSource") and (Players.LocalPlayer and Players.LocalPlayer.UserId == descendant.UserId)))) then
				v165:dispatch(LocalTextChannelParticipantAdded(descendant.Parent))

				if FFlagExpChatUseChannelTabsStore and v167 then
					local ParentName = descendant.Parent.Name

					if ParentName ~= "RBXSystem" and (not v192 or ParentName == "RBXGeneral") then
						local v283 = if ParentName ~= "RBXGeneral" then not GetFFlagTextChatEnableUniverseChatTabs() and 2 or if ParentName ~= "RBXGeneral" then ParentName ~= "RBXGlobal" and 3 or 2 else 1 else nil

						v167.addChannelTab({
							type = "TextChat",
							name = ParentName
						}, v283)
					end
				end
			end

			if descendant:IsA("TextChannel") then
				descendant.DescendantRemoving:Connect(function(descendant3) -- line: 1368
					-- upvalues: Players (copy), v165 (copy), LocalTextChannelParticipantRemoved (copy), descendant (copy), FFlagExpChatUseChannelTabsStore (copy), v167 (copy)
					if descendant3 and (descendant3:IsA("TextSource") and (Players.LocalPlayer and Players.LocalPlayer.UserId == descendant3.UserId)) then
						v165:dispatch(LocalTextChannelParticipantRemoved(descendant))

						if FFlagExpChatUseChannelTabsStore and v167 then
							local descendantName = descendant.Name

							v167.removeChannelTab(descendantName)
						end
					end
				end)
			end
		end)
	end

	if GetFFlagTextChatEnableUniverseChatTabs() then
		local t8 = {}

		local function handleUniverseChatChannelAllocated(s8: string) -- line: 1387
			-- upvalues: t8 (copy), TextChatService (copy), FFlagExpChatUseUnifiedTooltipStore (copy), GetChatTooltipStore (copy), v165 (copy), UniverseChatChannelAdded (copy), FFlagExpChatUseChannelTabsStore (copy), v167 (copy), GetFFlagEnableExpChatUniverseChatTabNames (copy), u164 (ref), FFlagExpChatUseMessagesStore (copy), v166 (copy), GetFFlagExpChatSuppressWelcomeMessageTabUnread (copy), FFlagExpChatUnreadTabIndicatorV2Window (copy), MarkChannelUnreadForSystemMessage (copy), UniverseChatSystemMessageAdded (copy), tryAddThirdPartySummaryGlobalSystemMessage (copy)
			if t8[s8] then
				return
			end

			t8[s8] = true

			local ChatWindowConfiguration = TextChatService:FindFirstChildOfClass("ChatWindowConfiguration")
			local ChatInputBarConfiguration = TextChatService:FindFirstChildOfClass("ChatInputBarConfiguration")
			local v287 = not ChatWindowConfiguration or ChatWindowConfiguration.Enabled ~= false
			local v288 = not ChatInputBarConfiguration or ChatInputBarConfiguration.Enabled ~= false

			if not v287 or not v288 then
				return
			end

			local s9 = ""

			if s8 == "global" then
				s9 = "RBXGlobal"

				if FFlagExpChatUseUnifiedTooltipStore then
					GetChatTooltipStore(false).setIsGlobalChatAvailable(true)
				end
			end

			v165:dispatch(UniverseChatChannelAdded(s9, if s9 ~= "RBXGeneral" then s9 ~= "RBXGlobal" and 3 or 2 else 1))

			if FFlagExpChatUseChannelTabsStore and v167 then
				v167.addChannelTab({
					type = "UniverseChat",
					name = s9
				}, nil)
			end

			if GetFFlagEnableExpChatUniverseChatTabNames() and s9 ~= "" then
				local ok, result = pcall(function() -- line: 1418
					-- upvalues: u164 (ref)
					return u164.translator:FormatByKey("CoreScripts.TextChat.ChatWindow.ChatEnabled.Global2")
				end)

				if ok and result and result ~= "" then
					if FFlagExpChatUseMessagesStore and v166 then
						if GetFFlagExpChatSuppressWelcomeMessageTabUnread() then
							v166.addSystemMessage(result, s9, "Roblox.Welcome.GlobalChat")
						else
							v166.addSystemMessage(result, s9)
						end

						if FFlagExpChatUseChannelTabsStore and v167 and not GetFFlagExpChatSuppressWelcomeMessageTabUnread() then
							v167.markChannelUnread(s9)
						elseif FFlagExpChatUnreadTabIndicatorV2Window then
							v165:dispatch(MarkChannelUnreadForSystemMessage(result, s9, if not GetFFlagExpChatSuppressWelcomeMessageTabUnread() then nil else "Roblox.Welcome.GlobalChat"))
						end
					elseif GetFFlagExpChatSuppressWelcomeMessageTabUnread() then
						v165:dispatch(UniverseChatSystemMessageAdded(result, s9, "Roblox.Welcome.GlobalChat"))
					else
						v165:dispatch(UniverseChatSystemMessageAdded(result, s9))
					end
				end
			end

			tryAddThirdPartySummaryGlobalSystemMessage()
		end

		if TextChatService:HasAllocatedUniverseChatContext("global") then
			handleUniverseChatChannelAllocated("global")
		end

		TextChatService.UniverseChatChannelAllocated:Connect(handleUniverseChatChannelAllocated)
		TextChatService.UniverseChatMessageReceived:Connect(function(p29) -- line: 1482
			-- upvalues: shouldFilterGlobalMessage (copy), GetGlobalMutedUsersStore (copy), LocalPlayer (copy), FFlagChatLineReportingGlobalMuteEnabled (copy), _processIncomingMessageCore (copy)
			if shouldFilterGlobalMessage(p29, GetGlobalMutedUsersStore(false), LocalPlayer and LocalPlayer.UserId) then
				return
			end

			if FFlagChatLineReportingGlobalMuteEnabled then
				local t9 = {
					channelNameOverride = "RBXGlobal",
					isUniverseChat = true
				}

				_processIncomingMessageCore(p29, t9 and t9.channelNameOverride, t9 and t9.isUniverseChat)

				return
			end

			_processIncomingMessageCore(p29, "RBXGlobal", nil)
		end)
	end

	local function runOnBubbleDisplayed(p30, s10: string, p31) -- line: 1504
		-- upvalues: Players (copy), HttpService (copy), getFFlagExpChatProtectedChatInternalAPIs (copy), FFlagExpChatUseMessagesStore (copy), v166 (copy), v165 (copy), IncomingBubbleChatMessageReceived (copy)
		local player = nil

		if p30:IsA("Model") then
			player = Players:GetPlayerFromCharacter(p30)
		end

		local guid = HttpService:GenerateGUID(false)
		local BubbleChatMessageProperties = nil
		local v300 = nil

		if p31 then
			guid = p31.MessageId
			BubbleChatMessageProperties = p31.BubbleChatMessageProperties
			v300 = if not getFFlagExpChatProtectedChatInternalAPIs() then p31.Translation else p31.TranslationInternal
		end

		local dateTime = DateTime.fromUnixTimestampMillis(workspace:GetServerTimeNow() * 1000)
		local t10 = {
			message = s10,
			translation = v300,
			bubbleChatMessageId = guid,
			bubbleChatMessageUserId = player and tostring(player.UserId) or nil,
			partOrModel = p30,
			timestamp = dateTime,
			bubbleChatMessageProperties = BubbleChatMessageProperties
		}

		if FFlagExpChatUseMessagesStore then
			v166.handleIncomingBubbleChatMessage(t10)

			return
		end

		v165:dispatch(IncomingBubbleChatMessageReceived(t10))
	end

	Chat.Chatted:Connect(function(message, p32) -- line: 1539
		-- upvalues: TextChatService (copy), Chat (copy), runOnBubbleDisplayed (copy)
		if TextChatService.ChatVersion ~= Enum.ChatVersion.LegacyChatService or Chat.BubbleChatEnabled then
			runOnBubbleDisplayed(message, p32)
		end
	end)
	Chat:GetPropertyChangedSignal("BubbleChatEnabled"):Connect(function() -- line: 1546
		-- upvalues: Chat (copy), v165 (copy), LegacyBubbleChatEnabledChanged (copy)
		local BubbleChatEnabled = Chat.BubbleChatEnabled

		v165:dispatch(LegacyBubbleChatEnabledChanged("Enabled", BubbleChatEnabled))
	end)

	local BubbleChatEnabled = Chat.BubbleChatEnabled

	v165:dispatch(LegacyBubbleChatEnabledChanged("Enabled", BubbleChatEnabled))
	Chat.BubbleChatSettingsChanged:Connect(function(p33) -- line: 1555
		-- upvalues: u164 (ref), FFlagExpChatUseMessagesStore (copy), v168 (copy), v165 (copy), LegacyBubbleChatSettingsChanged (copy)
		if u164.validateLegacyBubbleChatSettings then
			local v307, v308 = u164.validateLegacyBubbleChatSettings(p33)

			assert(v307, "Bad settings object passed to Chat:SetBubbleChatSettings:\n inside consolidated BubbleChat " .. (v308 or ""))

			if FFlagExpChatUseMessagesStore and v168 then
				v168.setBubbleChatSettings(p33)

				return
			end

			v165:dispatch(LegacyBubbleChatSettingsChanged(p33))
		end
	end)

	if getEngineFeatureFlagEnableDisplayBubble() then
		TextChatService.BubbleDisplayed:Connect(function(p34, p35) -- line: 1573
			-- upvalues: getFFlagExpChatProtectedChatInternalAPIs (copy), runOnBubbleDisplayed (copy)
			local v311 = p35 and if not getFFlagExpChatProtectedChatInternalAPIs() then p35.Text else p35.TextInternal

			runOnBubbleDisplayed(p34, v311, p35)
		end)
	end

	local function findCommandInstance(s11: string) -- line: 1584
		-- upvalues: TextChatService (copy)
		for _, descendant in ipairs(TextChatService:GetDescendants()) do
			if s11 == descendant.Name and descendant:IsA("TextChatCommand") then
				return descendant
			end
		end

		return nil
	end

	local t11 = {}

	local function setupTextChatCommands() -- line: 1595
		-- upvalues: Commands (copy), findCommandInstance (copy), t11 (copy), FFlagExpChatUseMessagesStore (copy), v165 (copy), context (copy), displaySystemMessage (copy), u164 (ref), CommandAliasChanged (copy)
		for _, v in ipairs(Commands.enabledCommands) do
			if v.clientRun then
				local v317 = findCommandInstance(v.name)

				if v317 and not t11[v317] then
					t11[v317] = true
					v317.Triggered:Connect(function(p36, ...) -- line: 1606
						-- upvalues: FFlagExpChatUseMessagesStore (copy), v (copy), v165 (copy), context (copy), displaySystemMessage (copy), u164 (ref)
						local v374 = if not FFlagExpChatUseMessagesStore then v.clientRun(v165, p36.UserId, ...) else v.clientRun(v165, p36.UserId, ..., context)

						if v374 then
							displaySystemMessage(v374.key, v374.args, v374.metadata, u164.translator, u164.defaultSystemTextChannel)
						end
					end)

					if string.find(v317.Name, "RBXTeamCommand") or string.find(v317.Name, "RBXWhisperCommand") then
						for _, v319 in {
							"PrimaryAlias",
							"SecondaryAlias"
						} do
							v317:GetPropertyChangedSignal(v319):Connect(function() -- line: 1629
								-- upvalues: v165 (copy), CommandAliasChanged (copy), v317 (copy)
								v165:dispatch(CommandAliasChanged(v317.Name, v317.PrimaryAlias, v317.SecondaryAlias))
							end)
						end
					end
				end
			end
		end
	end

	setupTextChatCommands()
	Chat:GetPropertyChangedSignal("IsAutoMigrated"):Once(setupTextChatCommands)

	if u164.canUserChatAsync and Players.LocalPlayer then
		Promise.try(function() -- line: 1649
			-- upvalues: u164 (ref), Players (copy)
			return u164.canUserChatAsync(Players.LocalPlayer.UserId)
		end):andThen(function(p37) -- line: 1652
			-- upvalues: FFlagExpChatUseMessagesStore (copy), v166 (copy), v165 (copy), ChatPrivacySettingsReceived (copy)
			if FFlagExpChatUseMessagesStore then
				v166.setCanLocalUserChat(p37)

				return
			end

			v165:dispatch(ChatPrivacySettingsReceived(p37))
		end):catch(function() -- line: 1659
			-- upvalues: FFlagExpChatUseMessagesStore (copy), v166 (copy), v165 (copy), ChatPrivacySettingsFetchFailed (copy)
			if FFlagExpChatUseMessagesStore then
				v166.setCanLocalUserChat(false)

				return
			end

			v165:dispatch(ChatPrivacySettingsFetchFailed())
		end)
	end

	watchPlayersService(u164, v165, v166)

	local AppStyleProvider = UIBlox.App.Style.AppStyleProvider
	local Constants = UIBlox.App.Style.Constants
	local Dark = Constants.ThemeName.Dark
	local Gotham = Constants.FontName.Gotham
	local t12 = {
		Dark = {
			themeName = Dark,
			fontName = Gotham
		}
	}
	local v209 = Roact.createElement(AppStyleProvider, {
		style = t12.Dark
	}, {
		app = Roact.createElement(App, {
			isChatWindowVisible = true,
			isChatInputBarVisible = true,
			isChannelBarVisible = false,
			isDefaultChatEnabled = true,
			store = v165,
			translator = u164.translator,
			gameTranslator = if not getFFlagExpChatEnableChannelTabsUI() then nil else u164.gameTranslator,
			getIconVoiceIndicator = u164.getIconVoiceIndicator,
			onClickedVoiceIndicator = u164.onClickedVoiceIndicator,
			onClickedCameraIndicator = u164.onClickedCameraIndicator,
			selfViewListenerChanged = u164.selfViewListenerChanged,
			getPermissions = u164.getPermissions,
			displayCameraDeniedToast = u164.displayCameraDeniedToast,
			isCamEnabledForUserAndPlace = u164.isCamEnabledForUserAndPlace,
			isCameraOnlyUser = u164.isCameraOnlyUser,
			isVoiceServiceInitialized = u164.isVoiceServiceInitialized,
			isSpatialUIEnabled = u164.isSpatialUIEnabled,
			expChatLoadStartTime = if not getFFlagExpChatTelemetryEventTrigger() then nil else os.clock()
		})
	})

	v165:dispatch(ClientAppLoaded({
		team = Players.LocalPlayer and Players.LocalPlayer.Team,
		isChatCoreGuiEnabled = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Chat),
		isTouchEnabled = UserInputService.TouchEnabled,
		isGamepadEnabled = UserInputService.PreferredInput == Enum.PreferredInput.Gamepad
	}))
	reportVersionLoaded(Analytics, Version[1])
	v44:trace("Roact.mount to {}", (tostring(u164.parent)))

	local v210 = Roact.mount(v209, u164.parent, "ExperienceChat")
	local v211 = ChatEnabledSystemMessage({
		translator = u164.translator,
		defaultSystemTextChannel = u164.defaultSystemTextChannel,
		localPlayer = LocalPlayer
	})

	local function updateChatStatus(p38) -- line: 1724
		-- upvalues: v169 (copy), isChatRegionLocked (copy), displaySystemMessage (copy), u164 (ref), ExpChatNewSystemMessagesExperimentation (copy), u182 (ref), canPlatformEnableChat (copy), FFlagExpChatRefactorEnabledMessageLogic (copy), FStringExpChatChatWithTFAmpFeatureName (copy), FStringExpChatChatWithTFAmpNameSpace (copy), v44 (copy), AmpApiProvider (copy), LocalPlayer (copy), AccessResponseEnum (copy), canOnlyChatInRegion (copy), v211 (copy)
		v169.setChatStatus(p38)

		if p38 == "GeoBlocked" or p38 ~= "Unknown" and isChatRegionLocked() then
			displaySystemMessage("CoreScripts.TextChat.ChatWindow.ChatDisabled.RegionUnavailable", nil, "Roblox.ChatDisabled.Info", u164.translator, u164.defaultSystemTextChannel, "You can only view system messages here. Chat is not available in your region.")

			return
		end

		if p38 == "AgeCheckGateExperiment" then
			displaySystemMessage("CoreScripts.TextChat.ChatWindow.ChatDisabled.CheckAgeInAccountInfo", nil, "Roblox.ChatDisabled.Info", u164.translator, u164.defaultSystemTextChannel, "You can only view system messages here. Unlock chat with an age check at Settings > Account info.")

			return
		end

		if p38 == "SettingsDisabled" then
			if ExpChatNewSystemMessagesExperimentation.isExperimentEnabled and ExpChatNewSystemMessagesExperimentation.isExperimentEnabled and not u182 then
				u182 = true
				ExpChatNewSystemMessagesExperimentation.logExposure()
			end

			displaySystemMessage(not ExpChatNewSystemMessagesExperimentation.getNewSystemMessagesEnabled() and "CoreScripts.TextChat.ChatWindow.ChatDisabled.SettingOff" or "CoreScripts.TextChat.Description.TurnOnChatInSettings", nil, "Roblox.ChatDisabled.Info", u164.translator, u164.defaultSystemTextChannel, not ExpChatNewSystemMessagesExperimentation.getNewSystemMessagesEnabled() and "You can only view system messages here. Update your Communication settings to turn on chat." or "Chat with people of similar age groups and trusted friends.")

			return
		end

		if p38 == "SettingsDisabledVpc" then
			if ExpChatNewSystemMessagesExperimentation.isExperimentEnabled and ExpChatNewSystemMessagesExperimentation.isExperimentEnabled and not u182 then
				u182 = true
				ExpChatNewSystemMessagesExperimentation.logExposure()
			end

			displaySystemMessage(not ExpChatNewSystemMessagesExperimentation.getNewSystemMessagesEnabled() and "CoreScripts.TextChat.ChatWindow.ChatDisabled.AskForPermission" or "CoreScripts.TextChat.Description.AskYourParentForPermissionToChat", nil, "Roblox.ChatDisabled.Info", u164.translator, u164.defaultSystemTextChannel, not ExpChatNewSystemMessagesExperimentation.getNewSystemMessagesEnabled() and "You can only view system messages here. Ask your parent for permission to chat in Communication settings." or "Ask your parent for permission to chat in Privacy>Communication settings.")

			return
		end

		if p38 == "AgeCheckVpc" then
			if ExpChatNewSystemMessagesExperimentation.isExperimentEnabled and ExpChatNewSystemMessagesExperimentation.isExperimentEnabled and not u182 then
				u182 = true
				ExpChatNewSystemMessagesExperimentation.logExposure()
			end

			displaySystemMessage(not ExpChatNewSystemMessagesExperimentation.getNewSystemMessagesEnabled() and "CoreScripts.TextChat.ChatWindow.ChatDisabled.AskForPermissionToAgeCheck" or "CoreScripts.TextChat.Description.AskYourParentForPermissionToChat", nil, "Roblox.ChatDisabled.Info", u164.translator, u164.defaultSystemTextChannel, not ExpChatNewSystemMessagesExperimentation.getNewSystemMessagesEnabled() and "You can only view system messages here. Ask your parent for permission to age check in Communication settings." or "Ask your parent for permission to chat in Privacy>Communication settings.")

			return
		end

		if not canPlatformEnableChat() and p38 == "AgeVerificationRequired" or p38 == "IdVerificationRequired" then
			if ExpChatNewSystemMessagesExperimentation.isExperimentEnabled and ExpChatNewSystemMessagesExperimentation.isExperimentEnabled and not u182 then
				u182 = true
				ExpChatNewSystemMessagesExperimentation.logExposure()
			end

			displaySystemMessage(not ExpChatNewSystemMessagesExperimentation.getNewSystemMessagesEnabled() and "CoreScripts.TextChat.ChatWindow.ChatDisabled.CheckAgeInSettings" or "CoreScripts.TextChat.Description.UnlockChatPrivacyCommunications", nil, "Roblox.ChatDisabled.Info", u164.translator, u164.defaultSystemTextChannel, not ExpChatNewSystemMessagesExperimentation.getNewSystemMessagesEnabled() and "You can only view system messages here. To chat, get an age check in your Communication settings." or "Unlock chat with an age check in Privacy>Communication settings.")

			return
		end

		if p38 == "AgeVerificationRequired" then
			if ExpChatNewSystemMessagesExperimentation.isExperimentEnabled and ExpChatNewSystemMessagesExperimentation.isExperimentEnabled and not u182 then
				u182 = true
				ExpChatNewSystemMessagesExperimentation.logExposure()
			end

			displaySystemMessage(not ExpChatNewSystemMessagesExperimentation.getNewSystemMessagesEnabled() and "CoreScripts.TextChat.ChatWindow.ChatDisabled.GetAnAgeCheck" or "CoreScripts.TextChat.Description.UnlockChatWithAnAgeCheck", nil, "Roblox.ChatDisabled.Info", u164.translator, u164.defaultSystemTextChannel, not ExpChatNewSystemMessagesExperimentation.getNewSystemMessagesEnabled() and "You can only view system messages here. Get an age check to chat." or "Unlock chat with an age check.")

			return
		end

		if FFlagExpChatRefactorEnabledMessageLogic and p38 == "Enabled" then
			coroutine.wrap(function() -- line: 1844
				-- upvalues: FStringExpChatChatWithTFAmpFeatureName (copy), FStringExpChatChatWithTFAmpNameSpace (copy), v44 (copy), AmpApiProvider (copy), LocalPlayer (copy), AccessResponseEnum (copy), displaySystemMessage (copy), u164 (ref), canOnlyChatInRegion (copy), v211 (copy)
				if FStringExpChatChatWithTFAmpFeatureName == "" or FStringExpChatChatWithTFAmpNameSpace == "" then
					v44:error("AMP feature name or namespace are not set")

					return
				end

				local v375 = AmpApiProvider.getFeatureAccess({ FStringExpChatChatWithTFAmpFeatureName }, FStringExpChatChatWithTFAmpNameSpace)

				if LocalPlayer.ChatAvailabilityStatus ~= "Enabled" then
					return
				end

				local v376 = nil

				if v375.featureAccessList and #v375.featureAccessList > 0 and v375.featureAccessList[1] then
					v376 = v375.featureAccessList[1].access == AccessResponseEnum.Granted
				end

				if v376 ~= nil then
					if v376 then
						displaySystemMessage("CoreScripts.TextChat.ChatWindow.ChatEnabled.ChatWithTF", nil, "Roblox.ChatEnabled.Info", u164.translator, u164.defaultSystemTextChannel, "Only your trusted friends can chat with you.")

						return
					end

					if canOnlyChatInRegion() then
						displaySystemMessage("CoreScripts.TextChat.ChatWindow.ChatEnabled.ChatInRegion", nil, "Roblox.ChatEnabled.Info", u164.translator, u164.defaultSystemTextChannel, "You can view system messages and chat with users in your region only.")

						return
					end

					v211()

					return
				end

				v44:error("No feature access list found after AMP call")
			end)()

			return
		end

		if p38 == "EnabledBubble" or p38 == "Enabled" and canOnlyChatInRegion() then
			displaySystemMessage("CoreScripts.TextChat.ChatWindow.ChatEnabled.ChatInRegion", nil, "Roblox.ChatEnabled.Info", u164.translator, u164.defaultSystemTextChannel, "You can view system messages and chat with users in your region only.")

			return
		end

		if p38 == "Enabled" then
			v211()

			return
		end

		if p38 == "AllUsers" or p38 == "NoOne" then
			if getChatTranslationEnabled() then
				displaySystemMessage("CoreScripts.TextChat.ChatTranslation.ChatWindow.SystemMessageNew", nil, "Roblox.ChatTranslation.ChatWindow.SystemMessage", u164.translator, u164.defaultSystemTextChannel, "Roblox automatically translates supported languages in chat")

				return
			end
		elseif p38 == "Ineligible" or p38 ~= "Unknown" then
			displaySystemMessage("CoreScripts.TextChat.ChatWindow.ChatDisabled.OnlyViewSystemMessages", nil, "Roblox.ChatDisabled.Info", u164.translator, u164.defaultSystemTextChannel, "You can only view system messages here.")
		end
	end

	local n2 = 0
	local u214 = math.random(v107, v108)

	local function handleUserMessageIntentSent(p39) -- line: 1946
		-- upvalues: v44 (copy), FFlagExpChatUseMessagesStore (copy), v166 (copy), v165 (copy), HiddenMessageReceived (copy), isUserChatEnabled (copy), LocalPlayer (copy), n2 (ref), u214 (ref), v107 (copy), v108 (copy), displaySystemMessage (copy), u164 (ref), GetTransparencyStore (copy)
		v44:debug("Handling a message from UserMessageIntentSent")

		if FFlagExpChatUseMessagesStore then
			v166.handleHiddenMessageReceived(p39)
		else
			v165:dispatch(HiddenMessageReceived(p39))
		end

		if not isUserChatEnabled(LocalPlayer.ChatAvailabilityStatus) then
			n2 += 1

			if n2 == u214 then
				u214 += math.random(v107, v108)
				displaySystemMessage("CoreScripts.TextChat.ChatWindow.ChatDisabled.DontMissMessages", nil, "Roblox.ChatDisabled.Info", u164.translator, u164.defaultSystemTextChannel, "Don’t miss messages. Unlock chat with an age check.")
			end
		end

		GetTransparencyStore(false).resetTextTransparency()
	end
	local function shouldConnectToUserMessageIntentSent() -- line: 1977
		-- upvalues: FFlagExpChatEnableFOMOUpsell (copy), shouldShowFOMOUpsell (copy), FFlagExpChatEnableCrossAgeChatActivity (copy), shouldShowCrossAgeChatActivity (copy)
		local v323 = FFlagExpChatEnableFOMOUpsell and shouldShowFOMOUpsell()
		local v324 = FFlagExpChatEnableCrossAgeChatActivity and shouldShowCrossAgeChatActivity()

		return v323 or v324
	end

	if FFlagAEGIS2EnableGatesForExpChat and LocalPlayer then
		if FFlagEnableModerateChatRemoteEvent then
			local v217 = getExperienceChatVisualConfig()
			local v218 = GetChatModerationStore(false)
			local u219 = false

			u164.moderateChatStoreDisposeEffect = Signals.createEffect(function(p40) -- line: 1991
				-- upvalues: v218 (copy), u219 (ref), displaySystemMessage (copy), u164 (ref), NotificationModalsManager (copy), UIBlox (copy), v217 (copy), FFlagConnectionsToFriendsRename (copy)
				local v326 = v218.getIsSettingEnabled(p40)

				if v326 ~= u219 then
					if v326 then
						displaySystemMessage("CoreScripts.TextChat.MessageStatus.Warning.ModerateChatOn", nil, "Roblox.MessageStatus.Warning.ModerateChatOn", u164.translator, u164.defaultSystemTextChannel)
						NotificationModalsManager.SetUIBloxToast({
							iconImage = UIBlox.App.ImageSet.Images[v217.icon.off],
							toastSubtitle = u164.translator:FormatByKey("CoreScripts.TextChat.Toast.ModerateChatOn.Subtitle"),
							toastTitle = u164.translator:FormatByKey("CoreScripts.TextChat.Toast.ModerateChatOn.Title")
						})
					else
						displaySystemMessage("CoreScripts.TextChat.MessageStatus.Warning.ModerateChatOff", nil, "Roblox.MessageStatus.Warning.ModerateChatOff", u164.translator, u164.defaultSystemTextChannel)
						NotificationModalsManager.SetUIBloxToast({
							iconImage = UIBlox.App.ImageSet.Images[v217.icon.off],
							toastSubtitle = u164.translator:FormatByKey(not FFlagConnectionsToFriendsRename and "CoreScripts.TextChat.Toast.ModerateChatOff.Subtitle" or "CoreScripts.TextChat.Toast.ModerateChatOff.Subtitle.FriendsRename"),
							toastTitle = u164.translator:FormatByKey("CoreScripts.TextChat.Toast.ModerateChatOff.Title")
						})
					end

					u219 = v326
				end
			end)
		end

		local ChatAvailabilityStatus = LocalPlayer.ChatAvailabilityStatus

		v44:debug("Local player's initial ChatAvailabilityStatus is {}", ChatAvailabilityStatus)
		updateChatStatus(ChatAvailabilityStatus)

		local connection = nil
		local v222 = FFlagExpChatEnableFOMOUpsell and shouldShowFOMOUpsell()
		local v223 = FFlagExpChatEnableCrossAgeChatActivity and shouldShowCrossAgeChatActivity()

		if v222 or v223 then
			v44:debug("Connecting to UserMessageIntentSent")
			connection = TextChatService.UserMessageIntentSent:Connect(handleUserMessageIntentSent)
		end

		LocalPlayer:GetPropertyChangedSignal("ChatAvailabilityStatus"):Connect(function() -- line: 2054
			-- upvalues: ChatAvailabilityStatus (ref), LocalPlayer (copy), v44 (copy), updateChatStatus (copy), FFlagExpChatPresetChatEnabled (copy), FFlagExpChatPresetChatLoadTestEnabled (copy), isUserChatEnabled (copy), initializePresetChat (copy), GetPresetChatStore (copy), FFlagExpChatEnableFOMOUpsell (copy), shouldShowFOMOUpsell (copy), FFlagExpChatEnableCrossAgeChatActivity (copy), shouldShowCrossAgeChatActivity (copy), connection (ref), TextChatService (copy), handleUserMessageIntentSent (copy), FFlagExpChatClearHiddenMessagesPostAgeCheck (copy), FFlagExpChatUseMessagesStore (copy), v166 (copy), v165 (copy), HiddenMessagesCleared (copy), GetTransparencyStore (copy), ChatPrivacySettingsReceived (copy)
			ChatAvailabilityStatus = LocalPlayer.ChatAvailabilityStatus
			v44:debug("Local player's ChatAvailabilityStatus has changed to {}", ChatAvailabilityStatus)
			updateChatStatus(ChatAvailabilityStatus)

			if (FFlagExpChatPresetChatEnabled or FFlagExpChatPresetChatLoadTestEnabled) and isUserChatEnabled(ChatAvailabilityStatus) then
				initializePresetChat(GetPresetChatStore(false), not FFlagExpChatPresetChatEnabled and FFlagExpChatPresetChatLoadTestEnabled)
			end

			local v327 = FFlagExpChatEnableFOMOUpsell and shouldShowFOMOUpsell()
			local v328 = FFlagExpChatEnableCrossAgeChatActivity and shouldShowCrossAgeChatActivity()

			if (v327 or v328) and not connection then
				v44:debug("Connecting to UserMessageIntentSent")
				connection = TextChatService.UserMessageIntentSent:Connect(handleUserMessageIntentSent)
			end

			if FFlagExpChatEnableFOMOUpsell and isUserChatEnabled(ChatAvailabilityStatus) and connection and (not FFlagExpChatEnableCrossAgeChatActivity or not shouldShowCrossAgeChatActivity()) then
				v44:debug("Disconnecting from UserMessageIntentSent")
				connection:Disconnect()

				if FFlagExpChatClearHiddenMessagesPostAgeCheck then
					if FFlagExpChatUseMessagesStore then
						v166.handleHiddenMessagesCleared()
					else
						v165:dispatch(HiddenMessagesCleared())
					end

					GetTransparencyStore(false).resetTextTransparency()
				end
			end

			if FFlagExpChatUseMessagesStore then
				v166.setCanLocalUserChat(isUserChatEnabled(ChatAvailabilityStatus))

				return
			end

			v165:dispatch(ChatPrivacySettingsReceived(isUserChatEnabled(ChatAvailabilityStatus)))
		end)
	elseif isChatRegionLocked() then
		displaySystemMessage("CoreScripts.TextChat.ChatWindow.ChatDisabled.RegionUnavailable", nil, "Roblox.ChatDisabled.Info", u164.translator, u164.defaultSystemTextChannel, not FFlagAEGIS2EnableGatesForExpChat and "Chat is unavailable in your region. You can still receive system messages." or "You can only view system messages here. Chat is currently unavailable in your region.")
	elseif not FFlagAEGIS2EnableGatesForExpChat and getChatTranslationEnabled() then
		displaySystemMessage("CoreScripts.TextChat.ChatTranslation.ChatWindow.SystemMessageNew", nil, "Roblox.ChatTranslation.ChatWindow.SystemMessage", u164.translator, u164.defaultSystemTextChannel, "Roblox automatically translates supported languages in chat")
	end

	if FFlagExpChatPresetChatEnabled or FFlagExpChatPresetChatLoadTestEnabled then
		initializePresetChat(GetPresetChatStore(false), not FFlagExpChatPresetChatEnabled and FFlagExpChatPresetChatLoadTestEnabled)
	end

	return {
		roactInstance = v210
	}
end
