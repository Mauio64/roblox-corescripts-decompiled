local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local EventIngestService = game:GetService("EventIngestService")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")

local SocialContextToasts = require(CorePackages.Workspace.Packages.SocialContextToasts)
local SocialContextToastContainer = SocialContextToasts.SocialContextToastContainer
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagSocialContextToastEventStream = SharedFlags.GetFFlagSocialContextToastEventStream
local SharedFlags2 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnablePartyNudgeAfterJoin = SharedFlags2.FFlagEnablePartyNudgeAfterJoin

local SharedFlags3 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagShowFriendJoinedYouToastForNonReferredJoins = SharedFlags3.FFlagShowFriendJoinedYouToastForNonReferredJoins

local SharedFlags4 = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagEnableReferredPlayerJoinRemoteEvent = SharedFlags4.GetFFlagEnableReferredPlayerJoinRemoteEvent

local SharedFlags5 = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFIntReferredPlayerJoinRemoteEventTimeout = SharedFlags5.GetFIntReferredPlayerJoinRemoteEventTimeout

local SharedFlags6 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagLuaAppDefaultHttpRetry = SharedFlags6.FFlagLuaAppDefaultHttpRetry
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

local v2 = {
	networking = networking,
	playersService = Players,
	apolloClient = ApolloClient,
	analytics = analytics.new(),
	ixpService = IXPServiceWrapper,
	eventIngest = EventIngest.new(EventIngestService),
	referredPlayerJoinRemoteEvent = referredPlayerJoin,
	showFriendJoinedPlayerToastRemoteEvent = showFriendJoinedPlayerToast,
	showPlayerJoinedFriendsToastRemoteEvent = showPlayerJoinedFriendsToast
}
local gameId

if GetFFlagSocialContextToastEventStream() then
	gameId = tostring(game.GameId)
else
	gameId = game.GameId
end

local v3

if GetFFlagSocialContextToastEventStream() then
	v3 = tostring(game.PlaceId)
else
	v3 = game.PlaceId
end

SocialContextToastContainer(v2, gameId, v3)
