local parent = script:FindFirstAncestor("AppBlox").Parent

local Cryo = require(parent.Cryo)
local Foundation = require(parent.Foundation)
local React = require(parent.React)

local View = Foundation.View

local function EmptyTile(props)
	return React.createElement(
		View,
		{ LayoutOrder = props.layoutOrder, ZIndex = props.ZIndex, tag = "size-full" },
		Cryo.Dictionary.union(props.children or {}, {
			Content = React.createElement(
				View,
				{
					aspectRatio = props.tileAspectRatio,
					Size = props.size,
					tag = "bg-surface-100 padding-y-medium padding-x-small radius-medium"
				},
				{ ContentOverlay = props.contentOverlayComponent }
			)
		})
	)
end

return React.memo(EmptyTile)
