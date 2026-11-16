local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

require(script.Parent.Parent.Parent.Types)
local Sizing = require(script.Parent.Parent.Parent.Sizing)

local flexItem = { ItemLineAlignment = Enum.ItemLineAlignment.Start }

local function BubbleUsername(props)
	local v = SignalsReact.useSignalBinding(props.getIdentity)
	local v2 = Sizing.useSizing()
	local tag = Foundation.Hooks.useDefaultTags(v2.username.tag, "auto-xy text-align-x-left")

	return React.createElement(Foundation.Text, {
		tag = tag,
		flexItem = flexItem,
		Text = v:map(function(p)
			return if p then p.displayName else ""
		end),
		LayoutOrder = props.LayoutOrder,
		testId = props.testId
	})
end

return BubbleUsername
