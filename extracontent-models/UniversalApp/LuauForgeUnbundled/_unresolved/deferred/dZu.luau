local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/Rodux")

local module2 = require("@luauforge/deferred/dZw")

local module3 = require("@luauforge/deferred/dZs")
local fetchingStatus = require("@luauforge/deferred/dZg").Reducers.FetchingStatus
local gameDetailReducer = require("@luauforge/deferred/dZx").GameDetails.GameDetailReducer
local gamesProductInfoReducer = require("@luauforge/deferred/dZy").GamesProductInfoReducer
local module4 = require("@luauforge/deferred/dZz")
local module5 = require("@luauforge/deferred/dZA")
local Networking = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/CapturesInExperience/App/Networking")
local nextDataExpirationTimeReducer = require("@luauforge/deferred/ead").NextDataExpirationTimeReducer
local playabilityStatusReducer = require("@luauforge/deferred/eae").PlayabilityStatus.PlayabilityStatusReducer
local module7 = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/CapturesInExperience/installReducer/ScreenSize")
local showAgeVerificationOverlay = require("@luauforge/deferred/eah").AgeVerificationOverlay.ShowAgeVerificationOverlay
local userGameVotes = require("@luauforge/deferred/dZz").UserGameVotes.UserGameVotes

local v5 = {
	[module3.RoduxKey] = module5(),
	[gamesProductInfoReducer.key] = gamesProductInfoReducer.reducer,
	ContentSharing = Networking.ContentSharingRodux.installReducer(),
	FetchingStatus = fetchingStatus,
	GameDetails = gameDetailReducer,
	GameVotes = module4.GameVotes.GameVotes,
	Games = Networking.RoduxGames.installReducer(),
	NetworkStatus = Networking.RoduxNetworking.installReducer(),
	Personalization = Rodux.combineReducers({
		[nextDataExpirationTimeReducer.key] = nextDataExpirationTimeReducer.reducer
	}),
	PlayabilityStatus = playabilityStatusReducer,
	ScreenSize = module7,
	ShowAgeVerificationOverlay = showAgeVerificationOverlay,
	UserGameVotes = userGameVotes
}

if not module2 then
	v5.Users = Networking.RoduxUsers.installReducer()
end

local combineReducers2 = Rodux.combineReducers(v5)

return function()
	return Rodux.Store.new(combineReducers2, {}, { Rodux.thunkMiddleware })
end
