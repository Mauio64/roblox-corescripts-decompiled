local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Foundation = require(ParentParentParent.Foundation)
local React = require(ParentParentParent.React)
local View = Foundation.View
local useZoomController = require(ParentParent.Hooks.useZoomController)

return function(t1: {[any]: any}) -- line: 17
	-- upvalues: useZoomController (copy), React (copy), View (copy)
	local v8 = t1.active == nil or t1.active
	local v9, v10 = useZoomController(v8)

	React.useEffect(function() -- line: 22
		-- upvalues: t1 (copy), v9 (copy)
		if t1.onZoomStatusChanged then
			t1.onZoomStatusChanged(v9)
		end
	end, {
		v9,
		t1.onZoomStatusChanged
	})

	return React.createElement(View, {
		tag = "anchor-center-center position-center-center size-full bg-action-subtle",
		ZIndex = 1,
		ref = v10
	}, {
		ZoomItem = React.createElement(React.Fragment, nil, t1.children)
	})
end
