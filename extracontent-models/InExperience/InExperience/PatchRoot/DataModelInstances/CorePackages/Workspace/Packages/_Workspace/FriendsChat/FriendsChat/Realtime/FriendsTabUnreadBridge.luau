local parent = script:FindFirstAncestor("FriendsChat").Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local ExpChatShared = require(parent.ExpChatShared)

local InExperienceAppChatModal = require(parent.AppChat.InExperienceAppChatModal)
local AppChatNetworking = require(parent.AppChatNetworking)
local GetFriendsChatRealtimeStore = require(script.Parent.Parent.Stores.GetFriendsChatRealtimeStore)
local GetFriendsChatNavigationStore = require(script.Parent.Parent.Stores.GetFriendsChatNavigationStore)
local FriendsChatTabName = require(script.Parent.Parent.FriendsChatTabName)

local v = ExpChatShared.Logger:new(script.Name)

local function FriendsTabUnreadBridge(data): nil
	local setTabUnread = data.setTabUnread
	local selectedTabName = data.selectedTabName
	local isChatWindowVisible = data.isChatWindowVisible
	local friendsChatRealtimeStore = GetFriendsChatRealtimeStore(false)
	local friendsChatNavigationStore = GetFriendsChatNavigationStore(false)
	local v2 = SignalsReact.useSignalState(friendsChatNavigationStore.getEffectiveConversationId)

	local function readHasLocalUnread(): boolean -- 1 equivalent call inferred from this helper
		return next(friendsChatRealtimeStore.getLocalUnreadConversationIds(false)) ~= nil
	end

	local v3

	if isChatWindowVisible == true then
		v3 = selectedTabName == FriendsChatTabName
	else
		v3 = false
	end

	local v4 = v3 and v2 == nil
	React.useEffect(function()
		local function onGlobalCount()
			if v3 and (InExperienceAppChatModal.default.unreadCount or 0) > 0 then
				InExperienceAppChatModal:setUnreadCount(0)
				AppChatNetworking.http.ClearGlobalUnreadCount():catch(function(p)
					v:warning(`Failed to clear global unread count: {tostring(p)}`)
				end)
			end

			setTabUnread((InExperienceAppChatModal.default.unreadCount or 0) > 0 or readHasLocalUnread()) -- inferred equivalent call
		end

		onGlobalCount()
		local eventConnection = InExperienceAppChatModal.default.unreadCountSignal.Event:Connect(onGlobalCount)
		return function()
			eventConnection:Disconnect()
		end
	end, { v3, setTabUnread })

	React.useEffect(function()
		local effect = Signals.createEffect(function(p)
			local localUnreadConversationIds = friendsChatRealtimeStore.getLocalUnreadConversationIds(p)

			local v5 = v3

			if v5 then
				if v2 == nil then
					v5 = false
				else
					v5 = localUnreadConversationIds[v2] == true
				end
			end

			if v5 or v4 and next(localUnreadConversationIds) ~= nil then
				friendsChatRealtimeStore.clearLocalUnread()
			end

			setTabUnread((InExperienceAppChatModal.default.unreadCount or 0) > 0 or next(friendsChatRealtimeStore.getLocalUnreadConversationIds(false)) ~= nil)
		end)

		return function()
			effect()
		end
	end, { v4, v3, v2, setTabUnread })

	return nil
end

return FriendsTabUnreadBridge
