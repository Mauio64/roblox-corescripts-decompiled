local ParentParent = script.Parent.Parent
local AppStorageService = game:GetService("AppStorageService")
local MessageBusService = game:GetService("MessageBusService")
local ParentParentParent = ParentParent.Parent
local dependencies = require(ParentParent.dependencies)
local React = require(ParentParentParent.React)
local Dash = require(ParentParentParent.Dash)
local Cryo = require(ParentParentParent.Cryo)
local RobloxAppHooks = require(ParentParentParent.RobloxAppHooks)
local SocialCommon = require(ParentParentParent.SocialCommon)
local useQuery = require(ParentParentParent.ApolloClient).useQuery
local ApolloLocalState = require(ParentParentParent.ApolloLocalState)
local ApolloFriends = require(ParentParentParent.ApolloFriends)
local queries = ApolloLocalState.queries
local SocialLuaAnalytics = require(ParentParentParent.SocialLuaAnalytics)
local AnalyticsFactory = SocialLuaAnalytics.Analytics.AnalyticsFactory
local DefaultAnalyticsService = SocialLuaAnalytics.Analytics.DefaultAnalyticsService
local EventTypes = SocialLuaAnalytics.Analytics.Enums.EventTypes
local Contexts = SocialLuaAnalytics.Analytics.Enums.Contexts
local useDispatch = require(ParentParentParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useFetchContactImporterInfoOnce = require(ParentParent.Utils).useFetchContactImporterInfoOnce
local useAutoSyncContacts = require(ParentParent.Utils).useAutoSyncContacts
local userIdExists = SocialCommon.Utils.userIdExists
local PermissionsProtocol = require(ParentParentParent.PermissionsProtocol).PermissionsProtocol
local rolloutByApplicationId = require(ParentParentParent.AppCommonLib).rolloutByApplicationId
local UserProfiles = require(ParentParentParent.UserProfiles)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local UniversalAppPolicy = dependencies.UniversalAppPolicy
local getAppFeaturePolicies = require(ParentParentParent.UniversalAppPolicy).getAppFeaturePolicies
local NetworkingFriends = dependencies.NetworkingFriends
local PaginatedFriendsCarouselIXP = require(ParentParent.Experiments.PaginatedFriendsCarouselIXP)
local v32 = game:DefineFastFlag("EarlierFetchTimeForFriendsCarousel_v1", false)
local v33 = game:DefineFastFlag("PrefetchProfileNamesOnStartup_v2", false)
local FIntFriendsCarouselInitialFetchSize = require(ParentParentParent.SharedFlags).FIntFriendsCarouselInitialFetchSize
local FFlagRegisterQRCodeKeyInEngine = require(ParentParentParent.SharedFlags).FFlagRegisterQRCodeKeyInEngine
local FFlagFriendSortedByPresenceSignalsImplementation = require(ParentParentParent.SharedFlags).FFlagFriendSortedByPresenceSignalsImplementation
local useSignalState = require(ParentParentParent.SignalsReact).useSignalState
local DataHydration = require(ParentParentParent.DataHydration)
local v39 = if not FFlagFriendSortedByPresenceSignalsImplementation then nil else DataHydration.Friends.FriendsStore.get()
local v40 = not FFlagRegisterQRCodeKeyInEngine and "ScreenshotEventTracking" or "ProfileQrCodeCameraSettingsModalSeen"
local v41 = rolloutByApplicationId(function() -- line: 61
	return game:DefineFastInt("CallFriendCountAtStartupRollout", 0)
end)
local MessageId = MessageBusService:GetMessageId("Realtime", "appResume")
local v43 = if not v33 then nil else UserProfiles.Stores.UserProfileStore.get()
local t1 = {
	ProfileQRCodeCameraSettingsModalSeen = {
		context = Contexts.ProfileQRCode,
		eventType = EventTypes.SettingsModalSeenSinceLastAppStart,
		formatRulesForAdditionalInfo = {
			cameraPermissionResponseStatus = Dash.identity
		}
	}
}

local function Container(t2: {[any]: any}) -- line: 99
	-- upvalues: useDispatch (copy), useLocalUserId (copy), getAppFeaturePolicies (copy), useFetchContactImporterInfoOnce (copy), v32 (copy), PaginatedFriendsCarouselIXP (copy), ApolloFriends (copy), FFlagFriendSortedByPresenceSignalsImplementation (copy), React (copy), v39 (copy), useSignalState (copy), useQuery (copy), queries (copy), userIdExists (copy), Cryo (copy), FIntFriendsCarouselInitialFetchSize (copy), v33 (copy), v43 (copy), useAutoSyncContacts (copy), v41 (copy), NetworkingFriends (copy), MessageBusService (copy), MessageId (copy), AnalyticsFactory (copy), t1 (copy), DefaultAnalyticsService (copy), AppStorageService (copy), v40 (copy), PermissionsProtocol (copy)
	local v47 = useDispatch()
	local v48 = useLocalUserId()
	local v49 = t2.isContactImporterPolicyEnabled or getAppFeaturePolicies().getContactImporterEnabled()

	useFetchContactImporterInfoOnce({
		policyIsEnabled = v49
	})

	local v50 = nil
	local v51 = nil

	if v32 then
		local v52, v53 = PaginatedFriendsCarouselIXP.usePaginatedFriendsCarouselExperiment()
		local t3 = {
			userId = v48,
			sort = v52 and v53 or ApolloFriends.Enums.Sort.FriendshipScore
		}

		if FFlagFriendSortedByPresenceSignalsImplementation then
			local v55 = React.useMemo(function() -- line: 123
				-- upvalues: v39 (copy)
				return v39.GetAllFriends()
			end, {})
			local v56 = useSignalState(v55)

			v51 = v56 and v56.friends or nil
			React.useEffect(function() -- line: 130
				-- upvalues: v39 (copy)
				v39.GetOnlineFriends()
			end, {})
		else
			v50 = useQuery(queries.allFriendsByUserId, {
				errorPolicy = "all",
				notifyOnNetworkStatusChange = true,
				skip = not v52 or not userIdExists(v48),
				variables = Cryo.Dictionary.join(t3, {
					pageCursor = "",
					pageLimit = FIntFriendsCarouselInitialFetchSize
				})
			})
			useQuery(queries.onlineFriendsByUserId, {
				notifyOnNetworkStatusChange = true,
				skip = not v52 or not userIdExists(v48),
				variables = t3
			})
		end
	end

	if v33 then
		local v57 = if not FFlagFriendSortedByPresenceSignalsImplementation then v50 and (v50.data and (v50.data.allFriendsByUserId and v50.data.allFriendsByUserId.friends)) else v51

		React.useEffect(function() -- line: 161
			-- upvalues: userIdExists (copy), v48 (copy), v57 (copy), v43 (copy)
			if userIdExists(v48) then
				local t4 = { (tostring(v48)) }

				if v57 then
					for _, v62 in v57 do
						if v62 and v62.id then
							table.insert(t4, (tostring(v62.id)))
						end
					end
				end

				v43.fetchNamesByUserIds(t4)
			end
		end, {
			v48,
			v57
		})
	end

	useAutoSyncContacts()

	if v41() then
		React.useEffect(function() -- line: 182
			-- upvalues: userIdExists (copy), v48 (copy), v47 (copy), NetworkingFriends (copy)
			if userIdExists(v48) then
				v47(NetworkingFriends.GetFriendsCountFromUserId.API(v48))
			end
		end, { v48 })
	end

	React.useEffect(function() -- line: 189
		-- upvalues: userIdExists (copy), v48 (copy), v47 (copy), NetworkingFriends (copy), MessageBusService (copy), MessageId (copy)
		if userIdExists(v48) then
			v47(NetworkingFriends.GetNewFriendRequestsCount.API({
				currentUserId = v48
			}))

			local v63 = MessageBusService:Subscribe(MessageId, function() -- line: 194
				-- upvalues: v47 (copy), NetworkingFriends (copy), v48 (copy)
				v47(NetworkingFriends.GetNewFriendRequestsCount.API({
					currentUserId = v48
				}))
			end, false, true)

			return function() -- line: 199
				-- upvalues: v63 (copy)
				v63:Disconnect()
			end
		end

		return function() -- line: 203
		end
	end, { v48 })

	local v58 = React.useMemo(function() -- line: 206
		-- upvalues: AnalyticsFactory (copy), t1 (copy), DefaultAnalyticsService (copy)
		return AnalyticsFactory.setUpAnalyticsFactory({
			eventLists = {
				EventStream = t1
			},
			analyticsImpl = {
				EventStream = DefaultAnalyticsService.EventStream
			}
		})()
	end, {})

	React.useEffect(function() -- line: 216
		-- upvalues: AppStorageService (copy), v40 (copy), PermissionsProtocol (copy), v58 (copy)
		if AppStorageService:GetItem(v40) == "true" then
			PermissionsProtocol.default:checkOrRequestPermissions({ PermissionsProtocol.Permissions.CAMERA_ACCESS }):andThen(function(p1) -- line: 224
				-- upvalues: v58 (copy)
				v58.fireAnalyticsEvent("ProfileQRCodeCameraSettingsModalSeen", {
					cameraPermissionResponseStatus = p1
				})
			end)
			AppStorageService:SetItem(v40, "false")
			AppStorageService:Flush()
		end
	end, {
		v48,
		v58
	})

	return nil
end

return UniversalAppPolicy.connect(function(p2) -- line: 237
	return {
		isContactImporterPolicyEnabled = p2.getContactImporterEnabled()
	}
end)(Container)
