local ParentParent = script.Parent.Parent.Parent.Parent
local React = require(ParentParent.React)
local Foundation = require(ParentParent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local FoundationImage = Foundation.Image

local function PlayerContextMenuHeader(t1: {[any]: any}) -- line: 11
	-- upvalues: React (copy), View (copy), FoundationImage (copy), FoundationText (copy)
	local header = t1.header

	return React.createElement(View, {
		tag = "row align-x-left align-y-center gap-medium size-full-1600 auto-y",
		LayoutOrder = t1.layoutOrder
	}, {
		Avatar = React.createElement(FoundationImage, {
			tag = "size-1000-1000 radius-circle",
			LayoutOrder = 1,
			Image = header.thumbnail or ""
		}),
		NameColumn = React.createElement(View, {
			LayoutOrder = 2,
			tag = "col align-x-left auto-xy"
		}, {
			DisplayName = React.createElement(FoundationText, {
				tag = "auto-xy text-title-medium text-align-x-left content-emphasis",
				LayoutOrder = 1,
				Text = header.displayName
			}),
			Username = React.createElement(FoundationText, {
				tag = "auto-xy text-body-medium text-align-x-left content-default",
				LayoutOrder = 2,
				Text = header.username
			})
		})
	})
end

return React.memo(PlayerContextMenuHeader)
