local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local Cryo = require(DiscoveryMonolithParent.Cryo)
local Rodux = require(DiscoveryMonolithParent.Rodux)
local FetchingStatus = require(DiscoveryMonolithParent.Http).Reducers.FetchingStatus
local GameInfosReducer = require(DiscoveryMonolithParent.GameInfosRodux).GameInfosReducer
local FetchStatusReducer = require(DiscoveryMonolithParent.FetchStatusRodux).FetchStatusReducer
local GameIconReducer = require(DiscoveryMonolithParent.GameIconRodux).GameIcons.GameIconReducer
local TopicContentsReducer = require(DiscoveryMonolithParent.TopicContentsRodux).TopicContentsReducer
local GameFiltersReducer = require(DiscoveryMonolithParent.GameFilters).DataStore.GameFiltersReducer
local TopicInfosReducer = require(DiscoveryMonolithParent.TopicInfosRodux).TopicInfosReducer
local NextDataExpirationTimeReducer = require(DiscoveryMonolithParent.NextDataExpirationTimeRodux).NextDataExpirationTimeReducer
local Modules = DiscoveryMonolith.Modules
local GameGridFlexFeedItemBounds = require(Modules.Personalization.OmniFeed.DataStore.GameGridFlexFeedItemBounds)
local FFlagLuaAppChartsStickyHeader = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppChartsStickyHeader
local v16 = Rodux.combineReducers({
	FetchingStatus = FetchingStatus,
	GameDetails = require(DiscoveryMonolithParent.GameDetailRodux).GameDetails.GameDetailReducer,
	[GameIconReducer.key] = GameIconReducer.reducer,
	GameVotes = require(DiscoveryMonolithParent.GameVotesRodux).GameVotes.GameVotes,
	InGameUsersByGame = function(p1, _) -- line: 27
		return p1 or {}
	end,
	OmniRecommendations = require(Modules.LuaApp.Reducers.Games.OmniRecommendations),
	OmniRecommendationsRefreshTime = require(Modules.LuaApp.Reducers.Games.OmniRecommendationsRefreshTime),
	Personalization = Rodux.combineReducers({
		[FetchStatusReducer.key] = FetchStatusReducer.reducer,
		[GameFiltersReducer.key] = GameFiltersReducer.reducer,
		GameGridFlexFeedItemBounds = GameGridFlexFeedItemBounds,
		[GameInfosReducer.key] = GameInfosReducer.reducer,
		[NextDataExpirationTimeReducer.key] = NextDataExpirationTimeReducer.reducer,
		OrderedOmniItems = if not FFlagLuaAppChartsStickyHeader then nil else function(p3, _) -- line: 40
			return p3 or {}
		end,
		[TopicContentsReducer.key] = TopicContentsReducer.reducer,
		[TopicInfosReducer.key] = TopicInfosReducer.reducer
	}),
	RequestsStatus = require(Modules.LuaApp.Reducers.RequestsStatus),
	UserGameVotes = require(DiscoveryMonolithParent.GameVotesRodux).UserGameVotes.UserGameVotes
})

local function v17(p5, p6) -- line: 51
	-- upvalues: v16 (copy)
	return v16(p5, p6)
end

return {
	new = function(p7, p8) -- line: 57
		-- upvalues: Cryo (copy), Rodux (copy), v17 (copy)
		if p8 == nil then
			p8 = {}
		end

		local v26 = Cryo.List.join(p8, { Rodux.thunkMiddleware })

		return Rodux.Store.new(v17, p7 or {}, v26)
	end
}
