local Parent = script:FindFirstAncestor("AppChat").Parent
local React = require(Parent.React)

return {
	ConversationListUltimate = function(p1) -- line: 6
		-- upvalues: React (copy)
		local ConversationListUltimate = require(script.Parent.ConversationListUltimate)

		return React.createElement(ConversationListUltimate, p1)
	end,
	ConversationRow = require(script.Parent.ConversationRow),
	logger = require(script.Parent.Logger),
	screenComponent = require(script.Parent.ChatLandingScreen)
}
