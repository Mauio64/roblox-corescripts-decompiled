local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local Roact = require(SocialLibraries.dependencies).Roact
local v3 = Roact.PureComponent:extend("MaskedIcon")

v3.defaultProps = {
	icon = "rbxasset://textures/ui/LuaChat/icons/share-game-thumbnail.png"
}

function v3.render(p1) -- line: 13
	-- upvalues: Roact (copy)
	local props = p1.props

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		layout = Roact.createElement("UIListLayout", {
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		}),
		button = Roact.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			Image = props.icon,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			layout = Roact.createElement("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}),
			mask = Roact.createElement("ImageLabel", {
				BackgroundTransparency = 1,
				Image = "rbxasset://textures/ui/LuaChat/graphic/gr-mask-game-icon-48x48.png",
				Size = UDim2.new(1, 0, 1, 0)
			})
		})
	})
end

return v3
