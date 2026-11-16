local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local SignalsReact = require(parent2.SignalsReact)
local Foundation = require(parent2.Foundation)
local useTokens = Foundation.Hooks.useTokens

local PlayerIconInfoStore = require(parent2.PlayerIconInfoStore)
local playerIconInfoStore = PlayerIconInfoStore.PlayerIconInfoStore

local getPlayerBadgeIcon = require(parent.Common.getPlayerBadgeIcon)
local LayoutValuesContext = require(parent.Common.LayoutValuesContext)
local PlayerListIcon = require(parent.Common.PlayerListIcon)
local PlayerRelationshipStore = require(parent.Common.PlayerRelationshipStore)

local function PlayerBadge(p)
	local v = React.useContext(LayoutValuesContext)
	local v2 = useTokens()
	local v3 = SignalsReact.useSignalState(playerIconInfoStore.getPlayerIconInfoReactive(p.player.UserId))

	local v4 = SignalsReact.useSignalState(PlayerRelationshipStore.getPlayerRelationshipReactive(p.player.UserId))
	local playerBadgeIcon = getPlayerBadgeIcon(v, p.player, v3, v4)

	return React.createElement(PlayerListIcon, {
		icon = playerBadgeIcon,
		size = v2.Size.Size_400,
		layoutOrder = p.layoutOrder
	})
end

return React.memo(PlayerBadge)
