local ExpChatShared = script:FindFirstAncestor("ExpChatShared")
local ExpChatSharedParent = ExpChatShared.Parent
local Flags = ExpChatShared.Flags
local Rodux = require(ExpChatSharedParent.Rodux)
local getFFlagUseCharacterStore = require(Flags.getFFlagUseCharacterStore)

return Rodux.combineReducers({
	byUserId = require(script.Parent.byUserId),
	byDisplayName = require(script.Parent.byDisplayName),
	byUsername = require(script.Parent.byUsername),
	charactersByUserId = if not getFFlagUseCharacterStore() then require(script.Parent.charactersByUserId) else nil
})
