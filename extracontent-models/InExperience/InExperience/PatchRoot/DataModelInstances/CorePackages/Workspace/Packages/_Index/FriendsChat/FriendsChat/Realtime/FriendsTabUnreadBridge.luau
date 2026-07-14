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

local function FriendsTabUnreadBridge(t1: {[any]: any}) -- line: 54
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
	local v21 = isChatWindowVisible == true and selectedTabName == "FriendsChat"
	local v22 = v21 and v20 == nil

	React.useEffect(function() -- line: 84
		-- upvalues: v21 (copy), InExperienceAppChatModal (copy), AppChatNetworking (copy), v11 (copy), setTabUnread (copy), v18 (copy)
		local function onGlobalCount() -- line: 85
			-- upvalues: v21 (copy), InExperienceAppChatModal (copy), AppChatNetworking (copy), v11 (copy), setTabUnread (copy), v18 (copy)
			if v21 and (InExperienceAppChatModal.default.unreadCount or 0) > 0 then
				InExperienceAppChatModal:setUnreadCount(0)
				AppChatNetworking.http.ClearGlobalUnreadCount():catch(function(p1) -- line: 92
					-- upvalues: v11 (copy)
					v11:warning(`Failed to clear global unread count: { tostring(p1) }`)
				end)
			end

			setTabUnread((InExperienceAppChatModal.default.unreadCount or 0) > 0 or v18.getHasLocalUnread(false))
		end

		onGlobalCount()

		local connection = InExperienceAppChatModal.default.unreadCountSignal.Event:Connect(onGlobalCount)

		return function() -- line: 102
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {
		v21,
		setTabUnread
	})
	React.useEffect(function() -- line: 110
		-- upvalues: Signals (copy), v18 (copy), v22 (copy), setTabUnread (copy), InExperienceAppChatModal (copy)
		local v25 = Signals.createEffect(function(p2) -- line: 111
			-- upvalues: v18 (copy), v22 (copy), setTabUnread (copy), InExperienceAppChatModal (copy)
			local v27 = v18.getHasLocalUnread(p2)

			if v22 and v27 then
				v18.setHasLocalUnread(false)
			end

			setTabUnread((InExperienceAppChatModal.default.unreadCount or 0) > 0 or v18.getHasLocalUnread(false))
		end)

		return function() -- line: 119
			-- upvalues: v25 (copy)
			v25()
		end
	end, {
		v22,
		setTabUnread
	})

	return nil
end

return FriendsTabUnreadBridge
