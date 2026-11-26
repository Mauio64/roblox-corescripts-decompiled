local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Roact")

local EmptyConversationPage = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/EmptyConversationPage")

local extended = Roact.PureComponent:extend("EmptyConversationScreen")
extended.defaultProps = { navigation = nil }

function extended.render(p2)
	local navigation = p2.props.navigation
	assert(type(navigation) ~= "nil", "ChatConversationScreen should be wrapped with Roact Navigation")

	return Roact.createElement(EmptyConversationPage, {
		topBarHeight = navigation.getScreenProps("topBarHeight", 0)
	})
end

return extended
