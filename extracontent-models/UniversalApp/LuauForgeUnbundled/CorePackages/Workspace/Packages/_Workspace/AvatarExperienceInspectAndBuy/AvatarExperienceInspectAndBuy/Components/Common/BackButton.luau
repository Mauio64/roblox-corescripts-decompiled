local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/Foundation")
local useTokens = Foundation.Hooks.useTokens

return function(props)
	local v5 = useTokens()

	return React.createElement(Foundation.IconButton, {
		icon = "chevron-large-left",
		Size = props.Size or UDim2.new(0, v5.Size.Size_1000, 1, 0),
		Position = props.Position,
		LayoutOrder = 1,
		onActivated = props.onBackButtonClick or function() end
	})
end
