local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local Foundation = require(ProfilePlatformParent.Foundation)
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local SocialCountEnableKeys = require(ProfilePlatform.Common.Enums).SocialCountEnableKeys
local AvatarGroupType = Foundation.Enums.AvatarGroupType
local FFlagConnectionsToFriendsRename = require(ProfilePlatformParent.SharedFlags).FFlagConnectionsToFriendsRename
local FFlagEnableSocialTabsPage = require(ProfilePlatformParent.SharedFlags).FFlagEnableSocialTabsPage

return {
	RowConfig = {
		mutualFriendsCount = {
			layoutOrder = 1,
			textKey = TextKeys.MutualsText,
			singleTextKey = TextKeys.MutualText,
			enabledKey = SocialCountEnableKeys.IsMutualFriendsCountEnabled,
			getIsDisabled = function(_: boolean, _: boolean, b3: boolean) -- line: 30
				if not b3 then
					return true
				end

				return false
			end,
			getLeading = function(t1: {[any]: any}) -- line: 36
				-- upvalues: AvatarGroupType (copy)
				local t2 = { table.unpack(t1.mutualFriendIds, 1, (math.min(2, #t1.mutualFriendIds))) }

				if t2 and #t2 > 0 then
					return {
						type = "AvatarGroup",
						props = {
							max = 2,
							avatars = t2,
							type = AvatarGroupType.Stacked
						}
					}
				end

				return nil
			end
		},
		friendsCount = {
			layoutOrder = 2,
			textKey = if not FFlagConnectionsToFriendsRename then TextKeys.Connections else TextKeys.Friends,
			singleTextKey = if not FFlagConnectionsToFriendsRename then TextKeys.Connection else TextKeys.Friend,
			enabledKey = SocialCountEnableKeys.IsFriendsCountEnabled,
			getIsDisabled = function(b4: boolean, b5: boolean, b6: boolean) -- line: 57
				-- upvalues: FFlagEnableSocialTabsPage (copy)
				if not b6 then
					return true
				end

				if FFlagEnableSocialTabsPage then
					return false
				end

				if b5 then
					return false
				end

				return not b4
			end
		},
		followersCount = {
			layoutOrder = 3,
			textKey = TextKeys.Followers,
			singleTextKey = TextKeys.Follower,
			enabledKey = SocialCountEnableKeys.IsFollowersCountEnabled,
			getIsDisabled = function(b7: boolean, _: boolean, b9: boolean) -- line: 76
				if not b9 then
					return true
				end

				return not b7
			end
		},
		followingsCount = {
			layoutOrder = 4,
			textKey = TextKeys.Following,
			singleTextKey = TextKeys.Following,
			enabledKey = SocialCountEnableKeys.IsFollowingsCountEnabled,
			getIsDisabled = function(b10: boolean, _: boolean, b12: boolean) -- line: 88
				if not b12 then
					return true
				end

				return not b10
			end
		}
	}
}
