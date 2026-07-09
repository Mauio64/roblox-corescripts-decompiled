local Parent = script:FindFirstAncestor("AvatarExperienceInspectAndBuy").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local useTokens = Foundation.Hooks.useTokens

return function(t1: {[any]: any}) -- line: 19
	-- upvalues: useTokens (copy), React (copy), Foundation (copy)
	local v6 = useTokens()

	return React.createElement(Foundation.IconButton, {
		icon = "chevron-large-left",
		LayoutOrder = 1,
		Size = t1.Size or UDim2.new(0, v6.Size.Size_1000, 1, 0),
		Position = t1.Position,
		onActivated = t1.onBackButtonClick or function() -- line: 28
		end
	})
end
