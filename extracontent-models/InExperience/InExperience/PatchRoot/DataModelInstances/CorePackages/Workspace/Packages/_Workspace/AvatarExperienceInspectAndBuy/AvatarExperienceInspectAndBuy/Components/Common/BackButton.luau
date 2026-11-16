local parent = script:FindFirstAncestor("AvatarExperienceInspectAndBuy").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens

return function(props)
	local v = useTokens()

	return React.createElement(Foundation.IconButton, {
		icon = "chevron-large-left",
		Size = props.Size or UDim2.new(0, v.Size.Size_1000, 1, 0),
		Position = props.Position,
		LayoutOrder = 1,
		onActivated = props.onBackButtonClick or function() end
	})
end
