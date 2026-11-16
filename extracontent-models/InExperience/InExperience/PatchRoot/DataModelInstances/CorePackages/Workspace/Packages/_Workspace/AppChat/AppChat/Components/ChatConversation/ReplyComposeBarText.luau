local parent = script:FindFirstAncestor("AppChat").Parent
local React = require(parent.React)
local Cryo = require(parent.Cryo)
local Foundation = require(parent.Foundation)

local View = Foundation.View
local Text = Foundation.Text

local v = { layoutOrder = 2, userText = "", contentText = "" }

function ReplyComposeBarText(p)
	local union = Cryo.Dictionary.union(v, p)

	return React.createElement(View, {
		tag = "col fill auto-y align-x-left clip",
		LayoutOrder = union.layoutOrder
	}, {
		UserReplyingTo = React.createElement(Text, {
			tag = "text-caption-medium content-muted text-truncate-end text-align-x-left auto-xy",
			Text = union.userText,
			LayoutOrder = 1
		}),
		ContentReplyingTo = React.createElement(Text, {
			tag = "text-body-medium content-emphasis text-truncate-end text-align-x-left auto-xy",
			Text = union.contentText,
			LayoutOrder = 2
		})
	})
end

return React.memo(ReplyComposeBarText)
