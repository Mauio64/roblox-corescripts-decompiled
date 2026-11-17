local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local EventIngestService = game:GetService("EventIngestService")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")

local SocialContextToasts = require(CorePackages.Workspace.Packages.SocialContextToasts)
local SocialContextToastContainer = SocialContextToasts.SocialContextToastContainer
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnablePartyNudgeAfterJoin = SharedFlags.FFlagEnablePartyNudgeAfterJoin

local SharedFlags2 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagShowFriendJoinedYouToastForNonReferredJoins = SharedFlags2.FFlagShowFriendJoinedYouToastForNonReferredJoins

local SharedFlags3 = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagEnableReferredPlayerJoinRemoteEvent = SharedFlags3.GetFFlagEnableReferredPlayerJoinRemoteEvent

local SharedFlags4 = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFIntReferredPlayerJoinRemoteEventTimeout = SharedFlags4.GetFIntReferredPlayerJoinRemoteEventTimeout

local SharedFlags5 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagLuaAppDefaultHttpRetry = SharedFlags5.FFlagLuaAppDefaultHttpRetry
local HttpRequest = require(CorePackages.Packages.HttpRequest)
local config = HttpRequest.config
local v = {
	requestFunction = function(p, p2, p3)
		return HttpRequest.requestFunctions.HttpRbxApi(p, p2, p3)
	end,
	maxRetryCount = 0
}
local maxRetryCount

if FFlagLuaAppDefaultHttpRetry then
	maxRetryCount = game:DefineFastInt("SocialContextToastHttpRetryCount", 4)
end

v.maxRetryCount = maxRetryCount
local networking = config(v)

local ApolloClient = require(CoreGui.RobloxGui.Modules.ApolloClient)
local Analytics = require(CorePackages.Workspace.Packages.Analytics)
local analytics = Analytics.Analytics
local Analytics2 = require(CorePackages.Workspace.Packages.Analytics)
local EventIngest = Analytics2.AnalyticsReporters.EventIngest

local IxpServiceWrapper = require(CorePackages.Workspace.Packages.IxpServiceWrapper)
local IXPServiceWrapper = IxpServiceWrapper.IXPServiceWrapper
local referredPlayerJoin

if GetFFlagEnableReferredPlayerJoinRemoteEvent() then
	referredPlayerJoin = RobloxReplicatedStorage:WaitForChild(
		"ReferredPlayerJoin",
		GetFIntReferredPlayerJoinRemoteEventTimeout()
	)
end

local showPlayerJoinedFriendsToast = nil
local defineFastInt = game:DefineFastInt("FriendPlayerJoinedRemoteEventTimeout", 5)
local showFriendJoinedPlayerToast

if FFlagEnablePartyNudgeAfterJoin or FFlagShowFriendJoinedYouToastForNonReferredJoins then
	showFriendJoinedPlayerToast = RobloxReplicatedStorage:WaitForChild("ShowFriendJoinedPlayerToast", defineFastInt)
end

if FFlagEnablePartyNudgeAfterJoin then
	showPlayerJoinedFriendsToast = RobloxReplicatedStorage:WaitForChild("ShowPlayerJoinedFriendsToast", defineFastInt)
end

SocialContextToastContainer({
	networking = networking,
	playersService = Players,
	apolloClient = ApolloClient,
	analytics = analytics.new(),
	ixpService = IXPServiceWrapper,
	eventIngest = EventIngest.new(EventIngestService),
	referredPlayerJoinRemoteEvent = referredPlayerJoin,
	showFriendJoinedPlayerToastRemoteEvent = showFriendJoinedPlayerToast,
	showPlayerJoinedFriendsToastRemoteEvent = showPlayerJoinedFriendsToast
}, tostring(game.GameId), (tostring(game.PlaceId)))
