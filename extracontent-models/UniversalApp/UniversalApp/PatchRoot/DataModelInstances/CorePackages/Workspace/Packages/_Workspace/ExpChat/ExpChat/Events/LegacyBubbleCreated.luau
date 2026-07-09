local event = require(script.Parent.event)
local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local SharedFlags = require(ExpChatParent.SharedFlags)
local Actions = ExpChat.Actions
local LegacyBubbleCreated = require(Actions.LegacyBubbleCreated)
local GetMessagesStore = require(ExpChat.Stores.GetMessagesStore)

if SharedFlags.FFlagExpChatUseMessagesStore then
	return function(p1) -- line: 14
		-- upvalues: GetMessagesStore (copy)
		GetMessagesStore(false).handleLegacyBubbleCreated(p1)
	end
end

return event(LegacyBubbleCreated)
