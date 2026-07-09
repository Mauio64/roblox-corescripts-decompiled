local Parent = script:FindFirstAncestor("AddFriends").Parent
local React = require(Parent.React)
local FFlagEnableSchoolEntry = require(Parent.SharedFlags).FFlagEnableSchoolEntry
local Foundation = require(Parent.Foundation)
local View = Foundation.View
local Icon = Foundation.Icon
local FoundationText = Foundation.Text
local Enums = Foundation.Enums

local function ConnectionChannelsTile(t1: {[any]: any}, p1) -- line: 25
	-- upvalues: React (copy), Enums (copy), View (copy), FFlagEnableSchoolEntry (copy), Icon (copy), FoundationText (copy)
	local layoutOrder = t1.componentUIProps.layoutOrder
	local itemSize = t1.componentUIProps.itemSize
	local icon = t1.icon
	local title = t1.title
	local onMounted = t1.onMounted
	local onActivated = t1.onActivated
	local v18, v19 = React.useState(false)
	local v20 = React.useCallback(function(p2) -- line: 35
		-- upvalues: v19 (copy), Enums (copy)
		v19(p2 == Enums.ControlState.Hover or p2 == Enums.ControlState.Pressed)
	end, {})

	React.useEffect(function() -- line: 40
		-- upvalues: onMounted (copy)
		if onMounted then
			onMounted()
		end
	end, {})

	return React.createElement(View, {
		tag = "auto-none gui-object-defaults",
		Size = itemSize,
		LayoutOrder = layoutOrder,
		ref = if not FFlagEnableSchoolEntry then nil else p1,
		selection = {
			Selectable = true,
			SelectionOrder = layoutOrder
		},
		onActivated = onActivated,
		onStateChanged = v20,
		stateLayer = {
			affordance = Enums.StateLayerAffordance.None
		}
	}, {
		Content = React.createElement(View, {
			tag = "size-full col align-x-center gap-small"
		}, {
			View = React.createElement(View, {
				LayoutOrder = 1,
				tag = {
					["size-full aspect-1-1 radius-circle align-x-center align-y-center row"] = true,
					["bg-shift-300"] = not v18,
					["bg-shift-400"] = v18
				}
			}, {
				Icon = if not icon then nil else React.createElement(Icon, {
					name = icon,
					size = Enums.IconSize.Large
				})
			}),
			Title = React.createElement(FoundationText, {
				LayoutOrder = 2,
				tag = "text-body-small auto-xy text-align-x-left clip text-truncate-end",
				Text = title
			})
		})
	})
end

if FFlagEnableSchoolEntry then
	return (React.forwardRef(ConnectionChannelsTile))
end

return ConnectionChannelsTile
