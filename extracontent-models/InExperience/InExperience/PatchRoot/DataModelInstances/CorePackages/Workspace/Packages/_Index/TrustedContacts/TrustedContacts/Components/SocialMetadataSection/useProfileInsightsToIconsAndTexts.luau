local TrustedContacts = script:FindFirstAncestor("TrustedContacts")
local parent = TrustedContacts.Parent

local ApolloProfileInsights = require(parent.ApolloProfileInsights)

local FriendRequestOriginSource = ApolloProfileInsights.Enums.FriendRequestOriginSource

local LocalizationService = game:GetService("LocalizationService")

local React = require(parent.React)

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local BuilderIcons = require(parent.BuilderIcons)
local Icon = BuilderIcons.Icon

local FFlagTFNonFriendsPermitted = require(TrustedContacts.Flags.FFlagTFNonFriendsPermitted)
local SharedFlags = require(parent.SharedFlags)
local FFlagTFClassmatesProfileInsight = SharedFlags.FFlagTFClassmatesProfileInsight

local v = {
	mutualFriends = Icon.TwoPeople,
	friendshipAgeUnixSeconds = Icon.Calendar,
	qrCode = Icon.SquaresGridQr,
	search = Icon.MagnifyingGlass,
	contacts = Icon.SmartphonePortrait,
	accountCreationDateUnixSeconds = Icon.CircleI,
	localizedCountryName = Icon.GlobeDetailed,
	isClassmate = 0,
	notAFriend = 0,
	noMutualFriends = 0
}
local isClassmate

if FFlagTFClassmatesProfileInsight then
	isClassmate = Icon.PersonGraduate
end

v.isClassmate = isClassmate
local notAFriend

if FFlagTFNonFriendsPermitted then
	notAFriend = Icon.TriangleExclamation
end

v.notAFriend = notAFriend
local noMutualFriends

if FFlagTFNonFriendsPermitted then
	noMutualFriends = Icon.TriangleExclamation
end

v.noMutualFriends = noMutualFriends

local function fn(k, list, data)
	local v2 = nil

	if k == "friendshipAgeUnixSeconds" then
		return data.connectedDuration
	end

	if k == "friendRequestOriginSource" then
		if list == FriendRequestOriginSource.QrCode then
			return data.fromQrCode
		end

		if list == FriendRequestOriginSource.PhoneContactImporter then
			return data.fromContacts
		end

		if list == FriendRequestOriginSource.PlayerSearch then
			return data.fromSearch
		end
	elseif k == "mutualFriends" then
		if #list > 1 then
			return data.mutualConnections
		end

		if #list == 1 then
			return data.singularMutualConnection
		end
	else
		if k == "localizedCountryName" then
			return list
		elseif k == "accountCreationDateUnixSeconds" then
			return data.joinedInYear
		end

		if not FFlagTFClassmatesProfileInsight or k ~= "isClassmate" then
			return v2
		end

		if list then
			return data.classmates
		end
	end

	return v2
end

local function fn2(k, p) -- 1 equivalent call inferred from this helper
	if k ~= "friendRequestOriginSource" then
		return v[k]
	end

	return v[p == FriendRequestOriginSource.QrCode and "qrCode" or p == FriendRequestOriginSource.PhoneContactImporter and "contacts" or p == FriendRequestOriginSource.PlayerSearch and "search" or nil]
end

local function useProfileInsightsToIconsAndTexts(p)
	local connectedDuration = React.useMemo(function()
		if not p.friendshipAgeUnixSeconds then
			return nil
		end

		local v2 = DateTime.now().UnixTimestamp - p.friendshipAgeUnixSeconds or 0
		local num = math.floor(v2 / 31536000)
		local num2 = math.floor(v2 / 2592000)
		local num3 = math.floor(v2 / 86400)

		if num > 1 then
			return {
				"Feature.Friends.Label.ConnectedNumYears",
				num = num
			}
		end

		if num == 1 then
			return "Feature.Friends.Label.ConnectedOneYear"
		end

		if num2 > 1 then
			return {
				"Feature.Friends.Label.ConnectedNumMonths",
				num = num2
			}
		end

		if num2 == 1 then
			return "Feature.Friends.Label.ConnectedOneMonth"
		end

		if num3 > 1 then
			return {
				"Feature.Friends.Label.ConnectedNumDays",
				num = num3
			}
		end

		if num3 == 1 then
			return "Feature.Friends.Label.ConnectedOneDay"
		end

		return "Feature.Friends.Label.NewFriend"
	end, { p.friendshipAgeUnixSeconds })

	local formatLocalTime = DateTime.fromUnixTimestamp(p.accountCreationDateUnixSeconds or 0):FormatLocalTime(
		"YYYY",
		LocalizationService.RobloxLocaleId
	)

	local v2 = useLocalization({
		singularMutualConnection = "Feature.Friends.Label.MutualFriendTitle",
		mutualConnections = {
			"Feature.Friends.Label.MutualFriendsTitle",
			numConnections = p.mutualFriends and #p.mutualFriends or 0
		},
		joinedInYear = {
			"Feature.Friends.Label.JoinedInYear",
			year = formatLocalTime
		},
		connectedDuration = connectedDuration,
		fromQrCode = "Feature.Friends.Description.FromQrCode",
		fromContacts = "Feature.Friends.Description.FromContacts",
		fromSearch = "Feature.PlayerSearchResults.Label.FromSearch",
		classmates = FFlagTFClassmatesProfileInsight and "Feature.Schools.Label.Classmates" or nil,
		notAFriend = FFlagTFNonFriendsPermitted and "Feature.Friends.Description.NotAFriend" or nil,
		noMutualFriends = FFlagTFNonFriendsPermitted and "Feature.Friends.Description.NoMutualFriends" or nil
	})

	local result = {}
	return React.useMemo(function()
		for k, v3 in p do
			local icon = fn2(k, v3) -- inferred equivalent call
			local text = fn(k, v3, v2)

			if icon and text then
				table.insert(result, { icon = icon, text = text })
			end
		end

		if not FFlagTFNonFriendsPermitted then
			return result
		end

		if p.friendshipAgeUnixSeconds == nil then
			table.insert(result, { icon = v.notAFriend, text = v2.notAFriend })
		end

		if p.mutualFriends == nil or next(p.mutualFriends) == nil then
			table.insert(result, { icon = v.noMutualFriends, text = v2.noMutualFriends })
		end

		return result
	end, { v2, p })
end

return useProfileInsightsToIconsAndTexts
