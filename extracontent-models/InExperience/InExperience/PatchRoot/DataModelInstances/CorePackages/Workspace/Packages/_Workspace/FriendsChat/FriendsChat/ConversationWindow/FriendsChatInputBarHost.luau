local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalizationService = game:GetService("LocalizationService")
local FriendsChat = script:FindFirstAncestor("FriendsChat")
local FriendsChatParent = FriendsChat.Parent
local Foundation = require(FriendsChatParent.Foundation)
local React = require(FriendsChatParent.React)
local SignalsExperimental = require(FriendsChatParent.SignalsExperimental)
local SignalsReact = require(FriendsChatParent.SignalsReact)
local ExpChatShared = require(FriendsChatParent.ExpChatShared)
local Localization = require(FriendsChatParent.InExperienceLocales).Localization
local useLocalization = require(FriendsChatParent.Localization).Hooks.useLocalization
local ChatUIPrimitives = require(FriendsChatParent.ChatUIPrimitives)
local AppChatNetworking = require(FriendsChatParent.AppChatNetworking)
local ChatInputBoxDisabled = require(FriendsChatParent.AppChat.ChatInputBoxDisabled)

require(FriendsChatParent.AppChat.ConversationChannels)

local createConversationFromFriendPlaceholder = require(FriendsChatParent.AppChat.createConversationFromFriendPlaceholder)
local GetConversationMessageStore = require(FriendsChatParent.AppChat.GetConversationMessageStore)
local GetConversationMessageListStore = require(FriendsChatParent.AppChat.GetConversationMessageListStore)
local ingestNewerMessages = require(FriendsChatParent.AppChat.ingestNewerMessages)
local ChatConversationTelemetryLayer = require(FriendsChatParent.AppChat.ChatConversationTelemetryLayer)
local ChatConversationTelemetryEvents = require(FriendsChatParent.AppChat.ChatConversationTelemetryEvents)
local SendMessageError = require(FriendsChatParent.AppChat.SendMessageError)
local useChatTimeoutDetailsFromHydration = require(FriendsChatParent.AppChat.useChatTimeoutDetailsFromHydration)
local useTelemetry = require(FriendsChatParent.AppChat.useTelemetry)
local InterventionShared = require(FriendsChatParent.InterventionShared)
local chatInputBoxDisabledPressedSignal = InterventionShared.Signals.chatInputBoxDisabledPressedSignal
local interventionTreatmentShownSignal = InterventionShared.Signals.interventionTreatmentShownSignal
local Constants = InterventionShared.Utils.Constants
local ExpChatConversationListAdapter = require(script.Parent.Parent.ConversationList.ExpChatConversationListAdapter)
local LayoutConstants = require(FriendsChat.LayoutConstants)
local getConversationMessageSentInfo = require(script.Parent.Parent.Telemetry.ChatConversation.getConversationMessageSentInfo)
local serializeParticipantIdsForTelemetry = require(script.Parent.Parent.Telemetry.App.serializeParticipantIdsForTelemetry)
local ChatInputBarView = ChatUIPrimitives.ChatInputBarView
local useChatInputBarSettings = require(FriendsChatParent.ExpChatIntegration.useChatInputBarSettings)
local useChatInputBarOnFocus = require(FriendsChatParent.ExpChatIntegration.useChatInputBarOnFocus)
local useChatWindowSettings = require(FriendsChatParent.ExpChatIntegration.useChatWindowSettings)
local useInterpolatedClientSettings = require(FriendsChatParent.ExpChatIntegration.useInterpolatedClientSettings)
local v38 = ExpChatShared.Logger:new(script.Name)

local function resolveFade(n1: number, p1) -- line: 84
	if type(p1) == "number" then
		return n1 + p1 * (1 - n1)
	end

	if p1 ~= nil then
		return p1:map(function(n2: number) -- line: 88
			-- upvalues: n1 (copy)
			return n1 + n2 * (1 - n1)
		end)
	end

	return n1
end
local function isSendResponseAccepted(p2) -- line: 95
	if p2 == nil or p2.responseBody == nil then
		return false
	end

	if p2.responseCode ~= nil and p2.responseCode ~= 200 then
		return false
	end

	if p2.StatusCode ~= nil and p2.StatusCode ~= 200 then
		return false
	end

	local messages = p2.responseBody.messages

	if messages == nil or #messages == 0 then
		return false
	end

	local status = messages[1].status

	return status == nil or (status == "" or status == "success")
end
local function FriendsChatInputBarHost(t1: {[any]: any}) -- line: 115
	-- upvalues: Foundation (copy), ExpChatConversationListAdapter (copy), useChatTimeoutDetailsFromHydration (copy), SignalsReact (copy), useChatWindowSettings (copy), React (copy), useChatInputBarSettings (copy), Localization (copy), LocalizationService (copy), useLocalization (copy), useTelemetry (copy), ChatConversationTelemetryLayer (copy), useInterpolatedClientSettings (copy), useChatInputBarOnFocus (copy), interventionTreatmentShownSignal (copy), Constants (copy), Players (copy), v38 (copy), createConversationFromFriendPlaceholder (copy), GetConversationMessageStore (copy), GetConversationMessageListStore (copy), HttpService (copy), serializeParticipantIdsForTelemetry (copy), AppChatNetworking (copy), ChatConversationTelemetryEvents (copy), getConversationMessageSentInfo (copy), isSendResponseAccepted (copy), SignalsExperimental (copy), ingestNewerMessages (copy), SendMessageError (copy), chatInputBoxDisabledPressedSignal (copy), ChatInputBoxDisabled (copy), LayoutConstants (copy), ChatInputBarView (copy)
	local v48 = Foundation.Hooks.useTokens()
	local conversationId = t1.conversationId
	local v50 = ExpChatConversationListAdapter.isFriendPlaceholder(conversationId)
	local v51 = conversationId ~= nil and (conversationId ~= "" and not v50)
	local v52 = useChatTimeoutDetailsFromHydration({
		conversationId = if not v51 then nil else conversationId,
		conversationModerationType = t1.conversationModerationType
	})
	local v53 = SignalsReact.useSignalState(v52)
	local isTimedOut = v53.isTimedOut
	local v55 = useChatWindowSettings()
	local v56 = React.useMemo(function() -- line: 131
		-- upvalues: v55 (copy)
		return {
			BackgroundColor3 = v55.ChatWindowBackgroundColor3,
			BackgroundTransparency = v55.ChatWindowBackgroundTransparency
		}
	end, { v55 })
	local v57 = useChatInputBarSettings()
	local v58 = React.useMemo(function() -- line: 142
		-- upvalues: t1 (copy), v57 (copy)
		if t1.isSpatialUIEnabled and (v57 and v57.SpatialPanelTextSize) then
			return v57.SpatialPanelTextSize
		end

		if v57 then
			return v57.TextSize
		end

		return nil
	end, {
		v57,
		t1.isSpatialUIEnabled
	})
	local v59 = React.useMemo(function() -- line: 152
		-- upvalues: Localization (copy), LocalizationService (copy)
		local v78 = Localization.new(LocalizationService.RobloxLocaleId)

		return {
			placeholder = v78:Format("CoreScripts.TextChat.InputBar.Hint.Touch"),
			disabled = v78:Format("CoreScripts.TextChat.InputBar.Hint.PrivacySettingsDisabled")
		}
	end, {})
	local v60 = useLocalization({
		timeoutDisabled = "Feature.Chat.Label.ChatDisabled"
	})
	local v61 = useTelemetry(ChatConversationTelemetryLayer.Context)
	local v62 = React.useRef(v61.emit)

	v62.current = v61.emit

	local v63 = useInterpolatedClientSettings(t1.chatWindowSettings or v56)
	local v64 = useChatInputBarOnFocus()
	local onFocusGained = v64.onFocusGained
	local onFocusLost = v64.onFocusLost
	local v67 = React.useRef(nil)

	React.useEffect(function() -- line: 182
		-- upvalues: onFocusLost (copy)
		return function() -- line: 183
			-- upvalues: onFocusLost (copy)
			onFocusLost()
		end
	end, { onFocusLost })
	React.useEffect(function() -- line: 188
		-- upvalues: interventionTreatmentShownSignal (copy), Constants (copy), v67 (copy)
		local v79 = interventionTreatmentShownSignal:connect(function(p3) -- line: 189
			-- upvalues: Constants (copy), v67 (copy)
			if p3 == Constants.TreatmentType.PartyChatNudgeDialog or p3 == Constants.TreatmentType.PartyChatTimeoutDialog then
				local current = v67.current

				if current then
					current:ReleaseFocus()
				end
			end
		end)

		return function() -- line: 200
			-- upvalues: v79 (copy)
			v79:disconnect()
		end
	end, {})

	local v68 = React.useCallback(function(s1: string) -- line: 206
		-- upvalues: isTimedOut (copy), conversationId (copy), Players (copy), v50 (copy), ExpChatConversationListAdapter (copy), v38 (copy), createConversationFromFriendPlaceholder (copy), t1 (copy), v51 (copy), GetConversationMessageStore (copy), GetConversationMessageListStore (copy), HttpService (copy), serializeParticipantIdsForTelemetry (copy), AppChatNetworking (copy), v62 (copy), ChatConversationTelemetryEvents (copy), getConversationMessageSentInfo (copy), isSendResponseAccepted (copy), SignalsExperimental (copy), ingestNewerMessages (copy), SendMessageError (copy)
		if isTimedOut then
			return
		end

		task.spawn(function() -- line: 213
			-- upvalues: s1 (copy), conversationId (copy), Players (copy), v50 (copy), ExpChatConversationListAdapter (copy), v38 (copy), createConversationFromFriendPlaceholder (copy), t1 (copy), v51 (copy), GetConversationMessageStore (copy), GetConversationMessageListStore (copy), HttpService (copy), serializeParticipantIdsForTelemetry (copy), AppChatNetworking (copy), v62 (copy), ChatConversationTelemetryEvents (copy), getConversationMessageSentInfo (copy), isSendResponseAccepted (copy), SignalsExperimental (copy), ingestNewerMessages (copy), SendMessageError (copy)
			local v84 = typeof(s1) ~= "string" and "" or s1

			if v84 == "" then
				return
			end

			local u85 = conversationId or ""
			local LocalPlayer = Players.LocalPlayer

			if v50 and conversationId ~= nil then
				local v87 = ExpChatConversationListAdapter.getConversationStore().getConversation(conversationId, false)

				if v87 == nil then
					v38:warning(`Unable to find friend placeholder { conversationId }`)

					return
				end

				local v88 = createConversationFromFriendPlaceholder(v87, not LocalPlayer and 0 or LocalPlayer.UserId)

				if v88 == nil then
					v38:warning(`Unable to create conversation for friend placeholder { conversationId }`)

					return
				end

				local v89, v90 = v88:await()

				if not v89 or v90 == nil then
					v38:warning(`Failed to create conversation for friend placeholder { conversationId }`)

					return
				end

				u85 = v90.id

				if t1.onFriendPlaceholderConversationCreated ~= nil then
					t1.onFriendPlaceholderConversationCreated(u85)
				end
			elseif not v51 then
				return
			end

			local v91 = GetConversationMessageStore(false)
			local v92 = GetConversationMessageListStore(false)
			local v93 = "sending-friends-message-" .. HttpService:GenerateGUID(false)
			local t2 = {
				type = "user",
				status = "Pending",
				id = v93,
				content = v84,
				created_at = tostring(os.time()),
				sender_user_id = if not LocalPlayer then nil else LocalPlayer.UserId,
				conversationId = u85
			}

			v91.upsertMessages({
				[v93] = t2
			})
			v92.prependMessages(u85, { v93 })

			local v95 = string.rep("#", utf8.len(v84) or #v84)
			local v96 = ExpChatConversationListAdapter.getConversationStore().getConversation(u85, false)
			local v97 = serializeParticipantIdsForTelemetry(if not v96 then nil else v96.participants, not LocalPlayer and 0 or LocalPlayer.UserId)

			AppChatNetworking.http.SendChatTextMessage(nil, u85, v84):andThen(function(p4) -- line: 282
				-- upvalues: v62 (copy), ChatConversationTelemetryEvents (copy), getConversationMessageSentInfo (copy), v97 (copy), isSendResponseAccepted (copy), v91 (copy), v93 (copy), v95 (copy), SignalsExperimental (copy), ingestNewerMessages (copy), u85 (ref), ExpChatConversationListAdapter (copy), LocalPlayer (copy), v92 (copy)
				v62.current(ChatConversationTelemetryEvents.ConversationMessageSent, getConversationMessageSentInfo(p4, v97))

				if not isSendResponseAccepted(p4) then
					v91.updateMessage(v93, {
						status = "Failed",
						content = v95
					})

					return
				end

				local v99 = p4.responseBody.messages or {}

				SignalsExperimental.batch(function() -- line: 299
					-- upvalues: ingestNewerMessages (copy), u85 (ref), v99 (copy), v91 (copy), v93 (copy), v95 (copy), ExpChatConversationListAdapter (copy), LocalPlayer (copy), v92 (copy)
					if #ingestNewerMessages(u85, v99) == 0 then
						v91.updateMessage(v93, {
							status = "Failed",
							content = v95
						})

						return
					end

					ExpChatConversationListAdapter.updateConversationPreviewFromMessages(u85, v99, {
						hasUnreadMessages = false,
						localUserId = not LocalPlayer and 0 or LocalPlayer.UserId
					})
					v92.removeMessage(u85, v93)
					v91.removeMessage(v93)
				end)
			end):catch(function(p5) -- line: 324
				-- upvalues: v38 (copy), u85 (ref), v62 (copy), ChatConversationTelemetryEvents (copy), SendMessageError (copy), v97 (copy), v91 (copy), v93 (copy), v95 (copy)
				v38:warning(`Failed to send message to { u85 }: { tostring(p5) }`)
				v62.current(ChatConversationTelemetryEvents.ConversationMessageSent, {
					messageSentResult = SendMessageError.OtherFailure,
					recipientIds = v97
				})
				v91.updateMessage(v93, {
					status = "Failed",
					content = v95
				})
			end)
		end)
	end, {
		conversationId,
		v51,
		v50,
		isTimedOut,
		t1.onFriendPlaceholderConversationCreated
	})
	local v69 = React.useCallback(function() -- line: 349
		-- upvalues: chatInputBoxDisabledPressedSignal (copy), v53 (copy)
		chatInputBoxDisabledPressedSignal:fire({
			endTimestamp = v53.timeoutEndTimestamp,
			decisionEventId = v53.decisionEventId,
			duration = v53.duration
		})
	end, {
		v53.timeoutEndTimestamp,
		v53.decisionEventId,
		v53.duration
	})
	local v70 = v58 or v48.Typography.CaptionMedium.FontSize
	local v71 = math.max(v48.Typography.CaptionMedium.LineHeight, v70)
	local v72 = if not isTimedOut then nil else React.createElement(Foundation.View, {
		tag = "auto-y",
		Size = UDim2.fromScale(1, 0),
		padding = {
			top = UDim.new(0, v70 / 2),
			bottom = UDim.new(0, v70 / 2),
			left = UDim.new(0, v48.Padding.Large),
			right = UDim.new(0, v48.Padding.XSmall)
		}
	}, {
		TimeoutContent = React.createElement("CanvasGroup", {
			BackgroundTransparency = 1,
			ZIndex = 5,
			GroupTransparency = t1.transparencyValue or 0,
			Size = UDim2.new(1, 0, 0, v71)
		}, {
			DisabledInput = React.createElement(ChatInputBoxDisabled, {
				bodyText = v60.timeoutDisabled,
				contentSize = v70,
				endTimestamp = v53.timeoutEndTimestamp,
				font = Enum.Font.BuilderSans,
				onActivated = v69,
				contentVerticalAlignment = Enum.VerticalAlignment.Center
			})
		})
	})
	local createElement = React.createElement
	local t3 = {
		Name = "friendsChatInput",
		LayoutOrder = t1.LayoutOrder,
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = v63.BackgroundColor3 or v55.ChatWindowBackgroundColor3
	}
	local BackgroundTransparency = v63.BackgroundTransparency
	local transparencyValue = t1.transparencyValue

	t3.BackgroundTransparency = if type(transparencyValue) ~= "number" then if transparencyValue == nil then BackgroundTransparency else transparencyValue:map(function(n3: number) -- line: 88
		-- upvalues: BackgroundTransparency (copy)
		return BackgroundTransparency + n3 * (1 - BackgroundTransparency)
	end) else BackgroundTransparency + transparencyValue * (1 - BackgroundTransparency)
	t3.Active = true
	t3.BorderSizePixel = 0
	t3.ClipsDescendants = true
	t3.Size = UDim2.fromScale(1, 0)
	t3[React.Event.MouseEnter] = t1.onHovered
	t3[React.Event.MouseLeave] = t1.onUnhovered

	return createElement("Frame", t3, {
		bottomCorner = React.createElement("UICorner", {
			BottomLeftRadius = UDim.new(0, LayoutConstants.PanelBottomCornerRadius),
			BottomRightRadius = UDim.new(0, LayoutConstants.PanelBottomCornerRadius),
			TopLeftRadius = UDim.new(0, 0),
			TopRightRadius = UDim.new(0, 0)
		}),
		padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, LayoutConstants.InputBarTopPadding),
			PaddingBottom = UDim.new(0, LayoutConstants.InputBarBottomPadding + LayoutConstants.PanelBottomCornerRadius),
			PaddingLeft = UDim.new(0, LayoutConstants.InputBarSidePadding),
			PaddingRight = UDim.new(0, LayoutConstants.InputBarSidePadding)
		}),
		inputBar = React.createElement(ChatInputBarView, {
			showSideChip = false,
			retainFocusOnSend = true,
			onSend = v68,
			canLocalUserChat = not isTimedOut or false,
			disabledOverlay = v72,
			textSize = v58,
			textBoxRef = v67,
			placeholderText = v59.placeholder,
			disabledChatPlaceholderText = v59.disabled,
			transparencyValue = t1.transparencyValue,
			onFocusGained = onFocusGained,
			onFocusLost = onFocusLost
		})
	})
end

return FriendsChatInputBarHost
