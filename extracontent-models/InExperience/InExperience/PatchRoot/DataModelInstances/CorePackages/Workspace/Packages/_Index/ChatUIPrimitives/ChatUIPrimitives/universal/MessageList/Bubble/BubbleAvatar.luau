local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

require(script.Parent.Parent.Parent.Types)
local Sizing = require(script.Parent.Parent.Parent.Sizing)

local function BubbleAvatar(props)
	local v = SignalsReact.useSignalBinding(props.getIdentity)
	local tag = Sizing.useSizing().avatar.tag
	local tag2 = Foundation.Hooks.useDefaultTags(tag, "stroke-standard stroke-default radius-circle")

	if props.visible then
		return React.createElement(Foundation.Image, {
			tag = tag2,
			Image = v:map(function(p)
				if p and p.avatarContent then
					return p.avatarContent
				end

				return ""
			end),
			LayoutOrder = props.LayoutOrder,
			testId = props.testId
		})
	end

	return React.createElement(Foundation.View, {
		tag = tag,
		LayoutOrder = props.LayoutOrder,
		testId = props.testId
	})
end

return BubbleAvatar
