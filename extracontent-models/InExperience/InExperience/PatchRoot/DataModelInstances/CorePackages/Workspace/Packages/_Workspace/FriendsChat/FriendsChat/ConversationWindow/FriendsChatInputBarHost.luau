local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalizationService = game:GetService("LocalizationService")
local FriendsChat = script:FindFirstAncestor("FriendsChat")
local FriendsChatParent = FriendsChat.Parent
local React = require(FriendsChatParent.React)
local SignalsExperimental = require(FriendsChatParent.SignalsExperimental)
local ExpChatShared = require(FriendsChatParent.ExpChatShared)
local Localization = require(FriendsChatParent.InExperienceLocales).Localization
local ChatUIPrimitives = require(FriendsChatParent.ChatUIPrimitives)
local AppChatNetworking = require(FriendsChatParent.AppChatNetworking)
local createConversationFromFriendPlaceholder = require(FriendsChatParent.AppChat.createConversationFromFriendPlaceholder)
local GetConversationMessageStore = require(FriendsChatParent.AppChat.GetConversationMessageStore)
local GetConversationMessageListStore = require(FriendsChatParent.AppChat.GetConversationMessageListStore)
local ingestNewerMessages = require(FriendsChatParent.AppChat.ingestNewerMessages)
local ChatConversationTelemetryLayer = require(FriendsChatParent.AppChat.ChatConversationTelemetryLayer)
local ChatConversationTelemetryEvents = require(FriendsChatParent.AppChat.ChatConversationTelemetryEvents)
local SendMessageError = require(FriendsChatParent.AppChat.SendMessageError)
local useTelemetry = require(FriendsChatParent.AppChat.useTelemetry)
local ExpChatConversationListAdapter = require(script.Parent.Parent.ConversationList.ExpChatConversationListAdapter)
local LayoutConstants = require(FriendsChat.LayoutConstants)
local getConversationMessageSentInfo = require(script.Parent.Parent.Telemetry.ChatConversation.getConversationMessageSentInfo)
local serializeParticipantIdsForTelemetry = require(script.Parent.Parent.Telemetry.App.serializeParticipantIdsForTelemetry)
local ChatInputBarView = ChatUIPrimitives.ChatInputBarView
local useChatInputBarSettings = require(FriendsChatParent.ExpChatIntegration.useChatInputBarSettings)
local useChatInputBarOnFocus = require(FriendsChatParent.ExpChatIntegration.useChatInputBarOnFocus)
local useChatWindowSettings = require(FriendsChatParent.ExpChatIntegration.useChatWindowSettings)
local useInterpolatedClientSettings = require(FriendsChatParent.ExpChatIntegration.useInterpolatedClientSettings)
local v29 = ExpChatShared.Logger:new(script.Name)

local function resolveFade(n1: number, p1) -- line: 72
	if type(p1) == "number" then
		return n1 + p1 * (1 - n1)
	end

	if p1 ~= nil then
		return p1:map(function(n2: number) -- line: 76
			-- upvalues: n1 (copy)
			return n1 + n2 * (1 - n1)
		end)
	end

	return n1
end
local function isSendResponseAccepted(p2) -- line: 83
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
local function FriendsChatInputBarHost(t1: {[any]: any}) -- line: 103
	-- upvalues: ExpChatConversationListAdapter (copy), useChatWindowSettings (copy), React (copy), useChatInputBarSettings (copy), Localization (copy), LocalizationService (copy), useTelemetry (copy), ChatConversationTelemetryLayer (copy), useInterpolatedClientSettings (copy), useChatInputBarOnFocus (copy), Players (copy), v29 (copy), createConversationFromFriendPlaceholder (copy), GetConversationMessageStore (copy), GetConversationMessageListStore (copy), HttpService (copy), serializeParticipantIdsForTelemetry (copy), AppChatNetworking (copy), ChatConversationTelemetryEvents (copy), getConversationMessageSentInfo (copy), isSendResponseAccepted (copy), SignalsExperimental (copy), ingestNewerMessages (copy), SendMessageError (copy), LayoutConstants (copy), ChatInputBarView (copy)
	local conversationId = t1.conversationId
	local v40 = ExpChatConversationListAdapter.isFriendsConversation(conversationId)
	local v41 = conversationId ~= nil and (conversationId ~= "" and not v40)
	local v42 = useChatWindowSettings()
	local v43 = React.useMemo(function() -- line: 112
		-- upvalues: v42 (copy)
		return {
			BackgroundColor3 = v42.ChatWindowBackgroundColor3,
			BackgroundTransparency = v42.ChatWindowBackgroundTransparency
		}
	end, { v42 })
	local v44 = useChatInputBarSettings()
	local v45 = React.useMemo(function() -- line: 126
		-- upvalues: t1 (copy), v44 (copy)
		if t1.isSpatialUIEnabled and (v44 and v44.SpatialPanelTextSize) then
			return v44.SpatialPanelTextSize
		end

		if v44 then
			return v44.TextSize
		end

		return nil
	end, {
		v44,
		t1.isSpatialUIEnabled
	})
	local v46 = React.useMemo(function() -- line: 136
		-- upvalues: Localization (copy), LocalizationService (copy)
		local v59 = Localization.new(LocalizationService.RobloxLocaleId)

		return {
			placeholder = v59:Format("CoreScripts.TextChat.InputBar.Hint.Touch"),
			disabled = v59:Format("CoreScripts.TextChat.InputBar.Hint.PrivacySettingsDisabled")
		}
	end, {})
	local v47 = useTelemetry(ChatConversationTelemetryLayer.Context)
	local v48 = React.useRef(v47.emit)

	v48.current = v47.emit

	local v49 = useInterpolatedClientSettings(t1.chatWindowSettings or v43)
	local v50 = useChatInputBarOnFocus()
	local onFocusGained = v50.onFocusGained
	local onFocusLost = v50.onFocusLost

	React.useEffect(function() -- line: 162
		-- upvalues: onFocusLost (copy)
		return function() -- line: 163
			-- upvalues: onFocusLost (copy)
			onFocusLost()
		end
	end, { onFocusLost })

	local v53 = React.useCallback(function(s1: string) -- line: 169
		-- upvalues: conversationId (copy), Players (copy), v40 (copy), ExpChatConversationListAdapter (copy), v29 (copy), createConversationFromFriendPlaceholder (copy), t1 (copy), v41 (copy), GetConversationMessageStore (copy), GetConversationMessageListStore (copy), HttpService (copy), serializeParticipantIdsForTelemetry (copy), AppChatNetworking (copy), v48 (copy), ChatConversationTelemetryEvents (copy), getConversationMessageSentInfo (copy), isSendResponseAccepted (copy), SignalsExperimental (copy), ingestNewerMessages (copy), SendMessageError (copy)
		task.spawn(function() -- line: 173
			-- upvalues: s1 (copy), conversationId (copy), Players (copy), v40 (copy), ExpChatConversationListAdapter (copy), v29 (copy), createConversationFromFriendPlaceholder (copy), t1 (copy), v41 (copy), GetConversationMessageStore (copy), GetConversationMessageListStore (copy), HttpService (copy), serializeParticipantIdsForTelemetry (copy), AppChatNetworking (copy), v48 (copy), ChatConversationTelemetryEvents (copy), getConversationMessageSentInfo (copy), isSendResponseAccepted (copy), SignalsExperimental (copy), ingestNewerMessages (copy), SendMessageError (copy)
			local v62 = typeof(s1) ~= "string" and "" or s1

			if v62 == "" then
				return
			end

			local u63 = conversationId or ""
			local LocalPlayer = Players.LocalPlayer

			if v40 and conversationId ~= nil then
				local v65 = ExpChatConversationListAdapter.getConversationStore().getConversation(conversationId, false)

				if v65 == nil then
					v29:warning(`Unable to find friend placeholder { conversationId }`)

					return
				end

				local v66 = createConversationFromFriendPlaceholder(v65, not LocalPlayer and 0 or LocalPlayer.UserId)

				if v66 == nil then
					v29:warning(`Unable to create conversation for friend placeholder { conversationId }`)

					return
				end

				local v67, v68 = v66:await()

				if not v67 or v68 == nil then
					v29:warning(`Failed to create conversation for friend placeholder { conversationId }`)

					return
				end

				u63 = v68.id

				if t1.onFriendPlaceholderConversationCreated ~= nil then
					t1.onFriendPlaceholderConversationCreated(u63)
				end
			elseif not v41 then
				return
			end

			local v69 = GetConversationMessageStore(false)
			local v70 = GetConversationMessageListStore(false)
			local v71 = "sending-friends-message-" .. HttpService:GenerateGUID(false)
			local t2 = {
				type = "user",
				status = "Pending",
				id = v71,
				content = v62,
				created_at = tostring(os.time()),
				sender_user_id = if not LocalPlayer then nil else LocalPlayer.UserId,
				conversationId = u63
			}

			v69.upsertMessages({
				[v71] = t2
			})
			v70.prependMessages(u63, { v71 })

			local v73 = string.rep("#", utf8.len(v62) or #v62)
			local v74 = ExpChatConversationListAdapter.getConversationStore().getConversation(u63, false)
			local v75 = serializeParticipantIdsForTelemetry(if not v74 then nil else v74.participants, not LocalPlayer and 0 or LocalPlayer.UserId)

			AppChatNetworking.http.SendChatTextMessage(nil, u63, v62):andThen(function(p3) -- line: 242
				-- upvalues: v48 (copy), ChatConversationTelemetryEvents (copy), getConversationMessageSentInfo (copy), v75 (copy), isSendResponseAccepted (copy), v69 (copy), v71 (copy), v73 (copy), SignalsExperimental (copy), ingestNewerMessages (copy), u63 (ref), ExpChatConversationListAdapter (copy), LocalPlayer (copy), v70 (copy)
				v48.current(ChatConversationTelemetryEvents.ConversationMessageSent, getConversationMessageSentInfo(p3, v75))

				if not isSendResponseAccepted(p3) then
					v69.updateMessage(v71, {
						status = "Failed",
						content = v73
					})

					return
				end

				local v77 = p3.responseBody.messages or {}

				SignalsExperimental.batch(function() -- line: 259
					-- upvalues: ingestNewerMessages (copy), u63 (ref), v77 (copy), v69 (copy), v71 (copy), v73 (copy), ExpChatConversationListAdapter (copy), LocalPlayer (copy), v70 (copy)
					if #ingestNewerMessages(u63, v77) == 0 then
						v69.updateMessage(v71, {
							status = "Failed",
							content = v73
						})

						return
					end

					ExpChatConversationListAdapter.updateConversationPreviewFromMessages(u63, v77, {
						hasUnreadMessages = false,
						localUserId = not LocalPlayer and 0 or LocalPlayer.UserId
					})
					v70.removeMessage(u63, v71)
					v69.removeMessage(v71)
				end)
			end):catch(function(p4) -- line: 284
				-- upvalues: v29 (copy), u63 (ref), v48 (copy), ChatConversationTelemetryEvents (copy), SendMessageError (copy), v75 (copy), v69 (copy), v71 (copy), v73 (copy)
				v29:warning(`Failed to send message to { u63 }: { tostring(p4) }`)
				v48.current(ChatConversationTelemetryEvents.ConversationMessageSent, {
					messageSentResult = SendMessageError.OtherFailure,
					recipientIds = v75
				})
				v69.updateMessage(v71, {
					status = "Failed",
					content = v73
				})
			end)
		end)
	end, {
		conversationId,
		v41,
		v40,
		t1.onFriendPlaceholderConversationCreated
	})
	local createElement = React.createElement
	local t3 = {
		Name = "friendsChatInput",
		LayoutOrder = t1.LayoutOrder,
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = v49.BackgroundColor3 or v42.ChatWindowBackgroundColor3
	}
	local BackgroundTransparency = v49.BackgroundTransparency
	local transparencyValue = t1.transparencyValue

	t3.BackgroundTransparency = if type(transparencyValue) ~= "number" then if transparencyValue == nil then BackgroundTransparency else transparencyValue:map(function(n3: number) -- line: 76
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
			canLocalUserChat = true,
			showSideChip = false,
			retainFocusOnSend = true,
			onSend = v53,
			textSize = v45,
			placeholderText = v46.placeholder,
			disabledChatPlaceholderText = v46.disabled,
			transparencyValue = t1.transparencyValue,
			onFocusGained = onFocusGained,
			onFocusLost = onFocusLost
		})
	})
end

return FriendsChatInputBarHost
