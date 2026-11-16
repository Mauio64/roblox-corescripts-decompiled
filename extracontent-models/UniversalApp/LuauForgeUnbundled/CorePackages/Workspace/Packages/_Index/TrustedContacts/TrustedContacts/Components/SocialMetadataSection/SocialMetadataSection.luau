local React = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/React")
local UserProfiles = require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/UserProfiles")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/Localization").Hooks.useLocalization

require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/GraphQLServer")

local ApolloProfileInsights = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/ApolloProfileInsights")
local useProfileInsightsByUserIds = ApolloProfileInsights.Hooks.useProfileInsightsByUserIds
local getProfileInsightsByUserIdFromData = ApolloProfileInsights.Selectors.getProfileInsightsByUserIdFromData
local isCustomNil = require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Utils/isCustomNil")

local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/SignalsReact")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/Foundation")
local skeleton = Foundation.Skeleton

local view = Foundation.View

local userTile = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/UserTile").UserTile
local layoutMode = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/UserTile").LayoutMode

local SocialMetadataIconsAndTextsSection = require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Components/SocialMetadataSection/SocialMetadataIconsAndTextsSection")
local useSignalProfileInsightsByUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/ProfileInsights").useSignalProfileInsightsByUserId
local AmpUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/AmpUpsell")
local ampApiProvider = AmpUpsell.AmpApiProvider
local accessResponseEnum = AmpUpsell.AmpEnums.AccessResponseEnum
local fFlagProfilePlatformAddTC = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/SharedFlags").FFlagProfilePlatformAddTC
local fStringParentLinkAmpNameSpace = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/SharedFlags").FStringParentLinkAmpNameSpace

local getFFlagEnableProfileInsightsApolloMigration = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/SharedFlags").GetFFlagEnableProfileInsightsApolloMigration
local fFlagTFClassmatesProfileInsight = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/SharedFlags").FFlagTFClassmatesProfileInsight

local defineFastFlag = game:DefineFastFlag("SocialMetadataSectionMigrateUserProfileToSignals", false)

local v5 = if defineFastFlag then UserProfiles.Stores.UserProfileStore.get() else nil

return function(props)
	local v6

	if not defineFastFlag then
		v6 = UserProfiles.Hooks.useUserProfilesFetch({
			userIds = { props.userId },
			query = UserProfiles.Queries.userProfilesCombinedNameAndUsernameByUserIds
		})
	end

	local v7, v8

	if defineFastFlag or not (v6 and v6.data) then
		v7 = ""
		v8 = ""
	else
		v7 = UserProfiles.Selectors.getCombinedNameFromId(v6.data, props.userId) or ""
		v8 = UserProfiles.Selectors.getUsernameFromId(v6.data, props.userId) or ""
	end

	if defineFastFlag then
		local v9 = React.useMemo(function()
			return Signals.createComputed(function(p2)
				local v10 = v5 and v5.fetchNamesByUserIds({ (tostring(props.userId)) })(p2)
				local v11 = v10 and v10.data and v10.data[1]
				local names = v11 and v11.names
				return {
					combinedName = not names and "" or names.getCombinedName(p2),
					username = not names and "" or names.getUsername()
				}
			end)
		end, { props.userId })

		local v10 = SignalsReact.useSignalState(v9)
		v8 = v10.username
		v7 = v10.combinedName
	end

	local v9 = {}
	local v10

	if getFFlagEnableProfileInsightsApolloMigration() then
		v9, v10 = useSignalProfileInsightsByUserId({
			userId = props.userId,
			rankingStrategy = "tc_info_boost",
			forceFetch = true
		})
	else
		local v11 = useProfileInsightsByUserIds({
			userIds = { props.userId },
			rankingStrategy = "tc_info_boost",
			fetchPolicy = "network-only"
		})

		if v11 and v11.data and not v11.loading then
			v9 = getProfileInsightsByUserIdFromData(v11.data, props.userId)
		end

		v10 = v11.loading
	end

	local v11 = if not isCustomNil(v9.userAgeVerifiedBracket) then v9.userAgeVerifiedBracket else nil

	local v12 = useLocalization({
		userAgeVerifiedBracket = v11,
		yourLinkedParent = "Feature.Friends.Label.YourLinkedParent"
	})

	local state, setState = React.useState(false)

	React.useEffect(function()
		local v15 = {
			{ name = "otherUser", type = "UserId", value = props.userId }
		}
		setState(ampApiProvider.upsellFeatureAccess(
			"IsLinkedChildOf",
			{},
			fStringParentLinkAmpNameSpace,
			v15
		).access == accessResponseEnum.Granted)
	end, { props.userId })

	local v15 = React.useMemo(function()
		if v12.userAgeVerifiedBracket then
			return ` • {v12.userAgeVerifiedBracket}`
		end

		return nil
	end, { v12.userAgeVerifiedBracket })

	local v16 = React.useMemo(function()
		local v17 = Foundation.Hooks.useTokens()
		local createElement = React.createElement
		local createElement2 = React.createElement
		local v22 = {
			userId = props.userId,
			userPresenceType = Foundation.Enums.UserPresence.None,
			layoutMode = layoutMode.wide,
			title = 0,
			subtitle = 0,
			titleStyle = 0,
			subtitleStyle = 0,
			onActivated = nil
		}
		local v23 = if state then v12.yourLinkedParent else v7
		v22.title = v23
		local v24 = if v8 ~= "" then `@{v8}{v15 or ""}` else nil
		v22.subtitle = v24
		v22.titleStyle = v17.Typography.TitleMedium
		v22.subtitleStyle = v17.Typography.BodyMedium
		return createElement(view, {
			tag = "size-0-1200 auto-x row align-y-center",
			LayoutOrder = 1
		}, {
			UserTile = createElement2(userTile, v22)
		})
	end, { props.userId, v7, state, setState, v12.yourLinkedParent, v8, v15 })

	local v17 = React.useMemo(function()
		local v19 = if not isCustomNil(v9.mutualFriends) then v9.mutualFriends else nil

		local v20 = if not isCustomNil(v9.friendshipAgeUnixSeconds) then v9.friendshipAgeUnixSeconds else nil

		local v21 = if not isCustomNil(v9.friendRequestOriginSource) then v9.friendRequestOriginSource else nil

		local v22 = if not isCustomNil(v9.accountCreationDateUnixSeconds) then v9.accountCreationDateUnixSeconds else nil

		local v23 = if not isCustomNil(v9.localizedCountryName) then v9.localizedCountryName else nil
		return {
			mutualFriends = v19,
			friendshipAgeUnixSeconds = v20,
			friendRequestOriginSource = v21,
			accountCreationDateUnixSeconds = v22,
			localizedCountryName = v23,
			isClassmate = fFlagTFClassmatesProfileInsight and v9.isClassmate == true and true or nil
		}
	end, { v9 })

	local createElement = React.createElement
	local v19 = {
		tag = {
			["col size-full-0 auto-y align-x-left radius-medium bg-shift-100"] = true,
			["gap-medium padding-medium"] = props.isVerticallyConstrained,
			["gap-large padding-large"] = not props.isVerticallyConstrained
		},
		LayoutOrder = 2
	}

	local v21 = if v10 then React.createElement(skeleton, {
		Size = UDim2.new(1, 0, 0, 50),
		LayoutOrder = not fFlagProfilePlatformAddTC and 2 or props.layoutOrder
	}) else React.createElement(SocialMetadataIconsAndTextsSection, {
		profileInsightIconItems = v17,
		isVerticallyConstrained = props.isVerticallyConstrained,
		layoutOrder = not fFlagProfilePlatformAddTC and 2 or props.layoutOrder
	})
	return createElement(view, v19, {
		AvatarWithNames = v16,
		SocialMetadataIconAndTextList = v21
	})
end
