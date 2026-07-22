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
local FStringParentLinkAmpNameSpace = require(TrustedContactsParent.SharedFlags).FStringParentLinkAmpNameSpace
local GetFFlagEnableProfileInsightsApolloMigration = require(TrustedContactsParent.SharedFlags).GetFFlagEnableProfileInsightsApolloMigration
local v25 = game:DefineFastFlag("SocialMetadataSectionMigrateUserProfileToSignals", false)
local v26 = if not v25 then nil else UserProfiles.Stores.UserProfileStore.get()

return function(t1: {[any]: any}) -- line: 51
	-- upvalues: v25 (copy), UserProfiles (copy), React (copy), Signals (copy), v26 (copy), SignalsReact (copy), GetFFlagEnableProfileInsightsApolloMigration (copy), useSignalProfileInsightsByUserId (copy), useProfileInsightsByUserIds (copy), getProfileInsightsByUserIdFromData (copy), isCustomNil (copy), useLocalization (copy), AmpApiProvider (copy), FStringParentLinkAmpNameSpace (copy), AccessResponseEnum (copy), Foundation (copy), View (copy), UserTile (copy), LayoutMode (copy), Skeleton (copy), FFlagProfilePlatformAddTC (copy), SocialMetadataIconsAndTextsSection (copy)
	local v28 = if v25 then nil else UserProfiles.Hooks.useUserProfilesFetch({
		userIds = { t1.userId },
		query = UserProfiles.Queries.userProfilesCombinedNameAndUsernameByUserIds
	})
	local s1 = ""
	local s2 = ""

	if not v25 and (v28 and v28.data) then
		s1 = UserProfiles.Selectors.getCombinedNameFromId(v28.data, t1.userId) or ""
		s2 = UserProfiles.Selectors.getUsernameFromId(v28.data, t1.userId) or ""
	end

	if v25 then
		local v31 = React.useMemo(function() -- line: 71
			-- upvalues: Signals (copy), v26 (copy), t1 (copy)
			return Signals.createComputed(function(p1) -- line: 72
				-- upvalues: v26 (copy), t1 (copy)
				local v51 = v26 and v26.fetchNamesByUserIds({ (tostring(t1.userId)) })(p1)
				local v52 = v51 and (v51.data and v51.data[1])
				local v53 = v52 and v52.names

				return {
					combinedName = not v53 and "" or v53.getCombinedName(p1),
					username = not v53 and "" or v53.getUsername()
				}
			end)
		end, { t1.userId })
		local v32 = SignalsReact.useSignalState(v31)

		s2 = v32.username
		s1 = v32.combinedName
	end

	local t2 = {}
	local v35

	if GetFFlagEnableProfileInsightsApolloMigration() then
		local v34

		v34, v35 = useSignalProfileInsightsByUserId({
			rankingStrategy = "tc_info_boost",
			userId = t1.userId
		})
		t2 = v34
	else
		local v36 = useProfileInsightsByUserIds({
			rankingStrategy = "tc_info_boost",
			fetchPolicy = "network-only",
			userIds = { t1.userId }
		})

		if v36 and v36.data and not v36.loading then
			t2 = getProfileInsightsByUserIdFromData(v36.data, t1.userId)
		end

		v35 = v36.loading
	end

	local v37 = if isCustomNil(t2.userAgeVerifiedBracket) then nil else t2.userAgeVerifiedBracket
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
	local v39 = useLocalization({
		yourLinkedParent = "Feature.Friends.Label.YourLinkedParent",
		userAgeVerifiedBracket = v37
	})
	local v40, v41 = React.useState(false)
	local u42 = v40
	local u43 = v41

	React.useEffect(function() -- line: 139
		-- upvalues: t1 (copy), AmpApiProvider (copy), FStringParentLinkAmpNameSpace (copy), u43 (ref), AccessResponseEnum (copy)
		local t3 = {
			name = "otherUser",
			type = "UserId",
			value = t1.userId
		}
		local v48 = AmpApiProvider.upsellFeatureAccess("IsLinkedChildOf", {}, FStringParentLinkAmpNameSpace, { t3 })

		u43(v48.access == AccessResponseEnum.Granted)
	end, { t1.userId })

	local v44 = React.useMemo(function() -- line: 152
		-- upvalues: v39 (copy)
		if v39.userAgeVerifiedBracket then
			return ` • { v39.userAgeVerifiedBracket }`
		end

		return nil
	end, { v39.userAgeVerifiedBracket })
	local v45 = React.useMemo(function() -- line: 163
		-- upvalues: Foundation (copy), React (copy), View (copy), UserTile (copy), t1 (copy), LayoutMode (copy), u42 (ref), v39 (copy), s1 (ref), s2 (ref), v44 (copy)
		local v49 = Foundation.Hooks.useTokens()

		return React.createElement(View, {
			tag = "size-0-1200 auto-x row align-y-center",
			LayoutOrder = 1
		}, {
			UserTile = React.createElement(UserTile, {
				onActivated = nil,
				userId = t1.userId,
				userPresenceType = Foundation.Enums.UserPresence.None,
				layoutMode = LayoutMode.wide,
				title = if not u42 then s1 else v39.yourLinkedParent,
				subtitle = if s2 == "" then nil else `@{ s2 }{ v44 or "" }`,
				titleStyle = v49.Typography.TitleMedium,
				subtitleStyle = v49.Typography.BodyMedium
			})
		})
	end, {
		t1.userId,
		s1,
		u42,
		u43,
		v39.yourLinkedParent,
		s2,
		v44
	})
	local v46 = React.useMemo(function() -- line: 190
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
		AvatarWithNames = v45,
		SocialMetadataIconAndTextList = if not v35 then React.createElement(SocialMetadataIconsAndTextsSection, {
			profileInsightIconItems = v46,
			isVerticallyConstrained = t1.isVerticallyConstrained,
			layoutOrder = not FFlagProfilePlatformAddTC and 2 or t1.layoutOrder
		}) else React.createElement(Skeleton, {
			Size = UDim2.new(1, 0, 0, 50),
			LayoutOrder = not FFlagProfilePlatformAddTC and 2 or t1.layoutOrder
		})
	})
end
