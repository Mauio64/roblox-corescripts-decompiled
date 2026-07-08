local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Theme = require(Modules.Settings.Theme)
local v5 = Roact.PureComponent:extend("RectangleButton")

v5.defaultProps = {
	visible = true
}

function v5.init(p1) -- line: 12
	p1.state = {
		isHovering = false
	}
end
function v5.render(p2) -- line: 18
	-- upvalues: Roact (copy), Theme (copy)
	local size = p2.props.size
	local position = p2.props.position
	local anchorPoint = p2.props.anchorPoint
	local layoutOrder = p2.props.layoutOrder
	local zIndex = p2.props.zIndex
	local onClick = p2.props.onClick
	local visible = p2.props.visible
	local v15 = p2.props[Roact.Children] or {}

	v15.Border = Roact.createElement("UIStroke", {
		Color = Theme.color("DefaultButtonStroke"),
		Transparency = Theme.transparency("DefaultButtonStroke"),
		Thickness = Theme.DefaultStokeThickness
	})
	v15.UICorner = Roact.createElement("UICorner", {
		CornerRadius = Theme.DefaultCornerRadius
	})

	return Roact.createElement("ImageButton", {
		BackgroundTransparency = 1,
		Image = "",
		Selectable = false,
		Size = size,
		Position = position,
		AnchorPoint = anchorPoint,
		LayoutOrder = layoutOrder,
		ZIndex = zIndex,
		Visible = visible,
		[Roact.Event.InputBegan] = function() -- line: 51
			-- upvalues: p2 (copy)
			p2:setState({
				isHovering = true
			})
		end,
		[Roact.Event.InputEnded] = function() -- line: 54
			-- upvalues: p2 (copy)
			p2:setState({
				isHovering = false
			})
		end,
		[Roact.Event.Activated] = function() -- line: 58
			-- upvalues: onClick (copy), p2 (copy)
			if onClick then
				p2:setState({
					isHovering = false
				})
				onClick()
			end
		end
	}, {
		ButtonBackgroundUIBlox = Roact.createElement("ImageLabel", {
			BackgroundColor3 = Theme.color(not p2.state.isHovering and "DefaultButton" or "DefaultButtonHover"),
			BackgroundTransparency = Theme.transparency(not p2.state.isHovering and "DefaultButton" or "DefaultButtonHover"),
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, 0, 1, 0),
			ZIndex = zIndex
		}, v15)
	})
end

return v5
