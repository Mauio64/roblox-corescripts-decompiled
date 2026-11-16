local module = require("@luauforge/deferred/eeO")

local fFlagEnableSchoolEntry = require("@luauforge/deferred/efc").FFlagEnableSchoolEntry
local fFlagConnectionChannelsTileSize = require("@luauforge/deferred/efc").FFlagConnectionChannelsTileSize
local module2 = require("@luauforge/deferred/ege")
local view = module2.View
local icon = module2.Icon
local text = module2.Text
local enums = module2.Enums
local useTokens = module2.Hooks.useTokens
local module3 = require("@luauforge/deferred/egH")

local function ConnectionChannelsTile(props, ref)
	local layoutOrder = props.componentUIProps.layoutOrder
	local itemSize = props.componentUIProps.itemSize

	local onVisibilityChange = if module3 then props.componentUIProps.onVisibilityChange else nil

	local icon2 = props.icon
	local title = props.title
	local onMounted = props.onMounted
	local onActivated = props.onActivated
	local isVisible = if module3 then props.isVisible else nil

	local v5 = if fFlagConnectionChannelsTileSize then useTokens() else nil

	local state, setState = module.useState(false)
	local v6 = module.useCallback(function(p2)
		setState(p2 == enums.ControlState.Hover or p2 == enums.ControlState.Pressed)
	end, {})

	if module3 then
		module.useLayoutEffect(function()
			onVisibilityChange(isVisible)
		end, { isVisible, onVisibilityChange })
	end

	local ref2, v7

	if module3 then
		ref2 = module.useRef(false)
		v7 = not isVisible
	else
		v7 = nil
		ref2 = nil
	end

	local useEffect = module.useEffect
	local function fn()
		if module3 and (v7 or ref2.current) then
			return
		end

		if onMounted then
			if module3 then
				ref2.current = true
			end

			onMounted()
		end
	end

	local v9 = if module3 then v7 else nil
	useEffect(fn, { v9, if module3 then onMounted else nil })

	if v7 and module3 then
		return nil
	end

	local createElement = module.createElement

	if not fFlagEnableSchoolEntry then
		ref = nil
	end

	local v12 = {
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
	local v19

	if icon2 then
		local createElement4 = module.createElement

		local v22 = if fFlagConnectionChannelsTileSize then enums.IconSize.XLarge else enums.IconSize.Large
		local v23 = if fFlagConnectionChannelsTileSize then v5.Color.Content.Emphasis else nil
		v19 = createElement4(icon, { name = icon2, size = v22, style = v23 })
	end

	return createElement(view, v12, {
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
			}, { Icon = v19 }),
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
