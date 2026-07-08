local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local Dash = require(FoundationParent.Dash)
local React = require(FoundationParent.React)

require(Foundation.Components.Types)

local Flags = require(Foundation.Utility.Flags)
local BaseMenuGroup = require(script.Parent.BaseMenuGroup)
local BaseMenuItem = require(script.Parent.BaseMenuItem)

local function DeclarativeBaseMenuContent(t1: {[any]: any}) -- line: 44
	-- upvalues: React (copy), Dash (copy), Flags (copy), BaseMenuGroup (copy), BaseMenuItem (copy), DeclarativeBaseMenuContent (copy)
	local v10 = React.useMemo(function() -- line: 45
		-- upvalues: Dash (copy), t1 (copy)
		local v18 = Dash.get(t1.items, {
			1,
			"items"
		})
		local v19 = Dash.get(t1.items, {
			1,
			"id"
		})

		if v18 and not v19 then
			return t1.items
		end

		return {{
			items = t1.items
		}}
	end, { t1.items })
	local t2 = {}
	local u12 = false

	if Flags.FoundationBaseMenuBeta then
		for v13, v14 in v10 do
			local v15 = false

			for _, v17 in v14.items do
				if not v15 and (v17.leading ~= nil or v17.icon ~= nil) then
					v15 = true
				end

				if not u12 and v17.isChecked == true then
					u12 = true
				end
			end

			t2[v13] = v15
		end
	end

	return React.createElement(React.Fragment, nil, Dash.map(v10, function(p1, n1: number) -- line: 78
		-- upvalues: t2 (copy), React (copy), BaseMenuGroup (copy), Flags (copy), u12 (ref), Dash (copy), BaseMenuItem (copy), DeclarativeBaseMenuContent (copy)
		local v22 = t2[n1]

		return React.createElement(BaseMenuGroup, {
			key = n1,
			LayoutOrder = n1,
			title = p1.title,
			menuHasLeading = if not Flags.FoundationBaseMenuBeta then nil else v22,
			menuHasCheck = if not Flags.FoundationBaseMenuBeta then nil else u12
		}, Dash.map(p1.items, function(p2, p3) -- line: 89
			-- upvalues: React (copy), BaseMenuItem (copy), Flags (copy), v22 (copy), u12 (ref), DeclarativeBaseMenuContent (copy)
			return React.createElement(BaseMenuItem, {
				LayoutOrder = p3,
				key = p2.id,
				icon = p2.icon,
				leading = if not Flags.FoundationBaseMenuBeta then nil else p2.leading,
				trailing = if not Flags.FoundationBaseMenuBeta then nil else p2.trailing,
				isChecked = p2.isChecked,
				isDisabled = p2.isDisabled,
				text = p2.text,
				onActivated = p2.onActivated,
				id = p2.id,
				testId = not p2.items and "--foundation-menu-item" or "--foundation-menu-submenu-item",
				ref = p2.ref,
				menuHasLeading = if not Flags.FoundationBaseMenuBeta then nil else v22,
				menuHasCheck = if not Flags.FoundationBaseMenuBeta then nil else u12
			}, if not p2.items then nil else React.createElement(DeclarativeBaseMenuContent, {
				items = p2.items
			}))
		end))
	end))
end

return React.memo(DeclarativeBaseMenuContent)
