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

local defineFastFlag = game:DefineFastFlag("SocialMetadataSectionMigrateUserProfileToSignals", false)
local v

if defineFastFlag then
	v = UserProfiles.Stores.UserProfileStore.get()
else
	v = nil
end

return function(props)
	local v2

	if not defineFastFlag then
		v2 = UserProfiles.Hooks.useUserProfilesFetch({
			userIds = { props.userId },
			query = UserProfiles.Queries.userProfilesCombinedNameAndUsernameByUserIds
		})
	end

	local v3, v4

	if defineFastFlag or not (v2 and v2.data) then
		v3 = ""
		v4 = ""
	else
		v3 = UserProfiles.Selectors.getCombinedNameFromId(v2.data, props.userId) or ""
		v4 = UserProfiles.Selectors.getUsernameFromId(v2.data, props.userId) or ""
	end

	if defineFastFlag then
		local v5 = React.useMemo(function()
			return Signals.createComputed(function(p)
				local v5 = v and v.fetchNamesByUserIds({ (tostring(props.userId)) })(p)
				local v6 = v5 and v5.data and v5.data[1]
				local names = v6 and v6.names
				return {
					combinedName = not names and "" or names.getCombinedName(p),
					username = not names and "" or names.getUsername()
				}
			end)
		end, { props.userId })

		local v6 = SignalsReact.useSignalState(v5)
		v4 = v6.username
		v3 = v6.combinedName
	end

	local v5 = {}
	local v6

	if GetFFlagEnableProfileInsightsApolloMigration() then
		v5, v6 = useSignalProfileInsightsByUserId({
			userId = props.userId,
			rankingStrategy = "tc_info_boost",
			forceFetch = true
		})
	else
		local v7 = useProfileInsightsByUserIds({
			userIds = { props.userId },
			rankingStrategy = "tc_info_boost",
			fetchPolicy = "network-only"
		})

		if v7 and v7.data and not v7.loading then
			v5 = getProfileInsightsByUserIdFromData(v7.data, props.userId)
		end

		v6 = v7.loading
	end

	local userAgeVerifiedBracket

	if not isCustomNil(v5.userAgeVerifiedBracket) then
		userAgeVerifiedBracket = v5.userAgeVerifiedBracket
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

	local v7 = useLocalization({
		userAgeVerifiedBracket = userAgeVerifiedBracket,
		yourLinkedParent = "Feature.Friends.Label.YourLinkedParent"
	})

	local state, setState = React.useState(false)

	React.useEffect(function()
		local v8 = {
			{ name = "otherUser", type = "UserId", value = props.userId }
		}
		setState(AmpApiProvider.upsellFeatureAccess("IsLinkedChildOf", {}, FStringParentLinkAmpNameSpace, v8).access == AccessResponseEnum.Granted)
	end, { props.userId })

	local v8 = React.useMemo(function()
		if v7.userAgeVerifiedBracket then
			return ` • {v7.userAgeVerifiedBracket}`
		end

		return nil
	end, { v7.userAgeVerifiedBracket })

	local avatarWithNames = React.useMemo(function()
		local v9 = Foundation.Hooks.useTokens()
		local createElement = React.createElement
		local createElement2 = React.createElement
		local v10 = {
			userId = props.userId,
			userPresenceType = Foundation.Enums.UserPresence.None,
			layoutMode = LayoutMode.wide,
			title = 0,
			subtitle = 0,
			titleStyle = 0,
			subtitleStyle = 0,
			onActivated = nil
		}
		local title = if state then v7.yourLinkedParent else v3
		v10.title = title
		local subtitle

		if v4 ~= "" then
			subtitle = `@{v4}{v8 or ""}`
		end

		v10.subtitle = subtitle
		v10.titleStyle = v9.Typography.TitleMedium
		v10.subtitleStyle = v9.Typography.BodyMedium
		return createElement(View, {
			tag = "size-0-1200 auto-x row align-y-center",
			LayoutOrder = 1
		}, {
			UserTile = createElement2(userTile, v10)
		})
	end, { props.userId, v3, state, setState, v7.yourLinkedParent, v4, v8 })

	local profileInsightIconItems = React.useMemo(function()
		local mutualFriends

		if not isCustomNil(v5.mutualFriends) then
			mutualFriends = v5.mutualFriends
		end

		local friendshipAgeUnixSeconds

		if not isCustomNil(v5.friendshipAgeUnixSeconds) then
			friendshipAgeUnixSeconds = v5.friendshipAgeUnixSeconds
		end

		local friendRequestOriginSource

		if not isCustomNil(v5.friendRequestOriginSource) then
			friendRequestOriginSource = v5.friendRequestOriginSource
		end

		local accountCreationDateUnixSeconds

		if not isCustomNil(v5.accountCreationDateUnixSeconds) then
			accountCreationDateUnixSeconds = v5.accountCreationDateUnixSeconds
		end

		local localizedCountryName

		if not isCustomNil(v5.localizedCountryName) then
			localizedCountryName = v5.localizedCountryName
		end

		return {
			mutualFriends = mutualFriends,
			friendshipAgeUnixSeconds = friendshipAgeUnixSeconds,
			friendRequestOriginSource = friendRequestOriginSource,
			accountCreationDateUnixSeconds = accountCreationDateUnixSeconds,
			localizedCountryName = localizedCountryName,
			isClassmate = FFlagTFClassmatesProfileInsight and v5.isClassmate == true and true or nil
		}
	end, { v5 })

	local createElement = React.createElement
	local v9 = {
		tag = {
			["col size-full-0 auto-y align-x-left radius-medium bg-shift-100"] = true,
			["gap-medium padding-medium"] = props.isVerticallyConstrained,
			["gap-large padding-large"] = not props.isVerticallyConstrained
		},
		LayoutOrder = 2
	}
	local socialMetadataIconAndTextList

	if v6 then
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

	return createElement(View, v9, {
		AvatarWithNames = avatarWithNames,
		SocialMetadataIconAndTextList = socialMetadataIconAndTextList
	})
end
