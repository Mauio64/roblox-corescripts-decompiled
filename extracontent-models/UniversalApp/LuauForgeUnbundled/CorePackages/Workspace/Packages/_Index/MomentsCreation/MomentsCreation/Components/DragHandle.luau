local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")

local view = Foundation.View

local useTokens = Foundation.Hooks.useTokens

return function(props)
	local v5 = useTokens()

	local createElement = React.createElement
	local v7 = {
		AnchorPoint = props.anchorPoint,
		tag = "size-300-1000 radius-medium bg-system-contrast",
		Position = props.position,
		stroke = {
			Color = v5.Color.System.Contrast.Color3,
			Transparency = v5.Color.System.Contrast.Transparency,
			Thickness = v5.Stroke.Thicker
		}
	}

	local children = {
		Line = React.createElement(view, {
			tag = "position-center-center anchor-center-center size-100-400 radius-circle bg-surface-300",
			ZIndex = 2
		}),
		Box = 0,
		DragDetector = 0
	}

	local createElement2 = React.createElement
	local v10 = if props.isFlipped then UDim2.new(0, v5.Size.Size_50, 0.5, 0) else UDim2.new(1, -v5.Size.Size_50, 0.5, 0)
	children.Box = createElement2(view, {
		Position = v10,
		tag = "anchor-center-center size-100-1000 bg-system-contrast",
		stroke = {
			Color = v5.Color.System.Contrast.Color3,
			Transparency = v5.Color.System.Contrast.Transparency,
			Thickness = v5.Stroke.Thicker
		}
	})

	children.DragDetector = React.createElement("UIDragDetector", {
		DragStyle = Enum.UIDragDetectorDragStyle.TranslateLine,
		ref = props.dragDetectorRef,
		ResponseStyle = Enum.UIDragDetectorResponseStyle.CustomScale
	})
	return createElement(view, v7, children)
end
