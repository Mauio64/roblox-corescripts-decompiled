local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/Rodux")

local getFFlagUseCharacterStore = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Flags/getFFlagUseCharacterStore")

local combineReducers = Rodux.combineReducers
local v5 = {
	byUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Reducers/Players/byUserId"),
	byDisplayName = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Reducers/Players/byDisplayName"),
	byUsername = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Reducers/Players/byUsername"),
	charactersByUserId = 0
}
local v6 = if not getFFlagUseCharacterStore() then require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Reducers/Players/charactersByUserId") else nil
v5.charactersByUserId = v6
return combineReducers(v5)
