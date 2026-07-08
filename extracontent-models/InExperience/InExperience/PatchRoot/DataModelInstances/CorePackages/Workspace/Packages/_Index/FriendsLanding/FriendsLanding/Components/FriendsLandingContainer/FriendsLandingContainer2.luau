local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local IXPService = game:GetService("IXPService")
local dependencies = require(FriendsLanding.dependencies)
local FriendsLandingParent = FriendsLanding.Parent
local IXPServiceWrapper = require(FriendsLandingParent.IXPServiceWrapper).IXPServiceWrapper
local React = require(FriendsLandingParent.React)
local Cryo = require(FriendsLandingParent.Cryo)
local useAppPolicy = require(FriendsLandingParent.UniversalAppPolicy).useAppPolicy
local useSelector = require(FriendsLandingParent.RoactUtils).Hooks.RoactRodux.useSelector
local getDeepValue = dependencies.SocialLibraries.Dictionary.getDeepValue
local getRbxthumbWithTypeSizeAndOptions = dependencies.getRbxthumbWithTypeSizeAndOptions
local UserLibConstants = dependencies.UserLibConstants
local FriendsLandingPage = require(FriendsLanding.Components.FriendsLandingPage)
local FriendsLandingContext = require(FriendsLanding.FriendsLandingContext)
local PresenceType = dependencies.RoduxPresence.Enums.PresenceType
local PresenceType2 = require(FriendsLandingParent.GraphQLServer).types.PresenceType
local FriendsCommon = require(FriendsLandingParent.FriendsCommon)
local useFriendsListOrderedByPresence = FriendsCommon.Hooks.useFriendsListOrderedByPresence
local useDecoratedTrustedConnections = FriendsCommon.Hooks.useDecoratedTrustedConnections
local useLocalUserId = require(FriendsLandingParent.RobloxAppHooks).useLocalUserId
local filterStates = require(FriendsLanding.Friends.filterStates)
local AppUserLayers = require(FriendsLandingParent.ExperimentLayers).AppUserLayers
local FFlagConnectionsHubLayerExposure = require(FriendsLandingParent.SharedFlags).FFlagConnectionsHubLayerExposure
local FFlagFixCohubExposureLayer = require(FriendsLandingParent.SharedFlags).FFlagFixCohubExposureLayer
local FFlagConnectionManagementChips = require(FriendsLandingParent.SharedFlags).FFlagConnectionManagementChips
local v26 = game:DefineFastInt("FriendsLandingPageSize", 50)
local t1 = {
	[PresenceType2.Offline] = PresenceType.Offline,
	[PresenceType2.Online] = PresenceType.Online,
	[PresenceType2.InGame] = PresenceType.InGame,
	[PresenceType2.InStudio] = PresenceType.InStudio
}

function FriendsLandingContainer(_) -- line: 48
	-- upvalues: FFlagConnectionsHubLayerExposure (copy), React (copy), FFlagFixCohubExposureLayer (copy), IXPServiceWrapper (copy), AppUserLayers (copy), IXPService (copy), useLocalUserId (copy), useSelector (copy), getDeepValue (copy), useAppPolicy (copy), FriendsLandingContext (copy), useFriendsListOrderedByPresence (copy), v26 (copy), FFlagConnectionManagementChips (copy), useDecoratedTrustedConnections (copy), filterStates (copy), Cryo (copy), PresenceType2 (copy), getRbxthumbWithTypeSizeAndOptions (copy), UserLibConstants (copy), t1 (copy), PresenceType (copy), FriendsLandingPage (copy)
	if FFlagConnectionsHubLayerExposure then
		React.useEffect(function() -- line: 50
			-- upvalues: FFlagFixCohubExposureLayer (copy), IXPServiceWrapper (copy), AppUserLayers (copy), IXPService (copy)
			if FFlagFixCohubExposureLayer then
				IXPServiceWrapper:LogFlagLinkedUserLayerExposure(AppUserLayers.ConnectionsHubExposureLayer)

				return
			end

			IXPService:LogFlagLinkedUserLayerExposure(AppUserLayers.ConnectionsHubExposureLayer)
		end, {})
	end

	local v29 = useLocalUserId()
	local v30 = useSelector(function(p2) -- line: 60
		-- upvalues: getDeepValue (copy), v29 (copy)
		return getDeepValue(p2, `FriendsLanding.Friends.countsByUserId.{ v29 }`)
	end)
	local v31 = useAppPolicy(function(p3) -- line: 64
		return p3.getShowDisplayName()
	end)
	local v32 = React.useContext(FriendsLandingContext.Context)
	local v33 = useFriendsListOrderedByPresence({
		userId = v29,
		pageSize = v26
	})
	local u34 = nil

	if FFlagConnectionManagementChips then
		u34 = useDecoratedTrustedConnections(v33.onlineFriends)
	end

	local v35 = React.useMemo(function() -- line: 82
		-- upvalues: v33 (copy), v32 (copy), filterStates (copy), Cryo (copy), FFlagConnectionManagementChips (copy), u34 (ref), PresenceType2 (copy)
		local t2 = {}

		if v33.onlineFriends and v33.offlineFriends then
			if v32.filter == filterStates.All then
				return (Cryo.List.join(v33.onlineFriends, v33.offlineFriends))
			end

			if v32.filter == filterStates.Offline then
				return v33.offlineFriends
			end

			if v32.filter == filterStates.Online then
				return v33.onlineFriends
			end

			if FFlagConnectionManagementChips and v32.filter == filterStates.Trusted then
				return u34 or {}
			end

			local onlineFriends = v33.onlineFriends

			t2 = Cryo.List.filter(onlineFriends, function(p4) -- line: 95
				-- upvalues: PresenceType2 (copy)
				return p4.presence and p4.presence.userPresenceType == PresenceType2.InGame
			end)
		end

		return t2
	end, if not FFlagConnectionManagementChips then {
		v32.filter,
		v33.onlineFriends,
		v33.offlineFriends
	} else {
		v32.filter,
		v33.onlineFriends,
		v33.offlineFriends,
		u34
	})
	local v36 = React.useMemo(function() -- line: 108
		-- upvalues: Cryo (copy), v35 (copy), getRbxthumbWithTypeSizeAndOptions (copy), UserLibConstants (copy), t1 (copy), PresenceType (copy)
		return Cryo.List.map(v35, function(p5, _) -- line: 109
			-- upvalues: getRbxthumbWithTypeSizeAndOptions (copy), UserLibConstants (copy), t1 (copy), PresenceType (copy)
			local v44 = getRbxthumbWithTypeSizeAndOptions(p5.id, UserLibConstants.RbxthumbTypes.Avatar, 352)
			local v45 = if not p5.presence then PresenceType.Offline else t1[p5.presence.userPresenceType]

			return {
				username = "",
				id = p5.id,
				thumbnail = v44,
				userPresenceType = v45,
				universeId = p5.presence and p5.presence.universeId or nil,
				lastLocation = if not p5.presence then nil else p5.presence.lastLocation
			}
		end)
	end, { v35 })

	return React.createElement(FriendsLandingPage, {
		totalFriendCount = v30,
		friends = if not FFlagConnectionManagementChips then v36 else v36 or {},
		fetchMoreFriends = if not v33 or v33.isEndOfList then nil else v33.fetchMoreFriends,
		refreshFriends = v33.refreshFriendsData,
		enableDisplayNamePolicy = v31,
		localUserId = v29
	})
end

return FriendsLandingContainer
