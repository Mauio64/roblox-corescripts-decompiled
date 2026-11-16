local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")

local view = Foundation.View

local function AvatarMomentView(props)
	return React.createElement(
		view,
		{ tag = "size-full", onAbsoluteSizeChanged = props.onAbsoluteSizeChanged },
		{
			Media = React.createElement(
				"ViewportFrame",
				{
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					ref = props.viewportFrameRef
				},
				{
					WorldModel = React.createElement("WorldModel", {
						ref = props.worldModelRef
					})
				}
			),
			Overlay = React.createElement(view, { tag = "size-full", ZIndex = 2 }, props.children)
		}
	)
end

return AvatarMomentView
