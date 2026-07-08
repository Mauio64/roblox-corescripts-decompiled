local Parent = script:FindFirstAncestor("AppBlox").Parent
local Cryo = require(Parent.Cryo)
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local View = Foundation.View

local function EmptyTile(t1: {[any]: any}) -- line: 19
	-- upvalues: React (copy), View (copy), Cryo (copy)
	return React.createElement(View, {
		tag = "size-full",
		LayoutOrder = t1.layoutOrder,
		ZIndex = t1.ZIndex
	}, Cryo.Dictionary.union(t1.children or {}, {
		Content = React.createElement(View, {
			tag = "bg-surface-100 padding-y-medium padding-x-small radius-medium",
			aspectRatio = t1.tileAspectRatio,
			Size = t1.size
		}, {
			ContentOverlay = t1.contentOverlayComponent
		})
	}))
end

return React.memo(EmptyTile)
