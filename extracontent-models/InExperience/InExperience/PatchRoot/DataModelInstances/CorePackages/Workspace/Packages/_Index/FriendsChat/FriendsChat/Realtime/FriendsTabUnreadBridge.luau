local Parent = script:FindFirstAncestor("FriendsChat").Parent
local React = require(Parent.React)
local Signals = require(Parent.Signals)
local SignalsReact = require(Parent.SignalsReact)
local SharedFlags = require(Parent.SharedFlags)
local ExpChatShared = require(Parent.ExpChatShared)
local InExperienceAppChatModal = require(Parent.AppChat.InExperienceAppChatModal)
local AppChatNetworking = require(Parent.AppChatNetworking)
local GetFriendsChatRealtimeStore = require(script.Parent.Parent.Stores.GetFriendsChatRealtimeStore)
local v10 = ExpChatShared.Logger:new(script.Name)
local FFlagExpChatEnableFriendsTab = SharedFlags.FFlagExpChatEnableFriendsTab

local function FriendsTabUnreadBridge(t1: {[any]: any}) -- line: 52
	-- upvalues: FFlagExpChatEnableFriendsTab (copy), GetFriendsChatRealtimeStore (copy), SignalsReact (copy), React (copy), InExperienceAppChatModal (copy), AppChatNetworking (copy), v10 (copy), Signals (copy)
	if not FFlagExpChatEnableFriendsTab then
		return nil
	end

	local setTabUnread = t1.setTabUnread
	local selectedTabName = t1.selectedTabName
	local isChatWindowVisible = t1.isChatWindowVisible
	local v17 = GetFriendsChatRealtimeStore(false)
	local v18 = SignalsReact.useSignalState(v17.getActiveConversationId)
	local v19 = isChatWindowVisible == true and selectedTabName == "FriendsChat"
	local v20 = v19 and v18 == nil

	React.useEffect(function() -- line: 75
		-- upvalues: v19 (copy), InExperienceAppChatModal (copy), AppChatNetworking (copy), v10 (copy), setTabUnread (copy), v17 (copy)
		local function onGlobalCount() -- line: 76
			-- upvalues: v19 (copy), InExperienceAppChatModal (copy), AppChatNetworking (copy), v10 (copy), setTabUnread (copy), v17 (copy)
			if v19 and (InExperienceAppChatModal.default.unreadCount or 0) > 0 then
				InExperienceAppChatModal:setUnreadCount(0)
				AppChatNetworking.http.ClearGlobalUnreadCount():catch(function(p1) -- line: 83
					-- upvalues: v10 (copy)
					v10:warning(`Failed to clear global unread count: { tostring(p1) }`)
				end)
			end

			setTabUnread((InExperienceAppChatModal.default.unreadCount or 0) > 0 or v17.getHasLocalUnread(false))
		end

		onGlobalCount()

		local connection = InExperienceAppChatModal.default.unreadCountSignal.Event:Connect(onGlobalCount)

		return function() -- line: 93
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {
		v19,
		setTabUnread
	})
	React.useEffect(function() -- line: 101
		-- upvalues: Signals (copy), v17 (copy), v20 (copy), setTabUnread (copy), InExperienceAppChatModal (copy)
		local v23 = Signals.createEffect(function(p2) -- line: 102
			-- upvalues: v17 (copy), v20 (copy), setTabUnread (copy), InExperienceAppChatModal (copy)
			local v25 = v17.getHasLocalUnread(p2)

			if v20 and v25 then
				v17.setHasLocalUnread(false)
			end

			setTabUnread((InExperienceAppChatModal.default.unreadCount or 0) > 0 or v17.getHasLocalUnread(false))
		end)

		return function() -- line: 110
			-- upvalues: v23 (copy)
			v23()
		end
	end, {
		v20,
		setTabUnread
	})

	return nil
end

return FriendsTabUnreadBridge
