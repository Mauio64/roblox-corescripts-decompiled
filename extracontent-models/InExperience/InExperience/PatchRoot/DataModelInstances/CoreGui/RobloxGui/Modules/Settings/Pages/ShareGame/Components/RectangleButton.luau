local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local CoreGui = game:GetService("CoreGui")
local Modules = CoreGui.RobloxGui.Modules
local Theme = require(Modules.Settings.Theme)

local extended = Roact.PureComponent:extend("RectangleButton")
extended.defaultProps = { visible = true }

function extended:init()
	self.state = { isHovering = false }
end

function extended.render(object)
	local size = object.props.size
	local position = object.props.position
	local anchorPoint = object.props.anchorPoint
	local layoutOrder = object.props.layoutOrder
	local zIndex = object.props.zIndex
	local onClick = object.props.onClick
	local visible = object.props.visible
	local children = object.props[Roact.Children] or {}

	children.Border = Roact.createElement("UIStroke", {
		Color = Theme.color("DefaultButtonStroke"),
		Transparency = Theme.transparency("DefaultButtonStroke"),
		Thickness = Theme.DefaultStokeThickness
	})

	children.UICorner = Roact.createElement("UICorner", { CornerRadius = Theme.DefaultCornerRadius })

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
		[Roact.Event.InputBegan] = function()
			object:setState({ isHovering = true })
		end,
		[Roact.Event.InputEnded] = function()
			object:setState({ isHovering = false })
		end,
		[Roact.Event.Activated] = function()
			if onClick then
				object:setState({ isHovering = false })
				onClick()
			end
		end
	}, {
		ButtonBackgroundUIBlox = Roact.createElement("ImageLabel", {
			BackgroundColor3 = Theme.color(object.state.isHovering and "DefaultButtonHover" or "DefaultButton"),
			BackgroundTransparency = Theme.transparency(object.state.isHovering and "DefaultButtonHover" or "DefaultButton"),
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, 0, 1, 0),
			ZIndex = zIndex
		}, children)
	})
end

return extended
