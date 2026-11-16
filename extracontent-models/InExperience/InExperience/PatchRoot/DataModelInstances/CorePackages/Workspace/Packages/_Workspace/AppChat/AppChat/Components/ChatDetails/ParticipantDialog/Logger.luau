local AppChat = script:FindFirstAncestor("AppChat")
local Logger = require(AppChat.Logger)

local v = Logger:new(script:GetFullName() .. ":ParticipantDialogScreen")
v:setContext({ screen = "ParticipantDialogScreen" })

return v
