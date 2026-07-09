local Parent = script:FindFirstAncestor("AppChat").Parent
local Roact = require(Parent.Roact)
local EmptyConversationPage = require(script.Parent.EmptyConversationPage)
local v4 = Roact.PureComponent:extend("EmptyConversationScreen")

v4.defaultProps = {
	navigation = nil
}

function v4.render(p1) -- line: 13
	-- upvalues: Roact (copy), EmptyConversationPage (copy)
	local navigation = p1.props.navigation

	assert(type(navigation) ~= "nil", "ChatConversationScreen should be wrapped with Roact Navigation")

	return Roact.createElement(EmptyConversationPage, {
		topBarHeight = navigation.getScreenProps("topBarHeight", 0)
	})
end

return v4
