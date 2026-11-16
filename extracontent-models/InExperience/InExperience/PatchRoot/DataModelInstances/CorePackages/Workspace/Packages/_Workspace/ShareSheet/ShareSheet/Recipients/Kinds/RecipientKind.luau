local parent = script:FindFirstAncestor("ShareSheet").Parent

require(parent.AppChat.GetExternalChatMessageSenderStore)
require(parent.LuauPolyfill)
require(parent.Signals)

return {}
