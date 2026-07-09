local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Rodux = require(ParentParentParent.Rodux)
local Constants = require(ParentParent.Constants)
local FetchingStatus = require(ParentParentParent.Http).Reducers.FetchingStatus
local GameDetailReducer = require(ParentParentParent.GameDetailRodux).GameDetails.GameDetailReducer
local GamesProductInfoReducer = require(ParentParentParent.GameProductInfoRodux).GamesProductInfoReducer
local GameVotesRodux = require(ParentParentParent.GameVotesRodux)
local installReducer = require(ParentParent.installReducer)
local Networking = require(ParentParent.App.Networking)
local NextDataExpirationTimeReducer = require(ParentParentParent.NextDataExpirationTimeRodux).NextDataExpirationTimeReducer
local PlayabilityStatusReducer = require(ParentParentParent.PlayabilityRodux).PlayabilityStatus.PlayabilityStatusReducer
local ScreenSize = require(ParentParent.installReducer.ScreenSize)
local ShowAgeVerificationOverlay = require(ParentParentParent.VoiceChat).AgeVerificationOverlay.ShowAgeVerificationOverlay
local UserGameVotes = require(ParentParentParent.GameVotesRodux).UserGameVotes.UserGameVotes
local v16 = Rodux.combineReducers({
	[Constants.RoduxKey] = installReducer(),
	[GamesProductInfoReducer.key] = GamesProductInfoReducer.reducer,
	ContentSharing = Networking.ContentSharingRodux.installReducer(),
	FetchingStatus = FetchingStatus,
	GameDetails = GameDetailReducer,
	GameVotes = GameVotesRodux.GameVotes.GameVotes,
	Games = Networking.RoduxGames.installReducer(),
	NetworkStatus = Networking.RoduxNetworking.installReducer(),
	Personalization = Rodux.combineReducers({
		[NextDataExpirationTimeReducer.key] = NextDataExpirationTimeReducer.reducer
	}),
	PlayabilityStatus = PlayabilityStatusReducer,
	ScreenSize = ScreenSize,
	ShowAgeVerificationOverlay = ShowAgeVerificationOverlay,
	UserGameVotes = UserGameVotes,
	Users = Networking.RoduxUsers.installReducer()
})

return function() -- line: 38
	-- upvalues: Rodux (copy), v16 (copy)
	return Rodux.Store.new(v16, {}, { Rodux.thunkMiddleware })
end
