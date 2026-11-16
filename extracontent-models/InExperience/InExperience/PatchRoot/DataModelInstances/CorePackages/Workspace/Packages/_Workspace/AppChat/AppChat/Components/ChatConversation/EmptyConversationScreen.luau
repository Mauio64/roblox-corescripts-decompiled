local parent = script:FindFirstAncestor("AppChat").Parent

local Roact = require(parent.Roact)

local EmptyConversationPage = require(script.Parent.EmptyConversationPage)

local extended = Roact.PureComponent:extend("EmptyConversationScreen")
extended.defaultProps = { navigation = nil }

function extended.render(p)
	local navigation = p.props.navigation
	assert(type(navigation) ~= "nil", "ChatConversationScreen should be wrapped with Roact Navigation")

	return Roact.createElement(EmptyConversationPage, {
		topBarHeight = navigation.getScreenProps("topBarHeight", 0)
	})
end

return extended
