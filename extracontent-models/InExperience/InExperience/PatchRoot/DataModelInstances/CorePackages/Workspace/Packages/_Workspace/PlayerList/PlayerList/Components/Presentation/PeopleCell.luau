local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local Foundation = require(ParentParentParent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local PlayerBadge = require(ParentParent.Components.Presentation.PlayerBadge)

local function PeopleCell(t1: {[any]: any}) -- line: 22
	-- upvalues: React (copy), FoundationText (copy), PlayerBadge (copy), View (copy)
	local v10 = t1.textTag or (not t1.truncate and "auto-xy text-body-small text-align-x-left content-default" or "fill size-0-full text-body-small text-align-x-left content-default text-truncate-end")
	local t2 = {
		NameText = React.createElement(FoundationText, {
			LayoutOrder = 1,
			Text = t1.displayName,
			tag = v10
		})
	}

	if t1.player then
		t2.Badge = React.createElement(PlayerBadge, {
			layoutOrder = 2,
			player = t1.player
		})
	end

	return React.createElement(View, {
		tag = "row align-x-left align-y-center fill gap-xsmall size-0-full clip",
		LayoutOrder = t1.layoutOrder
	}, t2)
end

return React.memo(PeopleCell)
