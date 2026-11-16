local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Cryo")
local DiscoveryAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/DiscoveryAnalytics")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/React")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags")

require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/GameTileOverflowMenu")
local useGameTileActions = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/useGameTileActions")

local buttonVariant = Foundation.Enums.ButtonVariant
local iconButton = Foundation.IconButton
local iconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens
local view = Foundation.View

local gameTileOverflowMenuAction = DiscoveryAnalytics.Events.gameTileOverflowMenuAction

local fFlagLuaAppEnableHomepageOneByTwoTile = SharedFlags.FFlagLuaAppEnableHomepageOneByTwoTile
local fFlagLuaAppGameTileDirectActionTelemetry = SharedFlags.FFlagLuaAppGameTileDirectActionTelemetry

local function GameTileDirectAction(props)
	local v5 = useTokens()
	local v6 = React.useMemo(function()
		return { [props.actionId] = true }
	end, { props.actionId })
	local joined = Cryo.Dictionary.join(props, { availableMenuItems = v6 })
	local v7

	if fFlagLuaAppGameTileDirectActionTelemetry then
		local useCallback = React.useCallback
		local function fn(p2)
			local v9 = {
				universeId = props.universeId,
				sortId = props.collectionId or "",
				actionType = "GameTileOverflowMenuItemActivated",
				menuItem = p2,
				availableMenuItems = p2,
				contentType = 0,
				isDirectAction = true
			}

			local v10 = if fFlagLuaAppEnableHomepageOneByTwoTile then props.contentType else nil
			v9.contentType = v10
			gameTileOverflowMenuAction(v9, props.appPage)
		end

		local appPage = props.appPage
		local universeId = props.universeId
		local collectionId = props.collectionId
		local v9 = if fFlagLuaAppEnableHomepageOneByTwoTile then props.contentType else nil
		v7 = useCallback(fn, { appPage, universeId, collectionId, v9 })
	end

	if not fFlagLuaAppGameTileDirectActionTelemetry then
		v7 = nil
	end

	local v9 = useGameTileActions(joined, v7)[1]

	if not (v9 and props.isHovered) then
		return nil
	end

	local iconOverride = props.iconOverride or v9.icon
	local id = v9.id
	local onActivated = v9.onActivated

	if iconOverride and id and onActivated then
		return React.createElement(view, {
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -v5.Padding.Medium, 0, v5.Padding.Medium),
			backgroundStyle = v5.Color.OverMedia.OverMedia_0,
			tag = "auto-xy radius-circle"
		}, {
			IconButton = React.createElement(iconButton, {
				icon = iconOverride,
				isCircular = true,
				onActivated = function()
					onActivated(id)
				end,
				size = iconSize.Small,
				testId = "game-tile-direct-action",
				variant = buttonVariant.Utility
			})
		})
	end

	return nil
end

return GameTileDirectAction
