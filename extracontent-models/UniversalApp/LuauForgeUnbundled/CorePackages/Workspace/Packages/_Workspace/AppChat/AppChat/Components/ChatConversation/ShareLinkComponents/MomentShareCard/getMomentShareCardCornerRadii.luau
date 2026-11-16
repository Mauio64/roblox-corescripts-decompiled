local getCornerRadii = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ShareLinkComponents/getCornerRadii")

local function getMomentShareCardCornerRadii(p2, p3, p4)
	return getCornerRadii({
		topLeft = not (not p2 and p3),
		topRight = not not (p2 or p3)
	}, p4)
end

return getMomentShareCardCornerRadii
