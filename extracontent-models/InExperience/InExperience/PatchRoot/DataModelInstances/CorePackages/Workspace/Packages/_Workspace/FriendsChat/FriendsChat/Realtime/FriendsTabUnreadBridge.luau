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
local v11 = ExpChatShared.Logger:new(script.Name)
local FFlagExpChatEnableFriendsTab = SharedFlags.FFlagExpChatEnableFriendsTab

local function FriendsTabUnreadBridge(t1: {[any]: any}) -- line: 60
	-- upvalues: FFlagExpChatEnableFriendsTab (copy), GetFriendsChatRealtimeStore (copy), GetFriendsChatNavigationStore (copy), SignalsReact (copy), React (copy), InExperienceAppChatModal (copy), AppChatNetworking (copy), v11 (copy), Signals (copy)
	if not FFlagExpChatEnableFriendsTab then
		return nil
	end

	local setTabUnread = t1.setTabUnread
	local selectedTabName = t1.selectedTabName
	local isChatWindowVisible = t1.isChatWindowVisible
	local v18 = GetFriendsChatRealtimeStore(false)
	local v19 = GetFriendsChatNavigationStore(false)
	local v20 = SignalsReact.useSignalState(v19.getSelectedConversationId)

	local function readHasLocalUnread() -- line: 72
		-- upvalues: v18 (copy)
		return next(v18.getLocalUnreadConversationIds(false)) ~= nil
	end

	local v22 = isChatWindowVisible == true and selectedTabName == "FriendsChat"
	local v23 = v22 and v20 == nil

	React.useEffect(function() -- line: 94
		-- upvalues: v22 (copy), InExperienceAppChatModal (copy), AppChatNetworking (copy), v11 (copy), setTabUnread (copy), v18 (copy)
		local function onGlobalCount() -- line: 95
			-- upvalues: v22 (copy), InExperienceAppChatModal (copy), AppChatNetworking (copy), v11 (copy), setTabUnread (copy), v18 (copy)
			if v22 and (InExperienceAppChatModal.default.unreadCount or 0) > 0 then
				InExperienceAppChatModal:setUnreadCount(0)
				AppChatNetworking.http.ClearGlobalUnreadCount():catch(function(p1) -- line: 102
					-- upvalues: v11 (copy)
					v11:warning(`Failed to clear global unread count: { tostring(p1) }`)
				end)
			end

			setTabUnread((InExperienceAppChatModal.default.unreadCount or 0) > 0 or next(v18.getLocalUnreadConversationIds(false)) ~= nil)
		end

		onGlobalCount()

		local connection = InExperienceAppChatModal.default.unreadCountSignal.Event:Connect(onGlobalCount)

		return function() -- line: 112
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {
		v22,
		setTabUnread
	})
	React.useEffect(function() -- line: 126
		-- upvalues: Signals (copy), v18 (copy), v22 (copy), v20 (copy), v23 (copy), setTabUnread (copy), InExperienceAppChatModal (copy)
		local v26 = Signals.createEffect(function(p2) -- line: 127
			-- upvalues: v18 (copy), v22 (copy), v20 (copy), v23 (copy), setTabUnread (copy), InExperienceAppChatModal (copy)
			local v28 = v18.getLocalUnreadConversationIds(p2)

			if v22 and (v20 ~= nil and v28[v20] == true) or v23 and next(v28) ~= nil then
				v18.clearLocalUnread()
			end

			setTabUnread((InExperienceAppChatModal.default.unreadCount or 0) > 0 or next(v18.getLocalUnreadConversationIds(false)) ~= nil)
		end)

		return function() -- line: 143
			-- upvalues: v26 (copy)
			v26()
		end
	end, {
		v23,
		v22,
		v20,
		setTabUnread
	})

	return nil
end

return FriendsTabUnreadBridge
