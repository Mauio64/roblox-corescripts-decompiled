local Parent = script:FindFirstAncestor("MomentsCreation").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

return function(t1: {[any]: any}) -- line: 27
	-- upvalues: useTokens (copy), React (copy), View (copy)
	local v7 = useTokens()

	return React.createElement(View, {
		tag = "size-300-1000 radius-medium bg-system-contrast",
		AnchorPoint = t1.anchorPoint,
		Position = t1.position,
		stroke = {
			Color = v7.Color.System.Contrast.Color3,
			Transparency = v7.Color.System.Contrast.Transparency,
			Thickness = v7.Stroke.Thicker
		}
	}, {
		Line = React.createElement(View, {
			tag = "position-center-center anchor-center-center size-100-400 radius-circle bg-surface-300",
			ZIndex = 2
		}),
		Box = React.createElement(View, {
			tag = "anchor-center-center size-100-1000 bg-system-contrast",
			Position = if not t1.isFlipped then UDim2.new(1, -v7.Size.Size_50, 0.5, 0) else UDim2.new(0, v7.Size.Size_50, 0.5, 0),
			stroke = {
				Color = v7.Color.System.Contrast.Color3,
				Transparency = v7.Color.System.Contrast.Transparency,
				Thickness = v7.Stroke.Thicker
			}
		}),
		DragDetector = React.createElement("UIDragDetector", {
			DragStyle = Enum.UIDragDetectorDragStyle.TranslateLine,
			ref = t1.dragDetectorRef,
			ResponseStyle = Enum.UIDragDetectorResponseStyle.CustomScale
		})
	})
end
