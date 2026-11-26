local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")

local view = Foundation.View
local text = Foundation.Text

local v5 = { layoutOrder = 2, userText = "", contentText = "" }

function LUAUFORGE_MODULE_GLOBALS_hzY_ReplyComposeBarText(p2)
	local union = Cryo.Dictionary.union(v5, p2)

	return React.createElement(
		view,
		{ tag = "col fill auto-y align-x-left clip", LayoutOrder = union.layoutOrder },
		{
			UserReplyingTo = React.createElement(text, {
				tag = "text-caption-medium content-muted text-truncate-end text-align-x-left auto-xy",
				Text = union.userText,
				LayoutOrder = 1
			}),
			ContentReplyingTo = React.createElement(text, {
				tag = "text-body-medium content-emphasis text-truncate-end text-align-x-left auto-xy",
				Text = union.contentText,
				LayoutOrder = 2
			})
		}
	)
end

return React.memo(LUAUFORGE_MODULE_GLOBALS_hzY_ReplyComposeBarText)
