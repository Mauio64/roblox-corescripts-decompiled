local CorePackages = game:GetService("CorePackages")

local useSheetNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/FoundationFork/Sheet/useSheetNavigation")
local LuaSocialLibrariesDeps = require(CorePackages.Packages.LuaSocialLibrariesDeps)
local llama = LuaSocialLibrariesDeps.llama

local module2 = require("@luauforge/bundled/ego")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module3 = require("@luauforge/bundled/egx")

local ChatFriendshipCreated = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/App/Thunks/ChatFriendshipCreated")
local ChatFriendshipDestroyed = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/App/Thunks/ChatFriendshipDestroyed")
local module6 = require("@luauforge/bundled/cio")

local useHandleFriendshipEvent = require("@luauforge/bundled/iiG").Hooks.useHandleFriendshipEvent

local getUnreadConversationCount = require("@luauforge/bundled/hGn").Requests.GetUnreadConversationCount

local v5 = require("@luauforge/bundled/dSY").Friends.FriendsStore.get()

local extended = module2.Component:extend("FriendshipEventReceiver")

function extended:init()
	local friendshipCreated = self.props.friendshipCreated
	local friendshipDestroyed = self.props.friendshipDestroyed

	local networking = self.props.networking
	self.tokens = { self.props.RobloxEventReceiver:observeEvent("FriendshipNotifications", function(p3)
			local localUserId = tostring(self.props.localUserId)

			if p3.Type == "FriendshipDestroyed" then
				local userId2 = localUserId == tostring(p3.EventArgs.UserId1)
					and tostring(p3.EventArgs.UserId2)
					or tostring(p3.EventArgs.UserId1)

				v5.RefreshFriendsCountByUserId(localUserId)

				friendshipDestroyed({ otherUser = userId2, localUserId = localUserId })

				self.props.handleFriendshipEvent({ removedUserId = userId2 })
				self.props.fetchGetUnreadConversationCount()
			elseif p3.Type == "FriendshipCreated" then
				local userId2 = localUserId == tostring(p3.EventArgs.UserId1)
					and tostring(p3.EventArgs.UserId2)
					or tostring(p3.EventArgs.UserId1)

				v5.RefreshFriendsCountByUserId(localUserId)

				friendshipCreated(networking, userId2)

				self.props.handleFriendshipEvent({ addedUserId = userId2 })
				self.props.fetchGetUnreadConversationCount()
			elseif p3.Type == "FriendshipRequested" then
				if p3.EventArgs then
					local userId1 = tostring(p3.EventArgs.UserId1)
					local userId2 = tostring(p3.EventArgs.UserId2)

					if userId1 == localUserId then
						v5.UpdateFriendshipStatus(userId2, Enum.FriendStatus.FriendRequestSent)
					elseif userId2 == localUserId then
						v5.UpdateFriendshipStatus(userId1, Enum.FriendStatus.FriendRequestReceived)
					end
				end
			elseif p3.Type == "FriendshipDeclined" and p3.EventArgs then
				local userId2 = localUserId == tostring(p3.EventArgs.UserId1)
					and tostring(p3.EventArgs.UserId2)
					or tostring(p3.EventArgs.UserId1)
				v5.UpdateFriendshipStatus(userId2, Enum.FriendStatus.NotFriend)
			end
		end) }
end

function extended.render(p2) end

function extended.willUnmount(p2)
	for k, token in pairs(p2.tokens) do
		token:disconnect()
	end
end

local v6 = useSheetNavigation.connect(function(p2)
	return { localUserId = p2.LocalUserId }
end, function(callback)
	return {
		friendshipCreated = function(...)
			return callback(ChatFriendshipCreated(...))
		end,
		friendshipDestroyed = function(p2)
			callback(module6.RoduxFriends.Actions.FriendshipDestroyed(p2.otherUser, p2.localUserId))
			return callback(ChatFriendshipDestroyed(p2.otherUser))
		end,
		fetchGetUnreadConversationCount = function()
			callback(getUnreadConversationCount.API())
		end
	}
end)(extended)

local v7 = roactServices.connect({ networking = module3 })(v6)

return function(p2)
	local v8 = useHandleFriendshipEvent()

	return module2.createElement(v7, llama.Dictionary.join(p2, {
		handleFriendshipEvent = v8
	}))
end
