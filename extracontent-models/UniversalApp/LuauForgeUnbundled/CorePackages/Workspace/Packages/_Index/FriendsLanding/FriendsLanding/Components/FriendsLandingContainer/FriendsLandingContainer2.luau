local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/dependencies")

local ixpServiceWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/IxpServiceWrapper").IXPServiceWrapper
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/Cryo")
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/UniversalAppPolicy").useAppPolicy
local useGetFriendsCountByUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/FriendsHydrationReact").useGetFriendsCountByUserId

local getRbxthumbWithTypeSizeAndOptions = dependencies.getRbxthumbWithTypeSizeAndOptions
local userLibConstants = dependencies.UserLibConstants

local FriendsLandingPage = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Components/FriendsLandingPage")
local FriendsLandingContext = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/FriendsLandingContext")

local presenceType = dependencies.RoduxPresence.Enums.PresenceType

local presenceType2 = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/GraphQLServer").types.PresenceType

local FriendsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/FriendsCommon")
local useFriendsListOrderedByPresence = FriendsCommon.Hooks.useFriendsListOrderedByPresence
local useDecoratedTrustedConnections = FriendsCommon.Hooks.useDecoratedTrustedConnections
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/RobloxAppHooks").useLocalUserId
local filterStates = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Friends/filterStates")
local FFlagFriendsLandingLayerExposure = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Flags/FFlagFriendsLandingLayerExposure")

local appUserLayers = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/ExperimentLayers").AppUserLayers
local fFlagConnectionManagementChips = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/SharedFlags").FFlagConnectionManagementChips
local FFlagFriendsPageUserListCtaEnabled = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Flags/FFlagFriendsPageUserListCtaEnabled")

local entityType = if FFlagFriendsPageUserListCtaEnabled then require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/UserList").Enums.EntityType else nil

local defineFastInt = game:DefineFastInt("FriendsLandingPageSize", 50)
local v5 = { skipFetch = true }

local v6 = {
	[presenceType2.Offline] = presenceType.Offline,
	[presenceType2.Online] = presenceType.Online,
	[presenceType2.InGame] = presenceType.InGame,
	[presenceType2.InStudio] = presenceType.InStudio
}

function LUAUFORGE_MODULE_GLOBALS_edF_FriendsLandingContainer(p2)
	React.useEffect(function()
		ixpServiceWrapper:LogFlagLinkedUserLayerExposure(appUserLayers.ConnectionsHubExposureLayer)

		if FFlagFriendsLandingLayerExposure then
			ixpServiceWrapper:LogFlagLinkedUserLayerExposure(appUserLayers.SocialFriendsLandingLayer)
		end
	end, {})

	local v7 = useLocalUserId()

	local v8 = if v7 then tostring(v7) else nil
	local v9 = useGetFriendsCountByUserId(v8, v5) or 0

	local v10 = useAppPolicy(function(p3)
		return p3.getShowDisplayName()
	end)

	local v11 = React.useContext(FriendsLandingContext.Context)

	local v12 = useFriendsListOrderedByPresence({
		userId = v7,
		pageSize = defineFastInt
	})
	local v13

	if fFlagConnectionManagementChips then
		v13 = useDecoratedTrustedConnections(v12.onlineFriends)
	else
		v13 = nil
	end

	local useMemo = React.useMemo
	local function fn()
		local v14

		if not (v12.onlineFriends and v12.offlineFriends) then
			v14 = {}

			return v14
		end

		if v11.filter == filterStates.All then
			return (Cryo.List.join(v12.onlineFriends, v12.offlineFriends))
		end

		if v11.filter == filterStates.Offline then
			return v12.offlineFriends
		end

		if v11.filter == filterStates.Online then
			return v12.onlineFriends
		end

		if fFlagConnectionManagementChips and v11.filter == filterStates.Trusted then
			return v13 or {}
		end

		local onlineFriends = v12.onlineFriends
		v14 = Cryo.List.filter(onlineFriends, function(p3)
			return p3.presence and p3.presence.userPresenceType == presenceType2.InGame
		end)

		return v14
	end

	local v14

	if fFlagConnectionManagementChips then
		v14 = { v11.filter, v12.onlineFriends, v12.offlineFriends, v13 }
	else
		v14 = { v11.filter, v12.onlineFriends, v12.offlineFriends }
	end

	local v15 = useMemo(fn, v14)

	local v16 = React.useMemo(function()
		return Cryo.List.map(v15, function(p3, p4)
			local rbxthumbWithTypeSizeAndOptions = getRbxthumbWithTypeSizeAndOptions(
				p3.id,
				userLibConstants.RbxthumbTypes.Avatar,
				352
			)

			local v17 = if p3.presence then v6[p3.presence.userPresenceType] else presenceType.Offline

			local v18 = {
				id = p3.id,
				type = 0,
				username = "",
				thumbnail = 0,
				userPresenceType = 0,
				universeId = 0,
				lastLocation = 0
			}
			local v19 = if FFlagFriendsPageUserListCtaEnabled then entityType.User else nil
			v18.type = v19

			v18.thumbnail = rbxthumbWithTypeSizeAndOptions

			v18.userPresenceType = v17
			local v20 = if p3.presence then p3.presence.universeId or nil else nil
			v18.universeId = v20
			local v21 = if p3.presence then p3.presence.lastLocation else nil
			v18.lastLocation = v21
			return v18
		end)
	end, { v15 })

	local createElement = React.createElement
	local v18 = {
		totalFriendCount = v9,
		friends = fFlagConnectionManagementChips and not v16 and {} or v16,
		fetchMoreFriends = 0,
		refreshFriends = 0,
		enableDisplayNamePolicy = 0,
		localUserId = 0
	}
	local v19 = if v12 and not v12.isEndOfList then v12.fetchMoreFriends else nil
	v18.fetchMoreFriends = v19
	v18.refreshFriends = v12.refreshFriendsData

	v18.enableDisplayNamePolicy = v10
	v18.localUserId = v7
	return createElement(FriendsLandingPage, v18)
end

return LUAUFORGE_MODULE_GLOBALS_edF_FriendsLandingContainer
