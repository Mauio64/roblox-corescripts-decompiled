local signal = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppCommonLib").Signal

require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/MessageFtuxTooltip/MessageFtuxTooltipVariant")

local v5 = { dismissed = signal.new() }

function v5.dismiss(p2)
	v5.dismissed:fire(p2)
end

return v5
