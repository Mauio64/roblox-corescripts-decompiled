local TrustedContacts = script:FindFirstAncestor("TrustedContacts")
local TrustedContactsParent = TrustedContacts.Parent
local FriendRequestOriginSource = require(TrustedContactsParent.ApolloProfileInsights).Enums.FriendRequestOriginSource
local LocalizationService = game:GetService("LocalizationService")
local React = require(TrustedContactsParent.React)
local useLocalization = require(TrustedContactsParent.Localization).Hooks.useLocalization
local Icon = require(TrustedContactsParent.BuilderIcons).Icon
local FFlagConnectionsToFriendsRename = require(TrustedContactsParent.SharedFlags).FFlagConnectionsToFriendsRename
local FFlagTFNonFriendsPermitted = require(TrustedContacts.Flags.FFlagTFNonFriendsPermitted)
local t1 = {
	mutualFriends = Icon.TwoPeople,
	friendshipAgeUnixSeconds = Icon.Calendar,
	qrCode = Icon.SquaresGridQr,
	search = Icon.MagnifyingGlass,
	contacts = Icon.SmartphonePortrait,
	accountCreationDateUnixSeconds = Icon.CircleI,
	localizedCountryName = Icon.GlobeDetailed,
	notAFriend = if not FFlagTFNonFriendsPermitted then nil else Icon.TriangleExclamation,
	noMutualFriends = if not FFlagTFNonFriendsPermitted then nil else Icon.TriangleExclamation
}

local function v11(p1, p2, p3) -- line: 56
	-- upvalues: FriendRequestOriginSource (copy)
	local joinedInYear = nil

	if p1 == "friendshipAgeUnixSeconds" then
		return p3.connectedDuration
	end

	if p1 == "friendRequestOriginSource" then
		if p2 == FriendRequestOriginSource.QrCode then
			return p3.fromQrCode
		end

		if p2 == FriendRequestOriginSource.PhoneContactImporter then
			return p3.fromContacts
		end

		if p2 == FriendRequestOriginSource.PlayerSearch then
			return p3.fromSearch
		end
	elseif p1 == "mutualFriends" then
		if #p2 > 1 then
			return p3.mutualConnections
		end

		if #p2 == 1 then
			return p3.singularMutualConnection
		end
	else
		if p1 == "localizedCountryName" then
			return p2
		end

		if p1 == "accountCreationDateUnixSeconds" then
			joinedInYear = p3.joinedInYear
		end
	end

	return joinedInYear
end
local function useProfileInsightsToIconsAndTexts(t2: {[any]: any}) -- line: 85
	-- upvalues: React (copy), FFlagConnectionsToFriendsRename (copy), LocalizationService (copy), useLocalization (copy), FFlagTFNonFriendsPermitted (copy), FriendRequestOriginSource (copy), t1 (copy), v11 (copy)
	local v21 = React.useMemo(function() -- line: 88
		-- upvalues: t2 (copy), FFlagConnectionsToFriendsRename (copy)
		if t2.friendshipAgeUnixSeconds then
			local v25 = DateTime.now().UnixTimestamp - t2.friendshipAgeUnixSeconds or 0
			local v26 = math.floor(v25 / 31536000)
			local v27 = math.floor(v25 / 2592000)
			local v28 = math.floor(v25 / 86400)

			if v26 > 1 then
				return {
					"Feature.Friends.Label.ConnectedNumYears",
					num = v26
				}
			end

			if v26 == 1 then
				return "Feature.Friends.Label.ConnectedOneYear"
			end

			if v27 > 1 then
				return {
					"Feature.Friends.Label.ConnectedNumMonths",
					num = v27
				}
			end

			if v27 == 1 then
				return "Feature.Friends.Label.ConnectedOneMonth"
			end

			if v28 > 1 then
				return {
					"Feature.Friends.Label.ConnectedNumDays",
					num = v28
				}
			end

			if v28 == 1 then
				return "Feature.Friends.Label.ConnectedOneDay"
			end

			if FFlagConnectionsToFriendsRename then
				return "Feature.Friends.Label.NewFriend"
			end

			return "Feature.Friends.Label.NewConnection"
		end

		return nil
	end, { t2.friendshipAgeUnixSeconds })
	local v22 = DateTime.fromUnixTimestamp(t2.accountCreationDateUnixSeconds or 0):FormatLocalTime("YYYY", LocalizationService.RobloxLocaleId)
	local v23 = useLocalization({
		singularMutualConnection = "Feature.Friends.Label.MutualFriendTitle",
		fromQrCode = "Feature.Friends.Description.FromQrCode",
		fromContacts = "Feature.Friends.Description.FromContacts",
		fromSearch = "Feature.PlayerSearchResults.Label.FromSearch",
		mutualConnections = {
			not FFlagConnectionsToFriendsRename and "Feature.Friends.Label.MutualConnections" or "Feature.Friends.Label.MutualFriendsTitle",
			numConnections = t2.mutualFriends and #t2.mutualFriends or 0
		},
		joinedInYear = {
			"Feature.Friends.Label.JoinedInYear",
			year = v22
		},
		connectedDuration = v21,
		notAFriend = if not FFlagTFNonFriendsPermitted then nil else "Feature.Friends.Description.NotAFriend",
		noMutualFriends = if not FFlagTFNonFriendsPermitted then nil else "Feature.Friends.Description.NoMutualFriends"
	})
	local t3 = {}

	return React.useMemo(function() -- line: 140
		-- upvalues: t2 (copy), FriendRequestOriginSource (copy), t1 (copy), v11 (copy), v23 (copy), t3 (copy), FFlagTFNonFriendsPermitted (copy)
		for v29, v30 in t2 do
			local v32

			if v29 == "friendRequestOriginSource" then
				local s1 = nil

				if v30 == FriendRequestOriginSource.QrCode then
					s1 = "qrCode"
				elseif v30 == FriendRequestOriginSource.PhoneContactImporter then
					s1 = "contacts"
				elseif v30 == FriendRequestOriginSource.PlayerSearch then
					s1 = "search"
				end

				v32 = t1[s1]
			else
				v32 = t1[v29]
			end

			local v33 = v11(v29, v30, v23)

			if v32 and v33 then
				table.insert(t3, {
					icon = v32,
					text = v33
				})
			end
		end

		if FFlagTFNonFriendsPermitted then
			if t2.friendshipAgeUnixSeconds == nil then
				table.insert(t3, {
					icon = t1.notAFriend,
					text = v23.notAFriend
				})
			end

			if t2.mutualFriends == nil or next(t2.mutualFriends) == nil then
				table.insert(t3, {
					icon = t1.noMutualFriends,
					text = v23.noMutualFriends
				})
			end
		end

		return t3
	end, {
		v23,
		t2
	})
end

return useProfileInsightsToIconsAndTexts
