local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Foundation = require(parent.Foundation)
require(parent.React)

local ButtonVariant = Foundation.Enums.ButtonVariant

require(AppChat.Components.ChatConversation.Grouping.MessageGroupShape)

local frozen = table.freeze({ Loading = "Loading", Ready = "Ready", Error = "Error" })

return table.freeze({ Status = frozen })
