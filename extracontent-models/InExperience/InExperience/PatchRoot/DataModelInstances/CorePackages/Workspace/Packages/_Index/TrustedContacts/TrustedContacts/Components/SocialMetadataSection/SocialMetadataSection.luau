local TrustedContacts = script:FindFirstAncestor("TrustedContacts")
local parent = TrustedContacts.Parent

local React = require(parent.React)
local UserProfiles = require(parent.UserProfiles)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

require(parent.GraphQLServer)

local ApolloProfileInsights = require(parent.ApolloProfileInsights)
local useProfileInsightsByUserIds = ApolloProfileInsights.Hooks.useProfileInsightsByUserIds
local getProfileInsightsByUserIdFromData = ApolloProfileInsights.Selectors.getProfileInsightsByUserIdFromData
local isCustomNil = require(TrustedContacts.Utils.isCustomNil)

local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local Foundation = require(parent.Foundation)
local Skeleton = Foundation.Skeleton

local View = Foundation.View

local UserTile = require(parent.UserTile)
local userTile = UserTile.UserTile
local UserTile2 = require(parent.UserTile)
local LayoutMode = UserTile2.LayoutMode

local SocialMetadataIconsAndTextsSection = require(script.Parent.SocialMetadataIconsAndTextsSection)
local ProfileInsights = require(parent.ProfileInsights)
local useSignalProfileInsightsByUserId = ProfileInsights.useSignalProfileInsightsByUserId
local AmpUpsell = require(parent.AmpUpsell)
local AmpApiProvider = AmpUpsell.AmpApiProvider
local AccessResponseEnum = AmpUpsell.AmpEnums.AccessResponseEnum
local SharedFlags = require(parent.SharedFlags)
local FFlagProfilePlatformAddTC = SharedFlags.FFlagProfilePlatformAddTC
local SharedFlags2 = require(parent.SharedFlags)
local FStringParentLinkAmpNameSpace = SharedFlags2.FStringParentLinkAmpNameSpace

local SharedFlags3 = require(parent.SharedFlags)
local GetFFlagEnableProfileInsightsApolloMigration = SharedFlags3.GetFFlagEnableProfileInsightsApolloMigration
local SharedFlags4 = require(parent.SharedFlags)
local FFlagTFClassmatesProfileInsight = SharedFlags4.FFlagTFClassmatesProfileInsight

local v = UserProfiles.Stores.UserProfileStore.get()

return function(props)
	local v2 = React.useMemo(function()
		return Signals.createComputed(function(p)
			local v2 = v and v.fetchNamesByUserIds({ (tostring(props.userId)) })(p)
			local v3 = v2 and v2.data and v2.data[1]
			local names = v3 and v3.names
			return {
				combinedName = not names and "" or names.getCombinedName(p),
				username = not names and "" or names.getUsername()
			}
		end)
	end, { props.userId })

	local v3 = SignalsReact.useSignalState(v2)
	local username = v3.username
	local combinedName = v3.combinedName

	local v4 = {}
	local v5

	if GetFFlagEnableProfileInsightsApolloMigration() then
		v4, v5 = useSignalProfileInsightsByUserId({
			userId = props.userId,
			rankingStrategy = "tc_info_boost",
			forceFetch = true
		})
	else
		local v6 = useProfileInsightsByUserIds({
			userIds = { props.userId },
			rankingStrategy = "tc_info_boost",
			fetchPolicy = "network-only"
		})

		if v6 and v6.data and not v6.loading then
			v4 = getProfileInsightsByUserIdFromData(v6.data, props.userId)
		end

		v5 = v6.loading
	end

	local userAgeVerifiedBracket

	if not isCustomNil(v4.userAgeVerifiedBracket) then
		userAgeVerifiedBracket = v4.userAgeVerifiedBracket
	end

	local _ = {
		under13 = "AccountIdentity.AgeCheck.Label.AgeBandUnder13",
		under17 = "AccountIdentity.AgeCheck.Label.AgeBandOver13",
		under17checked = "AccountIdentity.AgeCheck.Label.AgeBandOver13Checked",
		over18 = "AccountIdentity.AgeCheck.Label.AgeBandOver18",
		over18checked = "AccountIdentity.AgeCheck.Label.AgeBandOver18Checked",
		ageGroupUnder9 = "AccountIdentity.AgeCheck.Label.AgeGroupUnder9",
		ageGroup9To12 = "AccountIdentity.AgeCheck.Label.AgeGroup9To12",
		ageGroup13To15 = "AccountIdentity.AgeCheck.Label.AgeGroup13To15",
		ageGroup16To17 = "AccountIdentity.AgeCheck.Label.AgeGroup16To17",
		ageGroup18To20 = "AccountIdentity.AgeCheck.Label.AgeGroup18To20",
		ageGroupOver21 = "AccountIdentity.AgeCheck.Label.AgeGroupOver21",
		ageGroup18To24 = "AccountIdentity.AgeCheck.Label.AgeGroup18To24",
		ageGroupOver25 = "AccountIdentity.AgeCheck.Label.AgeGroupOver25"
	}

	local v6 = useLocalization({
		userAgeVerifiedBracket = userAgeVerifiedBracket,
		yourLinkedParent = "Feature.Friends.Label.YourLinkedParent"
	})

	local state, setState = React.useState(false)

	React.useEffect(function()
		local v7 = {
			{ name = "otherUser", type = "UserId", value = props.userId }
		}
		setState(AmpApiProvider.upsellFeatureAccess("IsLinkedChildOf", {}, FStringParentLinkAmpNameSpace, v7).access == AccessResponseEnum.Granted)
	end, { props.userId })

	local v7 = React.useMemo(function()
		if v6.userAgeVerifiedBracket then
			return ` • {v6.userAgeVerifiedBracket}`
		end

		return nil
	end, { v6.userAgeVerifiedBracket })

	local avatarWithNames = React.useMemo(function()
		local v8 = Foundation.Hooks.useTokens()
		local createElement = React.createElement
		local createElement2 = React.createElement
		local v9 = {
			userId = props.userId,
			userPresenceType = Foundation.Enums.UserPresence.None,
			layoutMode = LayoutMode.wide,
			title = 0,
			subtitle = 0,
			titleStyle = 0,
			subtitleStyle = 0,
			onActivated = nil
		}
		local title

		if state then
			title = v6.yourLinkedParent
		else
			title = combinedName
		end

		v9.title = title
		local subtitle

		if username ~= "" then
			subtitle = `@{username}{v7 or ""}`
		end

		v9.subtitle = subtitle
		v9.titleStyle = v8.Typography.TitleMedium
		v9.subtitleStyle = v8.Typography.BodyMedium
		return createElement(View, {
			tag = "size-0-1200 auto-x row align-y-center",
			LayoutOrder = 1
		}, {
			UserTile = createElement2(userTile, v9)
		})
	end, { props.userId, combinedName, state, setState, v6.yourLinkedParent, username, v7 })

	local profileInsightIconItems = React.useMemo(function()
		local mutualFriends

		if not isCustomNil(v4.mutualFriends) then
			mutualFriends = v4.mutualFriends
		end

		local friendshipAgeUnixSeconds

		if not isCustomNil(v4.friendshipAgeUnixSeconds) then
			friendshipAgeUnixSeconds = v4.friendshipAgeUnixSeconds
		end

		local friendRequestOriginSource

		if not isCustomNil(v4.friendRequestOriginSource) then
			friendRequestOriginSource = v4.friendRequestOriginSource
		end

		local accountCreationDateUnixSeconds

		if not isCustomNil(v4.accountCreationDateUnixSeconds) then
			accountCreationDateUnixSeconds = v4.accountCreationDateUnixSeconds
		end

		local localizedCountryName

		if not isCustomNil(v4.localizedCountryName) then
			localizedCountryName = v4.localizedCountryName
		end

		return {
			mutualFriends = mutualFriends,
			friendshipAgeUnixSeconds = friendshipAgeUnixSeconds,
			friendRequestOriginSource = friendRequestOriginSource,
			accountCreationDateUnixSeconds = accountCreationDateUnixSeconds,
			localizedCountryName = localizedCountryName,
			isClassmate = FFlagTFClassmatesProfileInsight and v4.isClassmate == true and true or nil
		}
	end, { v4 })

	local createElement = React.createElement
	local v8 = {
		tag = {
			["col size-full-0 auto-y align-x-left radius-medium bg-shift-100"] = true,
			["gap-medium padding-medium"] = props.isVerticallyConstrained,
			["gap-large padding-large"] = not props.isVerticallyConstrained
		},
		LayoutOrder = 2
	}
	local socialMetadataIconAndTextList

	if v5 then
		socialMetadataIconAndTextList = React.createElement(Skeleton, {
			Size = UDim2.new(1, 0, 0, 50),
			LayoutOrder = not FFlagProfilePlatformAddTC and 2 or props.layoutOrder
		})
	else
		socialMetadataIconAndTextList = React.createElement(SocialMetadataIconsAndTextsSection, {
			profileInsightIconItems = profileInsightIconItems,
			isVerticallyConstrained = props.isVerticallyConstrained,
			layoutOrder = not FFlagProfilePlatformAddTC and 2 or props.layoutOrder
		})
	end

	return createElement(View, v8, {
		AvatarWithNames = avatarWithNames,
		SocialMetadataIconAndTextList = socialMetadataIconAndTextList
	})
end
