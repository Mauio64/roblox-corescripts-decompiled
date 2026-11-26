local AppStorageService = game:GetService("AppStorageService")
local MessageBusService = game:GetService("MessageBusService")

local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/dependencies")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/React")
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/Dash")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/Cryo")
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/RobloxAppHooks")
local SocialCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/SocialCommon")
local useQuery = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/ApolloClient").useQuery
local ApolloLocalState = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/ApolloLocalState")
local ApolloFriends = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/ApolloFriends")
local queries = ApolloLocalState.queries
local SocialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/SocialLuaAnalytics")
local analyticsFactory = SocialLuaAnalytics.Analytics.AnalyticsFactory
local defaultAnalyticsService = SocialLuaAnalytics.Analytics.DefaultAnalyticsService
local eventTypes = SocialLuaAnalytics.Analytics.Enums.EventTypes
local contexts = SocialLuaAnalytics.Analytics.Enums.Contexts

local useFetchContactImporterInfoOnce = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Utils").useFetchContactImporterInfoOnce
local useAutoSyncContacts = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Utils").useAutoSyncContacts
local userIdExists = SocialCommon.Utils.userIdExists
local permissionsProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/PermissionsProtocol").PermissionsProtocol
local UserProfiles = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/UserProfiles")

local useLocalUserId = RobloxAppHooks.useLocalUserId

local universalAppPolicy = dependencies.UniversalAppPolicy
local getAppFeaturePolicies = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/UniversalAppPolicy").getAppFeaturePolicies

local PaginatedFriendsCarouselIXP = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Experiments/PaginatedFriendsCarouselIXP")

local defineFastFlag = game:DefineFastFlag("EarlierFetchTimeForFriendsCarousel_v1", false)
local defineFastFlag2 = game:DefineFastFlag("PrefetchProfileNamesOnStartup_v2", false)

local fIntFriendsCarouselInitialFetchSize = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/SharedFlags").FIntFriendsCarouselInitialFetchSize

local fFlagRegisterQRCodeKeyInEngine = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/SharedFlags").FFlagRegisterQRCodeKeyInEngine

local fFlagAddFriendsPageHighlightUnseenTrustedRequests = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/SharedFlags").FFlagAddFriendsPageHighlightUnseenTrustedRequests

local fFlagSocialCarouselMigrateRecommendations = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/SharedFlags").FFlagSocialCarouselMigrateRecommendations

local fFlagFriendSortedByPresenceSignalsImplementation = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/SharedFlags").FFlagFriendSortedByPresenceSignalsImplementation

local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/SignalsReact").useSignalState
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/DataHydration").Friends.FriendsStore.get()
local FriendsRequests = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/DataHydration/FriendsRequests")
local friendsRequestsStore = FriendsRequests.FriendsRequestsStore
local unseenRequestsStore = FriendsRequests.UnseenRequestsStore

local FriendsRecommendations = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/DataHydration/FriendsRecommendations")
local friendsRecommendationsStore = FriendsRecommendations.FriendsRecommendationsStore
local dataSource = FriendsRecommendations.Enums.DataSource
local v6 = fFlagRegisterQRCodeKeyInEngine and "ProfileQrCodeCameraSettingsModalSeen"
	or "ScreenshotEventTracking"
local messageId = MessageBusService:GetMessageId("Realtime", "appResume")

local v7 = if defineFastFlag2 then UserProfiles.Stores.UserProfileStore.get() else nil

local v8 = {
	ProfileQRCodeCameraSettingsModalSeen = {
		context = contexts.ProfileQRCode,
		eventType = eventTypes.SettingsModalSeenSinceLastAppStart,
		formatRulesForAdditionalInfo = {
			cameraPermissionResponseStatus = Dash.identity
		}
	}
}

local function Container(p2): nil
	local v9 = useLocalUserId()

	local isContactImporterPolicyEnabled = p2.isContactImporterPolicyEnabled
		or getAppFeaturePolicies().getContactImporterEnabled()

	useFetchContactImporterInfoOnce({ policyIsEnabled = isContactImporterPolicyEnabled })

	local v10 = nil
	local friends = nil

	if defineFastFlag then
		local v11, v12 = PaginatedFriendsCarouselIXP.usePaginatedFriendsCarouselExperiment()
		local v13 = {
			userId = v9,
			sort = v11 and v12 or ApolloFriends.Enums.Sort.FriendshipScore
		}

		if fFlagFriendSortedByPresenceSignalsImplementation then
			local v15 = useSignalState((React.useMemo(function()
				return v5.GetAllFriends()
			end, {})))
			friends = v15 and v15.friends or nil

			React.useEffect(function()
				v5.GetOnlineFriends()
			end, {})
		else
			v10 = useQuery(queries.allFriendsByUserId, {
				errorPolicy = "all",
				skip = not (v11 and userIdExists(v9)),
				notifyOnNetworkStatusChange = true,
				variables = Cryo.Dictionary.join(v13, {
					pageLimit = fIntFriendsCarouselInitialFetchSize,
					pageCursor = ""
				})
			})

			useQuery(queries.onlineFriendsByUserId, {
				skip = not (v11 and userIdExists(v9)),
				notifyOnNetworkStatusChange = true,
				variables = v13
			})
		end
	end

	if defineFastFlag2 then
		if not fFlagFriendSortedByPresenceSignalsImplementation then
			friends = v10
				and v10.data
				and v10.data.allFriendsByUserId
				and v10.data.allFriendsByUserId.friends
		end

		React.useEffect(function()
			if userIdExists(v9) then
				local ids = { (tostring(v9)) }

				if friends then
					for k, friend in friends do
						if friend and friend.id then
							table.insert(ids, (tostring(friend.id)))
						end
					end
				end

				v7.fetchNamesByUserIds(ids)
			end
		end, { v9, friends })
	end

	if fFlagSocialCarouselMigrateRecommendations then
		React.useEffect(function()
			if getAppFeaturePolicies().getSocialGraphSyncEnabled() then
				friendsRecommendationsStore.get().getFriendsRecommendations(dataSource.HomepageFriendsCarousel)
			end
		end, { v9 })
	end

	useAutoSyncContacts(isContactImporterPolicyEnabled)

	React.useEffect(function()
		if userIdExists(v9) then
			v5.GetFriendsCountByUserId((tostring(v9)))
		end
	end, { v9 })

	React.useEffect(function()
		if not userIdExists(v9) then
			return function() end
		end

		if fFlagAddFriendsPageHighlightUnseenTrustedRequests then
			unseenRequestsStore.get().getUnseenRequestCount()
		else
			friendsRequestsStore.get().getNewFriendsRequestCount()
		end

		local connection = MessageBusService:Subscribe(messageId, function()
			if fFlagAddFriendsPageHighlightUnseenTrustedRequests then
				unseenRequestsStore.get().refetchUnseenRequestCount()
			else
				friendsRequestsStore.get().refetchNewFriendRequestCount()
			end
		end, false, true)
		return function()
			connection:Disconnect()
		end
	end, { v9 })

	local v11 = React.useMemo(function()
		return analyticsFactory.setUpAnalyticsFactory({
			eventLists = { EventStream = v8 },
			analyticsImpl = { EventStream = defaultAnalyticsService.EventStream }
		})()
	end, {})
	React.useEffect(function()
		if AppStorageService:GetItem(v6) == "true" then
			permissionsProtocol.default:checkOrRequestPermissions({ permissionsProtocol.Permissions.CAMERA_ACCESS }):andThen(function(p3)
				v11.fireAnalyticsEvent("ProfileQRCodeCameraSettingsModalSeen", {
					cameraPermissionResponseStatus = p3
				})
			end)
			AppStorageService:SetItem(v6, "false")
			AppStorageService:Flush()
		end
	end, { v9, v11 })

	return nil
end

return universalAppPolicy.connect(function(p2)
	return { isContactImporterPolicyEnabled = p2.getContactImporterEnabled() }
end)(Container)
