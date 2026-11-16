local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

require(script.Parent.Parent.Parent.Types)
local MessageTimestamp = require(script.Parent.Parent.Parent.Adornments.MessageTimestamp)

local function toDisplayName(p)
	return if p then p.displayName else ""
end

local function DiscussionTopLine(props)
	local v = SignalsReact.useSignalBinding(props.getIdentity)
	local text = React.useMemo(function()
		return v:map(toDisplayName)
	end, { v })

	return React.createElement(
		Foundation.View,
		{ tag = props.tag, LayoutOrder = props.LayoutOrder, testId = props.testId },
		{
			Name = React.createElement(Foundation.Text, {
				tag = props.nameTag,
				Text = text,
				LayoutOrder = 1,
				testId = "discussion-name"
			}),
			Timestamp = React.createElement(MessageTimestamp, {
				getSentAtUnixMilliseconds = props.getSentAtUnixMilliseconds,
				tag = props.timestampTag,
				LayoutOrder = 2,
				testId = "discussion-timestamp"
			})
		}
	)
end

return React.memo(DiscussionTopLine)
