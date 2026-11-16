local friendRequestOriginSource = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/ApolloProfileInsights").Enums.FriendRequestOriginSource

local LocalizationService = game:GetService("LocalizationService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/React")

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/Localization").Hooks.useLocalization

local icon = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/BuilderIcons").Icon

local FFlagTFNonFriendsPermitted = require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Flags/FFlagTFNonFriendsPermitted")
local fFlagTFClassmatesProfileInsight = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/SharedFlags").FFlagTFClassmatesProfileInsight

local v5 = {
	mutualFriends = icon.TwoPeople,
	friendshipAgeUnixSeconds = icon.Calendar,
	qrCode = icon.SquaresGridQr,
	search = icon.MagnifyingGlass,
	contacts = icon.SmartphonePortrait,
	accountCreationDateUnixSeconds = icon.CircleI,
	localizedCountryName = icon.GlobeDetailed,
	isClassmate = 0,
	notAFriend = 0,
	noMutualFriends = 0
}
local v6 = if fFlagTFClassmatesProfileInsight then icon.PersonGraduate else nil
v5.isClassmate = v6
local v7 = if FFlagTFNonFriendsPermitted then icon.TriangleExclamation else nil
v5.notAFriend = v7
local v8 = if FFlagTFNonFriendsPermitted then icon.TriangleExclamation else nil
v5.noMutualFriends = v8

local function fn(k, list, data)
	local v9 = nil

	if k == "friendshipAgeUnixSeconds" then
		return data.connectedDuration
	end

	if k == "friendRequestOriginSource" then
		if list == friendRequestOriginSource.QrCode then
			return data.fromQrCode
		end

		if list == friendRequestOriginSource.PhoneContactImporter then
			return data.fromContacts
		end

		if list == friendRequestOriginSource.PlayerSearch then
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

		if not fFlagTFClassmatesProfileInsight or k ~= "isClassmate" then
			return v9
		end

		if list then
			return data.classmates
		end
	end

	return v9
end

local function useProfileInsightsToIconsAndTexts(p2)
	local v9 = React.useMemo(function()
		if not p2.friendshipAgeUnixSeconds then
			return nil
		end

		local v10 = DateTime.now().UnixTimestamp - p2.friendshipAgeUnixSeconds or 0
		local v11 = math.floor(v10 / 31536000)
		local v12 = math.floor(v10 / 2592000)
		local v13 = math.floor(v10 / 86400)

		if v11 > 1 then
			return {
				"Feature.Friends.Label.ConnectedNumYears",
				num = v11
			}
		end

		if v11 == 1 then
			return "Feature.Friends.Label.ConnectedOneYear"
		end

		if v12 > 1 then
			return {
				"Feature.Friends.Label.ConnectedNumMonths",
				num = v12
			}
		end

		if v12 == 1 then
			return "Feature.Friends.Label.ConnectedOneMonth"
		end

		if v13 > 1 then
			return {
				"Feature.Friends.Label.ConnectedNumDays",
				num = v13
			}
		end

		if v13 == 1 then
			return "Feature.Friends.Label.ConnectedOneDay"
		end

		return "Feature.Friends.Label.NewFriend"
	end, { p2.friendshipAgeUnixSeconds })

	local formatLocalTime = DateTime.fromUnixTimestamp(p2.accountCreationDateUnixSeconds or 0):FormatLocalTime(
		"YYYY",
		LocalizationService.RobloxLocaleId
	)

	local v10 = useLocalization({
		singularMutualConnection = "Feature.Friends.Label.MutualFriendTitle",
		mutualConnections = {
			"Feature.Friends.Label.MutualFriendsTitle",
			numConnections = p2.mutualFriends and #p2.mutualFriends or 0
		},
		joinedInYear = {
			"Feature.Friends.Label.JoinedInYear",
			year = formatLocalTime
		},
		connectedDuration = v9,
		fromQrCode = "Feature.Friends.Description.FromQrCode",
		fromContacts = "Feature.Friends.Description.FromContacts",
		fromSearch = "Feature.PlayerSearchResults.Label.FromSearch",
		classmates = fFlagTFClassmatesProfileInsight and "Feature.Schools.Label.Classmates" or nil,
		notAFriend = FFlagTFNonFriendsPermitted and "Feature.Friends.Description.NotAFriend" or nil,
		noMutualFriends = FFlagTFNonFriendsPermitted and "Feature.Friends.Description.NoMutualFriends" or nil
	})

	local result = {}
	return React.useMemo(function()
		for k, v11 in p2 do
			local v12

			if k == "friendRequestOriginSource" then
				v12 = v5[v11 == friendRequestOriginSource.QrCode and "qrCode" or v11 == friendRequestOriginSource.PhoneContactImporter and "contacts" or v11 == friendRequestOriginSource.PlayerSearch and "search" or nil]
			else
				v12 = v5[k]
			end

			local v13 = fn(k, v11, v10)

			if v12 and v13 then
				table.insert(result, { icon = v12, text = v13 })
			end
		end

		if not FFlagTFNonFriendsPermitted then
			return result
		end

		if p2.friendshipAgeUnixSeconds == nil then
			table.insert(result, { icon = v5.notAFriend, text = v10.notAFriend })
		end

		if p2.mutualFriends == nil or next(p2.mutualFriends) == nil then
			table.insert(result, {
				icon = v5.noMutualFriends,
				text = v10.noMutualFriends
			})
		end

		return result
	end, { v10, p2 })
end

return useProfileInsightsToIconsAndTexts
