local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalizationService = game:GetService("LocalizationService")
local Parent = script:FindFirstAncestor("FriendsChat").Parent
local React = require(Parent.React)
local SignalsExperimental = require(Parent.SignalsExperimental)
local ExpChatShared = require(Parent.ExpChatShared)
local Localization = require(Parent.InExperienceLocales).Localization
local ChatUIPrimitives = require(Parent.ChatUIPrimitives)
local AppChatNetworking = require(Parent.AppChatNetworking)
local createConversationFromFriendPlaceholder = require(Parent.AppChat.createConversationFromFriendPlaceholder)
local GetConversationMessageStore = require(Parent.AppChat.GetConversationMessageStore)
local GetConversationMessageListStore = require(Parent.AppChat.GetConversationMessageListStore)
local ingestNewerMessages = require(Parent.AppChat.ingestNewerMessages)
local ExpChatConversationListAdapter = require(script.Parent.Parent.ConversationList.ExpChatConversationListAdapter)
local ChatInputBarView = ChatUIPrimitives.ChatInputBarView
local useChatInputBarSettings = require(Parent.ExpChatIntegration.useChatInputBarSettings)
local useChatInputBarOnFocus = require(Parent.ExpChatIntegration.useChatInputBarOnFocus)
local useChatWindowSettings = require(Parent.ExpChatIntegration.useChatWindowSettings)
local useInterpolatedClientSettings = require(Parent.ExpChatIntegration.useInterpolatedClientSettings)
local v21 = ExpChatShared.Logger:new(script.Name)

local function resolveFade(n1: number, p1) -- line: 70
	if type(p1) == "number" then
		return n1 + p1 * (1 - n1)
	end

	if p1 ~= nil then
		return p1:map(function(n2: number) -- line: 74
			-- upvalues: n1 (copy)
			return n1 + n2 * (1 - n1)
		end)
	end

	return n1
end
local function isSendResponseAccepted(p2) -- line: 81
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
local function FriendsChatInputBarHost(t1: {[any]: any}) -- line: 101
	-- upvalues: ExpChatConversationListAdapter (copy), useChatWindowSettings (copy), React (copy), useChatInputBarSettings (copy), Localization (copy), LocalizationService (copy), useInterpolatedClientSettings (copy), useChatInputBarOnFocus (copy), Players (copy), v21 (copy), createConversationFromFriendPlaceholder (copy), GetConversationMessageStore (copy), GetConversationMessageListStore (copy), HttpService (copy), AppChatNetworking (copy), isSendResponseAccepted (copy), SignalsExperimental (copy), ingestNewerMessages (copy), ChatInputBarView (copy)
	local conversationId = t1.conversationId
	local v32 = ExpChatConversationListAdapter.isFriendsConversation(conversationId)
	local v33 = conversationId ~= nil and (conversationId ~= "" and not v32)
	local v34 = useChatWindowSettings()
	local v35 = React.useMemo(function() -- line: 110
		-- upvalues: v34 (copy)
		return {
			BackgroundColor3 = v34.ChatWindowBackgroundColor3,
			BackgroundTransparency = v34.ChatWindowBackgroundTransparency
		}
	end, { v34 })
	local v36 = useChatInputBarSettings()
	local v37 = React.useMemo(function() -- line: 124
		-- upvalues: t1 (copy), v36 (copy)
		if t1.isSpatialUIEnabled and (v36 and v36.SpatialPanelTextSize) then
			return v36.SpatialPanelTextSize
		end

		if v36 then
			return v36.TextSize
		end

		return nil
	end, {
		v36,
		t1.isSpatialUIEnabled
	})
	local v38 = React.useMemo(function() -- line: 134
		-- upvalues: Localization (copy), LocalizationService (copy)
		local v49 = Localization.new(LocalizationService.RobloxLocaleId)

		return {
			placeholder = v49:Format("CoreScripts.TextChat.InputBar.Hint.Touch"),
			disabled = v49:Format("CoreScripts.TextChat.InputBar.Hint.PrivacySettingsDisabled")
		}
	end, {})
	local v39 = useInterpolatedClientSettings(t1.chatWindowSettings or v35)
	local v40 = useChatInputBarOnFocus()
	local onFocusGained = v40.onFocusGained
	local onFocusLost = v40.onFocusLost

	React.useEffect(function() -- line: 154
		-- upvalues: onFocusLost (copy)
		return function() -- line: 155
			-- upvalues: onFocusLost (copy)
			onFocusLost()
		end
	end, { onFocusLost })

	local v43 = React.useCallback(function(s1: string) -- line: 161
		-- upvalues: conversationId (copy), Players (copy), v32 (copy), ExpChatConversationListAdapter (copy), v21 (copy), createConversationFromFriendPlaceholder (copy), t1 (copy), v33 (copy), GetConversationMessageStore (copy), GetConversationMessageListStore (copy), HttpService (copy), AppChatNetworking (copy), isSendResponseAccepted (copy), SignalsExperimental (copy), ingestNewerMessages (copy)
		task.spawn(function() -- line: 165
			-- upvalues: s1 (copy), conversationId (copy), Players (copy), v32 (copy), ExpChatConversationListAdapter (copy), v21 (copy), createConversationFromFriendPlaceholder (copy), t1 (copy), v33 (copy), GetConversationMessageStore (copy), GetConversationMessageListStore (copy), HttpService (copy), AppChatNetworking (copy), isSendResponseAccepted (copy), SignalsExperimental (copy), ingestNewerMessages (copy)
			local v52 = typeof(s1) ~= "string" and "" or s1

			if v52 == "" then
				return
			end

			local u53 = conversationId or ""
			local LocalPlayer = Players.LocalPlayer

			if v32 and conversationId ~= nil then
				local v55 = ExpChatConversationListAdapter.getConversationStore().getConversation(conversationId, false)

				if v55 == nil then
					v21:warning(`Unable to find friend placeholder { conversationId }`)

					return
				end

				local v56 = createConversationFromFriendPlaceholder(v55, not LocalPlayer and 0 or LocalPlayer.UserId)

				if v56 == nil then
					v21:warning(`Unable to create conversation for friend placeholder { conversationId }`)

					return
				end

				local v57, v58 = v56:await()

				if not v57 or v58 == nil then
					v21:warning(`Failed to create conversation for friend placeholder { conversationId }`)

					return
				end

				u53 = v58.id

				if t1.onFriendPlaceholderConversationCreated ~= nil then
					t1.onFriendPlaceholderConversationCreated(u53)
				end
			elseif not v33 then
				return
			end

			local v59 = GetConversationMessageStore(false)
			local v60 = GetConversationMessageListStore(false)
			local v61 = "sending-friends-message-" .. HttpService:GenerateGUID(false)
			local t2 = {
				type = "user",
				status = "Pending",
				id = v61,
				content = v52,
				created_at = tostring(os.time()),
				sender_user_id = if not LocalPlayer then nil else LocalPlayer.UserId,
				conversationId = u53
			}

			v59.upsertMessages({
				[v61] = t2
			})
			v60.prependMessages(u53, { v61 })

			local v63 = string.rep("#", utf8.len(v52) or #v52)

			AppChatNetworking.http.SendChatTextMessage(nil, u53, v52):andThen(function(p3) -- line: 225
				-- upvalues: isSendResponseAccepted (copy), v59 (copy), v61 (copy), v63 (copy), SignalsExperimental (copy), ingestNewerMessages (copy), u53 (ref), ExpChatConversationListAdapter (copy), LocalPlayer (copy), v60 (copy)
				if not isSendResponseAccepted(p3) then
					v59.updateMessage(v61, {
						status = "Failed",
						content = v63
					})

					return
				end

				local v65 = p3.responseBody.messages or {}

				SignalsExperimental.batch(function() -- line: 235
					-- upvalues: ingestNewerMessages (copy), u53 (ref), v65 (copy), v59 (copy), v61 (copy), v63 (copy), ExpChatConversationListAdapter (copy), LocalPlayer (copy), v60 (copy)
					if #ingestNewerMessages(u53, v65) == 0 then
						v59.updateMessage(v61, {
							status = "Failed",
							content = v63
						})

						return
					end

					ExpChatConversationListAdapter.updateConversationPreviewFromMessages(u53, v65, {
						hasUnreadMessages = false,
						localUserId = not LocalPlayer and 0 or LocalPlayer.UserId
					})
					v60.removeMessage(u53, v61)
					v59.removeMessage(v61)
				end)
			end):catch(function(p4) -- line: 260
				-- upvalues: v21 (copy), u53 (ref), v59 (copy), v61 (copy), v63 (copy)
				v21:warning(`Failed to send message to { u53 }: { tostring(p4) }`)
				v59.updateMessage(v61, {
					status = "Failed",
					content = v63
				})
			end)
		end)
	end, {
		conversationId,
		v33,
		v32,
		t1.onFriendPlaceholderConversationCreated
	})
	local createElement = React.createElement
	local t3 = {
		LayoutOrder = t1.LayoutOrder,
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = v39.BackgroundColor3 or v34.ChatWindowBackgroundColor3
	}
	local BackgroundTransparency = v39.BackgroundTransparency
	local transparencyValue = t1.transparencyValue

	t3.BackgroundTransparency = if type(transparencyValue) ~= "number" then if transparencyValue == nil then BackgroundTransparency else transparencyValue:map(function(n3: number) -- line: 74
		-- upvalues: BackgroundTransparency (copy)
		return BackgroundTransparency + n3 * (1 - BackgroundTransparency)
	end) else BackgroundTransparency + transparencyValue * (1 - BackgroundTransparency)
	t3.Active = true
	t3.BorderSizePixel = 0
	t3.Size = UDim2.fromScale(1, 0)
	t3[React.Event.MouseEnter] = t1.onHovered
	t3[React.Event.MouseLeave] = t1.onUnhovered

	return createElement("Frame", t3, {
		padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 8),
			PaddingLeft = UDim.new(0, 8),
			PaddingRight = UDim.new(0, 8)
		}),
		inputBar = React.createElement(ChatInputBarView, {
			canLocalUserChat = true,
			showSideChip = false,
			retainFocusOnSend = true,
			onSend = v43,
			textSize = v37,
			placeholderText = v38.placeholder,
			disabledChatPlaceholderText = v38.disabled,
			transparencyValue = t1.transparencyValue,
			onFocusGained = onFocusGained,
			onFocusLost = onFocusLost
		})
	})
end

return FriendsChatInputBarHost
