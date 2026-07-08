local Parent = script:FindFirstAncestor("MomentsCreationFlow").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

return function(t1: {[any]: any}) -- line: 21
	-- upvalues: useTokens (copy), React (copy), View (copy)
	local v7 = useTokens()

	return React.createElement(View, {
		tag = "bg-system-contrast radius-medium size-300-1000",
		AnchorPoint = t1.anchorPoint,
		Position = t1.position
	}, {
		OutlineStroke = React.createElement("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = v7.Color.System.Contrast.Color3,
			Transparency = v7.Color.System.Contrast.Transparency,
			Thickness = v7.Stroke.Thicker
		}),
		Line = React.createElement(View, {
			tag = "anchor-center-center bg-surface-300 size-100-400 position-center-center radius-circle",
			ZIndex = 2
		}),
		Box = React.createElement(View, {
			tag = "anchor-center-center bg-system-contrast size-100-1000",
			Position = if not t1.isFlipped then UDim2.new(1, -v7.Size.Size_50, 0.5, 0) else UDim2.new(0, v7.Size.Size_50, 0.5, 0)
		}, {
			OutlineStroke = React.createElement("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = v7.Color.System.Contrast.Color3,
				LineJoinMode = Enum.LineJoinMode.Miter,
				Transparency = v7.Color.System.Contrast.Transparency,
				Thickness = v7.Stroke.Thicker
			})
		}),
		DragDetector = React.createElement("UIDragDetector", {
			DragStyle = Enum.UIDragDetectorDragStyle.TranslateLine,
			ref = t1.dragDetectorRef,
			ResponseStyle = Enum.UIDragDetectorResponseStyle.CustomScale
		})
	})
end
