local Parent = script:FindFirstAncestor("FriendsChat").Parent
local React = require(Parent.React)
local Signals = require(Parent.Signals)
local SignalsReact = require(Parent.SignalsReact)
local SharedFlags = require(Parent.SharedFlags)
local ExpChatShared = require(Parent.ExpChatShared)
local InExperienceAppChatModal = require(Parent.AppChat.InExperienceAppChatModal)
local AppChatNetworking = require(Parent.AppChatNetworking)
local GetFriendsChatRealtimeStore = require(script.Parent.Parent.Stores.GetFriendsChatRealtimeStore)
local GetFriendsChatNavigationStore = require(script.Parent.Parent.Stores.GetFriendsChatNavigationStore)
local FFlagFriendsChatTabUnreadBadgeFix = require(script.Parent.Parent.Flags.FFlagFriendsChatTabUnreadBadgeFix)
local v12 = ExpChatShared.Logger:new(script.Name)
local FFlagExpChatEnableFriendsTab = SharedFlags.FFlagExpChatEnableFriendsTab

local function FriendsTabUnreadBridge(t1: {[any]: any}) -- line: 62
	-- upvalues: FFlagExpChatEnableFriendsTab (copy), GetFriendsChatRealtimeStore (copy), GetFriendsChatNavigationStore (copy), SignalsReact (copy), FFlagFriendsChatTabUnreadBadgeFix (copy), React (copy), InExperienceAppChatModal (copy), AppChatNetworking (copy), v12 (copy), Signals (copy)
	if not FFlagExpChatEnableFriendsTab then
		return nil
	end

	local setTabUnread = t1.setTabUnread
	local selectedTabName = t1.selectedTabName
	local isChatWindowVisible = t1.isChatWindowVisible
	local v19 = GetFriendsChatRealtimeStore(false)
	local v20 = GetFriendsChatNavigationStore(false)
	local v21 = SignalsReact.useSignalState(v20.getSelectedConversationId)

	local function readHasLocalUnread() -- line: 74
		-- upvalues: FFlagFriendsChatTabUnreadBadgeFix (copy), v19 (copy)
		if FFlagFriendsChatTabUnreadBadgeFix then
			return next(v19.getLocalUnreadConversationIds(false)) ~= nil
		end

		return v19.getHasLocalUnread(false)
	end

	local v23 = isChatWindowVisible == true and selectedTabName == "FriendsChat"
	local v24 = v23 and v21 == nil

	React.useEffect(function() -- line: 100
		-- upvalues: v23 (copy), InExperienceAppChatModal (copy), AppChatNetworking (copy), v12 (copy), setTabUnread (copy), FFlagFriendsChatTabUnreadBadgeFix (copy), v19 (copy)
		local function onGlobalCount() -- line: 101
			-- upvalues: v23 (copy), InExperienceAppChatModal (copy), AppChatNetworking (copy), v12 (copy), setTabUnread (copy), FFlagFriendsChatTabUnreadBadgeFix (copy), v19 (copy)
			if v23 and (InExperienceAppChatModal.default.unreadCount or 0) > 0 then
				InExperienceAppChatModal:setUnreadCount(0)
				AppChatNetworking.http.ClearGlobalUnreadCount():catch(function(p1) -- line: 108
					-- upvalues: v12 (copy)
					v12:warning(`Failed to clear global unread count: { tostring(p1) }`)
				end)
			end

			setTabUnread((InExperienceAppChatModal.default.unreadCount or 0) > 0 or if not FFlagFriendsChatTabUnreadBadgeFix then v19.getHasLocalUnread(false) else next(v19.getLocalUnreadConversationIds(false)) ~= nil)
		end

		onGlobalCount()

		local connection = InExperienceAppChatModal.default.unreadCountSignal.Event:Connect(onGlobalCount)

		return function() -- line: 118
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {
		v23,
		setTabUnread
	})
	React.useEffect(function() -- line: 132
		-- upvalues: Signals (copy), FFlagFriendsChatTabUnreadBadgeFix (copy), v19 (copy), v23 (copy), v21 (copy), v24 (copy), setTabUnread (copy), InExperienceAppChatModal (copy)
		local v27 = Signals.createEffect(function(p2) -- line: 133
			-- upvalues: FFlagFriendsChatTabUnreadBadgeFix (copy), v19 (copy), v23 (copy), v21 (copy), v24 (copy), setTabUnread (copy), InExperienceAppChatModal (copy)
			if FFlagFriendsChatTabUnreadBadgeFix then
				local v29 = v19.getLocalUnreadConversationIds(p2)

				if v23 and (v21 ~= nil and v29[v21] == true) or v24 and next(v29) ~= nil then
					v19.clearLocalUnread()
				end

				setTabUnread((InExperienceAppChatModal.default.unreadCount or 0) > 0 or next(v19.getLocalUnreadConversationIds(false)) ~= nil)

				return
			end

			local v30 = v19.getHasLocalUnread(p2)

			if v24 and v30 then
				v19.setHasLocalUnread(false)
			end

			setTabUnread((InExperienceAppChatModal.default.unreadCount or 0) > 0 or v19.getHasLocalUnread(false))
		end)

		return function() -- line: 159
			-- upvalues: v27 (copy)
			v27()
		end
	end, {
		v24,
		if not FFlagFriendsChatTabUnreadBadgeFix then nil else v23,
		if not FFlagFriendsChatTabUnreadBadgeFix then nil else v21,
		setTabUnread
	})

	return nil
end

return FriendsTabUnreadBridge
