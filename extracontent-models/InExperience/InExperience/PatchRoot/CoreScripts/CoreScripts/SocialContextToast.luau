local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local EventIngestService = game:GetService("EventIngestService")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local SocialContextToastContainer = require(CorePackages.Workspace.Packages.SocialContextToasts).SocialContextToastContainer
local GetFFlagSocialContextToastEventStream = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagSocialContextToastEventStream
local FFlagEnablePartyNudgeAfterJoin = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnablePartyNudgeAfterJoin
local GetFFlagEnableReferredPlayerJoinRemoteEvent = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableReferredPlayerJoinRemoteEvent
local GetFIntReferredPlayerJoinRemoteEventTimeout = require(CorePackages.Workspace.Packages.SharedFlags).GetFIntReferredPlayerJoinRemoteEventTimeout
local FFlagLuaAppDefaultHttpRetry = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppDefaultHttpRetry
local HttpRequest = require(CorePackages.Packages.HttpRequest)
local v13 = HttpRequest.config({
	requestFunction = function(p1, p2, p3) -- line: 19
		-- upvalues: HttpRequest (copy)
		return HttpRequest.requestFunctions.HttpRbxApi(p1, p2, p3)
	end,
	maxRetryCount = if not FFlagLuaAppDefaultHttpRetry then nil else game:DefineFastInt("SocialContextToastHttpRetryCount", 4)
})
local ApolloClient = require(CoreGui.RobloxGui.Modules.ApolloClient)
local Analytics = require(CorePackages.Workspace.Packages.Analytics).Analytics
local EventIngest = require(CorePackages.Workspace.Packages.Analytics).AnalyticsReporters.EventIngest
local IXPServiceWrapper = require(CorePackages.Workspace.Packages.IxpServiceWrapper).IXPServiceWrapper
local ReferredPlayerJoin = nil

if GetFFlagEnableReferredPlayerJoinRemoteEvent() then
	ReferredPlayerJoin = RobloxReplicatedStorage:WaitForChild("ReferredPlayerJoin", GetFIntReferredPlayerJoinRemoteEventTimeout())
end

local ShowFriendJoinedPlayerToast = nil
local ShowPlayerJoinedFriendsToast = nil
local v21 = game:DefineFastInt("FriendPlayerJoinedRemoteEventTimeout", 5)

if FFlagEnablePartyNudgeAfterJoin then
	ShowFriendJoinedPlayerToast = RobloxReplicatedStorage:WaitForChild("ShowFriendJoinedPlayerToast", v21)
	ShowPlayerJoinedFriendsToast = RobloxReplicatedStorage:WaitForChild("ShowPlayerJoinedFriendsToast", v21)
end

SocialContextToastContainer({
	networking = v13,
	playersService = Players,
	apolloClient = ApolloClient,
	analytics = Analytics.new(),
	ixpService = IXPServiceWrapper,
	eventIngest = EventIngest.new(EventIngestService),
	referredPlayerJoinRemoteEvent = ReferredPlayerJoin,
	showFriendJoinedPlayerToastRemoteEvent = ShowFriendJoinedPlayerToast,
	showPlayerJoinedFriendsToastRemoteEvent = ShowPlayerJoinedFriendsToast
}, if not GetFFlagSocialContextToastEventStream() then game.GameId else tostring(game.GameId), if not GetFFlagSocialContextToastEventStream() then game.PlaceId else tostring(game.PlaceId))
