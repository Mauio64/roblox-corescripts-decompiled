local TrustedContacts = script:FindFirstAncestor("TrustedContacts")
local TrustedContactsParent = TrustedContacts.Parent
local React = require(TrustedContactsParent.React)
local UserProfiles = require(TrustedContactsParent.UserProfiles)
local useLocalization = require(TrustedContactsParent.Localization).Hooks.useLocalization

require(TrustedContactsParent.GraphQLServer)

local ApolloProfileInsights = require(TrustedContactsParent.ApolloProfileInsights)
local useProfileInsightsByUserIds = ApolloProfileInsights.Hooks.useProfileInsightsByUserIds
local getProfileInsightsByUserIdFromData = ApolloProfileInsights.Selectors.getProfileInsightsByUserIdFromData
local isCustomNil = require(TrustedContacts.Utils.isCustomNil)
local Signals = require(TrustedContactsParent.Signals)
local SignalsReact = require(TrustedContactsParent.SignalsReact)
local Foundation = require(TrustedContactsParent.Foundation)
local Skeleton = Foundation.Skeleton
local View = Foundation.View
local UserTile = require(TrustedContactsParent.UserTile).UserTile
local LayoutMode = require(TrustedContactsParent.UserTile).LayoutMode
local SocialMetadataIconsAndTextsSection = require(script.Parent.SocialMetadataIconsAndTextsSection)
local useSignalProfileInsightsByUserId = require(TrustedContactsParent.ProfileInsights).useSignalProfileInsightsByUserId
local AmpUpsell = require(TrustedContactsParent.AmpUpsell)
local AmpApiProvider = AmpUpsell.AmpApiProvider
local AccessResponseEnum = AmpUpsell.AmpEnums.AccessResponseEnum
local FFlagProfilePlatformAddTC = require(TrustedContactsParent.SharedFlags).FFlagProfilePlatformAddTC
local FFlagTCYourLinkedParentText = require(TrustedContactsParent.SharedFlags).FFlagTCYourLinkedParentText
local FStringParentLinkAmpNameSpace = require(TrustedContactsParent.SharedFlags).FStringParentLinkAmpNameSpace
local GetFFlagEnableProfileInsightsApolloMigration = require(TrustedContactsParent.SharedFlags).GetFFlagEnableProfileInsightsApolloMigration
local v26 = game:DefineFastFlag("SocialMetadataSectionMigrateUserProfileToSignals", false)
local v27 = if not v26 then nil else UserProfiles.Stores.UserProfileStore.get()

return function(t1: {[any]: any}) -- line: 52
	-- upvalues: v26 (copy), UserProfiles (copy), React (copy), Signals (copy), v27 (copy), SignalsReact (copy), GetFFlagEnableProfileInsightsApolloMigration (copy), useSignalProfileInsightsByUserId (copy), useProfileInsightsByUserIds (copy), getProfileInsightsByUserIdFromData (copy), isCustomNil (copy), useLocalization (copy), FFlagTCYourLinkedParentText (copy), AmpApiProvider (copy), FStringParentLinkAmpNameSpace (copy), AccessResponseEnum (copy), Foundation (copy), View (copy), UserTile (copy), LayoutMode (copy), Skeleton (copy), FFlagProfilePlatformAddTC (copy), SocialMetadataIconsAndTextsSection (copy)
	local v29 = if v26 then nil else UserProfiles.Hooks.useUserProfilesFetch({
		userIds = { t1.userId },
		query = UserProfiles.Queries.userProfilesCombinedNameAndUsernameByUserIds
	})
	local s1 = ""
	local s2 = ""

	if not v26 and (v29 and v29.data) then
		s1 = UserProfiles.Selectors.getCombinedNameFromId(v29.data, t1.userId) or ""
		s2 = UserProfiles.Selectors.getUsernameFromId(v29.data, t1.userId) or ""
	end

	if v26 then
		local v32 = React.useMemo(function() -- line: 72
			-- upvalues: Signals (copy), v27 (copy), t1 (copy)
			return Signals.createComputed(function(p1) -- line: 73
				-- upvalues: v27 (copy), t1 (copy)
				local v52 = v27 and v27.fetchNamesByUserIds({ (tostring(t1.userId)) })(p1)
				local v53 = v52 and (v52.data and v52.data[1])
				local v54 = v53 and v53.names

				return {
					combinedName = not v54 and "" or v54.getCombinedName(p1),
					username = not v54 and "" or v54.getUsername()
				}
			end)
		end, { t1.userId })
		local v33 = SignalsReact.useSignalState(v32)

		s2 = v33.username
		s1 = v33.combinedName
	end

	local t2 = {}
	local v36

	if GetFFlagEnableProfileInsightsApolloMigration() then
		local v35

		v35, v36 = useSignalProfileInsightsByUserId({
			rankingStrategy = "tc_info_boost",
			userId = t1.userId
		})
		t2 = v35
	else
		local v37 = useProfileInsightsByUserIds({
			rankingStrategy = "tc_info_boost",
			fetchPolicy = "network-only",
			userIds = { t1.userId }
		})

		if v37 and v37.data and not v37.loading then
			t2 = getProfileInsightsByUserIdFromData(v37.data, t1.userId)
		end

		v36 = v37.loading
	end

	local v38 = if isCustomNil(t2.userAgeVerifiedBracket) then nil else t2.userAgeVerifiedBracket
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
	local v40 = useLocalization({
		userAgeVerifiedBracket = v38,
		yourLinkedParent = if not FFlagTCYourLinkedParentText then nil else "Feature.Friends.Label.YourLinkedParent"
	})
	local u41 = nil
	local u42 = nil

	if FFlagTCYourLinkedParentText then
		local v43, v44 = React.useState(false)

		u41 = v43
		u42 = v44
	end

	React.useEffect(function() -- line: 144
		-- upvalues: FFlagTCYourLinkedParentText (copy), t1 (copy), AmpApiProvider (copy), FStringParentLinkAmpNameSpace (copy), u42 (ref), AccessResponseEnum (copy)
		if FFlagTCYourLinkedParentText then
			local t3 = {
				name = "otherUser",
				type = "UserId",
				value = t1.userId
			}
			local v49 = AmpApiProvider.upsellFeatureAccess("IsLinkedChildOf", {}, FStringParentLinkAmpNameSpace, { t3 })

			u42(v49.access == AccessResponseEnum.Granted)
		end
	end, { t1.userId })

	local v45 = React.useMemo(function() -- line: 159
		-- upvalues: v40 (copy)
		if v40.userAgeVerifiedBracket then
			return ` • { v40.userAgeVerifiedBracket }`
		end

		return nil
	end, { v40.userAgeVerifiedBracket })
	local v46 = React.useMemo(function() -- line: 170
		-- upvalues: Foundation (copy), React (copy), View (copy), UserTile (copy), t1 (copy), LayoutMode (copy), FFlagTCYourLinkedParentText (copy), u41 (ref), v40 (copy), s1 (ref), s2 (ref), v45 (copy)
		local v50 = Foundation.Hooks.useTokens()

		return React.createElement(View, {
			tag = "size-0-1200 auto-x row align-y-center",
			LayoutOrder = 1
		}, {
			UserTile = React.createElement(UserTile, {
				onActivated = nil,
				userId = t1.userId,
				userPresenceType = Foundation.Enums.UserPresence.None,
				layoutMode = LayoutMode.wide,
				title = if not FFlagTCYourLinkedParentText or not u41 then s1 else v40.yourLinkedParent,
				subtitle = if s2 == "" then nil else `@{ s2 }{ v45 or "" }`,
				titleStyle = v50.Typography.TitleMedium,
				subtitleStyle = v50.Typography.BodyMedium
			})
		})
	end, {
		t1.userId,
		s1,
		if not FFlagTCYourLinkedParentText then nil else u41,
		if not FFlagTCYourLinkedParentText then nil else u42,
		if not FFlagTCYourLinkedParentText then nil else v40.yourLinkedParent,
		s2,
		v45
	})
	local v47 = React.useMemo(function() -- line: 199
		-- upvalues: isCustomNil (copy), t2 (ref)
		return {
			mutualFriends = if isCustomNil(t2.mutualFriends) then nil else t2.mutualFriends,
			friendshipAgeUnixSeconds = if isCustomNil(t2.friendshipAgeUnixSeconds) then nil else t2.friendshipAgeUnixSeconds,
			friendRequestOriginSource = if isCustomNil(t2.friendRequestOriginSource) then nil else t2.friendRequestOriginSource,
			accountCreationDateUnixSeconds = if isCustomNil(t2.accountCreationDateUnixSeconds) then nil else t2.accountCreationDateUnixSeconds,
			localizedCountryName = if isCustomNil(t2.localizedCountryName) then nil else t2.localizedCountryName
		}
	end, { t2 })

	return React.createElement(View, {
		LayoutOrder = 2,
		tag = {
			["col size-full-0 auto-y align-x-left radius-medium bg-shift-100"] = true,
			["gap-medium padding-medium"] = t1.isVerticallyConstrained,
			["gap-large padding-large"] = not t1.isVerticallyConstrained
		}
	}, {
		AvatarWithNames = v46,
		SocialMetadataIconAndTextList = if not v36 then React.createElement(SocialMetadataIconsAndTextsSection, {
			profileInsightIconItems = v47,
			isVerticallyConstrained = t1.isVerticallyConstrained,
			layoutOrder = not FFlagProfilePlatformAddTC and 2 or t1.layoutOrder
		}) else React.createElement(Skeleton, {
			Size = UDim2.new(1, 0, 0, 50),
			LayoutOrder = not FFlagProfilePlatformAddTC and 2 or t1.layoutOrder
		})
	})
end
