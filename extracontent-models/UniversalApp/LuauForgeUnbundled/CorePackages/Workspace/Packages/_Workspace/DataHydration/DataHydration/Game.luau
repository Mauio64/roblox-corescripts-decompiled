local module = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/GameInfo/createGameInfoStore")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/Favorites/createFavoritesStore")
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/Followings/createFollowingsStore")
local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/Votes/createVotesStore")
local module5 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/Votes/createUserVoteFeedbackMetadataStore")
local module6 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/Playability/createPlayabilityStore")
local module7 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/AgeRecommendations/createAgeRecommendationStore")
local module8 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/GameMedia/createGameMediaStore")
local module9 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/GameIcon/createGameIconStore")
local module10 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/GameIcon/GameIconSize")

local module11 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/Favorites/getFavoritesStore")
local module12 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/GameInfo/getGameInfoStore")
local module13 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/GameIcon/getGameIconStore")
local module14 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/Followings/getFollowingsStore")
local module15 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/Votes/getVotesStore")
local module16 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/Votes/getUserVoteFeedbackMetadataStore")

local module17 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/AgeRecommendations/getAgeRecommendationStore")
local module18 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/Playability/getPlayabilityStore")
local module19 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/GameMedia/getGameMediaStore")
local module20 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/ConnectionsPlayed/getConnectionsPlayedStore")
local module21 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/ConnectionsPlayed/createConnectionsPlayedStore")

local GamePass = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/GamePass")
local createGamePassStore = GamePass.createGamePassStore
local getGamePassStore = GamePass.getGamePassStore

local GameDeveloperProduct = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/GameDeveloperProduct")
local createGameDeveloperProductStore = GameDeveloperProduct.createGameDeveloperProductStore
local getGameDeveloperProductStore = GameDeveloperProduct.getGameDeveloperProductStore

local GameSubscription = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/GameSubscription")
local createGameSubscriptionStore = GameSubscription.createGameSubscriptionStore
local getGameSubscriptionStore = GameSubscription.getGameSubscriptionStore

require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/Followings/FollowingsStoreTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/Votes/VotesStoreTypes")
local module25 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/Votes/VotesUtils")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/Favorites/FavoritesStoreTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/AgeRecommendations/AgeRecommendationStoreTypes")
local module26 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/AgeRecommendations/AgeRecommendationUtils")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/GameInfo/GameInfoStoreTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/GameIcon/GameIconStoreTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/Playability/PlayabilityStoreTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/GameMedia/GameMediaStoreTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/Votes/UserVoteFeedbackMetadataStoreTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/GamePass/GamePassStoreTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/GameDeveloperProduct/GameDeveloperProductStoreTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/GameSubscription/GameSubscriptionStoreTypes")

local fFlagLuaAppDataHydrationConnectionsPlayedStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagLuaAppDataHydrationConnectionsPlayedStore

if not fFlagLuaAppDataHydrationConnectionsPlayedStore then
	module21 = nil
end

if not fFlagLuaAppDataHydrationConnectionsPlayedStore then
	module20 = nil
end

return {
	createGamePassStore = createGamePassStore,
	getGamePassStore = getGamePassStore,
	createGameDeveloperProductStore = createGameDeveloperProductStore,
	getGameDeveloperProductStore = getGameDeveloperProductStore,
	createGameSubscriptionStore = createGameSubscriptionStore,
	getGameSubscriptionStore = getGameSubscriptionStore,
	createFavoritesStore = module2,
	createAgeRecommendationStore = module7,
	createFollowingsStore = module3,
	createGameInfoStore = module,
	createPlayabilityStore = module6,
	createVotesStore = module4,
	createUserVoteFeedbackMetadataStore = module5,
	createConnectionsPlayedStore = module21,
	getFavoritesStore = module11,
	getAgeRecommendationStore = module17,
	getFollowingsStore = module14,
	getGameInfoStore = module12,
	getPlayabilityStore = module18,
	getVotesStore = module15,
	getUserVoteFeedbackMetadataStore = module16,
	VotesUtils = module25,
	AgeRecommendationUtils = module26,
	getConnectionsPlayedStore = module20,
	createGameMediaStore = module8,
	getGameMediaStore = module19,
	createGameIconStore = module9,
	getGameIconStore = module13,
	GameIconSize = module10
}
