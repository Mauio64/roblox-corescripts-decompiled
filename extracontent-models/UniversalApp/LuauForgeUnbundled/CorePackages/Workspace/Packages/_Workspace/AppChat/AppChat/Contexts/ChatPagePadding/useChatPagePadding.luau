local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Context = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ChatPagePadding/Context")

local function useChatPagePadding()
	return React.useContext(Context)
end

return useChatPagePadding
