local ExpChatShared = script:FindFirstAncestor("ExpChatShared")
local parent = ExpChatShared.Parent
local Flags = ExpChatShared.Flags

local Rodux = require(parent.Rodux)

local getFFlagUseCharacterStore = require(Flags.getFFlagUseCharacterStore)

local combineReducers = Rodux.combineReducers
local v = {
	byUserId = require(script.Parent.byUserId),
	byDisplayName = require(script.Parent.byDisplayName),
	byUsername = require(script.Parent.byUsername),
	charactersByUserId = 0
}
local charactersByUserId

if not getFFlagUseCharacterStore() then
	charactersByUserId = require(script.Parent.charactersByUserId)
end

v.charactersByUserId = charactersByUserId
return combineReducers(v)
