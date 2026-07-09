local event = require(script.Parent.event)
local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local SharedFlags = require(ExpChatParent.SharedFlags)
local Actions = ExpChat.Actions
local LegacyBubbleTextUpdated = require(Actions.LegacyBubbleTextUpdated)
local GetMessagesStore = require(ExpChat.Stores.GetMessagesStore)

if SharedFlags.FFlagExpChatUseMessagesStore then
	return function(s1: string, s2: string) -- line: 14
		-- upvalues: GetMessagesStore (copy)
		GetMessagesStore(false).handleLegacyBubbleTextUpdated(s1, s2)
	end
end

return event(LegacyBubbleTextUpdated)
