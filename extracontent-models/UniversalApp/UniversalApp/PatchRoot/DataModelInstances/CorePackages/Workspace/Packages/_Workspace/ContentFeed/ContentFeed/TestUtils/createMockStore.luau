local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Dash = require(ParentParentParent.Dash)
local Rodux = require(ParentParentParent.Rodux)
local Constants = require(ParentParent.Constants)
local FetchingStatus = require(ParentParentParent.Http).Reducers.FetchingStatus
local GameDetailReducer = require(ParentParentParent.GameDetailRodux).GameDetails.GameDetailReducer
local GamesProductInfoReducer = require(ParentParentParent.GameProductInfoRodux).GamesProductInfoReducer
local GameVotesRodux = require(ParentParentParent.GameVotesRodux)
local Inspect = require(ParentParent.installReducer.Inspect)
local installReducer = require(ParentParent.installReducer)
local ItemDetails = require(ParentParent.installReducer.ItemDetails)
local Networking = require(ParentParent.App.Networking)
local NextDataExpirationTimeReducer = require(ParentParentParent.NextDataExpirationTimeRodux).NextDataExpirationTimeReducer
local PlayabilityStatusReducer = require(ParentParentParent.PlayabilityRodux).PlayabilityStatus.PlayabilityStatusReducer
local ScreenSize = require(ParentParent.installReducer.ScreenSize)
local ShowAgeVerificationOverlay = require(ParentParentParent.VoiceChat).AgeVerificationOverlay.ShowAgeVerificationOverlay
local UserGameVotes = require(ParentParentParent.GameVotesRodux).UserGameVotes.UserGameVotes
local t1 = {}

local function createMockStore(p1) -- line: 24
	-- upvalues: Dash (copy), t1 (copy), Rodux (copy), Constants (copy), installReducer (copy), GamesProductInfoReducer (copy), Networking (copy), FetchingStatus (copy), Inspect (copy), ItemDetails (copy), GameDetailReducer (copy), GameVotesRodux (copy), NextDataExpirationTimeReducer (copy), PlayabilityStatusReducer (copy), ScreenSize (copy), ShowAgeVerificationOverlay (copy), UserGameVotes (copy)
	local v22 = Dash.joinDeep(t1, p1 or {})
	local v23 = Rodux.combineReducers({
		[Constants.RoduxKey] = installReducer(),
		[GamesProductInfoReducer.key] = GamesProductInfoReducer.reducer,
		ContentSharing = Networking.ContentSharingRodux.installReducer(),
		FetchingStatus = FetchingStatus,
		Inspect = Inspect,
		ItemAssets = ItemDetails,
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

	return Rodux.Store.new(v23, v22, { Rodux.thunkMiddleware })
end

return createMockStore
