local GameDetailRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/GameDetailRodux")
local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Http")
local PlayabilityRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/PlayabilityRodux")
local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Rodux")
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SquadsCore/Constants")
local installReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SquadsCore/installReducer")
local getFFlagIsSquadEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").GetFFlagIsSquadEnabled
local fFlagRemoveUnusedFriendCountRoduxSlice = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagRemoveUnusedFriendCountRoduxSlice

local formFactorReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/FormFactor").FormFactorReducer
local UserLib = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UserLib")

local gameDetailReducer = GameDetailRodux.GameDetails.GameDetailReducer
local fetchingStatus = Http.Reducers.FetchingStatus
local userReducer = UserLib.Reducers.UserReducer
local localUserIdReducer = UserLib.Reducers.LocalUserIdReducer
local playabilityStatusReducer = PlayabilityRodux.PlayabilityStatus.PlayabilityStatusReducer
local SocialBlockingModal = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialBlockingModal")

local module9 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/installReducer")
local ScreenSize = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/installReducer/ScreenSize")

local friendCount = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/LegacyFriendsRodux").Reducers.FriendCount
local PlayerContextualMenu = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/PlayerContextualMenu")

local squadLocation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SquadsCore/Enums").SquadLocation

local partyPageCarouselExperimentation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialExperiments").PartyPageCarouselExperimentation

local combineReducers = Rodux.combineReducers
local v5 = {}
v5.PlayerContextualMenu = PlayerContextualMenu.installReducer()
v5.EventReceievers = Rodux.combineReducers({
	NetworkStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Http/RoduxNetworking").installReducer()
})

v5.ChatAppReducer = module9()
v5.FetchingStatus = fetchingStatus
v5.GameDetails = gameDetailReducer
v5.LocalUserId = localUserIdReducer

if fFlagRemoveUnusedFriendCountRoduxSlice then
	friendCount = nil
end

v5.FriendCount = friendCount
v5.PlayabilityStatus = playabilityStatusReducer

if not partyPageCarouselExperimentation.getPartyPageCarouselEnabled() then
	ScreenSize = nil
end

v5.ScreenSize = ScreenSize
v5.FormFactor = formFactorReducer
v5.Users = userReducer
local RODUX_KEY = Constants.RODUX_KEY
local v6 = if getFFlagIsSquadEnabled() then installReducer(squadLocation.InExperience) else nil
v5[RODUX_KEY] = v6

v5[SocialBlockingModal.RoduxKey] = SocialBlockingModal.installReducer()
return (combineReducers(v5))
