local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local SignalsReact = require(ParentParentParent.SignalsReact)
local useTokens = require(ParentParentParent.Foundation).Hooks.useTokens
local PlayerIconInfoStore = require(ParentParentParent.PlayerIconInfoStore).PlayerIconInfoStore
local getPlayerBadgeIcon = require(ParentParent.Common.getPlayerBadgeIcon)
local LayoutValuesContext = require(ParentParent.Common.LayoutValuesContext)
local PlayerListIcon = require(ParentParent.Common.PlayerListIcon)
local PlayerRelationshipStore = require(ParentParent.Common.PlayerRelationshipStore)

local function PlayerBadge(t1: {[any]: any}) -- line: 17
	-- upvalues: React (copy), LayoutValuesContext (copy), useTokens (copy), SignalsReact (copy), PlayerIconInfoStore (copy), PlayerRelationshipStore (copy), getPlayerBadgeIcon (copy), PlayerListIcon (copy)
	local v13 = React.useContext(LayoutValuesContext)
	local v14 = useTokens()
	local v15 = SignalsReact.useSignalState(PlayerIconInfoStore.getPlayerIconInfoReactive(t1.player.UserId))
	local v16 = SignalsReact.useSignalState(PlayerRelationshipStore.getPlayerRelationshipReactive(t1.player.UserId))
	local v17 = getPlayerBadgeIcon(v13, t1.player, v15, v16)

	return React.createElement(PlayerListIcon, {
		icon = v17,
		size = v14.Size.Size_400,
		layoutOrder = t1.layoutOrder
	})
end

return React.memo(PlayerBadge)
