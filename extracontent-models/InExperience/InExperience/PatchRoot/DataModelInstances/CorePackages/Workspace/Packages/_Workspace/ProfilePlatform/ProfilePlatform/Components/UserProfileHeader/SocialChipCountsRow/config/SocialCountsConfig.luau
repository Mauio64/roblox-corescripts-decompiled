local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local Foundation = require(parent.Foundation)
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local Enums = require(ProfilePlatform.Common.Enums)

local SocialCountEnableKeys = Enums.SocialCountEnableKeys
local AvatarGroupType = Foundation.Enums.AvatarGroupType

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableSocialTabsPage = SharedFlags.FFlagEnableSocialTabsPage

return {
	RowConfig = {
		mutualFriendsCount = {
			layoutOrder = 1,
			textKey = TextKeys.MutualsText,
			singleTextKey = TextKeys.MutualText,
			enabledKey = SocialCountEnableKeys.IsMutualFriendsCountEnabled,
			getIsDisabled = function(_: boolean, _: boolean, flag: boolean): boolean
				return not flag
			end,
			getLeading = function(p)
				local avatars = { table.unpack(p.mutualFriendIds, 1, (math.min(2, #p.mutualFriendIds))) }

				if avatars and #avatars > 0 then
					return {
						type = "AvatarGroup",
						props = { avatars = avatars, type = AvatarGroupType.Stacked, max = 2 }
					}
				end

				return nil
			end
		},
		friendsCount = {
			layoutOrder = 2,
			textKey = TextKeys.Friends,
			singleTextKey = TextKeys.Friend,
			enabledKey = SocialCountEnableKeys.IsFriendsCountEnabled,
			getIsDisabled = function(flag: boolean, flag2: boolean, flag3: boolean): boolean
				return not flag3 or not FFlagEnableSocialTabsPage and not flag2 and not flag
			end
		},
		followersCount = {
			layoutOrder = 3,
			textKey = TextKeys.Followers,
			singleTextKey = TextKeys.Follower,
			enabledKey = SocialCountEnableKeys.IsFollowersCountEnabled,
			getIsDisabled = function(flag: boolean, _: boolean, flag2: boolean): boolean
				return not flag2 or not flag
			end
		},
		followingsCount = {
			layoutOrder = 4,
			textKey = TextKeys.Following,
			singleTextKey = TextKeys.Following,
			enabledKey = SocialCountEnableKeys.IsFollowingsCountEnabled,
			getIsDisabled = function(flag: boolean, _: boolean, flag2: boolean): boolean
				return not flag2 or not flag
			end
		}
	}
}
