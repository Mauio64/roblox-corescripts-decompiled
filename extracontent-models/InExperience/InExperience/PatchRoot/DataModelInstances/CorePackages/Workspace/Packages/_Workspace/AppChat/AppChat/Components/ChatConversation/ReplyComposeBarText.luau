local Parent = script:FindFirstAncestor("AppChat").Parent
local React = require(Parent.React)
local Cryo = require(Parent.Cryo)
local Foundation = require(Parent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local t1 = {
	layoutOrder = 2,
	userText = "",
	contentText = ""
}

function ReplyComposeBarText(t2: {[any]: any}) -- line: 22
	-- upvalues: Cryo (copy), t1 (copy), React (copy), View (copy), FoundationText (copy)
	local v9 = Cryo.Dictionary.union(t1, t2)

	return React.createElement(View, {
		tag = "col fill auto-y align-x-left clip",
		LayoutOrder = v9.layoutOrder
	}, {
		UserReplyingTo = React.createElement(FoundationText, {
			tag = "text-caption-medium content-muted text-truncate-end text-align-x-left auto-xy",
			LayoutOrder = 1,
			Text = v9.userText
		}),
		ContentReplyingTo = React.createElement(FoundationText, {
			tag = "text-body-medium content-emphasis text-truncate-end text-align-x-left auto-xy",
			LayoutOrder = 2,
			Text = v9.contentText
		})
	})
end

return React.memo(ReplyComposeBarText)
