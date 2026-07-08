local ParentParent = script.Parent.Parent
local CoreGui = game:GetService("CoreGui")
local AppStorageService = game:GetService("AppStorageService")
local MessageBusService = game:GetService("MessageBusService")
local ParentParentParent = ParentParent.Parent
local dependencies = require(ParentParent.dependencies)
local React = require(ParentParentParent.React)
local Roact = require(ParentParentParent.Roact)
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
local ContactsToast = require(ParentParentParent.ContactsToast).ContactsToast
local ContactsToastIXP = require(ParentParentParent.ContactsToast).ContactsToastIXP
local useDispatch = require(ParentParentParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useFetchContactImporterInfoOnce = require(ParentParent.Utils).useFetchContactImporterInfoOnce
local useAutoSyncContacts = require(ParentParent.Utils).useAutoSyncContacts
local getContactImporterParams = require(ParentParent.Utils).getContactImporterParams
local userIdExists = SocialCommon.Utils.userIdExists
local PermissionsProtocol = require(ParentParentParent.PermissionsProtocol).PermissionsProtocol
local rolloutByApplicationId = require(ParentParentParent.AppCommonLib).rolloutByApplicationId
local UserProfiles = require(ParentParentParent.UserProfiles)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local UniversalAppPolicy = dependencies.UniversalAppPolicy
local getAppFeaturePolicies = require(ParentParentParent.UniversalAppPolicy).getAppFeaturePolicies
local NetworkingFriends = dependencies.NetworkingFriends
local GetFFlagContactsToastEnabled = require(ParentParentParent.SharedFlags).GetFFlagContactsToastEnabled
local PaginatedFriendsCarouselIXP = require(ParentParent.Experiments.PaginatedFriendsCarouselIXP)
local v38 = game:DefineFastFlag("EarlierFetchTimeForFriendsCarousel_v1", false)
local v39 = game:DefineFastFlag("PrefetchProfileNamesOnStartup_v2", false)
local FIntFriendsCarouselInitialFetchSize = require(ParentParentParent.SharedFlags).FIntFriendsCarouselInitialFetchSize
local FFlagRegisterQRCodeKeyInEngine = require(ParentParentParent.SharedFlags).FFlagRegisterQRCodeKeyInEngine
local FFlagFriendSortedByPresenceSignalsImplementation = require(ParentParentParent.SharedFlags).FFlagFriendSortedByPresenceSignalsImplementation
local useSignalState = require(ParentParentParent.SignalsReact).useSignalState
local DataHydration = require(ParentParentParent.DataHydration)
local v45 = if not FFlagFriendSortedByPresenceSignalsImplementation then nil else DataHydration.Friends.FriendsStore.get()
local v46 = not FFlagRegisterQRCodeKeyInEngine and "ScreenshotEventTracking" or "ProfileQrCodeCameraSettingsModalSeen"
local v47 = rolloutByApplicationId(function() -- line: 67
	return game:DefineFastInt("CallFriendCountAtStartupRollout", 0)
end)
local MessageId = MessageBusService:GetMessageId("Realtime", "appResume")
local v49 = if not v39 then nil else UserProfiles.Stores.UserProfileStore.get()
local t1 = {
	ProfileQRCodeCameraSettingsModalSeen = {
		context = Contexts.ProfileQRCode,
		eventType = EventTypes.SettingsModalSeenSinceLastAppStart,
		formatRulesForAdditionalInfo = {
			cameraPermissionResponseStatus = Dash.identity
		}
	}
}

local function Container(t2: {[any]: any}) -- line: 106
	-- upvalues: useDispatch (copy), useLocalUserId (copy), getAppFeaturePolicies (copy), useFetchContactImporterInfoOnce (copy), v38 (copy), PaginatedFriendsCarouselIXP (copy), ApolloFriends (copy), FFlagFriendSortedByPresenceSignalsImplementation (copy), React (copy), v45 (copy), useSignalState (copy), useQuery (copy), queries (copy), userIdExists (copy), Cryo (copy), FIntFriendsCarouselInitialFetchSize (copy), v39 (copy), v49 (copy), useAutoSyncContacts (copy), v47 (copy), NetworkingFriends (copy), MessageBusService (copy), MessageId (copy), AnalyticsFactory (copy), t1 (copy), DefaultAnalyticsService (copy), AppStorageService (copy), v46 (copy), PermissionsProtocol (copy), GetFFlagContactsToastEnabled (copy), ContactsToastIXP (copy), Roact (copy), CoreGui (copy), ContactsToast (copy), Dash (copy), getContactImporterParams (copy)
	local v53 = useDispatch()
	local v54 = useLocalUserId()
	local v55 = t2.isContactImporterPolicyEnabled or getAppFeaturePolicies().getContactImporterEnabled()

	useFetchContactImporterInfoOnce({
		policyIsEnabled = v55
	})

	local v56 = nil
	local v57 = nil

	if v38 then
		local v58, v59 = PaginatedFriendsCarouselIXP.usePaginatedFriendsCarouselExperiment()
		local t3 = {
			userId = v54,
			sort = v58 and v59 or ApolloFriends.Enums.Sort.FriendshipScore
		}

		if FFlagFriendSortedByPresenceSignalsImplementation then
			local v61 = React.useMemo(function() -- line: 130
				-- upvalues: v45 (copy)
				return v45.GetAllFriends()
			end, {})
			local v62 = useSignalState(v61)

			v57 = v62 and v62.friends or nil
			React.useEffect(function() -- line: 137
				-- upvalues: v45 (copy)
				v45.GetOnlineFriends()
			end, {})
		else
			v56 = useQuery(queries.allFriendsByUserId, {
				errorPolicy = "all",
				notifyOnNetworkStatusChange = true,
				skip = not v58 or not userIdExists(v54),
				variables = Cryo.Dictionary.join(t3, {
					pageCursor = "",
					pageLimit = FIntFriendsCarouselInitialFetchSize
				})
			})
			useQuery(queries.onlineFriendsByUserId, {
				notifyOnNetworkStatusChange = true,
				skip = not v58 or not userIdExists(v54),
				variables = t3
			})
		end
	end

	if v39 then
		local v63 = if not FFlagFriendSortedByPresenceSignalsImplementation then v56 and (v56.data and (v56.data.allFriendsByUserId and v56.data.allFriendsByUserId.friends)) else v57

		React.useEffect(function() -- line: 168
			-- upvalues: userIdExists (copy), v54 (copy), v63 (copy), v49 (copy)
			if userIdExists(v54) then
				local t4 = { (tostring(v54)) }

				if v63 then
					for _, v68 in v63 do
						if v68 and v68.id then
							table.insert(t4, (tostring(v68.id)))
						end
					end
				end

				v49.fetchNamesByUserIds(t4)
			end
		end, {
			v54,
			v63
		})
	end

	useAutoSyncContacts()

	if v47() then
		React.useEffect(function() -- line: 189
			-- upvalues: userIdExists (copy), v54 (copy), v53 (copy), NetworkingFriends (copy)
			if userIdExists(v54) then
				v53(NetworkingFriends.GetFriendsCountFromUserId.API(v54))
			end
		end, { v54 })
	end

	React.useEffect(function() -- line: 196
		-- upvalues: userIdExists (copy), v54 (copy), v53 (copy), NetworkingFriends (copy), MessageBusService (copy), MessageId (copy)
		if userIdExists(v54) then
			v53(NetworkingFriends.GetNewFriendRequestsCount.API({
				currentUserId = v54
			}))

			local v69 = MessageBusService:Subscribe(MessageId, function() -- line: 201
				-- upvalues: v53 (copy), NetworkingFriends (copy), v54 (copy)
				v53(NetworkingFriends.GetNewFriendRequestsCount.API({
					currentUserId = v54
				}))
			end, false, true)

			return function() -- line: 206
				-- upvalues: v69 (copy)
				v69:Disconnect()
			end
		end

		return function() -- line: 210
		end
	end, { v54 })

	local v64 = React.useMemo(function() -- line: 213
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

	React.useEffect(function() -- line: 223
		-- upvalues: AppStorageService (copy), v46 (copy), PermissionsProtocol (copy), v64 (copy)
		if AppStorageService:GetItem(v46) == "true" then
			PermissionsProtocol.default:checkOrRequestPermissions({ PermissionsProtocol.Permissions.CAMERA_ACCESS }):andThen(function(p1) -- line: 231
				-- upvalues: v64 (copy)
				v64.fireAnalyticsEvent("ProfileQRCodeCameraSettingsModalSeen", {
					cameraPermissionResponseStatus = p1
				})
			end)
			AppStorageService:SetItem(v46, "false")
			AppStorageService:Flush()
		end
	end, {
		v54,
		v64
	})

	if GetFFlagContactsToastEnabled() or ContactsToastIXP.FFlagContactsToastExperimentEnabled and ContactsToastIXP.useContactsToastVariant() then
		return (React.createElement(Roact.Portal, {
			target = CoreGui
		}, { React.createElement(ContactsToast, Dash.join(t2, {
			getContactImporterParams = getContactImporterParams,
			isContactsToastPolicyEnabled = t2.isContactsToastPolicyEnabled
		})) }))
	end

	return nil
end

return UniversalAppPolicy.connect(function(p2) -- line: 257
	-- upvalues: GetFFlagContactsToastEnabled (copy), ContactsToastIXP (copy)
	return {
		isContactImporterPolicyEnabled = p2.getContactImporterEnabled(),
		isContactsToastPolicyEnabled = (GetFFlagContactsToastEnabled() or not not ContactsToastIXP.FFlagContactsToastExperimentEnabled) and p2.getContactsToastEnabled()
	}
end)(Container)
