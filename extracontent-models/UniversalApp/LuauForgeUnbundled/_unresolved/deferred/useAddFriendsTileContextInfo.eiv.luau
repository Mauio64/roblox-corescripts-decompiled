local module = require("@luauforge/deferred/eeO")
local module2 = require("@luauforge/deferred/egd")
local useLocalization = require("@luauforge/deferred/egl").Hooks.useLocalization

local useStyle = module2.Core.Style.useStyle
local images = module2.App.ImageSet.Images

local getMutualFriendsText = require("@luauforge/deferred/egh").Utils.getMutualFriendsText

local contextInfoType = require("@luauforge/deferred/eiw").ContextInfoType

local module3 = require("@luauforge/deferred/eix")
local module4 = require("@luauforge/deferred/eiy")
local module5 = require("@luauforge/deferred/eiA")

local v5 = {
	[contextInfoType.MutualFriends] = "icons/status/player/friend",
	[contextInfoType.FollowingUser] = "icons/status/player/following",
	[contextInfoType.FollowingMe] = "icons/status/player/following"
}

local function useAddFriendsTileContextInfo(data)
	local v6 = useStyle()

	local kind = data and data.type
	local mutualFriendsCount = data and data.mutualFriendsCount or 0
	local contactName = data and data.contactName
	local sentFromExperienceName = data and data.sentFromExperienceName

	local v7 = useLocalization({
		mutualConnections = {
			"Feature.Friends.Label.MutualFriendsTitle",
			numConnections = mutualFriendsCount
		},
		singularMutualConnection = "Feature.Friends.Label.MutualFriendTitle",
		contactNameText = contactName and {
			"Feature.Friends.Description.FromContactsV2",
			contactName = contactName
		} or nil,
		sentFromWithContextText = {
			"Feature.Friends.Label.SentFromWithContext",
			gameName = sentFromExperienceName or ""
		},
		fromContactsText = "Feature.Friends.Description.FoundFromContactImporter",
		foundThroughQRCode = "Feature.Profile.Label.QRCodeFriendRequest",
		classmatesText = module3 and "Feature.Schools.Label.Classmates" or nil,
		classmates = module5 and "Feature.Schools.Label.Classmates" or nil,
		youAreFollowingText = "Feature.Friends.Label.YouAreFollowing",
		followsYouText = "Feature.Friends.Label.FollowsYou",
		frequentsText = "Feature.Friends.Label.Frequent",
		fromContactsLabel = "Feature.Friends.Description.FromContacts",
		connectionRequestsText = "Feature.Friends.Label.ConnectionRequest",
		newFriendText = module4 and "Feature.Friends.Label.NewFriend" or nil
	})

	return module.useMemo(function()
		if not kind then
			return nil
		end

		local v8 = nil
		local v9 = nil

		if kind == contextInfoType.MutualFriends then
			v8 = getMutualFriendsText({
				mutualFriendsCount = mutualFriendsCount,
				localized = {
					mutualConnections = v7.mutualConnections,
					singularMutualConnection = v7.singularMutualConnection
				}
			})

			v9 = v5[contextInfoType.MutualFriends]
		elseif kind == contextInfoType.HaveContact then
			v8 = v7.contactNameText
		elseif kind == contextInfoType.FromCI then
			v8 = v7.fromContactsText
		elseif kind == contextInfoType.FromQR then
			v8 = v7.foundThroughQRCode
		elseif kind == contextInfoType.SchoolMemberList then
			v8 = v7.classmatesText
		elseif kind == contextInfoType.FromExperience then
			v8 = v7.sentFromWithContextText
		elseif kind == contextInfoType.FollowingUser then
			v8 = v7.youAreFollowingText
			v9 = v5[contextInfoType.FollowingUser]
		elseif kind == contextInfoType.FollowingMe then
			v8 = v7.followsYouText
			v9 = v5[contextInfoType.FollowingMe]
		elseif kind == contextInfoType.Frequents then
			v8 = v7.frequentsText
		elseif module5 and kind == contextInfoType.Classmates then
			v8 = v7.classmates
		elseif kind == contextInfoType.Contacts then
			v8 = v7.fromContactsLabel
		elseif kind == contextInfoType.OffNetworkFriendRequest then
			v8 = v7.connectionRequestsText
		elseif module4 and kind == contextInfoType.NewFriend then
			v8 = v7.newFriendText
		end

		if not v8 then
			return nil
		end

		local v10 = { text = v8, fontStyle = v6.Font.CaptionBody, icon = 0 }
		local v11 = if v9 then images[v9] else nil
		v10.icon = v11
		return v10
	end, { kind, mutualFriendsCount, contactName, sentFromExperienceName, v7, v6 })
end

return useAddFriendsTileContextInfo
