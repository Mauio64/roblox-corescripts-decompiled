local ExpChat = script:FindFirstAncestor("ExpChat")
local Logger = require(ExpChat.Parent.ExpChatShared).Logger

return Logger:new(Logger.name .. "/AppContainer")
