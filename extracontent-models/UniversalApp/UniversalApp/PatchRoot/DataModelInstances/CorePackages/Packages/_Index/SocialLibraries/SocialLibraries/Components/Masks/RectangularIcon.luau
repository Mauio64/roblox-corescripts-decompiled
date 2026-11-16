local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local roact = dependencies.Roact

local extended = roact.PureComponent:extend("MaskedIcon")
extended.defaultProps = { icon = "rbxasset://textures/ui/LuaChat/icons/share-game-thumbnail.png" }

function extended.render(p)
	local props = p.props

	return roact.createElement("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0) }, {
		layout = roact.createElement("UIListLayout", {
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		}),
		button = roact.createElement(
			"ImageLabel",
			{ BackgroundTransparency = 1, Image = props.icon, Size = UDim2.new(1, 0, 1, 0) },
			{
				layout = roact.createElement("UIListLayout", {
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Center
				}),
				mask = roact.createElement("ImageLabel", {
					BackgroundTransparency = 1,
					Image = "rbxasset://textures/ui/LuaChat/graphic/gr-mask-game-icon-48x48.png",
					Size = UDim2.new(1, 0, 1, 0)
				})
			}
		)
	})
end

return extended
