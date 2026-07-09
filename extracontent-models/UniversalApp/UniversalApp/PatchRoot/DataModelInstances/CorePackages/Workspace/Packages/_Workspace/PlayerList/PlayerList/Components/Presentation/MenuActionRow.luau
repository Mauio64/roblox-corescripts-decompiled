local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local Foundation = require(ParentParentParent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local PlayerListIcon = require(ParentParent.Common.PlayerListIcon)

local function MenuActionRow(t1: {[any]: any}) -- line: 13
	-- upvalues: useTokens (copy), React (copy), PlayerListIcon (copy), FoundationText (copy), View (copy)
	local v11 = useTokens()
	local t2 = {
		Icon = if t1.icon == nil then nil else React.createElement(PlayerListIcon, {
			layoutOrder = 1,
			icon = t1.icon,
			size = v11.Size.Size_500
		}),
		Label = React.createElement(FoundationText, {
			tag = "auto-xy text-body-medium text-align-x-left content-default",
			LayoutOrder = 2,
			Text = t1.label
		})
	}

	return React.createElement(View, {
		tag = "row align-x-left align-y-center gap-medium size-full-1000 auto-y",
		LayoutOrder = t1.layoutOrder,
		onActivated = t1.onActivated
	}, t2)
end

return React.memo(MenuActionRow)
