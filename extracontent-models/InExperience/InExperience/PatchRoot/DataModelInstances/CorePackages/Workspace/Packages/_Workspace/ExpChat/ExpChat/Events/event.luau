local ExpChat = script:FindFirstAncestor("ExpChat")
local DispatchBindableEvent = require(ExpChat.DispatchBindableEvent)

return require(script.Parent.createEvent)(DispatchBindableEvent)
