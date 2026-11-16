local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local BaseMenuContext = require(script.Parent.BaseMenuContext)
local BaseMenuDivider = require(script.Parent.BaseMenuDivider)
local BaseMenuTitleItem = require(script.Parent.BaseMenuTitleItem)
local View = require(Foundation.Components.View)

local v = {
	XSmall = "padding-xsmall",
	Small = "padding-small",
	Medium = "padding-small",
	Large = "padding-small"
}

local function BaseMenuGroup(props)
	local v2 = React.useContext(BaseMenuContext)
	local layoutOrder = props.LayoutOrder
	local createElement = React.createElement
	local fragment = React.Fragment
	local divider

	if layoutOrder ~= 1 then
		divider = React.createElement(BaseMenuDivider, {
			LayoutOrder = layoutOrder * 2 - 1
		})
	end

	local createElement2 = React.createElement
	local v3 = {
		LayoutOrder = layoutOrder * 2,
		tag = `col gap-xxsmall size-full-0 auto-y {v[v2.size]}`
	}
	local title

	if props.title then
		title = React.createElement(BaseMenuTitleItem, {
			text = props.title,
			size = v2.size,
			menuHasLeading = props.menuHasLeading,
			menuHasCheck = props.menuHasCheck
		})
	end

	return createElement(fragment, nil, {
		Divider = divider,
		Group = createElement2(View, v3, {
			Title = title,
			Items = React.createElement(React.Fragment, nil, props.children)
		})
	})
end

return BaseMenuGroup
