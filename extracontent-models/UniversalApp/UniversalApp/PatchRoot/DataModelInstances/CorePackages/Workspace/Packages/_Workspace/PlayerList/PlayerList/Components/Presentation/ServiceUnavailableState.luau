local ParentParent = script.Parent.Parent.Parent.Parent
local React = require(ParentParent.React)
local Foundation = require(ParentParent.Foundation)
local View = Foundation.View
local Empty = Foundation.Empty
local IconSize = Foundation.Enums.IconSize

local function v7() -- line: 15
end
local function ServiceUnavailableStateImpl(t1: {[any]: any}) -- line: 22
	-- upvalues: React (copy), View (copy), Empty (copy), IconSize (copy), v7 (copy)
	return React.createElement(View, {
		tag = "col size-full padding-large gap-medium align-x-center align-y-center bg-over-media-0",
		LayoutOrder = t1.layoutOrder
	}, {
		Content = React.createElement(Empty, {
			text = "Leaderboard unavailable. Please try again later.",
			icon = {
				name = "triangle-exclamation",
				size = IconSize.Large
			},
			button = {
				text = "Retry",
				onActivated = t1.onRetry or v7
			}
		})
	})
end

return React.memo(ServiceUnavailableStateImpl)
