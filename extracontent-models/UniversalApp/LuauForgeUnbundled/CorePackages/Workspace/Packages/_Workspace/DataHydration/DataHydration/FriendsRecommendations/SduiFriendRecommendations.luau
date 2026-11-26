local SduiFriendRecommendationsStoresByConfigKey = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/FriendsRecommendations/SduiFriendRecommendationsStoresByConfigKey")

local fFlagPymkCarouselExtendProps = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagPymkCarouselExtendProps

local v5 = {
	RecommendationType = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/FriendsRecommendations/SduiRecommendationType"),
	createStore = 0,
	getStore = 0,
	disposeStore = 0,
	mapFromProto = 0
}

local v6 = if not fFlagPymkCarouselExtendProps then require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/FriendsRecommendations/createSduiFriendRecommendationsStore") else nil
v5.createStore = v6

local v7 = if fFlagPymkCarouselExtendProps then SduiFriendRecommendationsStoresByConfigKey.get else require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/FriendsRecommendations/getSduiFriendRecommendationsStore")
v5.getStore = v7

local v8 = if fFlagPymkCarouselExtendProps then SduiFriendRecommendationsStoresByConfigKey.dispose else nil
v5.disposeStore = v8

v5.mapFromProto = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/FriendsRecommendations/mapSduiFriendRecommendationsFromProto")
return v5
