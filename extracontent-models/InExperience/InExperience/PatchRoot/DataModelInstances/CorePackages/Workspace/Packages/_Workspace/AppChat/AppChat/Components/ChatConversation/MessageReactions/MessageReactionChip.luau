local parent = script:FindFirstAncestor("AppChat").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Reactions = require(parent.Reactions)

local useMessageReactionCounts = require(script.Parent.useMessageReactionCounts)

local function MessageReactionChip(props)
	local reactionCounts = useMessageReactionCounts(props.messageId)

	if reactionCounts == nil then
		return nil
	end

	return React.createElement(Foundation.View, {
		tag = {
			["col align-y-bottom size-full-600"] = true,
			["align-x-left"] = props.isIncoming,
			["align-x-right"] = not props.isIncoming
		},
		ZIndex = 2,
		LayoutOrder = props.layoutOrder,
		testId = "MessageReactionChip"
	}, {
		ReactionChip = React.createElement(Reactions.ReactionChip, {
			reactionCounts = reactionCounts
		})
	})
end

return React.memo(MessageReactionChip)
