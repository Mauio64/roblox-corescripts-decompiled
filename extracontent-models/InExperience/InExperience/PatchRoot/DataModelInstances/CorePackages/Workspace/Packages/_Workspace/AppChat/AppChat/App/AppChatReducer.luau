local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local GameDetailRodux = require(AppChatParent.GameDetailRodux)
local Http = require(AppChatParent.Http)
local PlayabilityRodux = require(AppChatParent.PlayabilityRodux)
local Rodux = require(AppChatParent.Rodux)
local Constants = require(AppChatParent.SquadsCore.Constants)
local installReducer = require(AppChatParent.SquadsCore.installReducer)
local GetFFlagIsSquadEnabled = require(AppChatParent.SharedFlags).GetFFlagIsSquadEnabled
local FormFactorReducer = require(AppChatParent.FormFactor).FormFactorReducer
local UserLib = require(AppChatParent.UserLib)
local GameDetailReducer = GameDetailRodux.GameDetails.GameDetailReducer
local FetchingStatus = Http.Reducers.FetchingStatus
local UserReducer = UserLib.Reducers.UserReducer
local LocalUserIdReducer = UserLib.Reducers.LocalUserIdReducer
local PlayabilityStatusReducer = PlayabilityRodux.PlayabilityStatus.PlayabilityStatusReducer
local SocialBlockingModal = require(AppChatParent.SocialBlockingModal)
local installReducer2 = require(AppChat.installReducer)
local ScreenSize = require(AppChat.installReducer.ScreenSize)
local FriendCount = require(AppChatParent.LegacyFriendsRodux).Reducers.FriendCount
local PlayerContextualMenu = require(AppChatParent.PlayerContextualMenu)
local SquadLocation = require(AppChatParent.SquadsCore.Enums).SquadLocation
local PartyPageCarouselExperimentation = require(AppChatParent.SocialExperiments).PartyPageCarouselExperimentation

return (Rodux.combineReducers({
	PlayerContextualMenu = PlayerContextualMenu.installReducer(),
	EventReceievers = Rodux.combineReducers({
		NetworkStatus = require(AppChat.Http.RoduxNetworking).installReducer()
	}),
	ChatAppReducer = installReducer2(),
	FetchingStatus = FetchingStatus,
	GameDetails = GameDetailReducer,
	LocalUserId = LocalUserIdReducer,
	FriendCount = FriendCount,
	PlayabilityStatus = PlayabilityStatusReducer,
	ScreenSize = if not PartyPageCarouselExperimentation.getPartyPageCarouselEnabled() then nil else ScreenSize,
	FormFactor = FormFactorReducer,
	Users = UserReducer,
	[Constants.RODUX_KEY] = if not GetFFlagIsSquadEnabled() then nil else installReducer(SquadLocation.InExperience),
	[SocialBlockingModal.RoduxKey] = SocialBlockingModal.installReducer()
}))
