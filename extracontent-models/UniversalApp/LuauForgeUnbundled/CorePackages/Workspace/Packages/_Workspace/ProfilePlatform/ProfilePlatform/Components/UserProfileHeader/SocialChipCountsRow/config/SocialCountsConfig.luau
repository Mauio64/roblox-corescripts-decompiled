local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/TextKeys")
local socialCountEnableKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums").SocialCountEnableKeys
local avatarGroupType = Foundation.Enums.AvatarGroupType

local fFlagEnableSocialTabsPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagEnableSocialTabsPage

return {
	RowConfig = {
		mutualFriendsCount = {
			layoutOrder = 1,
			textKey = TextKeys.MutualsText,
			singleTextKey = TextKeys.MutualText,
			enabledKey = socialCountEnableKeys.IsMutualFriendsCountEnabled,
			getIsDisabled = function(p2, p3, p4): boolean
				if p4 then
					return false
				end

				return true
			end,
			getLeading = function(p2)
				local v5 = { table.unpack(p2.mutualFriendIds, 1, (math.min(2, #p2.mutualFriendIds))) }

				if v5 and #v5 > 0 then
					return {
						type = "AvatarGroup",
						props = {
							avatars = v5,
							type = avatarGroupType.Stacked,
							max = 2
						}
					}
				end

				return nil
			end
		},
		friendsCount = {
			layoutOrder = 2,
			textKey = TextKeys.Friends,
			singleTextKey = TextKeys.Friend,
			enabledKey = socialCountEnableKeys.IsFriendsCountEnabled,
			getIsDisabled = function(p2, p3, p4): boolean
				if not p4 then
					return true
				end

				if fFlagEnableSocialTabsPage or p3 then
					return false
				end

				return not p2
			end
		},
		followersCount = {
			layoutOrder = 3,
			textKey = TextKeys.Followers,
			singleTextKey = TextKeys.Follower,
			enabledKey = socialCountEnableKeys.IsFollowersCountEnabled,
			getIsDisabled = function(p2, p3, p4): boolean
				if p4 then
					return not p2
				end

				return true
			end
		},
		followingsCount = {
			layoutOrder = 4,
			textKey = TextKeys.Following,
			singleTextKey = TextKeys.Following,
			enabledKey = socialCountEnableKeys.IsFollowingsCountEnabled,
			getIsDisabled = function(p2, p3, p4): boolean
				if p4 then
					return not p2
				end

				return true
			end
		}
	}
}
