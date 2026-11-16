local parent = script.Parent.Parent
local AppStorageService = game:GetService("AppStorageService")
local MessageBusService = game:GetService("MessageBusService")
local parent2 = parent.Parent

local dependencies = require(parent.dependencies)

local React = require(parent2.React)
local Dash = require(parent2.Dash)
local Cryo = require(parent2.Cryo)
local RobloxAppHooks = require(parent2.RobloxAppHooks)
local SocialCommon = require(parent2.SocialCommon)
local ApolloClient = require(parent2.ApolloClient)
local useQuery = ApolloClient.useQuery
local ApolloLocalState = require(parent2.ApolloLocalState)
local ApolloFriends = require(parent2.ApolloFriends)
local queries = ApolloLocalState.queries
local SocialLuaAnalytics = require(parent2.SocialLuaAnalytics)
local AnalyticsFactory = SocialLuaAnalytics.Analytics.AnalyticsFactory
local DefaultAnalyticsService = SocialLuaAnalytics.Analytics.DefaultAnalyticsService
local EventTypes = SocialLuaAnalytics.Analytics.Enums.EventTypes
local Contexts = SocialLuaAnalytics.Analytics.Enums.Contexts

local Utils = require(parent.Utils)
local useFetchContactImporterInfoOnce = Utils.useFetchContactImporterInfoOnce
local Utils2 = require(parent.Utils)
local useAutoSyncContacts = Utils2.useAutoSyncContacts
local userIdExists = SocialCommon.Utils.userIdExists
local PermissionsProtocol = require(parent2.PermissionsProtocol)
local permissionsProtocol = PermissionsProtocol.PermissionsProtocol
local UserProfiles = require(parent2.UserProfiles)

local useLocalUserId = RobloxAppHooks.useLocalUserId

local universalAppPolicy = dependencies.UniversalAppPolicy
local UniversalAppPolicy = require(parent2.UniversalAppPolicy)
local getAppFeaturePolicies = UniversalAppPolicy.getAppFeaturePolicies

local PaginatedFriendsCarouselIXP = require(parent.Experiments.PaginatedFriendsCarouselIXP)

local defineFastFlag = game:DefineFastFlag("EarlierFetchTimeForFriendsCarousel_v1", false)
local defineFastFlag2 = game:DefineFastFlag("PrefetchProfileNamesOnStartup_v2", false)
local FFlagGateContactAutoSyncByPolicy = require(parent.Flags.FFlagGateContactAutoSyncByPolicy)

local SharedFlags = require(parent2.SharedFlags)
local FIntFriendsCarouselInitialFetchSize = SharedFlags.FIntFriendsCarouselInitialFetchSize

local SharedFlags2 = require(parent2.SharedFlags)
local FFlagRegisterQRCodeKeyInEngine = SharedFlags2.FFlagRegisterQRCodeKeyInEngine

local SharedFlags3 = require(parent2.SharedFlags)
local FFlagAddFriendsPageHighlightUnseenTrustedRequests = SharedFlags3.FFlagAddFriendsPageHighlightUnseenTrustedRequests

local SharedFlags4 = require(parent2.SharedFlags)
local FFlagSocialCarouselMigrateRecommendations = SharedFlags4.FFlagSocialCarouselMigrateRecommendations

local SharedFlags5 = require(parent2.SharedFlags)
local FFlagFriendSortedByPresenceSignalsImplementation = SharedFlags5.FFlagFriendSortedByPresenceSignalsImplementation

local SignalsReact = require(parent2.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local DataHydration = require(parent2.DataHydration)
local v = DataHydration.Friends.FriendsStore.get()
local FriendsRequests = require(parent2.DataHydration.FriendsRequests)
local FriendsRequestsStore = FriendsRequests.FriendsRequestsStore
local UnseenRequestsStore = FriendsRequests.UnseenRequestsStore

local FriendsRecommendations = require(parent2.DataHydration.FriendsRecommendations)
local FriendsRecommendationsStore = FriendsRecommendations.FriendsRecommendationsStore
local DataSource = FriendsRecommendations.Enums.DataSource
local v2 = FFlagRegisterQRCodeKeyInEngine and "ProfileQrCodeCameraSettingsModalSeen" or "ScreenshotEventTracking"
local messageId = MessageBusService:GetMessageId("Realtime", "appResume")
local v3

if defineFastFlag2 then
	v3 = UserProfiles.Stores.UserProfileStore.get()
else
	v3 = nil
end

local eventStream = {
	ProfileQRCodeCameraSettingsModalSeen = {
		context = Contexts.ProfileQRCode,
		eventType = EventTypes.SettingsModalSeenSinceLastAppStart,
		formatRulesForAdditionalInfo = { cameraPermissionResponseStatus = Dash.identity }
	}
}

local function Container(p): nil
	local userId = useLocalUserId()

	local isContactImporterPolicyEnabled = p.isContactImporterPolicyEnabled
		or getAppFeaturePolicies().getContactImporterEnabled()

	useFetchContactImporterInfoOnce({ policyIsEnabled = isContactImporterPolicyEnabled })

	local v4 = nil
	local friends = nil

	if defineFastFlag then
		local v5, v6 = PaginatedFriendsCarouselIXP.usePaginatedFriendsCarouselExperiment()
		local variables = {
			userId = userId,
			sort = v5 and v6 or ApolloFriends.Enums.Sort.FriendshipScore
		}

		if FFlagFriendSortedByPresenceSignalsImplementation then
			local v7 = useSignalState((React.useMemo(function()
				return v.GetAllFriends()
			end, {})))
			friends = v7 and v7.friends or nil

			React.useEffect(function()
				v.GetOnlineFriends()
			end, {})
		else
			v4 = useQuery(queries.allFriendsByUserId, {
				errorPolicy = "all",
				skip = not (v5 and userIdExists(userId)),
				notifyOnNetworkStatusChange = true,
				variables = Cryo.Dictionary.join(variables, {
					pageLimit = FIntFriendsCarouselInitialFetchSize,
					pageCursor = ""
				})
			})

			useQuery(queries.onlineFriendsByUserId, {
				skip = not (v5 and userIdExists(userId)),
				notifyOnNetworkStatusChange = true,
				variables = variables
			})
		end
	end

	if defineFastFlag2 then
		if not FFlagFriendSortedByPresenceSignalsImplementation then
			friends = v4 and v4.data and v4.data.allFriendsByUserId and v4.data.allFriendsByUserId.friends
		end

		React.useEffect(function()
			if userIdExists(userId) then
				local ids = { (tostring(userId)) }

				if friends then
					for _, friend in friends do
						if friend and friend.id then
							table.insert(ids, (tostring(friend.id)))
						end
					end
				end

				v3.fetchNamesByUserIds(ids)
			end
		end, { userId, friends })
	end

	if FFlagSocialCarouselMigrateRecommendations then
		React.useEffect(function()
			if getAppFeaturePolicies().getSocialGraphSyncEnabled() then
				FriendsRecommendationsStore.get().getFriendsRecommendations(DataSource.HomepageFriendsCarousel)
			end
		end, { userId })
	end

	if FFlagGateContactAutoSyncByPolicy then
		useAutoSyncContacts(isContactImporterPolicyEnabled)
	else
		useAutoSyncContacts()
	end

	React.useEffect(function()
		if userIdExists(userId) then
			v.GetFriendsCountByUserId((tostring(userId)))
		end
	end, { userId })

	React.useEffect(function()
		if not userIdExists(userId) then
			return function() end
		end

		if FFlagAddFriendsPageHighlightUnseenTrustedRequests then
			UnseenRequestsStore.get().getUnseenRequestCount()
		else
			FriendsRequestsStore.get().getNewFriendsRequestCount()
		end

		local connection = MessageBusService:Subscribe(messageId, function()
			if FFlagAddFriendsPageHighlightUnseenTrustedRequests then
				UnseenRequestsStore.get().refetchUnseenRequestCount()
			else
				FriendsRequestsStore.get().refetchNewFriendRequestCount()
			end
		end, false, true)
		return function()
			connection:Disconnect()
		end
	end, { userId })

	local v5 = React.useMemo(function()
		return AnalyticsFactory.setUpAnalyticsFactory({
			eventLists = { EventStream = eventStream },
			analyticsImpl = { EventStream = DefaultAnalyticsService.EventStream }
		})()
	end, {})
	React.useEffect(function()
		if AppStorageService:GetItem(v2) == "true" then
			permissionsProtocol.default:checkOrRequestPermissions({ permissionsProtocol.Permissions.CAMERA_ACCESS }):andThen(function(cameraPermissionResponseStatus)
				v5.fireAnalyticsEvent("ProfileQRCodeCameraSettingsModalSeen", {
					cameraPermissionResponseStatus = cameraPermissionResponseStatus
				})
			end)
			AppStorageService:SetItem(v2, "false")
			AppStorageService:Flush()
		end
	end, { userId, v5 })

	return nil
end

return universalAppPolicy.connect(function(p)
	return { isContactImporterPolicyEnabled = p.getContactImporterEnabled() }
end)(Container)
