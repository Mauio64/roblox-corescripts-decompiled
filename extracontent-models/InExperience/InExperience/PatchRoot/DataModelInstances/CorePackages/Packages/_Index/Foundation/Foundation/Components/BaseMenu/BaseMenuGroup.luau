local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local BaseMenuContext = require(script.Parent.BaseMenuContext)
local BaseMenuDivider = require(script.Parent.BaseMenuDivider)
local BaseMenuTitleItem = require(script.Parent.BaseMenuTitleItem)
local View = require(Foundation.Components.View)
local t1 = {
	XSmall = "padding-xsmall",
	Small = "padding-small",
	Medium = "padding-small",
	Large = "padding-small"
}

local function BaseMenuGroup(t2: {[any]: any}) -- line: 27
	-- upvalues: React (copy), BaseMenuContext (copy), BaseMenuDivider (copy), View (copy), t1 (copy), BaseMenuTitleItem (copy)
	local v11 = React.useContext(BaseMenuContext)
	local t2LayoutOrder = t2.LayoutOrder

	return React.createElement(React.Fragment, nil, {
		Divider = if t2LayoutOrder == 1 then nil else React.createElement(BaseMenuDivider, {
			LayoutOrder = t2LayoutOrder * 2 - 1
		}),
		Group = React.createElement(View, {
			LayoutOrder = t2LayoutOrder * 2,
			tag = `col gap-xxsmall size-full-0 auto-y { t1[v11.size] }`
		}, {
			Title = if not t2.title then nil else React.createElement(BaseMenuTitleItem, {
				text = t2.title,
				size = v11.size,
				menuHasLeading = t2.menuHasLeading,
				menuHasCheck = t2.menuHasCheck
			}),
			Items = React.createElement(React.Fragment, nil, t2.children)
		})
	})
end

return BaseMenuGroup
