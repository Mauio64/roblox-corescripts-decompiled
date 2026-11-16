local parent = script:FindFirstAncestor("MomentsCreation").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local View = Foundation.View

local function AvatarMomentView(props)
	return React.createElement(View, {
		tag = "size-full",
		onAbsoluteSizeChanged = props.onAbsoluteSizeChanged
	}, {
		Media = React.createElement(
			"ViewportFrame",
			{
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				ref = props.viewportFrameRef
			},
			{
				WorldModel = React.createElement("WorldModel", { ref = props.worldModelRef })
			}
		),
		Overlay = React.createElement(View, { tag = "size-full", ZIndex = 2 }, props.children)
	})
end

return AvatarMomentView
