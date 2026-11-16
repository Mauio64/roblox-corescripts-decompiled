local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)

local Actions = script.Parent.Parent.Actions
local AddPlayer = require(Actions.AddPlayer)
local RemovePlayer = require(Actions.RemovePlayer)
local SetPlayerIsBlocked = require(Actions.SetPlayerIsBlocked)
local SetPlayerFollowRelationship = require(Actions.SetPlayerFollowRelationship)
local SetPlayerFriendStatus = require(Actions.SetPlayerFriendStatus)
local SetPlayerIsFollowing = require(Actions.SetPlayerIsFollowing)

return (Rodux.createReducer({}, {
	[AddPlayer.name] = function(p, p2)
		return Cryo.Dictionary.join(p, {
			[p2.userId] = {
				isBlocked = false,
				friendStatus = Enum.FriendStatus.Unknown,
				isFollowing = false,
				isFollower = false
			}
		})
	end,
	[RemovePlayer.name] = function(p, p2)
		return Cryo.Dictionary.join(p, { [p2.userId] = Cryo.None })
	end,
	[SetPlayerIsBlocked.name] = function(p, p2)
		return Cryo.Dictionary.join(p, {
			[p2.userId] = {
				isBlocked = p2.isBlocked,
				friendStatus = p[p2.userId].friendStatus,
				isFollowing = p[p2.userId].isFollowing,
				isFollower = p[p2.userId].isFollower
			}
		})
	end,
	[SetPlayerFollowRelationship.name] = function(p, data)
		return Cryo.Dictionary.join(p, {
			[data.userId] = {
				isBlocked = p[data.userId].isBlocked,
				friendStatus = p[data.userId].friendStatus,
				isFollowing = data.isFollowing,
				isFollower = data.isFollower
			}
		})
	end,
	[SetPlayerIsFollowing.name] = function(p, p2)
		return Cryo.Dictionary.join(p, {
			[p2.userId] = {
				isBlocked = p[p2.userId].isBlocked,
				friendStatus = p[p2.userId].friendStatus,
				isFollowing = p2.isFollowing,
				isFollower = p[p2.userId].isFollower
			}
		})
	end,
	[SetPlayerFriendStatus.name] = function(p, p2)
		return Cryo.Dictionary.join(p, {
			[p2.userId] = {
				isBlocked = p[p2.userId].isBlocked,
				friendStatus = p2.friendStatus,
				isFollowing = p[p2.userId].isFollowing,
				isFollower = p[p2.userId].isFollower
			}
		})
	end
}))
