local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local ChatBubbleEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Bubble/ChatBubbleEnum")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")

local v5 = { isIncoming = false }

function LUAUFORGE_MODULE_GLOBALS_hls_RepliedToMarker(p2)
	local union = Cryo.Dictionary.union(v5, p2)

	local createElement = React.createElement
	local view = Foundation.View
	local v6 = {
		tag = "bg-shift-400 self-stretch",
		Size = UDim2.new(0, ChatBubbleEnum.REPLIED_TO_MARKER_WIDTH, 0, 0),
		BorderSizePixel = 0,
		AnchorPoint = 0,
		LayoutOrder = 0
	}

	local v7 = if union.isIncoming then Vector2.new(0, 0) else Vector2.new(1, 0)
	v6.AnchorPoint = v7
	v6.LayoutOrder = union.layoutOrder
	return createElement(view, v6, {
		UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(1, 0) })
	})
end

return React.memo(LUAUFORGE_MODULE_GLOBALS_hls_RepliedToMarker)
