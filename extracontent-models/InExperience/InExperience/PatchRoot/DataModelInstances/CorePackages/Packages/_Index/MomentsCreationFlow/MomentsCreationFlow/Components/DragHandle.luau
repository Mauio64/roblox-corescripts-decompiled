local parent = script:FindFirstAncestor("MomentsCreationFlow").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local View = Foundation.View

local useTokens = Foundation.Hooks.useTokens

return function(props)
	local v = useTokens()

	local createElement = React.createElement
	local v2 = {
		AnchorPoint = props.anchorPoint,
		tag = "bg-system-contrast radius-medium size-300-1000",
		Position = props.position
	}
	local children = {
		OutlineStroke = React.createElement("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = v.Color.System.Contrast.Color3,
			Transparency = v.Color.System.Contrast.Transparency,
			Thickness = v.Stroke.Thicker
		}),
		Line = React.createElement(View, {
			tag = "anchor-center-center bg-surface-300 size-100-400 position-center-center radius-circle",
			ZIndex = 2
		}),
		Box = 0,
		DragDetector = 0
	}

	local createElement2 = React.createElement
	local position

	if props.isFlipped then
		position = UDim2.new(0, v.Size.Size_50, 0.5, 0)
	else
		position = UDim2.new(1, -v.Size.Size_50, 0.5, 0)
	end

	children.Box = createElement2(
		View,
		{ Position = position, tag = "anchor-center-center bg-system-contrast size-100-1000" },
		{
			OutlineStroke = React.createElement("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = v.Color.System.Contrast.Color3,
				LineJoinMode = Enum.LineJoinMode.Miter,
				Transparency = v.Color.System.Contrast.Transparency,
				Thickness = v.Stroke.Thicker
			})
		}
	)

	children.DragDetector = React.createElement("UIDragDetector", {
		DragStyle = Enum.UIDragDetectorDragStyle.TranslateLine,
		ref = props.dragDetectorRef,
		ResponseStyle = Enum.UIDragDetectorResponseStyle.CustomScale
	})
	return createElement(View, v2, children)
end
