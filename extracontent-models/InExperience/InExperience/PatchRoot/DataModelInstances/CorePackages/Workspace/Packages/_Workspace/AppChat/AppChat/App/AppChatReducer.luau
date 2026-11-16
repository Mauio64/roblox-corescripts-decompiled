local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent
local GameDetailRodux = require(parent.GameDetailRodux)
local Http = require(parent.Http)
local PlayabilityRodux = require(parent.PlayabilityRodux)
local Rodux = require(parent.Rodux)
local Constants = require(parent.SquadsCore.Constants)
local installReducer = require(parent.SquadsCore.installReducer)
local SharedFlags = require(parent.SharedFlags)
local GetFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled
local SharedFlags2 = require(parent.SharedFlags)
local FFlagRemoveUnusedFriendCountRoduxSlice = SharedFlags2.FFlagRemoveUnusedFriendCountRoduxSlice

local FormFactor = require(parent.FormFactor)
local FormFactorReducer = FormFactor.FormFactorReducer
local UserLib = require(parent.UserLib)

local GameDetailReducer = GameDetailRodux.GameDetails.GameDetailReducer
local FetchingStatus = Http.Reducers.FetchingStatus
local UserReducer = UserLib.Reducers.UserReducer
local LocalUserIdReducer = UserLib.Reducers.LocalUserIdReducer
local PlayabilityStatusReducer = PlayabilityRodux.PlayabilityStatus.PlayabilityStatusReducer
local SocialBlockingModal = require(parent.SocialBlockingModal)

local installReducer2 = require(AppChat.installReducer)
local ScreenSize = require(AppChat.installReducer.ScreenSize)

local LegacyFriendsRodux = require(parent.LegacyFriendsRodux)
local FriendCount = LegacyFriendsRodux.Reducers.FriendCount
local PlayerContextualMenu = require(parent.PlayerContextualMenu)

local Enums = require(parent.SquadsCore.Enums)
local SquadLocation = Enums.SquadLocation

local SocialExperiments = require(parent.SocialExperiments)
local PartyPageCarouselExperimentation = SocialExperiments.PartyPageCarouselExperimentation

local combineReducers = Rodux.combineReducers
local v = {}
v.PlayerContextualMenu = PlayerContextualMenu.installReducer()
local combineReducers2 = Rodux.combineReducers
local RoduxNetworking = require(AppChat.Http.RoduxNetworking)
v.EventReceievers = combineReducers2({
	NetworkStatus = RoduxNetworking.installReducer()
})

v.ChatAppReducer = installReducer2()
v.FetchingStatus = FetchingStatus
v.GameDetails = GameDetailReducer
v.LocalUserId = LocalUserIdReducer

if FFlagRemoveUnusedFriendCountRoduxSlice then
	FriendCount = nil
end

v.FriendCount = FriendCount
v.PlayabilityStatus = PlayabilityStatusReducer

if not PartyPageCarouselExperimentation.getPartyPageCarouselEnabled() then
	ScreenSize = nil
end

v.ScreenSize = ScreenSize
v.FormFactor = FormFactorReducer
v.Users = UserReducer
local RODUX_KEY = Constants.RODUX_KEY
local v2

if GetFFlagIsSquadEnabled() then
	v2 = installReducer(SquadLocation.InExperience)
end

v[RODUX_KEY] = v2

v[SocialBlockingModal.RoduxKey] = SocialBlockingModal.installReducer()
return (combineReducers(v))
