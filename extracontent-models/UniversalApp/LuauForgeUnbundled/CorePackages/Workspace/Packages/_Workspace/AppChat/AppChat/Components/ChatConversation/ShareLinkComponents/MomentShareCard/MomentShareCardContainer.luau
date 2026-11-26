local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")

local MomentShareCardView = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ShareLinkComponents/MomentShareCard/MomentShareCardView")
local useMomentShareCardViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ShareLinkComponents/MomentShareCard/useMomentShareCardViewModel")

local function MomentShareCardContainer(p2)
	local v5 = useMomentShareCardViewModel(p2)
	return React.createElement(MomentShareCardView, v5)
end

return MomentShareCardContainer
