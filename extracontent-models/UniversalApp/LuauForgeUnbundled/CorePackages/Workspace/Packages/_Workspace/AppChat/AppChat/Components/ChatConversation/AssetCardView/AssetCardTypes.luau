local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")

local buttonVariant = Foundation.Enums.ButtonVariant

require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Grouping/MessageGroupShape")

local frozen = table.freeze({ Loading = "Loading", Ready = "Ready", Error = "Error" })

return table.freeze({ Status = frozen })
