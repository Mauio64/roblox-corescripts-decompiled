local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local RoactRodux = require(Modules.Common.RoactRodux)
local llama = require(CorePackages.Packages.LuaSocialLibrariesDeps).llama
local Roact = require(Modules.Common.Roact)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local FriendshipCreated = require(Modules.LuaApp.Thunks.FriendshipCreated)
local FriendshipDestroyed = require(Modules.LuaApp.Thunks.FriendshipDestroyed)
local EventNetworking = require(script.Parent.EventNetworking)
local useHandleFriendshipEvent = require(CorePackages.Workspace.Packages.FriendsCommon).Hooks.useHandleFriendshipEvent
local GetUnreadConversationCount = require(CorePackages.Workspace.Packages.SocialTabState).Requests.GetUnreadConversationCount
local v14 = Roact.Component:extend("FriendshipEventReceiver")

function v14.init(p1) -- line: 25
	local friendshipCreated = p1.props.friendshipCreated
	local friendshipDestroyed = p1.props.friendshipDestroyed
	local networking = p1.props.networking

	p1.tokens = { p1.props.RobloxEventReceiver:observeEvent("FriendshipNotifications", function(p2) -- line: 33
		-- upvalues: p1 (copy), friendshipDestroyed (copy), friendshipCreated (copy), networking (copy)
		local str = tostring(p1.props.localUserId)

		if p2.Type == "FriendshipDestroyed" then
			local v31 = str == tostring(p2.EventArgs.UserId1) and tostring(p2.EventArgs.UserId2) or tostring(p2.EventArgs.UserId1)

			p1.props.fetchFriendCount(str)
			friendshipDestroyed({
				otherUser = v31,
				localUserId = str
			})
			p1.props.handleFriendshipEvent({
				removedUserId = v31
			})
			p1.props.fetchGetUnreadConversationCount()

			return
		end

		if p2.Type == "FriendshipCreated" then
			local v32 = str == tostring(p2.EventArgs.UserId1) and tostring(p2.EventArgs.UserId2) or tostring(p2.EventArgs.UserId1)

			p1.props.fetchFriendCount(str)
			friendshipCreated(networking, v32)
			p1.props.handleFriendshipEvent({
				addedUserId = v32
			})
			p1.props.fetchGetUnreadConversationCount()
		end
	end) }
end
function v14.render(_) -- line: 63
end
function v14.willUnmount(p4) -- line: 65
	for _, v in pairs(p4.tokens) do
		v:disconnect()
	end
end

local v15 = RoactRodux.connect(function(p5) -- line: 71
	return {
		localUserId = p5.LocalUserId
	}
end, function(p6) -- line: 75
	-- upvalues: EventNetworking (copy), FriendshipDestroyed (copy), FriendshipCreated (copy), GetUnreadConversationCount (copy)
	return {
		friendshipCreated = function(...) -- line: 81
			-- upvalues: p6 (copy), FriendshipCreated (copy)
			return p6(FriendshipCreated(...))
		end,
		friendshipDestroyed = function(t1: {[any]: any}) -- line: 76
			-- upvalues: p6 (copy), EventNetworking (copy), FriendshipDestroyed (copy)
			p6(EventNetworking.RoduxFriends.Actions.FriendshipDestroyed(t1.otherUser, t1.localUserId))

			return p6(FriendshipDestroyed(t1.otherUser))
		end,
		fetchFriendCount = function(p7) -- line: 85
			-- upvalues: p6 (copy), EventNetworking (copy)
			p6(EventNetworking.FriendsNetworking.GetFriendsCountFromUserId.API(p7))
		end,
		fetchGetUnreadConversationCount = function() -- line: 88
			-- upvalues: p6 (copy), GetUnreadConversationCount (copy)
			p6(GetUnreadConversationCount.API())
		end
	}
end)(v14)
local u16 = RoactServices.connect({
	networking = RoactNetworking
})(v15)

return function(p8) -- line: 98
	-- upvalues: useHandleFriendshipEvent (copy), Roact (copy), u16 (ref), llama (copy)
	local v28 = useHandleFriendshipEvent()

	return Roact.createElement(u16, llama.Dictionary.join(p8, {
		handleFriendshipEvent = v28
	}))
end
