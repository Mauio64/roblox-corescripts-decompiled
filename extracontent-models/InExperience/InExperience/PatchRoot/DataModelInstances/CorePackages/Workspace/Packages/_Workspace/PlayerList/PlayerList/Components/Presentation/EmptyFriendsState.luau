local ParentParent = script.Parent.Parent.Parent.Parent
local React = require(ParentParent.React)
local Foundation = require(ParentParent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text

local function EmptyFriendsStateImpl(t1: {[any]: any}) -- line: 17
	-- upvalues: React (copy), View (copy), FoundationText (copy)
	return React.createElement(View, {
		tag = "col size-full padding-large gap-medium align-x-center align-y-center bg-over-media-0",
		LayoutOrder = t1.layoutOrder
	}, {
		Message = React.createElement(FoundationText, {
			Text = "None of your friends have played this experience yet.",
			tag = "size-full-0 auto-y text-body-small text-align-x-center content-default",
			TextWrapped = true
		})
	})
end

return React.memo(EmptyFriendsStateImpl)
