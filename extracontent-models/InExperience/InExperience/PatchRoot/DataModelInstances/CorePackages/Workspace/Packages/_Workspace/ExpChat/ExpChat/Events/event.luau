local ExpChat = script:FindFirstAncestor("ExpChat")
local DispatchBindableEvent = require(ExpChat.DispatchBindableEvent)
local createEvent = require(script.Parent.createEvent)

return createEvent(DispatchBindableEvent)
