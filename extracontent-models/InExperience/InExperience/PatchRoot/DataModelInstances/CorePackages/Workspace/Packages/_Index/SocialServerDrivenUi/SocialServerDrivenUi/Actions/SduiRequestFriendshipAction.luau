local SocialServerDrivenUi = script:FindFirstAncestor("SocialServerDrivenUi")
local parent = SocialServerDrivenUi.Parent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiActionType = SduiCoreSystem.SduiActionType

local DataHydration = require(parent.DataHydration)
local FriendsStore = DataHydration.Friends.FriendsStore
local friendsStoreChallengeNetwork = require(SocialServerDrivenUi.Networking.friendsStoreChallengeNetwork)

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableFriendsStoreChallengeInterceptor = SharedFlags.FFlagEnableFriendsStoreChallengeInterceptor
local ToastRodux = require(parent.ToastRodux)
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage
local FriendsNetworking = require(parent.FriendsNetworking)
local Enums = FriendsNetworking.Enums

local firePlayerFriendAddTelemetry = require(SocialServerDrivenUi.Analytics.firePlayerFriendAddTelemetry)

local SharedFlags2 = require(parent.SharedFlags)
local FFlagSduiSearchPeoplePlayerTileTelemetry = SharedFlags2.FFlagSduiSearchPeoplePlayerTileTelemetry

local rawValue = Enums.FriendshipOriginSourceType.PlayerSearch.rawValue()

return function(p, p2, p3)
	local actionParams = p and p.actionParams or nil

	if actionParams == nil then
		p3.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = SduiActionType.RequestFriendship, message = "Missing actionParams" },
			p3.appPage
		)
		return
	end

	local targetUserId = actionParams.targetUserId

	if targetUserId == nil or targetUserId == "" then
		p3.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = SduiActionType.RequestFriendship,
				message = "Missing actionParam: targetUserId",
				propName = "targetUserId"
			},
			p3.appPage
		)
		return
	end

	local v = actionParams.source

	if typeof(v) ~= "string" or v == "" then
		v = rawValue
	end

	local requestFriendship = FriendsStore.get().RequestFriendship
	local v2

	if FFlagEnableFriendsStoreChallengeInterceptor then
		v2 = friendsStoreChallengeNetwork
	end

	requestFriendship(targetUserId, v, nil, v2):andThen(function()
		p3.dependencies.dispatch(SetCurrentToastMessage({
			toastMessage = "Feature.Friends.Action.FriendRequestSent",
			isLocalized = false
		}))
	end):catch(function()
		p3.dependencies.dispatch(SetCurrentToastMessage({
			toastMessage = "Feature.Toast.NetworkingError.SomethingIsWrong",
			isLocalized = false
		}))
	end)

	if FFlagSduiSearchPeoplePlayerTileTelemetry then
		firePlayerFriendAddTelemetry(targetUserId, p2, p3)
	end
end
