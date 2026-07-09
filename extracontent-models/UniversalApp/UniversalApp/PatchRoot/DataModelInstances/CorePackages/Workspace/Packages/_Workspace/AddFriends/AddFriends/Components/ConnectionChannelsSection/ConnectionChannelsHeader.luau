local AddFriends = script:FindFirstAncestor("AddFriends")
local AddFriendsParent = AddFriends.Parent
local React = require(AddFriendsParent.React)
local AddFriendsSectionHeaderFrame = require(AddFriends.Components.AddFriendsSectionHeaderFrame)
local UserListHeader = require(AddFriendsParent.UserList).UserListHeader
local AmpApiProvider = require(AddFriendsParent.AmpUpsell).AmpApiProvider
local AccessResponseEnum = require(AddFriendsParent.AmpUpsell).AmpEnums.AccessResponseEnum
local useLocalization = require(AddFriendsParent.Localization).Hooks.useLocalization
local SharedFlags = require(AddFriendsParent.SharedFlags)
local FStringCanAccessTrustedContactsAmpFeature = SharedFlags.FStringCanAccessTrustedContactsAmpFeature
local FStringCanAccessTrustedContactsAmpNameSpace = SharedFlags.FStringCanAccessTrustedContactsAmpNameSpace
local FFlagAddFriendsUserListEnabled = SharedFlags.FFlagAddFriendsUserListEnabled

local function ConnectionChannelsHeader(t1: {[any]: any}) -- line: 24
	-- upvalues: React (copy), AmpApiProvider (copy), FStringCanAccessTrustedContactsAmpFeature (copy), FStringCanAccessTrustedContactsAmpNameSpace (copy), AccessResponseEnum (copy), useLocalization (copy), FFlagAddFriendsUserListEnabled (copy), UserListHeader (copy), AddFriendsSectionHeaderFrame (copy)
	local v15 = t1.layoutOrder or 1
	local v16, v17 = React.useState(false)

	React.useEffect(function() -- line: 28
		-- upvalues: AmpApiProvider (copy), FStringCanAccessTrustedContactsAmpFeature (copy), FStringCanAccessTrustedContactsAmpNameSpace (copy), AccessResponseEnum (copy), v17 (copy)
		if AmpApiProvider.upsellFeatureAccess(FStringCanAccessTrustedContactsAmpFeature, {}, FStringCanAccessTrustedContactsAmpNameSpace).access == AccessResponseEnum.Granted then
			v17(true)
		end
	end, {})

	local v18 = useLocalization({
		title = "Feature.Friends.TrustedFriend.Label.AddTrustedFriends"
	})

	if not v16 then
		return nil
	end

	if FFlagAddFriendsUserListEnabled then
		return React.createElement(UserListHeader, {
			title = v18.title,
			layoutOrder = v15
		})
	end

	return React.createElement(AddFriendsSectionHeaderFrame, {
		title = v18.title,
		layoutOrder = v15
	})
end

return ConnectionChannelsHeader
