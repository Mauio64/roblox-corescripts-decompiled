local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local SignalsReact = require(parent2.SignalsReact)
local Foundation = require(parent2.Foundation)

local View = Foundation.View
local Text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance

local PlayerListIcon = require(parent.Common.PlayerListIcon)
local PlayerContextualMenuStore = require(parent.Common.PlayerContextualMenuStore)
local Constants = require(parent.Common.Constants)

local v = { affordance = StateLayerAffordance.Background }

local function MenuActionRow(props)
	local v2 = useTokens()
	local item = props.item
	local v3 = SignalsReact.useSignalState(PlayerContextualMenuStore.getPendingConfirmKey)
	local v4

	if item.requiresConfirm == true then
		v4 = v3 == item.key
	else
		v4 = false
	end

	local text

	if v4 and item.confirmLabel ~= nil then
		text = item.confirmLabel
	else
		text = item.label
	end

	local isInteractable = props.isInteractable ~= false
	local onActivated = React.useCallback(function()
		if not isInteractable then
			return
		end

		PlayerContextualMenuStore.activateMenuItem(item)
	end, { item, isInteractable })
	local icon

	if item.icon ~= nil then
		icon = React.createElement(PlayerListIcon, {
			icon = item.icon,
			size = v2.Size.Size_500,
			layoutOrder = 1,
			testId = "menu-action-row-icon"
		})
	end

	local icon2

	if icon ~= nil then
		icon2 = React.createElement(
			View,
			{
				tag = "row align-x-center align-y-center size-1000-1000",
				LayoutOrder = 1,
				testId = "menu-action-row-icon-column"
			},
			{ Icon = icon }
		)
	end

	local v5 = {
		Icon = icon2,
		Label = React.createElement(
			View,
			{ tag = "fill auto-y", LayoutOrder = 2, testId = "menu-action-row-label-column" },
			{
				Text = React.createElement(Text, {
					Text = text,
					tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default",
					testId = "menu-action-row-label"
				})
			}
		)
	}

	local createElement = React.createElement
	local v6 = {
		LayoutOrder = props.layoutOrder,
		onActivated = 0,
		ref = 0,
		tag = "row align-x-left align-y-center gap-none size-full-1000 auto-y",
		stateLayer = 0,
		selection = 0,
		testId = "menu-action-row"
	}

	if not isInteractable then
		onActivated = nil
	end

	v6.onActivated = onActivated
	v6.ref = props.rowRef
	local stateLayer

	if isInteractable then
		stateLayer = v
	end

	v6.stateLayer = stateLayer
	v6.selection = Constants.SELECTABLE
	return createElement(View, v6, v5)
end

return React.memo(MenuActionRow)
