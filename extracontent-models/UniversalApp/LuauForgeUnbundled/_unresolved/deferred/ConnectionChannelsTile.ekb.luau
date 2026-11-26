local module = require("@luauforge/deferred/eil")

local fFlagEnableSchoolEntry = require("@luauforge/deferred/eiz").FFlagEnableSchoolEntry
local fFlagConnectionChannelsTileSize = require("@luauforge/deferred/eiz").FFlagConnectionChannelsTileSize
local module2 = require("@luauforge/deferred/eiU")
local view = module2.View
local icon = module2.Icon
local text = module2.Text
local enums = module2.Enums
local useTokens = module2.Hooks.useTokens

local function ConnectionChannelsTile(props, ref)
	local layoutOrder = props.componentUIProps.layoutOrder
	local itemSize = props.componentUIProps.itemSize
	local onVisibilityChange = props.componentUIProps.onVisibilityChange

	local icon2 = props.icon
	local title = props.title
	local onMounted = props.onMounted
	local onActivated = props.onActivated
	local isVisible = props.isVisible

	local v5 = if fFlagConnectionChannelsTileSize then useTokens() else nil

	local state, setState = module.useState(false)
	local v6 = module.useCallback(function(p2)
		setState(p2 == enums.ControlState.Hover or p2 == enums.ControlState.Pressed)
	end, {})

	module.useLayoutEffect(function()
		onVisibilityChange(isVisible)
	end, { isVisible, onVisibilityChange })

	local ref2 = module.useRef(false)
	local v7 = not isVisible

	module.useEffect(function()
		if v7 or ref2.current then
			return
		end

		if onMounted then
			ref2.current = true
			onMounted()
		end
	end, { v7, onMounted })

	if v7 then
		return nil
	end

	local createElement = module.createElement

	if not fFlagEnableSchoolEntry then
		ref = nil
	end

	local v9 = {
		tag = "auto-none gui-object-defaults",
		Size = itemSize,
		LayoutOrder = layoutOrder,
		ref = ref,
		selection = { SelectionOrder = layoutOrder, Selectable = true },
		onActivated = onActivated,
		onStateChanged = v6,
		stateLayer = { affordance = enums.StateLayerAffordance.None }
	}

	local createElement2 = module.createElement

	local createElement3 = module.createElement
	local v16

	if icon2 then
		local createElement4 = module.createElement

		local v19 = if fFlagConnectionChannelsTileSize then enums.IconSize.XLarge else enums.IconSize.Large
		local v20 = if fFlagConnectionChannelsTileSize then v5.Color.Content.Emphasis else nil
		v16 = createElement4(icon, { name = icon2, size = v19, style = v20 })
	end

	return createElement(view, v9, {
		Content = createElement2(view, {
			tag = "size-full col align-x-center gap-small"
		}, {
			View = createElement3(view, {
				LayoutOrder = 1,
				tag = {
					["size-full aspect-1-1 radius-circle align-x-center align-y-center row"] = true,
					["bg-shift-300"] = not state,
					["bg-shift-400"] = state
				}
			}, { Icon = v16 }),
			Title = module.createElement(text, {
				LayoutOrder = 2,
				tag = "text-body-small auto-xy text-align-x-left clip text-truncate-end",
				Text = title
			})
		})
	})
end

if fFlagEnableSchoolEntry then
	return module.forwardRef(ConnectionChannelsTile)
end

return ConnectionChannelsTile
