local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local module = require("@luauforge/bundled/cga")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagAddFriendsPageHighlightUnseenTrustedRequests = SharedFlags.FFlagAddFriendsPageHighlightUnseenTrustedRequests

local fFlagFriendRequestsEventReceiverListenTrustedFriends = SharedFlags.FFlagFriendRequestsEventReceiverListenTrustedFriends
local fFlagShowRequestsInCarouselForAllUsers = SharedFlags.FFlagShowRequestsInCarouselForAllUsers

local module3 = require("@luauforge/bundled/ibb")
local friendsRequestsStore = module3.FriendsRequestsStore
local unseenRequestsStore = module3.UnseenRequestsStore

local v5 = { Created = 1, Deleted = 2, RequestSent = 3 }

local extended = Roact.PureComponent:extend("FriendRequestsEventReceiver")

function extended:init()
	local robloxEventReceiver = self.props.RobloxEventReceiver

	self.tokens = { robloxEventReceiver:observeEvent("FriendshipNotifications", function(p2)
			if ({
				FriendshipRequested = true,
				FriendshipDeclined = true,
				FriendshipCreated = true
			})[p2.Type] then
				local v6 = friendsRequestsStore.get()

				if
					fFlagShowRequestsInCarouselForAllUsers
					and p2.Type == "FriendshipRequested"
					and p2.EventArgs
					and tostring(p2.EventArgs.UserId2) == tostring(self.props.localUserId)
				then
					v6.appendNewUserId((tostring(p2.EventArgs.UserId1)))
				end

				v6.refetchFriendRequestCount()

				if fFlagAddFriendsPageHighlightUnseenTrustedRequests then
					unseenRequestsStore.get().refetchUnseenRequestCount()
				else
					v6.refetchNewFriendRequestCount()
				end

				if self.props.friendRequestCountStatus ~= module.RoduxNetworking.Enum.NetworkStatus.Fetching then
					self.props.dispatchFetchFriendRequestsCount(self.props.localUserId)
				end
			end
		end) }

	if fFlagFriendRequestsEventReceiverListenTrustedFriends then
		table.insert(
			self.tokens,
			robloxEventReceiver:observeEvent("TrustedConnectionNotifications", function(p2)
				local eventType = p2.EventType

				if eventType == v5.Created or eventType == v5.Deleted or eventType == v5.RequestSent then
					if fFlagAddFriendsPageHighlightUnseenTrustedRequests then
						unseenRequestsStore.get().refetchUnseenRequestCount()
					else
						friendsRequestsStore.get().refetchNewFriendRequestCount()
					end
				end
			end)
		)
	end
end

function extended.render(p2): nil
	return nil
end

function extended.willUnmount(p2)
	for k, token in pairs(p2.tokens) do
		token:disconnect()
	end
end

return RoactRodux.connect(function(p2)
	return {
		localUserId = p2.LocalUserId,
		friendRequestCountStatus = module.FriendsNetworking.GetFriendRequestsCount.getStatus(p2)
	}
end, function(callback, p2)
	return {
		dispatchFetchFriendRequestsCount = function(p3)
			return callback(module.FriendsNetworking.GetFriendRequestsCount.API(p3))
		end,
		updateNewFriendRequestsCount = function(p3)
			return callback(module.FriendsNetworking.GetNewFriendRequestsCount.API(p3))
		end
	}
end)(extended)
