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

local v5 = UserProfiles.Stores.UserProfileStore.get()

return function(props)
	local v6 = React.useMemo(function()
		return Signals.createComputed(function(p2)
			local v7 = v5 and v5.fetchNamesByUserIds({ (tostring(props.userId)) })(p2)
			local v8 = v7 and v7.data and v7.data[1]
			local names = v8 and v8.names
			return {
				combinedName = not names and "" or names.getCombinedName(p2),
				username = not names and "" or names.getUsername()
			}
		end)
	end, { props.userId })

	local v7 = SignalsReact.useSignalState(v6)
	local username = v7.username
	local combinedName = v7.combinedName

	local v8 = {}
	local v9

	if getFFlagEnableProfileInsightsApolloMigration() then
		v8, v9 = useSignalProfileInsightsByUserId({
			userId = props.userId,
			rankingStrategy = "tc_info_boost",
			forceFetch = true
		})
	else
		local v10 = useProfileInsightsByUserIds({
			userIds = { props.userId },
			rankingStrategy = "tc_info_boost",
			fetchPolicy = "network-only"
		})

		if v10 and v10.data and not v10.loading then
			v8 = getProfileInsightsByUserIdFromData(v10.data, props.userId)
		end

		v9 = v10.loading
	end

	local v10 = if not isCustomNil(v8.userAgeVerifiedBracket) then v8.userAgeVerifiedBracket else nil

	local v11 = useLocalization({
		userAgeVerifiedBracket = v10,
		yourLinkedParent = "Feature.Friends.Label.YourLinkedParent"
	})

	local state, setState = React.useState(false)

	React.useEffect(function()
		local v14 = {
			{ name = "otherUser", type = "UserId", value = props.userId }
		}
		setState(ampApiProvider.upsellFeatureAccess(
			"IsLinkedChildOf",
			{},
			fStringParentLinkAmpNameSpace,
			v14
		).access == accessResponseEnum.Granted)
	end, { props.userId })

	local v14 = React.useMemo(function()
		if v11.userAgeVerifiedBracket then
			return ` • {v11.userAgeVerifiedBracket}`
		end

		return nil
	end, { v11.userAgeVerifiedBracket })

	local v15 = React.useMemo(function()
		local v16 = Foundation.Hooks.useTokens()
		local createElement = React.createElement
		local createElement2 = React.createElement
		local v21 = {
			userId = props.userId,
			userPresenceType = Foundation.Enums.UserPresence.None,
			layoutMode = layoutMode.wide,
			title = 0,
			subtitle = 0,
			titleStyle = 0,
			subtitleStyle = 0,
			onActivated = nil
		}
		local v22 = if state then v11.yourLinkedParent else combinedName
		v21.title = v22
		local v23 = if username ~= "" then `@{username}{v14 or ""}` else nil
		v21.subtitle = v23
		v21.titleStyle = v16.Typography.TitleMedium
		v21.subtitleStyle = v16.Typography.BodyMedium
		return createElement(view, {
			tag = "size-0-1200 auto-x row align-y-center",
			LayoutOrder = 1
		}, {
			UserTile = createElement2(userTile, v21)
		})
	end, {
		props.userId,
		combinedName,
		state,
		setState,
		v11.yourLinkedParent,
		username,
		v14
	})

	local v16 = React.useMemo(function()
		local v18 = if not isCustomNil(v8.mutualFriends) then v8.mutualFriends else nil

		local v19 = if not isCustomNil(v8.friendshipAgeUnixSeconds) then v8.friendshipAgeUnixSeconds else nil

		local v20 = if not isCustomNil(v8.friendRequestOriginSource) then v8.friendRequestOriginSource else nil

		local v21 = if not isCustomNil(v8.accountCreationDateUnixSeconds) then v8.accountCreationDateUnixSeconds else nil

		local v22 = if not isCustomNil(v8.localizedCountryName) then v8.localizedCountryName else nil
		return {
			mutualFriends = v18,
			friendshipAgeUnixSeconds = v19,
			friendRequestOriginSource = v20,
			accountCreationDateUnixSeconds = v21,
			localizedCountryName = v22,
			isClassmate = fFlagTFClassmatesProfileInsight and v8.isClassmate == true and true or nil
		}
	end, { v8 })

	local createElement = React.createElement
	local v18 = {
		tag = {
			["col size-full-0 auto-y align-x-left radius-medium bg-shift-100"] = true,
			["gap-medium padding-medium"] = props.isVerticallyConstrained,
			["gap-large padding-large"] = not props.isVerticallyConstrained
		},
		LayoutOrder = 2
	}

	local v20 = if v9 then React.createElement(skeleton, {
		Size = UDim2.new(1, 0, 0, 50),
		LayoutOrder = not fFlagProfilePlatformAddTC and 2 or props.layoutOrder
	}) else React.createElement(SocialMetadataIconsAndTextsSection, {
		profileInsightIconItems = v16,
		isVerticallyConstrained = props.isVerticallyConstrained,
		layoutOrder = not fFlagProfilePlatformAddTC and 2 or props.layoutOrder
	})
	return createElement(view, v18, {
		AvatarWithNames = v15,
		SocialMetadataIconAndTextList = v20
	})
end
