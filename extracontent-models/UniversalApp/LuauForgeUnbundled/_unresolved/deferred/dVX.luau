local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/Rodux")

local module2 = require("@luauforge/deferred/dVZ")

local module3 = require("@luauforge/deferred/dVV")
local fetchingStatus = require("@luauforge/deferred/dVJ").Reducers.FetchingStatus
local gameDetailReducer = require("@luauforge/deferred/dWa").GameDetails.GameDetailReducer
local gamesProductInfoReducer = require("@luauforge/deferred/dWb").GamesProductInfoReducer
local module4 = require("@luauforge/deferred/dWc")
local module5 = require("@luauforge/deferred/dWd")
local Networking = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/CapturesInExperience/App/Networking")
local nextDataExpirationTimeReducer = require("@luauforge/deferred/dWG").NextDataExpirationTimeReducer
local playabilityStatusReducer = require("@luauforge/deferred/dWH").PlayabilityStatus.PlayabilityStatusReducer
local module7 = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/CapturesInExperience/installReducer/ScreenSize")
local showAgeVerificationOverlay = require("@luauforge/deferred/dWK").AgeVerificationOverlay.ShowAgeVerificationOverlay
local userGameVotes = require("@luauforge/deferred/dWc").UserGameVotes.UserGameVotes

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
