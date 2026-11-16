local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Cryo")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/React")

local view = Foundation.View

local function EmptyTile(props)
	return React.createElement(
		view,
		{ LayoutOrder = props.layoutOrder, ZIndex = props.ZIndex, tag = "size-full" },
		Cryo.Dictionary.union(props.children or {}, {
			Content = React.createElement(
				view,
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
