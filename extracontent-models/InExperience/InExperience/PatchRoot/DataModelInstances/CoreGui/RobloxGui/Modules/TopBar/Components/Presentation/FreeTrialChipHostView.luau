local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local function FreeTrialChipHostView(props)
	return (React.createElement("Frame", {
		AnchorPoint = Vector2.new(1, 0),
		BackgroundTransparency = 1,
		Position = props.position,
		Size = props.size,
		Visible = props.visible,
		ZIndex = props.zIndex,
		[React.Tag] = "data-testid=FreeTrialChipHost",
		[React.Change.AbsoluteSize] = props.onAbsoluteSizeChanged
	}, {
		Align = React.createElement("Frame", {
			AnchorPoint = Vector2.new(1, 0),
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(1, 0),
			Size = UDim2.fromOffset(0, 0)
		}, {
			Slot = React.createElement(props.slot, {
				onActivated = props.onActivated,
				maxWidth = props.maxWidth,
				hostVisible = props.visible
			})
		})
	}))
end

return FreeTrialChipHostView
