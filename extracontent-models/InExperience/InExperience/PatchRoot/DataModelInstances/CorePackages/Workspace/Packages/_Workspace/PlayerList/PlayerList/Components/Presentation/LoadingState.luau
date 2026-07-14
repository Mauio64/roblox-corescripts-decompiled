local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local Foundation = require(ParentParentParent.Foundation)
local View = Foundation.View
local Loading = Foundation.Loading
local IconSize = Foundation.Enums.IconSize
local Constants = require(ParentParent.Common.Constants)

local function LoadingStateImpl(t1: {[any]: any}) -- line: 17
	-- upvalues: React (copy), View (copy), Constants (copy), Loading (copy), IconSize (copy)
	return React.createElement(View, {
		tag = Constants.STATE_PANEL_TAG,
		LayoutOrder = t1.layoutOrder
	}, {
		Spinner = React.createElement(Loading, {
			size = IconSize.XLarge
		})
	})
end

return React.memo(LoadingStateImpl)
