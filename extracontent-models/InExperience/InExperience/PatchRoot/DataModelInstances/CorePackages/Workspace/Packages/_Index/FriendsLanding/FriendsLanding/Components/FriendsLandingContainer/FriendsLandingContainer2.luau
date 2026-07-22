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
local FFlagFixCohubExposureLayer = require(FriendsLandingParent.SharedFlags).FFlagFixCohubExposureLayer
local FFlagConnectionManagementChips = require(FriendsLandingParent.SharedFlags).FFlagConnectionManagementChips
local v25 = game:DefineFastInt("FriendsLandingPageSize", 50)
local t1 = {
	[PresenceType2.Offline] = PresenceType.Offline,
	[PresenceType2.Online] = PresenceType.Online,
	[PresenceType2.InGame] = PresenceType.InGame,
	[PresenceType2.InStudio] = PresenceType.InStudio
}

function FriendsLandingContainer(_) -- line: 46
	-- upvalues: React (copy), FFlagFixCohubExposureLayer (copy), IXPServiceWrapper (copy), AppUserLayers (copy), IXPService (copy), useLocalUserId (copy), useSelector (copy), getDeepValue (copy), useAppPolicy (copy), FriendsLandingContext (copy), useFriendsListOrderedByPresence (copy), v25 (copy), FFlagConnectionManagementChips (copy), useDecoratedTrustedConnections (copy), filterStates (copy), Cryo (copy), PresenceType2 (copy), getRbxthumbWithTypeSizeAndOptions (copy), UserLibConstants (copy), t1 (copy), PresenceType (copy), FriendsLandingPage (copy)
	React.useEffect(function() -- line: 47
		-- upvalues: FFlagFixCohubExposureLayer (copy), IXPServiceWrapper (copy), AppUserLayers (copy), IXPService (copy)
		if FFlagFixCohubExposureLayer then
			IXPServiceWrapper:LogFlagLinkedUserLayerExposure(AppUserLayers.ConnectionsHubExposureLayer)

			return
		end

		IXPService:LogFlagLinkedUserLayerExposure(AppUserLayers.ConnectionsHubExposureLayer)
	end, {})

	local v28 = useLocalUserId()
	local v29 = useSelector(function(p2) -- line: 56
		-- upvalues: getDeepValue (copy), v28 (copy)
		return getDeepValue(p2, `FriendsLanding.Friends.countsByUserId.{ v28 }`)
	end)
	local v30 = useAppPolicy(function(p3) -- line: 60
		return p3.getShowDisplayName()
	end)
	local v31 = React.useContext(FriendsLandingContext.Context)
	local v32 = useFriendsListOrderedByPresence({
		userId = v28,
		pageSize = v25
	})
	local u33 = nil

	if FFlagConnectionManagementChips then
		u33 = useDecoratedTrustedConnections(v32.onlineFriends)
	end

	local v34 = React.useMemo(function() -- line: 78
		-- upvalues: v32 (copy), v31 (copy), filterStates (copy), Cryo (copy), FFlagConnectionManagementChips (copy), u33 (ref), PresenceType2 (copy)
		local t2 = {}

		if v32.onlineFriends and v32.offlineFriends then
			if v31.filter == filterStates.All then
				return (Cryo.List.join(v32.onlineFriends, v32.offlineFriends))
			end

			if v31.filter == filterStates.Offline then
				return v32.offlineFriends
			end

			if v31.filter == filterStates.Online then
				return v32.onlineFriends
			end

			if FFlagConnectionManagementChips and v31.filter == filterStates.Trusted then
				return u33 or {}
			end

			local onlineFriends = v32.onlineFriends

			t2 = Cryo.List.filter(onlineFriends, function(p4) -- line: 91
				-- upvalues: PresenceType2 (copy)
				return p4.presence and p4.presence.userPresenceType == PresenceType2.InGame
			end)
		end

		return t2
	end, if not FFlagConnectionManagementChips then {
		v31.filter,
		v32.onlineFriends,
		v32.offlineFriends
	} else {
		v31.filter,
		v32.onlineFriends,
		v32.offlineFriends,
		u33
	})
	local v35 = React.useMemo(function() -- line: 104
		-- upvalues: Cryo (copy), v34 (copy), getRbxthumbWithTypeSizeAndOptions (copy), UserLibConstants (copy), t1 (copy), PresenceType (copy)
		return Cryo.List.map(v34, function(p5, _) -- line: 105
			-- upvalues: getRbxthumbWithTypeSizeAndOptions (copy), UserLibConstants (copy), t1 (copy), PresenceType (copy)
			local v43 = getRbxthumbWithTypeSizeAndOptions(p5.id, UserLibConstants.RbxthumbTypes.Avatar, 352)
			local v44 = if not p5.presence then PresenceType.Offline else t1[p5.presence.userPresenceType]

			return {
				username = "",
				id = p5.id,
				thumbnail = v43,
				userPresenceType = v44,
				universeId = p5.presence and p5.presence.universeId or nil,
				lastLocation = if not p5.presence then nil else p5.presence.lastLocation
			}
		end)
	end, { v34 })

	return React.createElement(FriendsLandingPage, {
		totalFriendCount = v29,
		friends = if not FFlagConnectionManagementChips then v35 else v35 or {},
		fetchMoreFriends = if not v32 or v32.isEndOfList then nil else v32.fetchMoreFriends,
		refreshFriends = v32.refreshFriendsData,
		enableDisplayNamePolicy = v30,
		localUserId = v28
	})
end

return FriendsLandingContainer
