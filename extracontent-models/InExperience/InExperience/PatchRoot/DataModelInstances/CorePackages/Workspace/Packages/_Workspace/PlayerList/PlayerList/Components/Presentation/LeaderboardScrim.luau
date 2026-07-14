local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local SignalsReact = require(ParentParentParent.SignalsReact)
local Foundation = require(ParentParentParent.Foundation)
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local PlayerListVisibilityStore = require(ParentParent.Common.PlayerListVisibilityStore)
local PlayerContextualMenuStore = require(ParentParent.Common.PlayerContextualMenuStore)
local t1 = {
	affordance = StateLayerAffordance.None
}

local function LeaderboardScrimMobile() -- line: 18
	-- upvalues: useTokens (copy), SignalsReact (copy), PlayerListVisibilityStore (copy), React (copy), PlayerContextualMenuStore (copy), View (copy), t1 (copy)
	local v14 = useTokens()
	local v15 = SignalsReact.useSignalBinding(PlayerListVisibilityStore.getEffectiveVisible)
	local v16 = React.useCallback(function() -- line: 22
		-- upvalues: PlayerContextualMenuStore (copy), PlayerListVisibilityStore (copy)
		PlayerContextualMenuStore.closeContextMenu()
		PlayerListVisibilityStore.setVisible(false)
	end, {})

	return React.createElement(View, {
		tag = "size-full",
		ZIndex = 0,
		backgroundStyle = v14.Color.Common.Scrim,
		Visible = v15,
		onActivated = v16,
		stateLayer = t1
	})
end
local function LeaderboardScrim(t2: {[any]: any}) -- line: 38
	-- upvalues: React (copy), LeaderboardScrimMobile (copy)
	if not t2.isSmallTouchDevice then
		return nil
	end

	return React.createElement(LeaderboardScrimMobile)
end

return React.memo(LeaderboardScrim)
