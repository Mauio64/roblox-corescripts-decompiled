local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local SignalsReact = require(parent2.SignalsReact)
local Foundation = require(parent2.Foundation)

local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance

local PlayerListVisibilityStore = require(parent.Common.PlayerListVisibilityStore)
local PlayerContextualMenuStore = require(parent.Common.PlayerContextualMenuStore)

local Constants = require(parent.Common.Constants)

local stateLayer = { affordance = StateLayerAffordance.None }

local function LeaderboardScrimMobile()
	local v = useTokens()
	local visible = SignalsReact.useSignalBinding(PlayerListVisibilityStore.getEffectiveVisible)

	local onActivated = React.useCallback(function()
		PlayerContextualMenuStore.closeContextMenu()
		PlayerListVisibilityStore.setVisible(false)
	end, {})

	return React.createElement(View, {
		tag = "size-full",
		ZIndex = 0,
		backgroundStyle = v.Color.Common.Scrim,
		Visible = visible,
		onActivated = onActivated,
		stateLayer = stateLayer,
		selection = Constants.NOT_SELECTABLE
	})
end

local function LeaderboardScrim(p)
	if p.isSmallTouchDevice then
		return React.createElement(LeaderboardScrimMobile)
	end

	return nil
end

return React.memo(LeaderboardScrim)
