local parent = script:FindFirstAncestor("DataHydration").Parent

local SduiFriendRecommendationsStoresByConfigKey = require(script.Parent.SduiFriendRecommendationsStoresByConfigKey)

local SharedFlags = require(parent.SharedFlags)
local FFlagPymkCarouselExtendProps = SharedFlags.FFlagPymkCarouselExtendProps

local SduiFriendRecommendations = {
	RecommendationType = require(script.Parent.SduiRecommendationType),
	createStore = 0,
	getStore = 0,
	disposeStore = 0,
	mapFromProto = 0
}
local createStore

if not FFlagPymkCarouselExtendProps then
	createStore = require(script.Parent.createSduiFriendRecommendationsStore)
end

SduiFriendRecommendations.createStore = createStore
local getStore

if FFlagPymkCarouselExtendProps then
	getStore = SduiFriendRecommendationsStoresByConfigKey.get
else
	getStore = require(script.Parent.getSduiFriendRecommendationsStore)
end

SduiFriendRecommendations.getStore = getStore
local disposeStore

if FFlagPymkCarouselExtendProps then
	disposeStore = SduiFriendRecommendationsStoresByConfigKey.dispose
end

SduiFriendRecommendations.disposeStore = disposeStore

SduiFriendRecommendations.mapFromProto = require(script.Parent.mapSduiFriendRecommendationsFromProto)
return SduiFriendRecommendations
