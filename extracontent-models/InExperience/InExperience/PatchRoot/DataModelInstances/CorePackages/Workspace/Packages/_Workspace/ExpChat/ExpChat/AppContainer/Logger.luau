local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatShared = require(ExpChat.Parent.ExpChatShared)
local logger = ExpChatShared.Logger

return logger:new(logger.name .. "/AppContainer")
