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
	[AddPlayer.name] = function(p1, p2) -- line: 16
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p1, {
			[p2.userId] = {
				isBlocked = false,
				isFollowing = false,
				isFollower = false,
				friendStatus = Enum.FriendStatus.Unknown
			}
		})
	end,
	[RemovePlayer.name] = function(p3, p4) -- line: 27
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p3, {
			[p4.userId] = Cryo.None
		})
	end,
	[SetPlayerIsBlocked.name] = function(p5, p6) -- line: 33
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p5, {
			[p6.userId] = {
				isBlocked = p6.isBlocked,
				friendStatus = p5[p6.userId].friendStatus,
				isFollowing = p5[p6.userId].isFollowing,
				isFollower = p5[p6.userId].isFollower
			}
		})
	end,
	[SetPlayerFollowRelationship.name] = function(p7, p8) -- line: 44
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p7, {
			[p8.userId] = {
				isBlocked = p7[p8.userId].isBlocked,
				friendStatus = p7[p8.userId].friendStatus,
				isFollowing = p8.isFollowing,
				isFollower = p8.isFollower
			}
		})
	end,
	[SetPlayerIsFollowing.name] = function(p9, p10) -- line: 55
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p9, {
			[p10.userId] = {
				isBlocked = p9[p10.userId].isBlocked,
				friendStatus = p9[p10.userId].friendStatus,
				isFollowing = p10.isFollowing,
				isFollower = p9[p10.userId].isFollower
			}
		})
	end,
	[SetPlayerFriendStatus.name] = function(p11, p12) -- line: 66
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p11, {
			[p12.userId] = {
				isBlocked = p11[p12.userId].isBlocked,
				friendStatus = p12.friendStatus,
				isFollowing = p11[p12.userId].isFollowing,
				isFollower = p11[p12.userId].isFollower
			}
		})
	end
}))
