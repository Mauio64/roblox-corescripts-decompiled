local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local Foundation = require(ParentParentParent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local Constants = require(ParentParent.Common.Constants)

local function EmptyFriendsStateImpl(t1: {[any]: any}) -- line: 16
	-- upvalues: React (copy), View (copy), Constants (copy), FoundationText (copy)
	return React.createElement(View, {
		tag = Constants.STATE_PANEL_TAG,
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
