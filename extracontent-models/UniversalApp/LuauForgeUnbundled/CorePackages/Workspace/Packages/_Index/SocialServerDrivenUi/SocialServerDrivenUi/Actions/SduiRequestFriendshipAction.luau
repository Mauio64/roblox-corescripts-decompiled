local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SduiCoreSystem")
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local sduiActionType = SduiCoreSystem.SduiActionType

local friendsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/DataHydration").Friends.FriendsStore
local friendsStoreChallengeNetwork = require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/SocialServerDrivenUi/Networking/friendsStoreChallengeNetwork")

local fFlagEnableFriendsStoreChallengeInterceptor = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SharedFlags").FFlagEnableFriendsStoreChallengeInterceptor
local setCurrentToastMessage = require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/ToastRodux").Actions.SetCurrentToastMessage
local enums = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/NetworkingFriends").Enums

local firePlayerFriendAddTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/SocialServerDrivenUi/Analytics/firePlayerFriendAddTelemetry")

local fFlagSduiSearchPeoplePlayerTileTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SharedFlags").FFlagSduiSearchPeoplePlayerTileTelemetry

local rawValue = enums.FriendshipOriginSourceType.PlayerSearch.rawValue()

return function(p2, p3, p4)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.RequestFriendship,
				message = "Missing actionParams"
			},
			p4.appPage
		)
		return
	end

	local targetUserId = actionParams.targetUserId

	if targetUserId == nil or targetUserId == "" then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.RequestFriendship,
				message = "Missing actionParam: targetUserId",
				propName = "targetUserId"
			},
			p4.appPage
		)
		return
	end

	local v5 = actionParams.source

	if typeof(v5) ~= "string" or v5 == "" then
		v5 = rawValue
	end

	local requestFriendship = friendsStore.get().RequestFriendship
	local v7 = if fFlagEnableFriendsStoreChallengeInterceptor then friendsStoreChallengeNetwork else nil
	requestFriendship(targetUserId, v5, nil, v7):andThen(function()
		p4.dependencies.dispatch(setCurrentToastMessage({
			toastMessage = "Feature.Friends.Action.FriendRequestSent",
			isLocalized = false
		}))
	end):catch(function()
		p4.dependencies.dispatch(setCurrentToastMessage({
			toastMessage = "Feature.Toast.NetworkingError.SomethingIsWrong",
			isLocalized = false
		}))
	end)

	if fFlagSduiSearchPeoplePlayerTileTelemetry then
		firePlayerFriendAddTelemetry(targetUserId, p3, p4)
	end
end
