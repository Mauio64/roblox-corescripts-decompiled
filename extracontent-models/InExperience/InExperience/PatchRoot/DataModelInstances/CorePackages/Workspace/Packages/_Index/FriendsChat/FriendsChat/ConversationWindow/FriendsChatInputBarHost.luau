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
local ExpChatConversationListAdapter = require(script.Parent.Parent.ConversationList.ExpChatConversationListAdapter)
local LayoutConstants = require(FriendsChat.LayoutConstants)
local ChatInputBarView = ChatUIPrimitives.ChatInputBarView
local useChatInputBarSettings = require(FriendsChatParent.ExpChatIntegration.useChatInputBarSettings)
local useChatInputBarOnFocus = require(FriendsChatParent.ExpChatIntegration.useChatInputBarOnFocus)
local useChatWindowSettings = require(FriendsChatParent.ExpChatIntegration.useChatWindowSettings)
local useInterpolatedClientSettings = require(FriendsChatParent.ExpChatIntegration.useInterpolatedClientSettings)
local v23 = ExpChatShared.Logger:new(script.Name)

local function resolveFade(n1: number, p1) -- line: 64
	if type(p1) == "number" then
		return n1 + p1 * (1 - n1)
	end

	if p1 ~= nil then
		return p1:map(function(n2: number) -- line: 68
			-- upvalues: n1 (copy)
			return n1 + n2 * (1 - n1)
		end)
	end

	return n1
end
local function isSendResponseAccepted(p2) -- line: 75
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
local function FriendsChatInputBarHost(t1: {[any]: any}) -- line: 95
	-- upvalues: ExpChatConversationListAdapter (copy), useChatWindowSettings (copy), React (copy), useChatInputBarSettings (copy), Localization (copy), LocalizationService (copy), useInterpolatedClientSettings (copy), useChatInputBarOnFocus (copy), Players (copy), v23 (copy), createConversationFromFriendPlaceholder (copy), GetConversationMessageStore (copy), GetConversationMessageListStore (copy), HttpService (copy), AppChatNetworking (copy), isSendResponseAccepted (copy), SignalsExperimental (copy), ingestNewerMessages (copy), LayoutConstants (copy), ChatInputBarView (copy)
	local conversationId = t1.conversationId
	local v34 = ExpChatConversationListAdapter.isFriendsConversation(conversationId)
	local v35 = conversationId ~= nil and (conversationId ~= "" and not v34)
	local v36 = useChatWindowSettings()
	local v37 = React.useMemo(function() -- line: 104
		-- upvalues: v36 (copy)
		return {
			BackgroundColor3 = v36.ChatWindowBackgroundColor3,
			BackgroundTransparency = v36.ChatWindowBackgroundTransparency
		}
	end, { v36 })
	local v38 = useChatInputBarSettings()
	local v39 = React.useMemo(function() -- line: 118
		-- upvalues: t1 (copy), v38 (copy)
		if t1.isSpatialUIEnabled and (v38 and v38.SpatialPanelTextSize) then
			return v38.SpatialPanelTextSize
		end

		if v38 then
			return v38.TextSize
		end

		return nil
	end, {
		v38,
		t1.isSpatialUIEnabled
	})
	local v40 = React.useMemo(function() -- line: 128
		-- upvalues: Localization (copy), LocalizationService (copy)
		local v51 = Localization.new(LocalizationService.RobloxLocaleId)

		return {
			placeholder = v51:Format("CoreScripts.TextChat.InputBar.Hint.Touch"),
			disabled = v51:Format("CoreScripts.TextChat.InputBar.Hint.PrivacySettingsDisabled")
		}
	end, {})
	local v41 = useInterpolatedClientSettings(t1.chatWindowSettings or v37)
	local v42 = useChatInputBarOnFocus()
	local onFocusGained = v42.onFocusGained
	local onFocusLost = v42.onFocusLost

	React.useEffect(function() -- line: 148
		-- upvalues: onFocusLost (copy)
		return function() -- line: 149
			-- upvalues: onFocusLost (copy)
			onFocusLost()
		end
	end, { onFocusLost })

	local v45 = React.useCallback(function(s1: string) -- line: 155
		-- upvalues: conversationId (copy), Players (copy), v34 (copy), ExpChatConversationListAdapter (copy), v23 (copy), createConversationFromFriendPlaceholder (copy), t1 (copy), v35 (copy), GetConversationMessageStore (copy), GetConversationMessageListStore (copy), HttpService (copy), AppChatNetworking (copy), isSendResponseAccepted (copy), SignalsExperimental (copy), ingestNewerMessages (copy)
		task.spawn(function() -- line: 159
			-- upvalues: s1 (copy), conversationId (copy), Players (copy), v34 (copy), ExpChatConversationListAdapter (copy), v23 (copy), createConversationFromFriendPlaceholder (copy), t1 (copy), v35 (copy), GetConversationMessageStore (copy), GetConversationMessageListStore (copy), HttpService (copy), AppChatNetworking (copy), isSendResponseAccepted (copy), SignalsExperimental (copy), ingestNewerMessages (copy)
			local v54 = typeof(s1) ~= "string" and "" or s1

			if v54 == "" then
				return
			end

			local u55 = conversationId or ""
			local LocalPlayer = Players.LocalPlayer

			if v34 and conversationId ~= nil then
				local v57 = ExpChatConversationListAdapter.getConversationStore().getConversation(conversationId, false)

				if v57 == nil then
					v23:warning(`Unable to find friend placeholder { conversationId }`)

					return
				end

				local v58 = createConversationFromFriendPlaceholder(v57, not LocalPlayer and 0 or LocalPlayer.UserId)

				if v58 == nil then
					v23:warning(`Unable to create conversation for friend placeholder { conversationId }`)

					return
				end

				local v59, v60 = v58:await()

				if not v59 or v60 == nil then
					v23:warning(`Failed to create conversation for friend placeholder { conversationId }`)

					return
				end

				u55 = v60.id

				if t1.onFriendPlaceholderConversationCreated ~= nil then
					t1.onFriendPlaceholderConversationCreated(u55)
				end
			elseif not v35 then
				return
			end

			local v61 = GetConversationMessageStore(false)
			local v62 = GetConversationMessageListStore(false)
			local v63 = "sending-friends-message-" .. HttpService:GenerateGUID(false)
			local t2 = {
				type = "user",
				status = "Pending",
				id = v63,
				content = v54,
				created_at = tostring(os.time()),
				sender_user_id = if not LocalPlayer then nil else LocalPlayer.UserId,
				conversationId = u55
			}

			v61.upsertMessages({
				[v63] = t2
			})
			v62.prependMessages(u55, { v63 })

			local v65 = string.rep("#", utf8.len(v54) or #v54)

			AppChatNetworking.http.SendChatTextMessage(nil, u55, v54):andThen(function(p3) -- line: 219
				-- upvalues: isSendResponseAccepted (copy), v61 (copy), v63 (copy), v65 (copy), SignalsExperimental (copy), ingestNewerMessages (copy), u55 (ref), ExpChatConversationListAdapter (copy), LocalPlayer (copy), v62 (copy)
				if not isSendResponseAccepted(p3) then
					v61.updateMessage(v63, {
						status = "Failed",
						content = v65
					})

					return
				end

				local v67 = p3.responseBody.messages or {}

				SignalsExperimental.batch(function() -- line: 229
					-- upvalues: ingestNewerMessages (copy), u55 (ref), v67 (copy), v61 (copy), v63 (copy), v65 (copy), ExpChatConversationListAdapter (copy), LocalPlayer (copy), v62 (copy)
					if #ingestNewerMessages(u55, v67) == 0 then
						v61.updateMessage(v63, {
							status = "Failed",
							content = v65
						})

						return
					end

					ExpChatConversationListAdapter.updateConversationPreviewFromMessages(u55, v67, {
						hasUnreadMessages = false,
						localUserId = not LocalPlayer and 0 or LocalPlayer.UserId
					})
					v62.removeMessage(u55, v63)
					v61.removeMessage(v63)
				end)
			end):catch(function(p4) -- line: 254
				-- upvalues: v23 (copy), u55 (ref), v61 (copy), v63 (copy), v65 (copy)
				v23:warning(`Failed to send message to { u55 }: { tostring(p4) }`)
				v61.updateMessage(v63, {
					status = "Failed",
					content = v65
				})
			end)
		end)
	end, {
		conversationId,
		v35,
		v34,
		t1.onFriendPlaceholderConversationCreated
	})
	local createElement = React.createElement
	local t3 = {
		Name = "friendsChatInput",
		LayoutOrder = t1.LayoutOrder,
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = v41.BackgroundColor3 or v36.ChatWindowBackgroundColor3
	}
	local BackgroundTransparency = v41.BackgroundTransparency
	local transparencyValue = t1.transparencyValue

	t3.BackgroundTransparency = if type(transparencyValue) ~= "number" then if transparencyValue == nil then BackgroundTransparency else transparencyValue:map(function(n3: number) -- line: 68
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
			onSend = v45,
			textSize = v39,
			placeholderText = v40.placeholder,
			disabledChatPlaceholderText = v40.disabled,
			transparencyValue = t1.transparencyValue,
			onFocusGained = onFocusGained,
			onFocusLost = onFocusLost
		})
	})
end

return FriendsChatInputBarHost
