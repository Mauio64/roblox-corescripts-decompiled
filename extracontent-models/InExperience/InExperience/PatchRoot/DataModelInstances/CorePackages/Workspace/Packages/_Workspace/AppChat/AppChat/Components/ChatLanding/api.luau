local parent = script:FindFirstAncestor("AppChat").Parent

local React = require(parent.React)

return {
	ConversationListUltimate = function(p)
		local ConversationListUltimate = require(script.Parent.ConversationListUltimate)

		return React.createElement(ConversationListUltimate, p)
	end,
	ConversationRow = require(script.Parent.ConversationRow),
	logger = require(script.Parent.Logger),
	screenComponent = require(script.Parent.ChatLandingScreen)
}
