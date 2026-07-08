local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local SignalsReact = require(ParentParentParent.SignalsReact)
local useTokens = require(ParentParentParent.Foundation).Hooks.useTokens
local PlayerIconInfoStore = require(ParentParentParent.PlayerIconInfoStore).PlayerIconInfoStore
local getPlayerBadgeIcon = require(ParentParent.Common.getPlayerBadgeIcon)
local LayoutValuesContext = require(ParentParent.Common.LayoutValuesContext)
local PlayerListIcon = require(ParentParent.Common.PlayerListIcon)

local function PlayerBadge(t1: {[any]: any}) -- line: 16
	-- upvalues: React (copy), LayoutValuesContext (copy), useTokens (copy), SignalsReact (copy), PlayerIconInfoStore (copy), getPlayerBadgeIcon (copy), PlayerListIcon (copy)
	local v12 = React.useContext(LayoutValuesContext)
	local v13 = useTokens()
	local v14 = SignalsReact.useSignalState(PlayerIconInfoStore.getPlayerIconInfoReactive(t1.player.UserId))
	local v15 = getPlayerBadgeIcon(v12, t1.player, v14, nil)

	return React.createElement(PlayerListIcon, {
		icon = v15,
		size = v13.Size.Size_400,
		layoutOrder = t1.layoutOrder
	})
end

return React.memo(PlayerBadge)
