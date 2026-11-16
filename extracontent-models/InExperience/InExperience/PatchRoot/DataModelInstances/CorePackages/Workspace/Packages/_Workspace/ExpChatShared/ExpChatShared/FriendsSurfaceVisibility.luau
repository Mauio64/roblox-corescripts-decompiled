local parent = script:FindFirstAncestor("ExpChatShared").Parent

local Signals = require(parent.Signals)

local signal, setVisibleConversationId = Signals.createSignal(nil)

return { getVisibleConversationId = signal, setVisibleConversationId = setVisibleConversationId }
