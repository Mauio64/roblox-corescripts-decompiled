local FriendsLanding = script:FindFirstAncestor("FriendsLanding")

local dependencies = require(FriendsLanding.dependencies)
local parent = FriendsLanding.Parent
local IXPServiceWrapper = require(parent.IXPServiceWrapper)
local ixpServiceWrapper = IXPServiceWrapper.IXPServiceWrapper
local React = require(parent.React)
local Cryo = require(parent.Cryo)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local FriendsHydrationReact = require(parent.FriendsHydrationReact)
local useGetFriendsCountByUserId = FriendsHydrationReact.useGetFriendsCountByUserId

local getRbxthumbWithTypeSizeAndOptions = dependencies.getRbxthumbWithTypeSizeAndOptions
local userLibConstants = dependencies.UserLibConstants

local FriendsLandingPage = require(FriendsLanding.Components.FriendsLandingPage)
local FriendsLandingContext = require(FriendsLanding.FriendsLandingContext)

local presenceType = dependencies.RoduxPresence.Enums.PresenceType

local GraphQLServer = require(parent.GraphQLServer)
local presenceType2 = GraphQLServer.types.PresenceType

local FriendsCommon = require(parent.FriendsCommon)
local useFriendsListOrderedByPresence = FriendsCommon.Hooks.useFriendsListOrderedByPresence
local useDecoratedTrustedConnections = FriendsCommon.Hooks.useDecoratedTrustedConnections
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local filterStates = require(FriendsLanding.Friends.filterStates)
local FFlagFriendsLandingLayerExposure = require(FriendsLanding.Flags.FFlagFriendsLandingLayerExposure)

local ExperimentLayers = require(parent.ExperimentLayers)
local AppUserLayers = ExperimentLayers.AppUserLayers
local SharedFlags = require(parent.SharedFlags)
local FFlagConnectionManagementChips = SharedFlags.FFlagConnectionManagementChips
local FFlagFriendsPageUserListCtaEnabled = require(FriendsLanding.Flags.FFlagFriendsPageUserListCtaEnabled)
local entityType

if FFlagFriendsPageUserListCtaEnabled then
	local UserList = require(parent.UserList)
	entityType = UserList.Enums.EntityType
else
	entityType = nil
end

local defineFastInt = game:DefineFastInt("FriendsLandingPageSize", 50)
local v = { skipFetch = true }

local v2 = {
	[presenceType2.Offline] = presenceType.Offline,
	[presenceType2.Online] = presenceType.Online,
	[presenceType2.InGame] = presenceType.InGame,
	[presenceType2.InStudio] = presenceType.InStudio
}

function FriendsLandingContainer(_)
	React.useEffect(function()
		ixpServiceWrapper:LogFlagLinkedUserLayerExposure(AppUserLayers.ConnectionsHubExposureLayer)

		if FFlagFriendsLandingLayerExposure then
			ixpServiceWrapper:LogFlagLinkedUserLayerExposure(AppUserLayers.SocialFriendsLandingLayer)
		end
	end, {})

	local v3 = useLocalUserId()
	local v4

	if v3 then
		v4 = tostring(v3)
	end

	local totalFriendCount = useGetFriendsCountByUserId(v4, v) or 0

	local enableDisplayNamePolicy = useAppPolicy(function(p)
		return p.getShowDisplayName()
	end)

	local v5 = React.useContext(FriendsLandingContext.Context)

	local v6 = useFriendsListOrderedByPresence({ userId = v3, pageSize = defineFastInt })
	local v7

	if FFlagConnectionManagementChips then
		v7 = useDecoratedTrustedConnections(v6.onlineFriends)
	else
		v7 = nil
	end

	local useMemo = React.useMemo
	local function fn()
		if not (v6.onlineFriends and v6.offlineFriends) then
			return {}
		end

		if v5.filter == filterStates.All then
			return (Cryo.List.join(v6.onlineFriends, v6.offlineFriends))
		end

		if v5.filter == filterStates.Offline then
			return v6.offlineFriends
		end

		if v5.filter == filterStates.Online then
			return v6.onlineFriends
		end

		if FFlagConnectionManagementChips and v5.filter == filterStates.Trusted then
			return v7 or {}
		end

		local onlineFriends = v6.onlineFriends
		return (Cryo.List.filter(onlineFriends, function(p)
			return p.presence and p.presence.userPresenceType == presenceType2.InGame
		end))
	end

	local v8

	if FFlagConnectionManagementChips then
		v8 = { v5.filter, v6.onlineFriends, v6.offlineFriends, v7 }
	else
		v8 = { v5.filter, v6.onlineFriends, v6.offlineFriends }
	end

	local v9 = useMemo(fn, v8)

	local v10 = React.useMemo(function()
		return Cryo.List.map(v9, function(p, _)
			local rbxthumbWithTypeSizeAndOptions = getRbxthumbWithTypeSizeAndOptions(
				p.id,
				userLibConstants.RbxthumbTypes.Avatar,
				352
			)
			local userPresenceType

			if p.presence then
				userPresenceType = v2[p.presence.userPresenceType]
			else
				userPresenceType = presenceType.Offline
			end

			local v10 = {
				id = p.id,
				type = 0,
				username = "",
				thumbnail = 0,
				userPresenceType = 0,
				universeId = 0,
				lastLocation = 0
			}
			local v11

			if FFlagFriendsPageUserListCtaEnabled then
				v11 = entityType.User
			end

			v10.type = v11

			v10.thumbnail = rbxthumbWithTypeSizeAndOptions

			v10.userPresenceType = userPresenceType
			local universeId

			if p.presence then
				universeId = p.presence.universeId or nil
			end

			v10.universeId = universeId
			local lastLocation

			if p.presence then
				lastLocation = p.presence.lastLocation
			end

			v10.lastLocation = lastLocation
			return v10
		end)
	end, { v9 })

	local createElement = React.createElement
	local v11 = {
		totalFriendCount = totalFriendCount,
		friends = FFlagConnectionManagementChips and not v10 and {} or v10,
		fetchMoreFriends = 0,
		refreshFriends = 0,
		enableDisplayNamePolicy = 0,
		localUserId = 0
	}
	local fetchMoreFriends

	if v6 and not v6.isEndOfList then
		fetchMoreFriends = v6.fetchMoreFriends
	end

	v11.fetchMoreFriends = fetchMoreFriends
	v11.refreshFriends = v6.refreshFriendsData

	v11.enableDisplayNamePolicy = enableDisplayNamePolicy
	v11.localUserId = v3
	return createElement(FriendsLandingPage, v11)
end

return FriendsLandingContainer
