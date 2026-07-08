local ParentParent = script.Parent.Parent
local ParentParent2 = ParentParent.Parent.Parent
local React = require(ParentParent2.React)
local Object = require(ParentParent2.LuauPolyfill).Object

require(ParentParent.Style.StyleTypes)

local t1 = {
	zIndex = 1
}

return function(t2: {[any]: any}) -- line: 27
	-- upvalues: Object (copy), t1 (copy), React (copy)
	local v7 = Object.assign({}, t1, t2)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		ZIndex = v7.zIndex,
		Size = UDim2.fromScale(1, 1)
	}, {
		TopContainer = React.createElement("Frame", {
			ClipsDescendants = true,
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(0, 0),
			Size = UDim2.fromScale(1, 0.5)
		}, {
			Content = React.createElement("Frame", {
				Position = UDim2.fromScale(0, 0),
				Size = UDim2.fromScale(1, 2),
				BackgroundColor3 = v7.background.Color,
				BackgroundTransparency = v7.background.Transparency
			}, {
				UICorner = if not v7.topCornerRadius then nil else React.createElement("UICorner", {
					CornerRadius = v7.topCornerRadius
				})
			})
		}),
		BottomContainer = React.createElement("Frame", {
			ClipsDescendants = true,
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(0, 0.5),
			Size = UDim2.fromScale(1, 0.5)
		}, {
			Content = React.createElement("Frame", {
				Position = UDim2.fromScale(0, -1),
				Size = UDim2.fromScale(1, 2),
				BackgroundColor3 = v7.background.Color,
				BackgroundTransparency = v7.background.Transparency
			}, {
				UICorner = if not v7.bottomCornerRadius then nil else React.createElement("UICorner", {
					CornerRadius = v7.bottomCornerRadius
				})
			})
		})
	})
end
