local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Reactions = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Reactions")

local useMessageReactionCounts = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/MessageReactions/useMessageReactionCounts")

local function MessageReactionChip(props)
	local v5 = useMessageReactionCounts(props.messageId)

	if v5 == nil then
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
			reactionCounts = v5
		})
	})
end

return React.memo(MessageReactionChip)
