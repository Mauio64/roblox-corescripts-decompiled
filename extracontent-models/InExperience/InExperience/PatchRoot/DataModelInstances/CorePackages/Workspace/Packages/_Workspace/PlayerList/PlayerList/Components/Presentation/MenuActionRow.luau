local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local SignalsReact = require(ParentParentParent.SignalsReact)
local Foundation = require(ParentParentParent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local PlayerListIcon = require(ParentParent.Common.PlayerListIcon)
local PlayerContextualMenuStore = require(ParentParent.Common.PlayerContextualMenuStore)
local t1 = {
	affordance = StateLayerAffordance.None
}

local function MenuActionRow(t2: {[any]: any}) -- line: 20
	-- upvalues: useTokens (copy), SignalsReact (copy), PlayerContextualMenuStore (copy), React (copy), PlayerListIcon (copy), FoundationText (copy), View (copy), t1 (copy)
	local v15 = useTokens()
	local item = t2.item
	local v17 = SignalsReact.useSignalState(PlayerContextualMenuStore.getPendingConfirmKey)
	local v18 = if not (item.requiresConfirm == true and v17 == item.key) or item.confirmLabel == nil then item.label else item.confirmLabel
	local v19 = React.useCallback(function() -- line: 31
		-- upvalues: PlayerContextualMenuStore (copy), item (copy)
		PlayerContextualMenuStore.activateMenuItem(item)
	end, { item })
	local t3 = {
		Icon = if item.icon == nil then nil else React.createElement(PlayerListIcon, {
			layoutOrder = 1,
			icon = item.icon,
			size = v15.Size.Size_500
		}),
		Label = React.createElement(FoundationText, {
			tag = "auto-xy text-body-medium text-align-x-left content-default",
			LayoutOrder = 2,
			Text = v18
		})
	}

	return React.createElement(View, {
		tag = "row align-x-left align-y-center gap-medium size-full-1000 auto-y",
		LayoutOrder = t2.layoutOrder,
		onActivated = v19,
		stateLayer = t1
	}, t3)
end

return React.memo(MenuActionRow)
