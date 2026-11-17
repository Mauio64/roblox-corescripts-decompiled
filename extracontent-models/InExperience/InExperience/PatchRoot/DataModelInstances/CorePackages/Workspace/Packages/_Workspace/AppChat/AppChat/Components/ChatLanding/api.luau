local parent = script:FindFirstAncestor("AppChat").Parent

local React = require(parent.React)

return {
	ConversationListViewRecycler = function(p)
		local ConversationListViewRecycler = require(script.Parent.ConversationListViewRecycler)

		return React.createElement(ConversationListViewRecycler, p)
	end,
	ConversationRow = require(script.Parent.ConversationRow)
}
