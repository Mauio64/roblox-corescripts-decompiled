local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local Dash = require(parent.Dash)
local React = require(parent.React)

require(Foundation.Components.Types)

local BaseMenuGroup = require(script.Parent.BaseMenuGroup)
local BaseMenuItem = require(script.Parent.BaseMenuItem)
local function DeclarativeBaseMenuContent(p)
	local v = React.useMemo(function()
		local v = Dash.get(p.items, { 1, "items" })
		local v2 = Dash.get(p.items, { 1, "id" })

		if v and not v2 then
			return p.items
		end

		return {
			{ items = p.items }
		}
	end, { p.items })
	local menuHasCheck = false
	local v2 = {}

	for k, v3 in v do
		local v4 = false

		for _, item in v3.items do
			v4 = not v4 and (item.leading ~= nil or item.icon ~= nil) or v4

			if menuHasCheck or item.isChecked ~= true then
				continue
			end

			menuHasCheck = true
		end

		v2[k] = v4
	end

	return React.createElement(React.Fragment, nil, Dash.map(v, function(p2, layoutOrder: number)
		local menuHasLeading = v2[layoutOrder]
		return React.createElement(BaseMenuGroup, {
			key = layoutOrder,
			LayoutOrder = layoutOrder,
			title = p2.title,
			menuHasLeading = menuHasLeading,
			menuHasCheck = menuHasCheck
		}, Dash.map(p2.items, function(props, layoutOrder2)
			local createElement = React.createElement

			local v3 = {
				LayoutOrder = layoutOrder2,
				key = props.id,
				icon = props.icon,
				leading = props.leading,
				trailing = props.trailing,
				isChecked = props.isChecked,
				isDisabled = props.isDisabled,
				text = props.text,
				onActivated = props.onActivated,
				id = props.id,
				testId = props.items and "--foundation-menu-submenu-item" or "--foundation-menu-item",
				ref = props.ref,
				menuHasLeading = menuHasLeading,
				menuHasCheck = menuHasCheck
			}
			local v4

			if props.items then
				v4 = React.createElement(DeclarativeBaseMenuContent, { items = props.items })
			end

			return createElement(BaseMenuItem, v3, v4)
		end))
	end))
end

return React.memo(DeclarativeBaseMenuContent)
