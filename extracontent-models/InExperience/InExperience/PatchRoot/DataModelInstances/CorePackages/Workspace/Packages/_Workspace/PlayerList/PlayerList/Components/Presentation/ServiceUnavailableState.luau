local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local Foundation = require(ParentParentParent.Foundation)
local View = Foundation.View
local Empty = Foundation.Empty
local IconSize = Foundation.Enums.IconSize
local Constants = require(ParentParent.Common.Constants)

local function v9() -- line: 14
end
local function ServiceUnavailableStateImpl(t1: {[any]: any}) -- line: 21
	-- upvalues: React (copy), View (copy), Constants (copy), Empty (copy), IconSize (copy), v9 (copy)
	return React.createElement(View, {
		tag = Constants.STATE_PANEL_TAG,
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
				onActivated = t1.onRetry or v9
			}
		})
	})
end

return React.memo(ServiceUnavailableStateImpl)
