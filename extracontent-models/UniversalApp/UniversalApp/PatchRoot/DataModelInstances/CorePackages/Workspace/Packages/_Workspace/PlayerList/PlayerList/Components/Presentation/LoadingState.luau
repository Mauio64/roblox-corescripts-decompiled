local ParentParent = script.Parent.Parent.Parent.Parent
local React = require(ParentParent.React)
local Foundation = require(ParentParent.Foundation)
local View = Foundation.View
local Loading = Foundation.Loading
local IconSize = Foundation.Enums.IconSize

local function LoadingStateImpl(t1: {[any]: any}) -- line: 18
	-- upvalues: React (copy), View (copy), Loading (copy), IconSize (copy)
	return React.createElement(View, {
		tag = "col size-full padding-large gap-medium align-x-center align-y-center bg-over-media-0",
		LayoutOrder = t1.layoutOrder
	}, {
		Spinner = React.createElement(Loading, {
			size = IconSize.XLarge
		})
	})
end

return React.memo(LoadingStateImpl)
