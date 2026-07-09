local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local SignalsReact = require(ParentParentParent.SignalsReact)
local Foundation = require(ParentParentParent.Foundation)
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local PlayerListVisibilityStore = require(ParentParent.Common.PlayerListVisibilityStore)

local function LeaderboardScrim(t1: {[any]: any}) -- line: 18
	-- upvalues: useTokens (copy), SignalsReact (copy), PlayerListVisibilityStore (copy), React (copy), View (copy)
	local v11 = useTokens()
	local v12 = SignalsReact.useSignalBinding(PlayerListVisibilityStore.getEffectiveVisible)

	if not t1.isSmallTouchDevice then
		return nil
	end

	return React.createElement(View, {
		tag = "size-full",
		ZIndex = 0,
		backgroundStyle = v11.Color.Common.Scrim,
		Visible = v12
	})
end

return React.memo(LeaderboardScrim)
