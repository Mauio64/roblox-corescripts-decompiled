local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Context = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ChatWideModeFocus/Context")

local function useChatWideModeFocus()
	return React.useContext(Context)
end

return useChatWideModeFocus
